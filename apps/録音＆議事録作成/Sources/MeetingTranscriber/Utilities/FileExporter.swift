import Foundation
import AppKit
import UniformTypeIdentifiers

enum FileExportError: LocalizedError {
    case savePanelCancelled
    case saveFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .savePanelCancelled:
            return "保存がキャンセルされました"
        case .saveFailed(let error):
            return "保存に失敗しました: \(error.localizedDescription)"
        }
    }
}

@MainActor
final class FileExporter {
    static func exportMinutes(_ content: String, format: ExportFormat, defaultPath: URL?) async throws -> URL {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [format.utiType]
        panel.nameFieldStringValue = defaultFileName(format: format)
        
        if let defaultPath = defaultPath {
            panel.directoryURL = defaultPath.deletingLastPathComponent()
        }
        
        let response = await panel.begin()
        
        guard response == .OK, let url = panel.url else {
            throw FileExportError.savePanelCancelled
        }
        
        do {
            let data = try formatData(content: content, format: format)
            try data.write(to: url)
            return url
        } catch {
            throw FileExportError.saveFailed(error)
        }
    }
    
    static func exportTranscript(_ transcript: RawTranscript, format: ExportFormat, defaultPath: URL?) async throws -> URL {
        let content = formatTranscript(transcript, format: format)
        return try await exportMinutes(content, format: format, defaultPath: defaultPath)
    }
    
    private static func formatData(content: String, format: ExportFormat) throws -> Data {
        switch format {
        case .txt:
            return content.data(using: .utf8) ?? Data()
        case .markdown:
            return content.data(using: .utf8) ?? Data()
        case .json:
            // JSON として保存する場合は、構造化データが必要
            // ここでは簡易的にテキストとして保存
            let json: [String: String] = ["content": content]
            return try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        }
    }
    
    private static func formatTranscript(_ transcript: RawTranscript, format: ExportFormat) -> String {
        let sortedEntries = transcript.entries.sorted { $0.timestamp < $1.timestamp }
        
        switch format {
        case .txt:
            return sortedEntries.map { entry in
                let timeStr = formatTime(entry.timestamp)
                return "[\(timeStr)] \(entry.speaker): \(entry.text)"
            }.joined(separator: "\n")
            
        case .markdown:
            var markdown = "# 文字起こし結果\n\n"
            markdown += sortedEntries.map { entry in
                let timeStr = formatTime(entry.timestamp)
                return "- **[\(timeStr)]** \(entry.speaker): \(entry.text)"
            }.joined(separator: "\n")
            return markdown
            
        case .json:
            let entries = sortedEntries.map { entry in
                [
                    "timestamp": entry.timestamp,
                    "speaker": entry.speaker,
                    "text": entry.text
                ] as [String: Any]
            }
            if let jsonData = try? JSONSerialization.data(withJSONObject: ["entries": entries], options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
            return "{}"
        }
    }
    
    private static func formatTime(_ interval: TimeInterval) -> String {
        let totalSeconds = Int(interval)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private static func defaultFileName(format: ExportFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let dateStr = dateFormatter.string(from: Date())
        return "議事録_\(dateStr).\(format.fileExtension)"
    }
}

extension ExportFormat {
    var utiType: UTType {
        switch self {
        case .txt:
            return .plainText
        case .markdown:
            // macOS 13+ では .markdownText が利用可能
            if #available(macOS 13.0, *) {
                return UTType(filenameExtension: "md") ?? .plainText
            } else {
                return .plainText
            }
        case .json:
            return .json
        }
    }
    
    var fileExtension: String {
        switch self {
        case .txt: return "txt"
        case .markdown: return "md"
        case .json: return "json"
        }
    }
}

