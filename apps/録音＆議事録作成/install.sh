#!/bin/bash

# Meeting Transcriber を Applications フォルダにインストールするスクリプト

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_NAME="MeetingTranscriber.app"
TARGET_DIR="$HOME/Applications"

echo "Meeting Transcriber をインストールします..."

# ビルド
echo "アプリをビルドしています..."
cd "$SCRIPT_DIR"
swift build -c release

if [ $? -ne 0 ]; then
    echo "エラー: ビルドに失敗しました"
    exit 1
fi

# .app バンドルを更新
echo ".app バンドルを更新しています..."
mkdir -p "$APP_NAME/Contents/MacOS"
cp .build/release/MeetingTranscriber "$APP_NAME/Contents/MacOS/"
chmod +x "$APP_NAME/Contents/MacOS/MeetingTranscriber"

# Applications フォルダにコピー
echo "Applications フォルダにインストールしています..."
if [ -d "$TARGET_DIR/$APP_NAME" ]; then
    rm -rf "$TARGET_DIR/$APP_NAME"
fi
cp -R "$APP_NAME" "$TARGET_DIR/"

# Launch Services を更新
echo "システムに登録しています..."
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$TARGET_DIR/$APP_NAME"

echo "インストール完了！"
echo "Applications フォルダから Meeting Transcriber を起動できます。"





