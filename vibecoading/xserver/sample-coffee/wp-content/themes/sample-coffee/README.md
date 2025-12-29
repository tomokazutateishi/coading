# Sample Coffee Okinawa WordPress Theme

沖縄の豊かな自然と、コーヒーへの深い情熱が織りなす、ここでしか味わえない一杯。土壌から育み、心を込めて焙煎する、私たちのこだわりの物語です。

## 概要

Sample Coffee OkinawaはFigmaデザインをベースに構築されたWordPressカスタムテーマです。レスポンシブデザインに対応し、デスクトップ、タブレット、モバイルデバイスで最適な表示を実現します。

## 必要要件

- WordPress 5.0以上
- PHP 7.4以上
- MySQL 5.6以上

## インストール方法

1. このテーマフォルダを `/wp-content/themes/` ディレクトリにアップロードします
2. WordPress管理画面の「外観」→「テーマ」に移動します
3. 「Sample Coffee Okinawa」テーマを有効化します

## テーマ設定

### 1. メニューの設定

WordPress管理画面で以下のメニューを設定してください：

**外観 → メニュー**

- **Primary Menu (プライマリメニュー)**
  - 私たちについて (About)
  - 店舗情報 / 豆の購入 (Find Us)
  - コンタクト (Contact)

- **Footer Menu (フッターメニュー)**
  - 店舗情報 / 豆の購入
  - 私たちについて

### 2. ページの作成

以下の固定ページを作成してください：

#### Aboutページ
- ページタイトル: 私たちについて
- スラッグ: about
- テンプレート: About Page

#### Find Usページ
- ページタイトル: 店舗情報 / 豆の購入
- スラッグ: find-us
- テンプレート: Find Us Page

#### Contactページ
- ページタイトル: コンタクト
- スラッグ: contact
- テンプレート: デフォルト

### 3. フロントページの設定

**設定 → 表示設定**
- ホームページの表示: 固定ページ
- ホームページ: (新規作成またはフロントページとして設定)

### 4. サイト情報の設定

**設定 → 一般**
- サイトのタイトル: Sample Coffee Okinawa
- キャッチフレーズ: 沖縄の太陽と恵みが育む、特別な一杯。

### 5. 画像の追加

以下のディレクトリに画像を配置してください：

```
/assets/images/
├── hero-bg.jpg           # ヒーローセクション背景
├── featured-product.jpg  # 特集商品画像
├── product-1.jpg         # 商品画像1
├── product-2.jpg         # 商品画像2
├── product-3.jpg         # 商品画像3
├── stocklist.jpg         # 店舗情報画像
├── founder.jpg           # 生産者画像
└── contact-image.jpg     # コンタクト画像
```

## ファイル構造

```
sample-coffee/
├── assets/
│   ├── css/
│   │   └── custom.css          # カスタムスタイル
│   ├── js/
│   │   └── navigation.js       # ナビゲーションスクリプト
│   └── images/                 # 画像ファイル
├── template-parts/
│   ├── content.php             # 投稿コンテンツテンプレート
│   └── content-none.php        # コンテンツなしテンプレート
├── front-page.php              # フロントページテンプレート
├── page-about.php              # Aboutページテンプレート
├── page-find-us.php            # Find Usページテンプレート
├── header.php                  # ヘッダーテンプレート
├── footer.php                  # フッターテンプレート
├── index.php                   # メインテンプレート
├── functions.php               # テーマ機能
├── style.css                   # メインスタイルシート
└── README.md                   # このファイル
```

## レスポンシブデザイン

このテーマは以下のブレークポイントに対応しています：

- **Desktop**: 1280px以上
- **Tablet**: 800px以下
- **Mobile**: 375px以下

## カスタマイズ

### カラーパレット

テーマのカラーは `style.css` の CSS変数で定義されています：

```css
:root {
    --color-black: #000000;
    --color-white: #FFFFFF;
    --color-dark-brown: #321D1D;
    --color-gray: #7C7C7C;
    --color-light-gray: #E0E0E0;
    --color-blue: #1F41FF;
}
```

### フォント

- **メインフォント**: Noto Serif JP (Google Fonts)
- **セカンダリフォント**: Geist

## 追加機能

### カスタム画像サイズ

- `sample-coffee-hero`: 1280x800px
- `sample-coffee-featured`: 600x600px
- `sample-coffee-thumbnail`: 355x355px

### ウィジェットエリア

- サイドバー (未使用)

## サポート

このテーマに関する質問や問題は、以下までお問い合わせください：

- Email: hello@name.com
- Phone: 000-0000-0000

## ライセンス

GNU General Public License v2 or later

## クレジット

- デザイン: Figmaデザインファイルに基づく
- 開発: Sample Coffee Team
- フォント: Noto Serif JP (Google Fonts)

## バージョン履歴

### Version 1.0.0
- 初回リリース
- レスポンシブデザイン対応
- カスタムページテンプレート実装
- ナビゲーションメニュー機能

