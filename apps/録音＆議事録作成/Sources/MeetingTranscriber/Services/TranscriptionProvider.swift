import Foundation

struct TranscriptChunkResult {
    let chunk: AudioChunk
    let transcription: TranscriptEntry
}

protocol TranscriptionProviding {
    func transcribe(chunk: AudioChunk, settings: AppSettings) async throws -> TranscriptEntry
}

struct MinutesGenerationResult {
    let document: MinutesDocument
}

protocol MinutesProviding {
    func generateMinutes(transcript: RawTranscript, spec: MinutesSpec, settings: AppSettings) async throws -> MinutesDocument
}

final class MockTranscriptionProvider: TranscriptionProviding {
    func transcribe(chunk: AudioChunk, settings: AppSettings) async throws -> TranscriptEntry {
        TranscriptEntry(timestamp: chunk.startedAt, speaker: "話者", text: "サンプル文字起こし（\(chunk.fileURL.lastPathComponent))")
    }
}

final class MockMinutesProvider: MinutesProviding {
    func generateMinutes(transcript: RawTranscript, spec: MinutesSpec, settings: AppSettings) async throws -> MinutesDocument {
        let header = "議事録（\(spec.detailLevel.rawValue) / \(spec.flowStyle.rawValue)）"
        let body = transcript.entries
            .sorted { $0.timestamp < $1.timestamp }
            .map { "- [\(formatTime($0.timestamp))] \($0.speaker): \($0.text)" }
            .joined(separator: "\n")
        return MinutesDocument(content: "\(header)\n\n\(body)", generatedAt: Date())
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let seconds = Int(interval) % 60
        let minutes = Int(interval / 60)
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
