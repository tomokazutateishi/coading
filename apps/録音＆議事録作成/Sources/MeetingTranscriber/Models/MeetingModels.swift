import Foundation

enum RecordingState: String {
    case idle = "待機中"
    case recording = "録音中"
    case transcribing = "文字起こし中"
    case completed = "完了"
    case error = "エラー"
}

struct RecordingLogEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let message: String
}

struct TranscriptEntry: Identifiable, Hashable {
    let id = UUID()
    var timestamp: TimeInterval
    var speaker: String
    var text: String
}

struct RawTranscript: Hashable {
    var entries: [TranscriptEntry]
}

struct AudioChunk: Identifiable, Hashable {
    let id = UUID()
    let fileURL: URL
    let startedAt: TimeInterval
    let duration: TimeInterval
}

enum ExportFormat: String, Codable, CaseIterable, Identifiable {
    case txt
    case markdown
    case json

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .txt: return "TXT"
        case .markdown: return "Markdown"
        case .json: return "JSON"
        }
    }
}

enum MinutesDetailLevel: String, Codable, CaseIterable, Identifiable {
    case detailed = "詳しく"
    case normal = "普通"
    case concise = "簡潔"

    var id: String { rawValue }
}

enum MinutesFlowStyle: String, Codable, CaseIterable, Identifiable {
    case grouped = "まとめて"
    case chronological = "時系列"

    var id: String { rawValue }
}

enum MissingInfoStrategy: String, Codable, CaseIterable, Identifiable {
    case infer = "補完する"
    case transcriptOnly = "文字情報のみ"

    var id: String { rawValue }
}

struct MinutesSpec: Hashable, Codable {
    var detailLevel: MinutesDetailLevel
    var flowStyle: MinutesFlowStyle
    var missingInfoStrategy: MissingInfoStrategy
}

struct MinutesDocument: Identifiable, Hashable {
    let id = UUID()
    var content: String
    var generatedAt: Date
}

enum TranscriptionServiceKind: String, Codable, CaseIterable, Identifiable {
    case openAI
    case deepgram
    case custom

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .openAI: return "OpenAI Whisper"
        case .deepgram: return "Deepgram"
        case .custom: return "その他"
        }
    }
}

struct AppSettings: Codable {
    var transcriptionService: TranscriptionServiceKind
    var apiKeyReference: String
    var defaultLanguageCode: String
    var concurrentRequests: Int
    var defaultSavePath: URL?
    var defaultDetailLevel: MinutesDetailLevel
    var defaultFlowStyle: MinutesFlowStyle
    var defaultMissingInfoStrategy: MissingInfoStrategy
    var defaultExportFormat: ExportFormat
    var autoTranscriptionEnabled: Bool = false

    static let `default` = AppSettings(
        transcriptionService: .openAI,
        apiKeyReference: "",
        defaultLanguageCode: Locale.current.identifier,
        concurrentRequests: 2,
        defaultSavePath: nil,
        defaultDetailLevel: .normal,
        defaultFlowStyle: .grouped,
        defaultMissingInfoStrategy: .infer,
        defaultExportFormat: .markdown,
        autoTranscriptionEnabled: false
    )
}
