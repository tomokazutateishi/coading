import SwiftUI
import AppKit

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var selectedTab: SettingsTab = .transcription
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            Picker("", selection: $selectedTab) {
                ForEach(SettingsTab.allCases) { tab in
                    Text(tab.title).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 12)

            switch selectedTab {
            case .transcription:
                TranscriptionSettingsView(viewModel: viewModel)
            case .minutes:
                MinutesSettingsView(viewModel: viewModel)
            case .storage:
                StorageSettingsView(viewModel: viewModel)
            }

            HStack {
                Spacer()
                Button("閉じる") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

private enum SettingsTab: CaseIterable, Identifiable {
    case transcription
    case minutes
    case storage

    var id: Self { self }
    var title: String {
        switch self {
        case .transcription: return "文字起こしAPI"
        case .minutes: return "議事録設定"
        case .storage: return "保存設定"
        }
    }
}

private struct TranscriptionSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var showAPIKey: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("サービス")
                    .font(.headline)
                Picker("", selection: $viewModel.settings.transcriptionService) {
                    ForEach(TranscriptionServiceKind.allCases) { service in
                        Text(service.displayName).tag(service)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("APIキー")
                    .font(.headline)
                HStack {
                    Group {
                        if showAPIKey {
                            TextField("sk-...", text: $viewModel.apiKeyInput)
                                .textFieldStyle(.roundedBorder)
                        } else {
                            SecureField("sk-...", text: $viewModel.apiKeyInput)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    .frame(minWidth: 400)
                    .onTapGesture {
                        // タップでアプリをアクティブにする
                        NSApplication.shared.activate(ignoringOtherApps: true)
                    }
                    
                    Button(action: { showAPIKey.toggle() }) {
                        Image(systemName: showAPIKey ? "eye.slash.fill" : "eye.fill")
                    }
                    .buttonStyle(.plain)
                    .help(showAPIKey ? "非表示にする" : "表示する")
                }
                
                if !viewModel.apiKeyInput.isEmpty {
                    Text("入力済み: \(String(viewModel.apiKeyInput.prefix(7)))...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text("OpenAI API キーを入力してください（sk- で始まる文字列）")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("デフォルト言語")
                    .font(.headline)
                TextField("ja", text: Binding(
                    get: { viewModel.settings.defaultLanguageCode },
                    set: { viewModel.settings.defaultLanguageCode = $0 }
                ))
                .textFieldStyle(.roundedBorder)
                Text("例: ja (日本語), en (英語)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("同時リクエスト数")
                    .font(.headline)
                Stepper(value: $viewModel.settings.concurrentRequests, in: 1...5) {
                    Text("\(viewModel.settings.concurrentRequests)")
                }
                Text("同時に処理するチャンクの数。多いほど速いですが、レート制限に注意してください。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Toggle(isOn: $viewModel.settings.autoTranscriptionEnabled) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("録音後に自動で文字起こしする")
                    Text("オフの場合は録音ファイルのみ保存し、後から手動で文字起こしします。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .toggleStyle(.switch)
            
            HStack {
                Button("テスト接続") { viewModel.testConnection() }
                    .disabled(viewModel.isTestingConnection)
                if viewModel.isTestingConnection {
                    ProgressView()
                        .scaleEffect(0.7)
                }
                if let message = viewModel.testResultMessage {
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(message.contains("失敗") || message.contains("エラー") ? .red : .secondary)
                }
                Spacer()
                Button("保存") { viewModel.save() }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}

private struct MinutesSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Form {
            Picker("詳細レベル", selection: $viewModel.settings.defaultDetailLevel) {
                ForEach(MinutesDetailLevel.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            Picker("記載形式", selection: $viewModel.settings.defaultFlowStyle) {
                ForEach(MinutesFlowStyle.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            Picker("補完方針", selection: $viewModel.settings.defaultMissingInfoStrategy) {
                ForEach(MissingInfoStrategy.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
        }
        .formStyle(.grouped)
    }
}

private struct StorageSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var path: String = ""

    var body: some View {
        Form {
            TextField("保存先パス", text: Binding(
                get: { viewModel.settings.defaultSavePath?.path(percentEncoded: false) ?? "" },
                set: { newValue in
                    viewModel.settings.defaultSavePath = newValue.isEmpty ? nil : URL(fileURLWithPath: newValue)
                }
            ))
            Picker("デフォルト形式", selection: $viewModel.settings.defaultExportFormat) {
                ForEach(ExportFormat.allCases) { format in
                    Text(format.displayName).tag(format)
                }
            }
        }
        .formStyle(.grouped)
    }
}
