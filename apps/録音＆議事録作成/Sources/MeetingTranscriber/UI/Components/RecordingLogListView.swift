import SwiftUI

struct RecordingLogListView: View {
    let entries: [RecordingLogEntry]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ログ")
                .font(.caption)
                .foregroundStyle(.secondary)
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(entries) { entry in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.message)
                                .font(.footnote)
                            Text(entry.timestamp, style: .time)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                    }
                }
            }
            .frame(minHeight: 120)
            .background(RoundedRectangle(cornerRadius: 12).stroke(.quaternary))
        }
    }
}
