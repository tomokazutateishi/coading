import Foundation
import Combine

@MainActor
final class RecordingViewModel: ObservableObject {
    @Published var state: RecordingState = .idle
    @Published var elapsedTime: TimeInterval = 0
    @Published var selectedWindowName: String?
    @Published var logs: [RecordingLogEntry] = []
    @Published var recordedChunks: [AudioChunk] = []

    var chunksPublisher: AnyPublisher<AudioChunk, Never> {
        chunkSubject.eraseToAnyPublisher()
    }

    private let audioService: AudioCaptureServing
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    private let chunkSubject = PassthroughSubject<AudioChunk, Never>()
    private var autoTranscriptionEnabled = false

    init(audioService: AudioCaptureServing? = nil) {
        if #available(macOS 12.3, *) {
            self.audioService = audioService ?? ScreenCaptureAudioService()
        } else {
            self.audioService = audioService ?? MockAudioCaptureService()
        }
        self.audioService.chunksPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chunk in
                self?.recordedChunks.append(chunk)
                self?.chunkSubject.send(chunk)
            }
            .store(in: &cancellables)
    }

    func startRecording(windowName: String?) {
        Task {
            do {
                try await audioService.startCapture(windowName: windowName)
                selectedWindowName = windowName
                state = .recording
                appendLog("録音を開始しました")
                startTimer()
            } catch {
                state = .error
                appendLog("録音開始に失敗: \(error.localizedDescription)")
            }
        }
    }

    func stopRecording() {
        Task {
            await audioService.stopCapture()
            timer?.invalidate()
            timer = nil
            state = autoTranscriptionEnabled ? .transcribing : .completed
            appendLog("録音を停止しました")
            if !autoTranscriptionEnabled {
                appendLog("録音ファイルは下の一覧から確認できます")
            }
        }
    }

    private func startTimer() {
        timer?.invalidate()
        elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            elapsedTime += 1
        }
    }

    func markTranscriptionComplete() {
        state = .completed
        appendLog("文字起こし完了")
    }

    func reset() {
        elapsedTime = 0
        logs = []
        state = .idle
        selectedWindowName = nil
        recordedChunks = []
        appendLog("待機状態に戻りました")
    }

    func updateAutoTranscriptionEnabled(_ isEnabled: Bool) {
        autoTranscriptionEnabled = isEnabled
        if !isEnabled && state == .transcribing {
            state = .completed
        }
    }

    private func appendLog(_ message: String) {
        logs.insert(RecordingLogEntry(timestamp: Date(), message: message), at: 0)
    }
}
