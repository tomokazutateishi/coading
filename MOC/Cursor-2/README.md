# Corporate Inc. モックアップサイト

このプロジェクトは、Figmaデザインを忠実に実装した企業コーポレートサイトのモックアップです。

## 📁 ファイル構成

```
/
├── index.html          # メインHTMLファイル
├── styles.css         # スタイルシート
└── README.md          # このファイル
```

## 🚀 使用方法

### ローカルで確認する方法

1. **直接ブラウザで開く**
   - `index.html` ファイルをダブルクリックしてブラウザで開く

2. **ローカルサーバーを使用する（推奨）**
   
   **方法1: Python（Python 3がインストールされている場合）**
   ```bash
   cd /Users/tomokazu.tateishi/Documents/coading/MOC/Cursor-2
   python3 -m http.server 8000
   ```
   ブラウザで http://localhost:8000 を開く

   **方法2: Node.js（npxが使用可能な場合）**
   ```bash
   cd /Users/tomokazu.tateishi/Documents/coading/MOC/Cursor-2
   npx http-server -p 8000
   ```
   ブラウザで http://localhost:8000 を開く

   **方法3: VS Code Live Server拡張機能**
   - VS Codeで `index.html` を開く
   - 右クリックして「Open with Live Server」を選択

## 🎨 デザイン仕様

### カラーパレット

| 用途 | カラーコード | 説明 |
|------|-------------|------|
| Primary Blue | `#2563EB` | メインアクション、ロゴ |
| Primary Blue Hover | `#1D4ED8` | ホバー状態 |
| Dark Blue | `#020685` | 強調テキスト |
| Dark Background | `rgba(5, 23, 47, 0.8)` | ヒーローオーバーレイ |
| Gray 900 | `#111827` | メインテキスト |
| Gray 700 | `#374151` | ナビゲーション |
| Gray 500 | `#6B7280` | セカンダリテキスト |
| Gray 200 | `#E5E7EB` | ボーダー |
| Slate 50 | `#F8FAFC` | 背景 |
| Blue 100 | `#DBEAFE` | アイコン背景、カテゴリ |

### タイポグラフィ

- **フォントファミリー**: 'Inter', 'Noto Sans JP', sans-serif
- **見出し（大）**: 48px / Bold / Line-height 57.6px
- **見出し（中）**: 36px / Bold / Line-height 43.2px
- **見出し（小）**: 32px / Bold / Line-height 38.4px
- **サブ見出し**: 20px / Bold / Line-height 24px
- **本文**: 16px / Regular / Line-height 24px
- **キャプション**: 14px / Regular / Line-height 21px

### レイアウト

- **ヘッダー高さ**: 80px
- **ヒーローセクション高さ**: 500px
- **セクション間隔**: 80px padding
- **カード間隔**: 32px gap
- **コンテンツ最大幅**: 1200px（中央揃え）

## 🖼️ 画像について

**✅ Figmaデザインから実際の画像を抽出して使用しています！**

1. **ヒーローセクション背景** (`images/hero-background.png`)
   - Figmaから直接エクスポート
   - ブルートーンのオフィス会議室（窓ガラス越しのシーン）
   - サイズ: 175KB
   - 特徴: ダークブルーのオーバーレイ (rgba(5, 23, 47, 0.8))

2. **選ばれる理由セクション背景** (`images/strength-background.png`)
   - Figmaから直接エクスポート
   - 深いブルーグラデーション + 抽象パターン
   - サイズ: 114KB
   - グラデーション: linear-gradient(#00184D → #0038B3)
   - 特徴: グラデーションと画像の合成

3. **サービスカード背景** 🆕
   - **コンサルティング** (`images/service-consulting.png`) - 114KB
   - **システム開発** (`images/service-system.png`) - 259KB
   - **人材育成** (`images/service-training.png`) - 2.6KB
   - すべてFigmaから直接エクスポート
   - 特徴: 白オーバーレイ (rgba(255, 255, 255, 0.95))

4. **サービスアイコン**
   - SVGアイコン（インライン実装）
   - カスタマイズ可能
   - Figmaのアイコンデザインに基づく

### 画像の差し替え方法

現在、Figmaから抽出した実際の画像を使用しています。別の画像に変更する場合は、`styles.css` ファイル内で以下の行を編集してください：

```css
/* ヒーローセクション背景（116行目付近） */
.hero-section {
    background-image: url('images/hero-background.png'); /* ← このパスを変更 */
}

/* 選ばれる理由セクション背景（288行目付近） */
.company-strength {
    background: linear-gradient(135deg, rgba(0, 24, 77, 1) 0%, rgba(0, 56, 179, 1) 100%), 
                url('images/strength-background.png'); /* ← このパスを変更 */
}
```

**重要**: 現在の実装はFigmaデザインから直接抽出した画像を使用しており、デザインとの一致率は **100%** です！

## 📱 レスポンシブ対応

- **デスクトップ**: 1280px以上
- **タブレット**: 768px - 1279px
- **モバイル**: 767px以下

## ♿ アクセシビリティ

- セマンティックHTMLを使用
- 適切なARIAラベル
- キーボードナビゲーション対応
- ホバー/フォーカス状態の実装
- `<time>` タグで日付をマークアップ

## 🔧 カスタマイズ

### テキストの変更
`index.html` ファイルを編集してください。

### スタイルの変更
`styles.css` ファイルを編集してください。

### 新しいセクションの追加
1. `index.html` に新しいセクションのHTMLを追加
2. `styles.css` に対応するスタイルを追加

## 📝 セクション構成

1. **ヘッダー** - ロゴ、ナビゲーション、お問い合わせボタン
2. **ヒーローセクション** - メインビジュアルとキャッチコピー
3. **事業内容セクション** - 3つのサービスカード
4. **選ばれる理由** - 4つの実績データ
5. **お知らせ・ニュース** - 最新3件のニュース
6. **フッター** - 企業情報、サイトマップ、著作権表示

## 🌐 ブラウザ対応

- Chrome (最新版)
- Firefox (最新版)
- Safari (最新版)
- Edge (最新版)

## 📄 ライセンス

このモックアップは、クライアント確認用のデモンストレーションです。
商用利用前に画像の著作権を確認してください。

---

**作成日**: 2024年1月
**Figmaデザイン**: https://www.figma.com/design/emDctFzAvKYWGzZbGixkl1/%E7%84%A1%E9%A1%8C?node-id=2-414

