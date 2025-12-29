# Figma Dev Mode MCPサーバーとVS Codeの連携設定メモ

## 1. 目的
FigmaのDev Mode MCPサーバー機能とVS Codeを連携させ、デザイン情報をVS Codeで利用できるようにする。

## 2. 事前準備と調査
- Figmaの公式ヘルプドキュメントを確認。
- 連携にはFigmaデスクトップアプリ側でのサーバー有効化と、VS Codeの対応拡張機能が必要であることが判明。
- ユーザーはFigmaデスクトップアプリで「Dev Mode MCP server」を有効済み。

## 3. 接続試行と問題の特定
- **接続確認 (1回目)**
    - `curl -I http://127.0.0.1:3845/sse` を実行してローカルサーバーの応答を確認。
    - サーバーからの応答は `HTTP/1.1 404 Not Found`。サーバー自体は起動しているが、指定したパス `/sse` が見つからない状態。

- **設定ファイルの調査**
    - VS Codeのユーザー設定 `settings.json` には関連する項目が見つからなかった。
    - ユーザーが以下の設定ファイルを発見: `~/Library/Application Support/Code/User/mcp.json`
    - ファイルの内容を確認したところ、サーバーURLがFigmaのリモートサーバーを指していた。
      ```json
      {
          "servers": {
              "Figma": {
                  "url": "https://mcp.figma.com/mcp",
                  "type": "http"
              }
          },
          "inputs": []
      }
      ```

## 4. 解決策の実施
- **設定ファイルの修正**
    - `mcp.json` の内容を、ローカルサーバーを参照するように変更することを提案。
    - セキュリティ制限により私からの直接編集は不可だったため、ユーザー自身に以下の内容でファイルを更新してもらった。
      ```json
      {
          "servers": {
              "Figma": {
                  "url": "http://127.0.0.1:3845/sse",
                  "type": "sse"
              }
          },
          "inputs": []
      }
      ```

- **接続確認 (2回目)**
    - ファイル更新後に再度 `curl` コマンドで接続を確認したが、結果は変わらず `404 Not Found`。

## 5. 次のステップ
- VS Codeが設定ファイルの変更を読み込めていない可能性を考慮し、**VS Codeの完全な再起動**を試す。

## 6. VS Code再起動と再度の接続確認
- VS Code再起動後も、`curl -I http://127.0.0.1:3845/sse` を実行したが、結果は変わらず `404 Not Found`。
- Figmaデスクトップアプリのローカルサーバー機能では問題が解決しないと判断。

## 7. 新たな調査とアプローチの変更
- ユーザーから提供された参考資料（`FigmaMCP`フォルダ内のブログ記事など）を読み込む。
- 以下の新しいアプローチが判明。
    - **設定ファイル:** `mcp.json` ではなく、VS Codeの `settings.json` を使用する。
    - **サーバー起動方法:** Figmaアプリの機能ではなく、`npx` を使って `figma-developer-mcp` パッケージをコマンドラインで実行する。
    - **認証:** FigmaのPersonal Access Tokenが必要。

## 8. 新しい解決策の実施
- **Step 1: Figma Personal Access Tokenの準備**
    - ユーザーがFigmaのサイトからPersonal Access Tokenを発行。

- **Step 2: VS Codeの設定変更**
    - 以前変更した `~/Library/Application Support/Code/User/mcp.json` を削除またはリネームしてリセット。
    - VS Codeの `settings.json` に以下の設定を追記。`YOUR_TOKEN` の部分には発行したトークンを挿入。
      ```json
      "mcp.servers": {
        "figma-developer-mcp": {
          "command": "npx",
          "args": [
            "-y",
            "figma-developer-mcp",
            "--figma-api-key=YOUR_TOKEN",
            "--stdio"
          ]
        }
      }
      ```

- **Step 3: サーバーの起動と動作確認**
    - VS Codeを再起動。
    - コマンドパレットから `MCP: List Servers` を実行し、`figma-developer-mcp` を選択して `Start`。
    - GitHub Copilot Chatで `@figma <URL>` を使用して動作確認を行うようユーザーに案内。

## 9. 現在の状況
- ユーザーがステップ3の動作確認を実施中。