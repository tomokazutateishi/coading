import SwiftUI

struct TranscriptToolbar: View {
    @Binding var searchQuery: String

    var body: some View {
        HStack {
            TextField("キーワード検索", text: $searchQuery)
                .textFieldStyle(.roundedBorder)
            Menu {
                Button("TXTで保存") {}
                Button("Markdownで保存") {}
                Button("JSONで保存") {}
                Button("WAVで保存") {}
            } label: {
                Label("ダウンロード", systemImage: "square.and.arrow.down")
            }
            Button(action: {}) {
                Image(systemName: "doc.on.doc")
            }
            .help("コピー")
        }
    }
}
