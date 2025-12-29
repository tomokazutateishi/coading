# 音声3分分割ツール

Python + Tkinter + pydub を使った、音声ファイルを 3 分ごとに自動分割する簡単なGUIアプリです。

## 必要なもの

- Python 3.x
- ffmpeg (pydub が内部で使用します)
- Python ライブラリ
  - pydub

### ライブラリのインストール

```bash
pip install -r requirements.txt
```

### ffmpeg のインストール例 (macOS / Homebrew)

```bash
brew install ffmpeg
```

## 使い方

1. このフォルダで Python を起動します:
    ```bash
    cd "音声分割"
    python main.py
    ```
2. アプリが起動したら、
   - 「入力フォルダ」… 3 分ごとに分割したい音声ファイルが入ったフォルダを選択
   - 「出力フォルダ」… 分割後のファイルを出力したいフォルダを選択
     - 未指定の場合は、入力フォルダの中に自動で `output` フォルダが作られます
3. 「3分ごとに分割開始」ボタンを押すと、
   - 対象フォルダ内の `mp3, wav, m4a, flac, ogg, aac` ファイルをすべて読み込み
   - 各ファイルを 3 分ごとに分割
   - `output/元ファイル名/元ファイル名_part01.mp3` のように保存されます。

## 補足

- 変換後の形式は `mp3` で固定しています。
- 変換に失敗したファイルがあっても、他のファイルの処理は継続されます。
