import Foundation
import ScreenCaptureKit

@available(macOS 12.3, *)
struct WindowInfo: Identifiable {
    let id: UUID
    let windowID: CGWindowID
    let title: String
    let appName: String
    
    var displayName: String {
        "\(appName) - \(title)"
    }
}

@available(macOS 12.3, *)
@MainActor
class WindowSelector: ObservableObject {
    @Published var availableWindows: [WindowInfo] = []
    @Published var isRefreshing: Bool = false
    
    func refreshWindows() async {
        isRefreshing = true
        defer { isRefreshing = false }
        
        do {
            let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: true)
            
            let windows = content.windows.compactMap { window -> WindowInfo? in
                guard let app = window.owningApplication else { return nil }
                return WindowInfo(
                    id: UUID(),
                    windowID: window.windowID,
                    title: window.title ?? "",
                    appName: app.applicationName
                )
            }
            
            // Teams と Zoom を優先的に表示
            let sortedWindows = windows.sorted { w1, w2 in
                let w1IsTarget = w1.appName.contains("Teams") || w1.appName.contains("Zoom")
                let w2IsTarget = w2.appName.contains("Teams") || w2.appName.contains("Zoom")
                if w1IsTarget && !w2IsTarget { return true }
                if !w1IsTarget && w2IsTarget { return false }
                return w1.displayName < w2.displayName
            }
            
            availableWindows = sortedWindows
        } catch {
            print("Failed to get windows: \(error)")
            availableWindows = []
        }
    }
}

