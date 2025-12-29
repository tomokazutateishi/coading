import os
import threading
import subprocess
import shutil
import tkinter as tk
from tkinter import filedialog, messagebox
from tkinter import ttk


SEGMENT_MINUTES = 3  # 3分ごとに分割


class AudioSplitterApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("音声3分分割ツール")
        self.geometry("520x260")
        self.resizable(False, False)

        self.input_dir = tk.StringVar()
        self.output_dir = tk.StringVar()

        self._build_ui()

    def _build_ui(self):
        padding = {"padx": 10, "pady": 8}

        # 入力フォルダ
        frm_input = ttk.Frame(self)
        frm_input.pack(fill="x", **padding)

        ttk.Label(frm_input, text="入力フォルダ (音声ファイル)").pack(anchor="w")

        frm_input_row = ttk.Frame(frm_input)
        frm_input_row.pack(fill="x")

        ent_input = ttk.Entry(frm_input_row, textvariable=self.input_dir)
        ent_input.pack(side="left", fill="x", expand=True)

        ttk.Button(frm_input_row, text="参照...", command=self.browse_input).pack(side="left", padx=5)

        # 出力フォルダ
        frm_output = ttk.Frame(self)
        frm_output.pack(fill="x", **padding)

        ttk.Label(frm_output, text="出力フォルダ (output)").pack(anchor="w")

        frm_output_row = ttk.Frame(frm_output)
        frm_output_row.pack(fill="x")

        ent_output = ttk.Entry(frm_output_row, textvariable=self.output_dir)
        ent_output.pack(side="left", fill="x", expand=True)

        ttk.Button(frm_output_row, text="参照...", command=self.browse_output).pack(side="left", padx=5)

        # 進捗表示
        frm_progress = ttk.Frame(self)
        frm_progress.pack(fill="x", **padding)

        self.progress_label = ttk.Label(frm_progress, text="待機中")
        self.progress_label.pack(anchor="w")

        self.progress_bar = ttk.Progressbar(frm_progress, orient="horizontal", mode="determinate")
        self.progress_bar.pack(fill="x")

        # 実行ボタン
        frm_buttons = ttk.Frame(self)
        frm_buttons.pack(fill="x", pady=10)

        self.start_button = ttk.Button(frm_buttons, text="3分ごとに分割開始", command=self.start_splitting)
        self.start_button.pack(pady=5)

        ttk.Label(
            self,
            text="対応形式: mp3, wav, m4a など (内部で ffmpeg コマンドを使用)",
            font=("", 9),
        ).pack(pady=(0, 5))

    def browse_input(self):
        directory = filedialog.askdirectory(title="入力フォルダを選択")
        if directory:
            self.input_dir.set(directory)

    def browse_output(self):
        directory = filedialog.askdirectory(title="出力フォルダを選択")
        if directory:
            self.output_dir.set(directory)

    def start_splitting(self):
        input_dir = self.input_dir.get().strip()
        output_dir = self.output_dir.get().strip()

        if not input_dir or not os.path.isdir(input_dir):
            messagebox.showerror("エラー", "有効な入力フォルダを選択してください。")
            return

        # ffmpeg が使えるか確認
        if shutil.which("ffmpeg") is None:
            messagebox.showerror(
                "エラー",
                "ffmpeg コマンドが見つかりませんでした。\n\n"
                "Homebrew をお使いの場合は、次のコマンドでインストールしてください:\n"
                "  brew install ffmpeg",
            )
            return

        if not output_dir:
            # 未指定なら、入力フォルダの直下に output フォルダを作成
            output_dir = os.path.join(input_dir, "output")
            self.output_dir.set(output_dir)

        os.makedirs(output_dir, exist_ok=True)

        # UIロック & 別スレッドで実行
        self.start_button.config(state="disabled")
        self.progress_label.config(text="分割処理を開始します...")

        thread = threading.Thread(target=self.split_all_files, args=(input_dir, output_dir), daemon=True)
        thread.start()

    def split_all_files(self, input_dir: str, output_dir: str):
        try:
            # 対象拡張子
            exts = (".mp3", ".wav", ".m4a", ".flac", ".ogg", ".aac")
            files = [f for f in os.listdir(input_dir) if f.lower().endswith(exts)]

            if not files:
                self._update_status("音声ファイルが見つかりませんでした。", done=True)
                return

            total_files = len(files)
            self._set_progress_max(total_files)

            for idx, filename in enumerate(files, start=1):
                filepath = os.path.join(input_dir, filename)

                try:
                    self._update_status(f"[{idx}/{total_files}] {filename} を処理中...")
                    self.split_single_file(filepath, output_dir)
                except Exception as e:
                    self._append_status(f"エラー: {filename} の処理に失敗しました ({e})")

                self._step_progress()

            self._update_status("すべてのファイルの分割が完了しました。", done=True)
        finally:
            # ボタンを元に戻す
            self._enable_start_button()

    def split_single_file(self, filepath: str, output_root: str):
        """
        ffmpeg の segment 機能を使って 3分ごとに分割する。

        - 入力: 任意の音声ファイル (mp3, wav, m4a, ...）
        - 出力: mp3 (libmp3lame) に変換しつつ 3分ごとに分割
        - 出力フォルダ: output/元ファイル名/
        - 出力ファイル名: 元ファイル名_part01.mp3, 元ファイル名_part02.mp3, ...
        """
        filename = os.path.basename(filepath)
        name_without_ext, _ = os.path.splitext(filename)

        # 出力フォルダ: output/元ファイル名
        out_dir = os.path.join(output_root, name_without_ext)
        os.makedirs(out_dir, exist_ok=True)

        segment_seconds = SEGMENT_MINUTES * 60

        # ffmpeg コマンド組み立て
        # 例:
        # ffmpeg -i input.ext -vn -acodec libmp3lame -b:a 192k
        #        -f segment -segment_time 180 -reset_timestamps 1
        #        output/name_part%02d.mp3
        out_pattern = os.path.join(out_dir, f"{name_without_ext}_part%02d.mp3")

        cmd = [
            "ffmpeg",
            "-y",  # 既存ファイルがあっても上書き
            "-i",
            filepath,
            "-vn",  # 映像があっても無視
            "-acodec",
            "libmp3lame",
            "-b:a",
            "192k",
            "-f",
            "segment",
            "-segment_time",
            str(segment_seconds),
            "-reset_timestamps",
            "1",
            out_pattern,
        ]

        result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

        if result.returncode != 0:
            raise RuntimeError(f"ffmpeg 実行エラー: {result.stderr.strip()}")

    # ----- UI 更新用のヘルパー (メインスレッドで実行) -----
    def _update_status(self, text: str, done: bool = False):
        def _inner():
            self.progress_label.config(text=text)
            if done:
                messagebox.showinfo("完了", text)

        self.after(0, _inner)

    def _append_status(self, text: str):
        # 今回はラベル1つだけなので、追記というより上書きで表示
        self._update_status(text)

    def _set_progress_max(self, maximum: int):
        def _inner():
            self.progress_bar.config(maximum=maximum)
            self.progress_bar["value"] = 0

        self.after(0, _inner)

    def _step_progress(self):
        def _inner():
            self.progress_bar.step(1)

        self.after(0, _inner)

    def _enable_start_button(self):
        def _inner():
            self.start_button.config(state="normal")

        self.after(0, _inner)


if __name__ == "__main__":
    app = AudioSplitterApp()
    app.mainloop()
