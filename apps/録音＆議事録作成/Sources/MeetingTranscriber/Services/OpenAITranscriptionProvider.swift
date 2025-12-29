import Foundation

struct WhisperResponse: Codable {
    let text: String
}

final class OpenAITranscriptionProvider: TranscriptionProviding {
    private let apiKey: String
    private let baseURL = URL(string: "https://api.openai.com/v1/audio/transcriptions")!
    private let maxRetries = 3
    private let retryDelay: TimeInterval = 2.0
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func transcribe(chunk: AudioChunk, settings: AppSettings) async throws -> TranscriptEntry {
        guard !apiKey.isEmpty else {
            throw TranscriptionError.apiKeyMissing
        }
        
        // 音声ファイルを読み込む
        let audioData = try Data(contentsOf: chunk.fileURL)
        
        // リトライロジック付きで API を呼び出し
        var lastError: Error?
        for attempt in 1...maxRetries {
            do {
                let text = try await performTranscription(audioData: audioData, language: settings.defaultLanguageCode)
                
                // 話者名は暫定的に "話者" としておく（将来的に話者分離機能を追加可能）
                return TranscriptEntry(
                    timestamp: chunk.startedAt,
                    speaker: "話者",
                    text: text
                )
            } catch {
                lastError = error
                
                // レート制限エラーの場合は待機
                if let transcriptionError = error as? TranscriptionError,
                   case .rateLimitExceeded = transcriptionError {
                    let delay = retryDelay * Double(attempt)
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    continue
                }
                
                // 最後の試行でなければリトライ
                if attempt < maxRetries {
                    let delay = retryDelay * Double(attempt)
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                    continue
                }
            }
        }
        
        throw lastError ?? TranscriptionError.unknown
    }
    
    private func performTranscription(audioData: Data, language: String) async throws -> String {
        // multipart/form-data リクエストを作成
        let boundary = UUID().uuidString
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        // file パラメータ
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.wav\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
        
        // model パラメータ
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("whisper-1\r\n".data(using: .utf8)!)
        
        // language パラメータ（オプション）
        if !language.isEmpty {
            let langCode = language.prefix(2).lowercased()
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"language\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(langCode)\r\n".data(using: .utf8)!)
        }
        
        // response_format パラメータ（JSON を指定）
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"response_format\"\r\n\r\n".data(using: .utf8)!)
        body.append("json\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // リクエスト実行
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TranscriptionError.invalidResponse
        }
        
        // エラーレスポンスの処理
        if httpResponse.statusCode != 200 {
            if let errorData = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data) {
                if errorData.error?.code == "rate_limit_exceeded" {
                    throw TranscriptionError.rateLimitExceeded
                }
                throw TranscriptionError.apiError(errorData.error?.message ?? "Unknown API error")
            }
            
            if httpResponse.statusCode == 401 {
                throw TranscriptionError.authenticationFailed
            }
            
            throw TranscriptionError.httpError(statusCode: httpResponse.statusCode)
        }
        
        // レスポンスを解析
        do {
            let whisperResponse = try JSONDecoder().decode(WhisperResponse.self, from: data)
            return whisperResponse.text.trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            throw TranscriptionError.decodingError(error)
        }
    }
}

struct OpenAIErrorResponse: Codable {
    let error: ErrorDetail?
    
    struct ErrorDetail: Codable {
        let message: String?
        let code: String?
    }
}

enum TranscriptionError: LocalizedError {
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





