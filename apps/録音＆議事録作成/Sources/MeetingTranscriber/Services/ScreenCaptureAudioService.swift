import Foundation
import Combine
import ScreenCaptureKit
import AVFoundation
import AudioToolbox
import CoreGraphics

@available(macOS 12.3, *)
final class ScreenCaptureAudioService: AudioCaptureServing {
    private let subject = PassthroughSubject<AudioChunk, Never>()
    private(set) var isCapturing: Bool = false
    
    private var stream: SCStream?
    private var streamOutput: StreamOutput?
    private var streamDelegate: StreamDelegate?
    private var chunkTimer: Timer?
    private var chunkCounter: Int = 0
    private var recordingStartTime: Date?
    private var currentChunkBuffer: [Float] = []
    private let chunkDuration: TimeInterval = 15.0
    private let targetSampleRate: Double = 16000.0
    private let tempDirectory: URL
    private let processingQueue = DispatchQueue(label: "com.meetingtranscriber.audioprocessing", qos: .userInitiated)
    private var audioBufferCount: Int = 0
    
    var chunksPublisher: AnyPublisher<AudioChunk, Never> {
        subject.eraseToAnyPublisher()
    }
    
    init() {
        tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("MeetingTranscriber", isDirectory: true)
        try? FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
    }
    
    func startCapture(windowName: String?) async throws {
        guard !isCapturing else {
            print("⚠️ 既に録音中です")
            return
        }
        
        print("🎬 録音開始処理を開始します...")
        
        // 画面録画の権限を確認
        guard await checkScreenRecordingPermission() else {
            print("❌ 画面録画権限がありません")
            throw AudioCaptureError.permissionDenied
        }
        
        print("📋 利用可能なコンテンツを取得中...")
        let availableContent = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
        print("📋 アプリケーション数: \(availableContent.applications.count), ウィンドウ数: \(availableContent.windows.count)")
        
        // 利用可能なアプリケーションをログ出力
        for app in availableContent.applications.prefix(10) {
            print("  📱 \(app.applicationName) (bundle: \(app.bundleIdentifier ?? "unknown"))")
        }
        
        guard let window = resolveWindow(named: windowName, in: availableContent) else {
            print("❌ 対象ウィンドウが見つかりません")
            print("   利用可能なウィンドウ:")
            for win in availableContent.windows.prefix(10) {
                print("     - \(win.mt_displayName)")
            }
            throw AudioCaptureError.windowNotFound
        }
        
        let filter = makeContentFilter(for: window, in: availableContent)
        print("🎯 ターゲットウィンドウ: \(window.mt_displayName)")
        
        // ストリーム設定
        var streamConfig = SCStreamConfiguration()
        streamConfig.capturesAudio = true
        streamConfig.excludesCurrentProcessAudio = false
        streamConfig.sampleRate = 48000
        streamConfig.channelCount = 2
        
        print("⚙️ ストリーム設定: 音声=ON, サンプルレート=48000Hz, チャンネル=2")
        
        // ストリーム出力
        let output = StreamOutput { [weak self] audioBuffer in
            guard let self = self else { return }
            self.processingQueue.async {
                self.processAudioBuffer(audioBuffer)
            }
        }
        streamOutput = output
        
        // ストリームデリゲートを設定（エラー検出のため）
        let delegate = StreamDelegate { [weak self] error in
            guard let self = self else { return }
            print("❌ ストリームでエラーが発生しました: \(error.localizedDescription)")
            Task { @MainActor in
                self.isCapturing = false
            }
        }
        streamDelegate = delegate
        
        // ストリーム作成
        stream = SCStream(filter: filter, configuration: streamConfig, delegate: delegate)
        
        print("📡 ストリーム出力を設定しました")
        
        // 音声ストリームを追加
        do {
            try await stream?.addStreamOutput(output, type: .audio, sampleHandlerQueue: processingQueue)
            print("✅ 音声ストリーム出力を追加しました")
        } catch {
            print("❌ 音声ストリーム出力の追加に失敗: \(error.localizedDescription)")
            throw AudioCaptureError.streamError("音声ストリーム出力の追加に失敗: \(error.localizedDescription)")
        }
        
        // キャプチャ開始
        do {
            try await stream?.startCapture()
            print("🎬 キャプチャを開始しました")
        } catch {
            print("❌ キャプチャ開始に失敗: \(error.localizedDescription)")
            throw AudioCaptureError.streamError("キャプチャ開始に失敗: \(error.localizedDescription)")
        }
        
        isCapturing = true
        recordingStartTime = Date()
        chunkCounter = 0
        currentChunkBuffer = []
        audioBufferCount = 0
        print("✅ 録音開始: 開始時刻=\(recordingStartTime!), バッファサイズ=\(currentChunkBuffer.count)")
        
        // チャンクタイマー開始
        await MainActor.run {
            chunkTimer = Timer.scheduledTimer(withTimeInterval: chunkDuration, repeats: true) { [weak self] _ in
                Task { [weak self] in
                    await self?.saveCurrentChunk()
                }
            }
        }
    }
    
    func stopCapture() async {
        guard isCapturing else { return }
        
        print("⏹️ 録音停止処理を開始します...")
        
        // 最後のチャンクを保存
        await saveCurrentChunk()
        
        chunkTimer?.invalidate()
        chunkTimer = nil
        
        do {
            try await stream?.stopCapture()
            print("✅ キャプチャを停止しました")
        } catch {
            print("⚠️ キャプチャ停止時にエラー: \(error.localizedDescription)")
        }
        
        stream = nil
        streamOutput = nil
        streamDelegate = nil
        
        isCapturing = false
        print("📊 録音状態をリセットしました。総バッファ数: \(audioBufferCount)")
    }
    
    private func checkScreenRecordingPermission() async -> Bool {
        // macOS の画面録画権限を確認
        let hasPermission = CGPreflightScreenCaptureAccess()
        print("🔐 画面録画権限チェック: \(hasPermission ? "許可済み" : "未許可")")
        
        if !hasPermission {
            print("⚠️ 画面録画権限がありません。権限を要求します...")
            // 権限がない場合は要求
            let granted = CGRequestScreenCaptureAccess()
            print("🔐 権限要求結果: \(granted ? "許可" : "拒否")")
            
            if !granted {
                print("❌ 画面録画権限が拒否されました。システム環境設定 > セキュリティとプライバシー > プライバシー > 画面の録画 から権限を許可してください。")
            }
            
            return granted
        }
        return true
    }
    
    private func processAudioBuffer(_ buffer: CMSampleBuffer) {
        audioBufferCount += 1
        
        guard let formatDescription = CMSampleBufferGetFormatDescription(buffer),
              let audioStreamBasicDescription = CMAudioFormatDescriptionGetStreamBasicDescription(formatDescription) else {
            if audioBufferCount <= 5 {
                print("⚠️ 音声フォーマット情報の取得に失敗")
            }
            return
        }
        
        let channelCount = Int(audioStreamBasicDescription.pointee.mChannelsPerFrame)
        let frameCount = CMSampleBufferGetNumSamples(buffer)
        let sampleRate = audioStreamBasicDescription.pointee.mSampleRate
        
        // 最初の数回のみ詳細ログを出力
        if audioBufferCount <= 3 {
            let formatFlags = audioStreamBasicDescription.pointee.mFormatFlags
            let bitsPerChannel = Int(audioStreamBasicDescription.pointee.mBitsPerChannel)
            let formatID = audioStreamBasicDescription.pointee.mFormatID
            print("🎤 音声バッファ[\(audioBufferCount)]: フレーム数=\(frameCount), チャンネル数=\(channelCount), サンプルレート=\(sampleRate)")
            print("   formatID=\(formatID), bitsPerChannel=\(bitsPerChannel), formatFlags=0x\(String(format: "%08x", formatFlags))")
            print("   isFloat=\((formatFlags & kAudioFormatFlagIsFloat) != 0), isSignedInteger=\((formatFlags & kAudioFormatFlagIsSignedInteger) != 0)")
            print("   isNonInterleaved=\((formatFlags & kAudioFormatFlagIsNonInterleaved) != 0), isBigEndian=\((formatFlags & kAudioFormatFlagIsBigEndian) != 0)")
        }
        
        let bufferListSize = MemoryLayout<AudioBufferList>.size + max(channelCount - 1, 0) * MemoryLayout<AudioBuffer>.size
        let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: bufferListSize, alignment: MemoryLayout<AudioBufferList>.alignment)
        defer { rawPointer.deallocate() }
        
        let audioBufferList = rawPointer.bindMemory(to: AudioBufferList.self, capacity: 1)
        var blockBuffer: CMBlockBuffer?
        
        let status = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
            buffer,
            bufferListSizeNeededOut: nil,
            audioBufferListOut: audioBufferList,
            bufferListSize: bufferListSize,
            blockBufferAllocator: nil,
            blockBufferMemoryAllocator: nil,
            flags: 0,
            blockBufferOut: &blockBuffer
        )
        
        guard status == noErr else {
            if audioBufferCount <= 5 {
                print("⚠️ 音声バッファリストの取得に失敗: status=\(status)")
            }
            return
        }
        
        let audioBuffers = UnsafeMutableAudioBufferListPointer(audioBufferList)
        guard let firstBuffer = audioBuffers.first else {
            if audioBufferCount <= 5 {
                print("⚠️ AudioBufferList が空です")
            }
            return
        }
        
        let dataSize = Int(firstBuffer.mDataByteSize)
        
        // 最初の数回のみ詳細ログを出力
        if audioBufferCount <= 3 {
            print("✅ 音声データを取得: サイズ=\(dataSize) バイト, bufferCount=\(audioBuffers.count)")
        }
        
        let formatFlags = audioStreamBasicDescription.pointee.mFormatFlags
        let bitsPerChannel = Int(audioStreamBasicDescription.pointee.mBitsPerChannel)
        let isFloat = (formatFlags & kAudioFormatFlagIsFloat) != 0
        let isSignedInteger = (formatFlags & kAudioFormatFlagIsSignedInteger) != 0
        let isNonInterleaved = (formatFlags & kAudioFormatFlagIsNonInterleaved) != 0
        let isBigEndian = (formatFlags & kAudioFormatFlagIsBigEndian) != 0
        
        // デバッグ: フォーマット情報を確認
        if audioBufferCount <= 2 {
            print("🔍 フォーマット解析: bitsPerChannel=\(bitsPerChannel), isFloat=\(isFloat), isSignedInteger=\(isSignedInteger), isNonInterleaved=\(isNonInterleaved), isBigEndian=\(isBigEndian)")
        }
        
        guard let channelSamples = extractChannelSamples(
            from: audioBuffers,
            channelCount: channelCount,
            frameCount: Int(frameCount),
            bitsPerChannel: bitsPerChannel,
            isFloat: isFloat,
            isSignedInteger: isSignedInteger,
            isNonInterleaved: isNonInterleaved,
            isBigEndian: isBigEndian
        ) else {
            if audioBufferCount <= 5 {
                print("⚠️ チャネルデータの抽出に失敗")
            }
            return
        }
        
        // デバッグ: チャンネルデータの統計を確認
        if audioBufferCount <= 3 {
            for (index, samples) in channelSamples.enumerated() {
                let maxVal = samples.max() ?? 0
                let minVal = samples.min() ?? 0
                let mean = samples.reduce(0, +) / Float(samples.count)
                let rms = sqrt(samples.reduce(0) { $0 + $1 * $1 } / Float(samples.count))
                print("🎛️ ch\(index): count=\(samples.count), min=\(minVal), max=\(maxVal), mean=\(mean), rms=\(rms)")
            }
        }
        
        // モノラル化
        let monoBuffer = mixDownToMono(channelSamples: channelSamples, frameCount: Int(frameCount))
        
        // 16kHz にダウンサンプリング
        let resampled = resampleAudio(monoBuffer, from: sampleRate, to: targetSampleRate)
        
        // 音量を確認（最初の数回のみ）
        if audioBufferCount <= 3 {
            let maxVal = resampled.max() ?? 0
            let minVal = resampled.min() ?? 0
            let rms = sqrt(resampled.reduce(0) { $0 + $1 * $1 } / Float(resampled.count))
            print("🔊 音声レベル: min=\(String(format: "%.4f", minVal)), max=\(String(format: "%.4f", maxVal)), RMS=\(String(format: "%.4f", rms))")
        }
        
        currentChunkBuffer.append(contentsOf: resampled)
        
        // 定期的に進捗をログ出力（5秒ごと）
        let currentDuration = Double(currentChunkBuffer.count) / targetSampleRate
        if Int(currentDuration) % 5 == 0 && Int(currentDuration * 10) % 50 == 0 && currentDuration > 0 {
            print("📊 録音中: \(String(format: "%.1f", currentDuration))秒, バッファサイズ: \(currentChunkBuffer.count) サンプル")
        }
    }
    
    private func resampleAudio(_ samples: [Float], from sourceRate: Double, to targetRate: Double) -> [Float] {
        guard !samples.isEmpty, sourceRate > 0, targetRate > 0 else { return [] }
        
        if abs(sourceRate - targetRate) < 1.0 {
            return samples
        }
        
        let ratio = sourceRate / targetRate
        var resampled: [Float] = []
        resampled.reserveCapacity(Int(Double(samples.count) / ratio))
        
        var index: Double = 0
        while Int(index) < samples.count {
            let idx = Int(index)
            if idx < samples.count {
                resampled.append(samples[idx])
            }
            index += ratio
        }
        
        return resampled
    }
    
    private func extractChannelSamples(
        from audioBuffers: UnsafeMutableAudioBufferListPointer,
        channelCount: Int,
        frameCount: Int,
        bitsPerChannel: Int,
        isFloat: Bool,
        isSignedInteger: Bool,
        isNonInterleaved: Bool,
        isBigEndian: Bool
    ) -> [[Float]]? {
        var channelData: [[Float]] = []
        
        if isNonInterleaved {
            for channelIndex in 0..<min(channelCount, audioBuffers.count) {
                let buffer = audioBuffers[channelIndex]
                guard let pointer = buffer.mData else {
                    if audioBufferCount <= 5 {
                        print("⚠️ チャンネル\(channelIndex) のデータがnil")
                    }
                    continue
                }
                
                let bytesPerSample = max(bitsPerChannel / 8, 1)
                let availableSamples = Int(buffer.mDataByteSize) / bytesPerSample
                let sampleCount = min(availableSamples, frameCount)
                
                let samples = convertSamples(
                    from: pointer,
                    sampleCount: sampleCount,
                    bitsPerChannel: bitsPerChannel,
                    isFloat: isFloat,
                    isSignedInteger: isSignedInteger,
                    isBigEndian: isBigEndian
                )
                channelData.append(samples)
            }
        } else {
            guard let pointer = audioBuffers.first?.mData else {
                if audioBufferCount <= 5 {
                    print("⚠️ インターリーブデータがnil")
                }
                return nil
            }
            let totalSamples = frameCount * channelCount
            let interleaved = convertSamples(
                from: pointer,
                sampleCount: totalSamples,
                bitsPerChannel: bitsPerChannel,
                isFloat: isFloat,
                isSignedInteger: isSignedInteger,
                isBigEndian: isBigEndian
            )
            
            guard interleaved.count >= totalSamples else {
                if audioBufferCount <= 5 {
                    print("⚠️ インターリーブデータが不足: \(interleaved.count) / \(totalSamples)")
                }
                return nil
            }
            
            for channelIndex in 0..<channelCount {
                var samples: [Float] = []
                samples.reserveCapacity(frameCount)
                for frame in 0..<frameCount {
                    let idx = frame * channelCount + channelIndex
                    if idx < interleaved.count {
                        samples.append(interleaved[idx])
                    }
                }
                channelData.append(samples)
            }
        }
        
        return channelData.isEmpty ? nil : channelData
    }
    
    private func convertSamples(
        from pointer: UnsafeMutableRawPointer,
        sampleCount: Int,
        bitsPerChannel: Int,
        isFloat: Bool,
        isSignedInteger: Bool,
        isBigEndian: Bool
    ) -> [Float] {
        guard sampleCount > 0 else { return [] }
        
        // デバッグ: 最初の数サンプルの生データを確認
        if audioBufferCount <= 2 {
            let firstBytes = (0..<min(16, sampleCount * (bitsPerChannel / 8))).map { i in
                pointer.advanced(by: i).load(as: UInt8.self)
            }
            print("🔍 生データ（最初の16バイト）: \(firstBytes.map { String(format: "%02x", $0) }.joined(separator: " "))")
            print("🔍 フォーマット: bitsPerChannel=\(bitsPerChannel), isFloat=\(isFloat), isSignedInteger=\(isSignedInteger), isBigEndian=\(isBigEndian)")
        }
        
        if isFloat && bitsPerChannel == 32 {
            if isBigEndian {
                let buffer = pointer.bindMemory(to: UInt32.self, capacity: sampleCount)
                var floats: [Float] = []
                floats.reserveCapacity(sampleCount)
                for i in 0..<sampleCount {
                    let swapped = buffer[i].byteSwapped
                    floats.append(Float(bitPattern: swapped))
                }
                return floats
            } else {
                return pointer.withMemoryRebound(to: Float32.self, capacity: sampleCount) {
                    Array(UnsafeBufferPointer(start: $0, count: sampleCount)).map { Float($0) }
                }
            }
        } else if isSignedInteger && bitsPerChannel == 16 {
            if isBigEndian {
                let buffer = pointer.bindMemory(to: UInt16.self, capacity: sampleCount)
                var floats: [Float] = []
                floats.reserveCapacity(sampleCount)
                for i in 0..<sampleCount {
                    let swapped = Int16(bitPattern: buffer[i].byteSwapped)
                    floats.append(Float(swapped) / Float(Int16.max))
                }
                return floats
            } else {
                let ints = pointer.withMemoryRebound(to: Int16.self, capacity: sampleCount) {
                    Array(UnsafeBufferPointer(start: $0, count: sampleCount))
                }
                return ints.map { Float($0) / Float(Int16.max) }
            }
        } else if isSignedInteger && bitsPerChannel == 32 {
            if isBigEndian {
                let buffer = pointer.bindMemory(to: UInt32.self, capacity: sampleCount)
                var floats: [Float] = []
                floats.reserveCapacity(sampleCount)
                for i in 0..<sampleCount {
                    let swapped = Int32(bitPattern: buffer[i].byteSwapped)
                    floats.append(Float(swapped) / Float(Int32.max))
                }
                return floats
            } else {
                let ints = pointer.withMemoryRebound(to: Int32.self, capacity: sampleCount) {
                    Array(UnsafeBufferPointer(start: $0, count: sampleCount))
                }
                return ints.map { Float($0) / Float(Int32.max) }
            }
        } else {
            if audioBufferCount <= 5 {
                print("⚠️ 未対応の音声フォーマット: bitsPerChannel=\(bitsPerChannel), isFloat=\(isFloat), isSignedInteger=\(isSignedInteger)")
            }
            return []
        }
    }
    
    private func mixDownToMono(channelSamples: [[Float]], frameCount: Int) -> [Float] {
        guard !channelSamples.isEmpty else { return [] }
        var mono: [Float] = Array(repeating: 0, count: frameCount)
        for samples in channelSamples {
            let limit = min(frameCount, samples.count)
            for i in 0..<limit {
                mono[i] += samples[i]
            }
        }
        let divisor = Float(channelSamples.count)
        guard divisor > 0 else { return mono }
        for i in 0..<frameCount {
            mono[i] /= divisor
        }
        return mono
    }
    
    private func saveCurrentChunk() async {
        // スレッドセーフにバッファを取得
        let extraction: ([Float], Date?, Int) = processingQueue.sync {
            guard !currentChunkBuffer.isEmpty, let startTime = recordingStartTime else {
                return ([Float](), nil, 0)
            }
            let buffer = currentChunkBuffer
            let chunkIndex = chunkCounter
            currentChunkBuffer = []
            chunkCounter += 1
            return (buffer, startTime, chunkIndex)
        }
        let (bufferToSave, startTime, counter) = extraction
        
        guard !bufferToSave.isEmpty, let startTime = startTime else {
            print("⚠️ チャンク保存をスキップ: バッファが空または開始時刻なし")
            return
        }
        
        print("💾 チャンクを保存中... (カウンター: \(counter), バッファサイズ: \(bufferToSave.count))")
        
        // 音量を確認
        let maxVal = bufferToSave.max() ?? 0
        let minVal = bufferToSave.min() ?? 0
        let rms = sqrt(bufferToSave.reduce(0) { $0 + $1 * $1 } / Float(bufferToSave.count))
        print("🔊 チャンク音声レベル: min=\(String(format: "%.4f", minVal)), max=\(String(format: "%.4f", maxVal)), RMS=\(String(format: "%.4f", rms))")
        
        // RMSが非常に小さい場合は警告
        if rms < 0.001 {
            print("⚠️ 警告: 音声レベルが非常に低いです（RMS=\(String(format: "%.6f", rms))）。音声が正しくキャプチャされていない可能性があります。")
        }
        
        let chunkStartTime = startTime.timeIntervalSince1970 + (Double(counter) * chunkDuration)
        let chunkURL = tempDirectory.appendingPathComponent("chunk-\(counter).wav")
        
        // WAVファイルとして保存
        do {
            try saveAsWAV(buffer: bufferToSave, to: chunkURL, sampleRate: targetSampleRate)
            
            let chunk = AudioChunk(
                fileURL: chunkURL,
                startedAt: chunkStartTime,
                duration: Double(bufferToSave.count) / targetSampleRate
            )
            
            print("📤 チャンクを発行: \(chunk.fileURL.lastPathComponent), 開始時刻: \(chunk.startedAt), サイズ: \(bufferToSave.count) サンプル, 長さ: \(String(format: "%.2f", chunk.duration))秒")
            subject.send(chunk)
            
            print("✅ チャンク送信完了。カウンター: \(counter + 1)")
        } catch {
            print("❌ チャンク保存に失敗: \(error.localizedDescription)")
        }
    }
    
    private func saveAsWAV(buffer: [Float], to url: URL, sampleRate: Double) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
        
        // FloatをInt16に変換（-1.0から1.0の範囲を-32768から32767にマッピング）
        let int16Samples: [Int16] = buffer.map { sample in
            let clamped = max(-1.0, min(1.0, sample))
            return Int16(clamped * Float(Int16.max))
        }
        
        let numChannels: UInt16 = 1
        let bitsPerSample: UInt16 = 16
        let byteRate = UInt32(sampleRate) * UInt32(numChannels) * UInt32(bitsPerSample / 8)
        let blockAlign = UInt16(numChannels * bitsPerSample / 8)
        let dataSize = UInt32(int16Samples.count * MemoryLayout<Int16>.size)
        let chunkSize = 36 + dataSize
        
        var data = Data()
        
        func append<T: FixedWidthInteger>(_ value: T) {
            var le = value.littleEndian
            withUnsafeBytes(of: &le) { buffer in
                data.append(buffer.bindMemory(to: UInt8.self))
            }
        }
        
        // WAVヘッダー
        data.append(contentsOf: "RIFF".utf8)
        append(UInt32(chunkSize))
        data.append(contentsOf: "WAVE".utf8)
        data.append(contentsOf: "fmt ".utf8)
        append(UInt32(16))              // PCM header size
        append(UInt16(1))               // Audio format (PCM)
        append(numChannels)
        append(UInt32(sampleRate))
        append(byteRate)
        append(blockAlign)
        append(bitsPerSample)
        data.append(contentsOf: "data".utf8)
        append(dataSize)
        
        // サンプルデータ
        var samplesCopy = int16Samples
        let sampleData = Data(buffer: UnsafeBufferPointer(start: &samplesCopy, count: samplesCopy.count))
        data.append(sampleData)
        
        try data.write(to: url, options: .atomic)
        
        // ファイルサイズを確認
        if let attributes = try? fileManager.attributesOfItem(atPath: url.path),
           let fileSize = attributes[.size] as? Int64 {
            print("💾 WAVファイル保存完了: \(url.lastPathComponent), サイズ: \(fileSize) バイト")
        }
    }
}

@available(macOS 12.3, *)
private class StreamOutput: NSObject, SCStreamOutput {
    private let handler: (CMSampleBuffer) -> Void
    
    init(handler: @escaping (CMSampleBuffer) -> Void) {
        self.handler = handler
    }
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        if type == .audio {
            handler(sampleBuffer)
        }
    }
}

@available(macOS 12.3, *)
private class StreamDelegate: NSObject, SCStreamDelegate {
    private let onError: (Error) -> Void
    
    init(onError: @escaping (Error) -> Void) {
        self.onError = onError
    }
    
    func stream(_ stream: SCStream, didStopWithError error: Error) {
        print("❌ ストリームエラー: \(error.localizedDescription)")
        onError(error)
    }
    
    func streamDidStartCapture(_ stream: SCStream) {
        print("✅ ストリームキャプチャが開始されました")
    }
    
    func streamDidStopCapture(_ stream: SCStream) {
        print("⏹️ ストリームキャプチャが停止されました")
    }
}

@available(macOS 12.3, *)
private extension ScreenCaptureAudioService {
    func resolveWindow(named windowName: String?, in content: SCShareableContent) -> SCWindow? {
        // 指定されたウィンドウ名で検索
        if let windowName, !windowName.isEmpty {
            let normalized = windowName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if let found = content.windows.first(where: { window in
                let displayName = window.mt_displayName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                return displayName == normalized || displayName.contains(normalized)
            }) {
                print("✅ 指定されたウィンドウを発見: \(found.mt_displayName)")
                return found
            }
        }
        
        // Teams/Zoom/Meetなどの会議アプリを優先的に検索
        let meetingAppKeywords = [
            "microsoft teams", "teams",
            "zoom", "zoom.us",
            "google meet", "meet",
            "webex", "cisco webex",
            "bluejeans", "gotomeeting",
            "skype", "skype for business"
        ]
        
        // まずアプリケーション名で検索
        if let app = content.applications.first(where: { app in
            let appName = app.applicationName.lowercased()
            return meetingAppKeywords.contains { keyword in
                appName.contains(keyword)
            }
        }) {
            // そのアプリケーションのウィンドウを探す
            if let window = content.windows.first(where: { $0.owningApplication?.bundleIdentifier == app.bundleIdentifier }) {
                print("✅ 会議アプリを発見（アプリ名）: \(app.applicationName) - \(window.mt_displayName)")
                return window
            }
        }
        
        // ウィンドウタイトルで検索
        if let matched = content.windows.first(where: { window in
            let appName = window.owningApplication?.applicationName.lowercased() ?? ""
            let title = window.title?.lowercased() ?? ""
            return meetingAppKeywords.contains { keyword in
                appName.contains(keyword) || title.contains(keyword)
            }
        }) {
            print("✅ 会議アプリを発見（ウィンドウタイトル）: \(matched.mt_displayName)")
            return matched
        }
        
        // 見つからない場合は最初のウィンドウを使用
        if let firstWindow = content.windows.first {
            print("⚠️ 会議アプリが見つからないため、最初のウィンドウを使用: \(firstWindow.mt_displayName)")
            return firstWindow
        }
        
        return nil
    }
    
    func makeContentFilter(for window: SCWindow, in content: SCShareableContent) -> SCContentFilter {
        // 音声を確実に取得するため、アプリケーション全体をキャプチャする
        guard let app = window.owningApplication else {
            print("⚠️ アプリケーション情報が見つかりません。ウィンドウ単位でキャプチャします。")
            if let display = display(containing: window, from: content.displays) {
                return SCContentFilter(display: display, including: [window])
            } else {
                return SCContentFilter(desktopIndependentWindow: window)
            }
        }
        
        // ディスプレイを取得
        guard let display = display(containing: window, from: content.displays) else {
            print("⚠️ ディスプレイが見つかりません。アプリケーション全体をキャプチャします。")
            // アプリケーション全体をキャプチャ（デスクトップ独立ウィンドウとして）
            return SCContentFilter(desktopIndependentWindow: window)
        }
        
        // アプリケーション全体をキャプチャ（音声を含む）
        print("📱 アプリケーション全体をキャプチャ: \(app.applicationName)")
        return SCContentFilter(display: display, including: [app], exceptingWindows: [])
    }
    
    func display(containing window: SCWindow, from displays: [SCDisplay]) -> SCDisplay? {
        let windowRect = window.frame
        var best: (display: SCDisplay, area: CGFloat)?
        
        for display in displays {
            let intersection = windowRect.intersection(display.frame)
            let area = intersection.mt_area
            if let currentBest = best {
                if area > currentBest.area {
                    best = (display, area)
                }
            } else if area > 0 {
                best = (display, area)
            }
        }
        
        return best?.display ?? displays.first
    }
}

@available(macOS 12.3, *)
private extension SCWindow {
    var mt_displayName: String {
        let appName = owningApplication?.applicationName ?? "Unknown App"
        let title = title?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return title.isEmpty ? appName : "\(appName) - \(title)"
    }
}

private extension CGRect {
    var mt_area: CGFloat {
        if isNull || isEmpty { return 0 }
        return width * height
    }
}

enum AudioCaptureError: LocalizedError {
    case permissionDenied
    case windowNotFound
    case streamError(String)
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "画面録画の権限が必要です。\n\nシステム環境設定 > セキュリティとプライバシー > プライバシー > 画面の録画 から、このアプリに権限を許可してください。"
        case .windowNotFound:
            return "会議アプリ（Teams、Zoom、Google Meetなど）のウィンドウが見つかりませんでした。\n\n会議アプリを起動してから、もう一度お試しください。"
        case .streamError(let message):
            return "音声ストリームの取得に失敗しました: \(message)"
        }
    }
}
