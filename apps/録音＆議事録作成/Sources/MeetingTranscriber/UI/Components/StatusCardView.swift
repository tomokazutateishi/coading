import SwiftUI

struct StatusCardView: View {
    var state: RecordingState
    var elapsedTime: TimeInterval
    var progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("状態：\(state.rawValue)")
                .font(.headline)
            Text(formattedTime)
                .font(.system(.title, design: .rounded))
                .monospacedDigit()
            ProgressView(value: progress)
                .progressViewStyle(.linear)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(.thinMaterial))
    }

    private var formattedTime: String {
        let totalSeconds = Int(elapsedTime)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
