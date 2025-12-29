import SwiftUI

struct MinutesOptionsView: View {
    @ObservedObject var viewModel: MinutesViewModel
    let transcript: RawTranscript
    var isEnabled: Bool
    @ObservedObject var settingsViewModel: SettingsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("議事録オプション")
                .font(.headline)
            OptionGroup(
                title: "詳細レベル",
                options: MinutesDetailLevel.allCases,
                selection: binding(
                    get: { viewModel.spec.detailLevel },
                    set: { viewModel.spec.detailLevel = $0 }
                )
            )
            OptionGroup(
                title: "記載の流れ",
                options: MinutesFlowStyle.allCases,
                selection: binding(
                    get: { viewModel.spec.flowStyle },
                    set: { viewModel.spec.flowStyle = $0 }
                )
            )
            OptionGroup(
                title: "足りない情報",
                options: MissingInfoStrategy.allCases,
                selection: binding(
                    get: { viewModel.spec.missingInfoStrategy },
                    set: { viewModel.spec.missingInfoStrategy = $0 }
                )
            )
            Button {
                viewModel.generate(from: transcript)
            } label: {
                Label("議事録にまとめる", systemImage: "doc.text")
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isEnabled || viewModel.isGenerating)

            if let document = viewModel.latestDocument {
                MinutesEditorView(document: document, settingsViewModel: settingsViewModel)
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).stroke(.quaternary))
        .opacity(isEnabled ? 1 : 0.4)
    }
}

private struct OptionGroup<Option: Identifiable & RawRepresentable & Hashable>: View where Option.RawValue == String {
    let title: String
    let options: [Option]
    @Binding var selection: Option

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
            HStack {
                ForEach(options) { option in
                    RadioButton(isSelected: selection == option, label: option.rawValue) {
                        selection = option
                    }
                }
            }
        }
    }
}

private struct RadioButton: View {
    let isSelected: Bool
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                Text(label)
            }
        }
        .buttonStyle(.plain)
    }
}

private func binding<Value>(get: @escaping () -> Value, set: @escaping (Value) -> Void) -> Binding<Value> {
    Binding(get: get, set: set)
}
