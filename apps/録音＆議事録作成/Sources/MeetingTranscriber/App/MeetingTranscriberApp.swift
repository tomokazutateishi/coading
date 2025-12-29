import SwiftUI
import AppKit

@main
struct MeetingTranscriberApp: App {
    @StateObject private var settingsViewModel: SettingsViewModel
    @StateObject private var recordingViewModel: RecordingViewModel
    @StateObject private var transcriptionViewModel: TranscriptionViewModel
    @StateObject private var minutesViewModel: MinutesViewModel

    init() {
        let settingsVM = SettingsViewModel()
        let recordingVM = RecordingViewModel()
        let transcriptionVM = TranscriptionViewModel(settingsProvider: { settingsVM.settings })
        let minutesVM = MinutesViewModel(settingsProvider: { settingsVM.settings })

        transcriptionVM.bind(to: recordingVM.chunksPublisher)

        _settingsViewModel = StateObject(wrappedValue: settingsVM)
        _recordingViewModel = StateObject(wrappedValue: recordingVM)
        _transcriptionViewModel = StateObject(wrappedValue: transcriptionVM)
        _minutesViewModel = StateObject(wrappedValue: minutesVM)
    }

    var body: some Scene {
        WindowGroup {
            MainView(
                recordingViewModel: recordingViewModel,
                transcriptionViewModel: transcriptionViewModel,
                minutesViewModel: minutesViewModel,
                settingsViewModel: settingsViewModel
            )
            .frame(minWidth: 800, minHeight: 600)
            .background(WindowAccessor())
        }
        .windowStyle(.automatic)
        .defaultSize(width: 1000, height: 700)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}

// ウィンドウを前面に表示するためのヘルパー
struct WindowAccessor: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                window.makeKeyAndOrderFront(nil)
                NSApplication.shared.activate(ignoringOtherApps: true)
                window.level = .floating
                window.level = .normal
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
