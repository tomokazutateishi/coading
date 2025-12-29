import SwiftUI

struct TranscriptListView: View {
    let entries: [TranscriptEntry]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(entries) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("[\(formattedTime(entry.timestamp))] \(entry.speaker)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(entry.text)
                            .font(.body)
                    }
                    .padding(.bottom, 4)
                    Divider()
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(.quaternary))
    }

    private func formattedTime(_ interval: TimeInterval) -> String {
        let seconds = Int(interval) % 60
        let minutes = Int(interval / 60)
        let hours = Int(interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
