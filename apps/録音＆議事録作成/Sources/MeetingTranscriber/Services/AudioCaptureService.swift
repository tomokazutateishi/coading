import Foundation
import Combine

protocol AudioCaptureServing {
    var isCapturing: Bool { get }
    var chunksPublisher: AnyPublisher<AudioChunk, Never> { get }
    func startCapture(windowName: String?) async throws
    func stopCapture() async
}

final class MockAudioCaptureService: AudioCaptureServing {
    private let subject = PassthroughSubject<AudioChunk, Never>()
    private(set) var isCapturing: Bool = false
    private var timer: Timer?
    private var startedAt: Date?

    var chunksPublisher: AnyPublisher<AudioChunk, Never> {
        subject.eraseToAnyPublisher()
    }

    func startCapture(windowName: String?) async throws {
        guard !isCapturing else { return }
        isCapturing = true
        startedAt = Date()
        startMockTimer()
    }

    func stopCapture() async {
        isCapturing = false
        timer?.invalidate()
        timer = nil
    }

    private func startMockTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            guard let self else { return }
            let index = Date().timeIntervalSince1970
            let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("chunk-\(index).wav")
            let chunk = AudioChunk(fileURL: temporaryURL, startedAt: index, duration: 15)
            subject.send(chunk)
        }
    }
}
