import Foundation
import Combine

@MainActor
final class TranscriptionViewModel: ObservableObject {
    @Published var transcriptEntries: [TranscriptEntry] = []
    @Published var isProcessing: Bool = false
    @Published var progress: Double = 0
    @Published var statusMessage: String = "待機中"
    @Published var encounteredError: String?

    var rawTranscript: RawTranscript {
        RawTranscript(entries: transcriptEntries.sorted { $0.timestamp < $1.timestamp })
    }

    private let provider: TranscriptionProviding
    private let settingsProvider: () -> AppSettings
    private var cancellables = Set<AnyCancellable>()
    private var processedChunks = 0

    init(provider: TranscriptionProviding? = nil,
         settingsProvider: @escaping () -> AppSettings) {
        if let provider = provider {
            self.provider = provider
        } else {
            // 設定に基づいてプロバイダーを選択
            let settings = settingsProvider()
            let secureStorage = SecureStorage()
            
            if settings.transcriptionService == .openAI {
                do {
                    let apiKey = try secureStorage.load(key: "openai_api_key")
                    if apiKey.isEmpty {
                        print("⚠️ APIキーが空です")
                        self.provider = MockTranscriptionProvider()
                    } else {
                        print("✅ APIキーを読み込みました（長さ: \(apiKey.count)）")
                        self.provider = OpenAITranscriptionProvider(apiKey: apiKey)
                    }
                } catch {
                    print("⚠️ APIキーの読み込みに失敗: \(error.localizedDescription)")
                    // API キーが見つからない場合はモックを使用
                    self.provider = MockTranscriptionProvider()
                }
            } else {
                print("⚠️ サービスが OpenAI ではありません")
                self.provider = MockTranscriptionProvider()
            }
        }
        self.settingsProvider = settingsProvider
    }

    func bind(to chunksPublisher: AnyPublisher<AudioChunk, Never>) {
        print("📝 TranscriptionViewModel: chunksPublisher にバインドしました")
        chunksPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chunk in
                print("📦 チャンクを受信: \(chunk.fileURL.lastPathComponent), 開始時刻: \(chunk.startedAt)")
                self?.handle(chunk: chunk)
            }
            .store(in: &cancellables)
    }

    private var totalChunks: Int = 0
    
    private var activeTasks: [UUID: Task<Void, Never>] = [:]
    
    private func handle(chunk: AudioChunk) {
        guard settingsProvider().autoTranscriptionEnabled else {
            print("⏭️ 自動文字起こしが無効のためチャンクをスキップ")
            return
        }
        print("🔄 チャンクを処理開始: \(chunk.fileURL.lastPathComponent)")
        isProcessing = true
        statusMessage = "文字起こし中 (\(processedChunks + 1)件目)"
        totalChunks = max(totalChunks, processedChunks + 1)
        
        let taskId = UUID()
        let task = Task {
            do {
                print("📤 API を呼び出し中...")
                let entry = try await provider.transcribe(chunk: chunk, settings: settingsProvider())
                print("✅ 文字起こし成功: \(entry.text.prefix(50))...")
                await MainActor.run {
                    transcriptEntries.append(entry)
                    processedChunks += 1
                    
                    // 進捗計算
                    if totalChunks > 0 {
                        progress = Double(processedChunks) / Double(totalChunks)
                    } else {
                        progress = min(1.0, Double(processedChunks) / 10.0)
                    }
                    
                    let totalDisplay = totalChunks > 0 ? String(totalChunks) : "?"
                    statusMessage = "文字起こし中 (\(processedChunks)/\(totalDisplay)件)"
                    
                    print("📊 進捗: \(processedChunks)/\(totalDisplay), エントリ数: \(transcriptEntries.count)")
                    
                    // すべてのチャンクが処理されたか確認
                    if processedChunks >= totalChunks && totalChunks > 0 {
                        isProcessing = false
                        statusMessage = "文字起こし完了"
                        print("✅ すべてのチャンクの処理が完了しました")
                    }
                    
                    // タスクを削除
                    activeTasks.removeValue(forKey: taskId)
                }
            } catch {
                print("❌ 文字起こしエラー: \(error.localizedDescription)")
                await MainActor.run {
                    let errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                    encounteredError = "チャンク \(processedChunks + 1) の文字起こしに失敗: \(errorMessage)"
                    statusMessage = "エラーが発生しました"
                    isProcessing = false
                    activeTasks.removeValue(forKey: taskId)
                }
            }
        }
        
        activeTasks[taskId] = task
    }

    func completeIfNeeded() {
        // すべてのチャンクが処理されたか確認
        Task {
            // 処理中のタスクが完了するまで待機（最大60秒）
            var waitCount = 0
            while !activeTasks.isEmpty && waitCount < 60 {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1秒待機
                waitCount += 1
            }
            
            await MainActor.run {
                if isProcessing {
                    isProcessing = false
                }
                if processedChunks > 0 {
                    statusMessage = "文字起こし完了"
                } else if encounteredError == nil {
                    statusMessage = "文字起こし結果がありません"
                }
            }
        }
    }
    
    func markAllChunksReceived(total: Int) {
        totalChunks = total
    }

    func reset() {
        transcriptEntries = []
        progress = 0
        processedChunks = 0
        statusMessage = "待機中"
        encounteredError = nil
    }
}
