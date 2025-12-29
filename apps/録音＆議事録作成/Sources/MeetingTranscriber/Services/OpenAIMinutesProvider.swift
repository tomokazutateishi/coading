import Foundation

struct ChatCompletionRequest: Codable {
    let model: String
    let messages: [ChatMessage]
    let temperature: Double
}

struct ChatMessage: Codable {
    let role: String
    let content: String
}

struct ChatCompletionResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: ChatMessage
    }
}


final class OpenAIMinutesProvider: MinutesProviding {
    private let apiKey: String
    private let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    private let maxRetries = 2
    private let retryDelay: TimeInterval = 2.0
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func generateMinutes(transcript: RawTranscript, spec: MinutesSpec, settings: AppSettings) async throws -> MinutesDocument {
        guard !apiKey.isEmpty else {
            throw MinutesGenerationError.apiKeyMissing
        }
        
        // プロンプトを生成
        let prompt = buildPrompt(transcript: transcript, spec: spec)
        
        // リトライロジック付きで API を呼び出し
        var lastError: Error?
        for attempt in 1...maxRetries {
            do {
                let content = try await performGeneration(prompt: prompt)
                return MinutesDocument(content: content, generatedAt: Date())
            } catch {
                lastError = error
                
                if let minutesError = error as? MinutesGenerationError,
                   case .rateLimitExceeded = minutesError {
                    let delay = retryDelay * Double(attempt)
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    continue
                }
                
                if attempt < maxRetries {
                    let delay = retryDelay * Double(attempt)
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    continue
                }
            }
        }
        
        throw lastError ?? MinutesGenerationError.unknown
    }
    
    private func buildPrompt(transcript: RawTranscript, spec: MinutesSpec) -> String {
        let sortedEntries = transcript.entries.sorted { $0.timestamp < $1.timestamp }
        
        // 文字起こしテキストを整形
        let transcriptText = sortedEntries.map { entry in
            let timeStr = formatTime(entry.timestamp)
            return "[\(timeStr)] \(entry.speaker): \(entry.text)"
        }.joined(separator: "\n")
        
        // 詳細レベルの指示
        let detailInstruction: String
        switch spec.detailLevel {
        case .detailed:
            detailInstruction = "詳細に、発言の背景や文脈も含めて記録してください。"
        case .normal:
            detailInstruction = "標準的な詳細さで記録してください。"
        case .concise:
            detailInstruction = "簡潔に、要点のみを記録してください。"
        }
        
        // 記載の流れの指示
        let flowInstruction: String
        switch spec.flowStyle {
        case .grouped:
            flowInstruction = "議題やテーマごとにまとめて記載してください。時系列ではなく、関連する内容をグループ化してください。"
        case .chronological:
            flowInstruction = "時系列順（発言順）に記載してください。"
        }
        
        // 補完方針の指示
        let completionInstruction: String
        switch spec.missingInfoStrategy {
        case .infer:
            completionInstruction = "会話の内容から推測できる情報（議題、決定事項、次のアクションなど）があれば、それを補完して記載してください。"
        case .transcriptOnly:
            completionInstruction = "文字起こしされた内容のみを記載してください。推測や補完は行わないでください。"
        }
        
        return """
        以下の会議の文字起こし結果から、議事録を作成してください。

        【文字起こし結果】
        \(transcriptText)

        【作成指示】
        1. \(detailInstruction)
        2. \(flowInstruction)
        3. \(completionInstruction)

        【議事録の形式】
        - 会議の日時や参加者（推測可能な場合）
        - 議題・テーマごとのまとめ（または時系列での記載）
        - 決定事項
        - 次のアクションアイテム（あれば）

        議事録を作成してください：
        """
    }
    
    private func performGeneration(prompt: String) async throws -> String {
        let requestBody = ChatCompletionRequest(
            model: "gpt-4o-mini",
            messages: [
                ChatMessage(role: "system", content: "あなたは会議の議事録を作成する専門家です。文字起こし結果から、分かりやすく整理された議事録を作成してください。"),
                ChatMessage(role: "user", content: prompt)
            ],
            temperature: 0.7
        )
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MinutesGenerationError.invalidResponse
        }
        
        // エラーレスポンスの処理
        if httpResponse.statusCode != 200 {
            if let errorData = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data) {
                if errorData.error?.code == "rate_limit_exceeded" {
                    throw MinutesGenerationError.rateLimitExceeded
                }
                throw MinutesGenerationError.apiError(errorData.error?.message ?? "Unknown API error")
            }
            
            if httpResponse.statusCode == 401 {
                throw MinutesGenerationError.authenticationFailed
            }
            
            throw MinutesGenerationError.httpError(statusCode: httpResponse.statusCode)
        }
        
        // レスポンスを解析
        do {
            let completionResponse = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
            guard let content = completionResponse.choices.first?.message.content else {
                throw MinutesGenerationError.invalidResponse
            }
            return content.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            throw MinutesGenerationError.decodingError(error)
        }
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

enum MinutesGenerationError: LocalizedError {
    case apiKeyMissing
    case authenticationFailed
    case rateLimitExceeded
    case httpError(statusCode: Int)
    case apiError(String)
    case invalidResponse
    case decodingError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .apiKeyMissing:
            return "APIキーが設定されていません。設定画面でAPIキーを入力してください。"
        case .authenticationFailed:
            return "認証に失敗しました。APIキーを確認してください。"
        case .rateLimitExceeded:
            return "レート制限に達しました。しばらく待ってから再試行してください。"
        case .httpError(let statusCode):
            return "HTTPエラー: \(statusCode)"
        case .apiError(let message):
            return "APIエラー: \(message)"
        case .invalidResponse:
            return "無効なレスポンスを受け取りました。"
        case .decodingError(let error):
            return "レスポンスの解析に失敗しました: \(error.localizedDescription)"
        case .unknown:
            return "不明なエラーが発生しました。"
        }
    }
}

