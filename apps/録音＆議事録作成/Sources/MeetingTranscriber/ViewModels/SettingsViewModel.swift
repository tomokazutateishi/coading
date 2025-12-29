import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings
    @Published var isTestingConnection: Bool = false
    @Published var testResultMessage: String?
    @Published var apiKeyInput: String = ""

    private let repository: SettingsRepository
    private let secureStorage = SecureStorage()

    init(repository: SettingsRepository = UserDefaultsSettingsRepository()) {
        self.repository = repository
        self.settings = repository.load()
        
        // Keychain から API キーを読み込む（表示用）
        do {
            self.apiKeyInput = try secureStorage.load(key: "openai_api_key")
        } catch {
            self.apiKeyInput = ""
        }
    }

    func save() {
        // API キーを Keychain に保存
        if !apiKeyInput.isEmpty {
            do {
                try secureStorage.save(key: "openai_api_key", value: apiKeyInput)
            } catch {
                testResultMessage = "APIキーの保存に失敗しました: \(error.localizedDescription)"
                return
            }
        }
        
        repository.save(settings)
        testResultMessage = "設定を保存しました"
    }

    func testConnection() {
        guard !apiKeyInput.isEmpty else {
            testResultMessage = "APIキーを入力してください"
            return
        }
        
        isTestingConnection = true
        testResultMessage = nil

        Task {
            do {
                let provider = OpenAITranscriptionProvider(apiKey: apiKeyInput)
                // 小さなテスト用のダミーデータで接続テスト
                // 実際には Whisper API はファイルが必要なので、認証のみテスト
                // ここでは簡易的に API キーの形式チェックのみ
                if apiKeyInput.hasPrefix("sk-") && apiKeyInput.count > 20 {
                    await MainActor.run {
                        isTestingConnection = false
                        testResultMessage = "APIキーの形式は正しいようです"
                    }
                } else {
                    await MainActor.run {
                        isTestingConnection = false
                        testResultMessage = "APIキーの形式が正しくない可能性があります"
                    }
                }
            } catch {
                await MainActor.run {
                    isTestingConnection = false
                    testResultMessage = "テスト接続に失敗しました: \(error.localizedDescription)"
                }
            }
        }
    }
}
