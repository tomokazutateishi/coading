#!/bin/bash

# アプリをターミナルから起動してログを表示するスクリプト

cd "$(dirname "$0")"

echo "Meeting Transcriber を起動します（ログ表示付き）..."
echo "=========================================="
echo ""

# アプリをビルド
swift build -c release

# 実行ファイルを直接実行（ログがターミナルに表示される）
.build/release/MeetingTranscriber





