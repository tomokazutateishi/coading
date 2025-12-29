import SwiftUI
import UniformTypeIdentifiers

struct MinutesEditorView: View {
    var document: MinutesDocument
    @State private var editedContent: String = ""
    @State private var isSaving: Bool = false
    @State private var saveMessage: String?
    @ObservedObject var settingsViewModel: SettingsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("議事録")
                .font(.headline)
            TextEditor(text: $editedContent)
                .frame(minHeight: 160)
            HStack {
                Button("TXT保存") {
                    Task {
                        await save(format: .txt)
                    }
                }
                .disabled(isSaving)
                
                Button("Markdown保存") {
                    Task {
                        await save(format: .markdown)
                    }
                }
                .disabled(isSaving)
                
                Button("JSON保存") {
                    Task {
                        await save(format: .json)
                    }
                }
                .disabled(isSaving)
                
                if isSaving {
                    ProgressView()
                        .scaleEffect(0.7)
                }
                
                if let message = saveMessage {
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .onAppear {
            editedContent = document.content
        }
        .onChange(of: document.id) { _ in
            editedContent = document.content
        }
    }
    
    private func save(format: ExportFormat) async {
        isSaving = true
        saveMessage = nil
        
        do {
            let url = try await FileExporter.exportMinutes(
                editedContent,
                format: format,
                defaultPath: settingsViewModel.settings.defaultSavePath
            )
            await MainActor.run {
                saveMessage = "保存しました: \(url.lastPathComponent)"
                isSaving = false
            }
        } catch {
            await MainActor.run {
                saveMessage = "エラー: \(error.localizedDescription)"
                isSaving = false
            }
        }
    }
}
