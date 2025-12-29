import SwiftUI
import AppKit

extension MainView {
    private func openSettingsWindow() {
        let contentView = SettingsView(viewModel: settingsViewModel)
            .frame(minWidth: 520, minHeight: 360)
        
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.frame = NSRect(x: 0, y: 0, width: 520, height: 360)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 520, height: 360),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.contentView = hostingView
        window.title = "設定"
        window.center()
        window.makeKeyAndOrderFront(nil)
        window.isReleasedWhenClosed = false
        
        // ウィンドウが閉じられたときに通知を受け取る
        var isPresentedBinding = Binding(
            get: { isSettingsPresented },
            set: { isSettingsPresented = $0 }
        )
        
        NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { _ in
            isPresentedBinding.wrappedValue = false
        }
        
        NSApplication.shared.activate(ignoringOtherApps: true)
        settingsWindow = window
    }
    
    private func closeSettingsWindow() {
        settingsWindow?.close()
        settingsWindow = nil
    }
}

struct MainView: View {
    @ObservedObject var recordingViewModel: RecordingViewModel
    @ObservedObject var transcriptionViewModel: TranscriptionViewModel
    @ObservedObject var minutesViewModel: MinutesViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel

    @State private var searchQuery: String = ""
    @State private var isSettingsPresented: Bool = false
    @State private var settingsWindow: NSWindow?

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            content
        }
        .onChange(of: isSettingsPresented) { isPresented in
            if isPresented {
                openSettingsWindow()
            } else {
                closeSettingsWindow()
            }
        }
        .onAppear {
            recordingViewModel.updateAutoTranscriptionEnabled(settingsViewModel.settings.autoTranscriptionEnabled)
        }
        .onChange(of: settingsViewModel.settings.autoTranscriptionEnabled) { newValue in
            recordingViewModel.updateAutoTranscriptionEnabled(newValue)
        }
        .padding()
    }

    private var header: some View {
        HStack {
            Text("Meeting Transcriber")
                .font(.title2.bold())
            Spacer()
            Button(action: {
                NSApplication.shared.activate(ignoringOtherApps: true)
                isSettingsPresented = true
            }) {
                Label("設定", systemImage: "gearshape")
            }
        }
        .padding(.bottom, 12)
    }

    @ViewBuilder
    private var content: some View {
        let isTranscriptionEnabled = settingsViewModel.settings.autoTranscriptionEnabled
        HStack(alignment: .top, spacing: 24) {
            RecordingColumn(viewModel: recordingViewModel)
                .frame(maxWidth: 320)
            if isTranscriptionEnabled {
                TranscriptColumn(
                    transcriptionViewModel: transcriptionViewModel,
                    minutesViewModel: minutesViewModel,
                    settingsViewModel: settingsViewModel,
                    searchQuery: $searchQuery
                )
            } else {
                TranscriptionDisabledView()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onChange(of: recordingViewModel.state) { state in
            if isTranscriptionEnabled && state == .transcribing {
                // 録音停止後、文字起こし完了を確認
                transcriptionViewModel.completeIfNeeded()
            }
        }
        .onChange(of: transcriptionViewModel.statusMessage) { message in
            if isTranscriptionEnabled && message == "文字起こし完了" {
                recordingViewModel.markTranscriptionComplete()
            }
        }
    }
}

struct RecordingColumn: View {
    @ObservedObject var viewModel: RecordingViewModel
    @State private var isWindowSelectionPresented = false

    var body: some View {
        VStack(spacing: 16) {
            StatusCardView(state: viewModel.state,
                           elapsedTime: viewModel.elapsedTime,
                           progress: viewModel.state == .transcribing ? 0.5 : 0)

            VStack(spacing: 12) {
                Button(action: {
                    if viewModel.state == .idle {
                        if #available(macOS 12.3, *) {
                            isWindowSelectionPresented = true
                        } else {
                            viewModel.startRecording(windowName: "Teams")
                        }
                    } else {
                        viewModel.startRecording(windowName: viewModel.selectedWindowName)
                    }
                }) {
                    Label("録音開始", systemImage: "circle.fill")
                        .labelStyle(.titleAndIcon)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.state == .recording)

                Button(action: { viewModel.stopRecording() }) {
                    Label("録音終了", systemImage: "stop.fill")
                        .labelStyle(.titleAndIcon)
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.state != .recording)

                if let window = viewModel.selectedWindowName {
                    Text("対象: \(window)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)

            RecordingLogListView(entries: viewModel.logs)
            
            RecordedChunkListView(chunks: viewModel.recordedChunks) { chunk in
                NSWorkspace.shared.activateFileViewerSelecting([chunk.fileURL])
            }
        }
        .sheet(isPresented: $isWindowSelectionPresented) {
            if #available(macOS 12.3, *) {
                WindowSelectionSheet(onSelect: { windowName in
                    viewModel.startRecording(windowName: windowName)
                    isWindowSelectionPresented = false
                })
            }
        }
    }
}

struct TranscriptionDisabledView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("現在は録音のみモードです", systemImage: "mic.slash")
                .font(.headline)
            Text("設定 > 文字起こしAPI で「録音後に自動で文字起こしする」をオンにすると、ここに文字起こし結果が表示されます。")
                .font(.body)
            Text("録音されたファイルは左側の「録音ファイル」リストからFinderで確認できます。")
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).stroke(.quaternary))
    }
}

@available(macOS 12.3, *)
struct WindowSelectionSheet: View {
    @StateObject private var windowSelector = WindowSelector()
    let onSelect: (String) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        WindowSelectionView(
            windowSelector: windowSelector,
            onSelect: onSelect
        )
    }
}

@available(macOS 12.3, *)
struct WindowSelectionView: View {
    @ObservedObject var windowSelector: WindowSelector
    let onSelect: (String) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("録音するウィンドウを選択")
                .font(.headline)
            
            if windowSelector.isRefreshing {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else if windowSelector.availableWindows.isEmpty {
                Text("利用可能なウィンドウが見つかりません")
                    .foregroundStyle(.secondary)
            } else {
                List(windowSelector.availableWindows) { window in
                    Button(action: {
                        onSelect(window.displayName)
                    }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(window.appName)
                                .font(.headline)
                            Text(window.title)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)
                }
            }
            
            HStack {
                Button("更新") {
                    Task {
                        await windowSelector.refreshWindows()
                    }
                }
                Spacer()
                Button("キャンセル") {
                    dismiss()
                }
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
        .task {
            await windowSelector.refreshWindows()
        }
    }
}

struct TranscriptColumn: View {
    @ObservedObject var transcriptionViewModel: TranscriptionViewModel
    @ObservedObject var minutesViewModel: MinutesViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Binding var searchQuery: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TranscriptToolbar(searchQuery: $searchQuery)

            if transcriptionViewModel.statusMessage == "文字起こし完了" {
                CompletionBanner(message: transcriptionViewModel.statusMessage)
            }
            
            if let error = transcriptionViewModel.encounteredError {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                        Text("エラー")
                            .font(.headline)
                    }
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.orange.opacity(0.1)))
            }

            TranscriptListView(entries: filteredEntries)
                .frame(minHeight: 240)

            MinutesOptionsView(
                viewModel: minutesViewModel,
                transcript: transcriptionViewModel.rawTranscript,
                isEnabled: !transcriptionViewModel.transcriptEntries.isEmpty,
                settingsViewModel: settingsViewModel
            )
        }
    }

    private var filteredEntries: [TranscriptEntry] {
        guard !searchQuery.isEmpty else {
            return transcriptionViewModel.transcriptEntries
        }
        return transcriptionViewModel.transcriptEntries.filter { entry in
            entry.text.localizedCaseInsensitiveContains(searchQuery) ||
            entry.speaker.localizedCaseInsensitiveContains(searchQuery)
        }
    }
}

#Preview {
    let settings = SettingsViewModel(repository: UserDefaultsSettingsRepository())
    let recording = RecordingViewModel()
    let transcription = TranscriptionViewModel(settingsProvider: { settings.settings })
    transcription.transcriptEntries = [
        TranscriptEntry(timestamp: 12, speaker: "田中", text: "本日のアジェンダですが"),
        TranscriptEntry(timestamp: 45, speaker: "佐藤", text: "進捗共有します")
    ]
    let minutes = MinutesViewModel(settingsProvider: { settings.settings })
    return MainView(
        recordingViewModel: recording,
        transcriptionViewModel: transcription,
        minutesViewModel: minutes,
        settingsViewModel: settings
    )
}
