import SwiftUI

struct RecordedChunkListView: View {
    let chunks: [AudioChunk]
    let onReveal: (AudioChunk) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("録音ファイル")
                .font(.caption)
                .foregroundStyle(.secondary)

            if chunks.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("まだ録音されたファイルはありません。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text("録音を停止すると、ここに保存されたチャンクが表示されます。")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).stroke(.quaternary))
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(chunks) { chunk in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(chunk.fileURL.lastPathComponent)
                                    .font(.footnote)
                                    .bold()
                                Text("開始: \(Date(timeIntervalSince1970: chunk.startedAt), style: .time) / 長さ: \(formatted(duration: chunk.duration))秒")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Button {
                                    onReveal(chunk)
                                } label: {
                                    Label("Finderで表示", systemImage: "folder")
                                }
                                .buttonStyle(.bordered)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Divider()
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(minHeight: 150)
                .background(RoundedRectangle(cornerRadius: 12).stroke(.quaternary))
            }
        }
    }

    private func formatted(duration: TimeInterval) -> String {
        String(format: "%.1f", duration)
    }
}




