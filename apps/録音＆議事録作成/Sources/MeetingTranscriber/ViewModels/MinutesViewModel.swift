import Foundation

@MainActor
final class MinutesViewModel: ObservableObject {
    @Published var spec: MinutesSpec
    @Published var latestDocument: MinutesDocument?
    @Published var isGenerating: Bool = false
    @Published var errorMessage: String?

    private let provider: MinutesProviding
    private let settingsProvider: () -> AppSettings

    init(provider: MinutesProviding? = nil,
         settingsProvider: @escaping () -> AppSettings) {
        if let provider = provider {
            self.provider = provider
        } else {
            // 設定に基づいてプロバイダーを選択
            let settings = settingsProvider()
            let secureStorage = SecureStorage()
            
            do {
                let apiKey = try secureStorage.load(key: "openai_api_key")
                self.provider = OpenAIMinutesProvider(apiKey: apiKey)
            } catch {
                // API キーが見つからない場合はモックを使用
                self.provider = MockMinutesProvider()
            }
        }
        self.settingsProvider = settingsProvider
        self.spec = settingsProvider().defaultMinutesSpec()
    }

    func generate(from transcript: RawTranscript) {
        guard !transcript.entries.isEmpty else {
            errorMessage = "文字起こし結果がありません"
            return
        }
        isGenerating = true
        errorMessage = nil
        Task {
            do {
                let document = try await provider.generateMinutes(
                    transcript: transcript,
                    spec: spec,
                    settings: settingsProvider()
                )
                await MainActor.run {
                    latestDocument = document
                    isGenerating = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isGenerating = false
                }
            }
        }
    }
}

private extension AppSettings {
    func defaultMinutesSpec() -> MinutesSpec {
        MinutesSpec(
            detailLevel: defaultDetailLevel,
            flowStyle: defaultFlowStyle,
            missingInfoStrategy: defaultMissingInfoStrategy
        )
    }
}
