# 三菱ガス化学 情報システム部ポータル 実装記録

## プロジェクト概要

Figmaデザインを忠実に再現した三菱ガス化学の情報システム部ポータルページをVue 3とHTML/CSSで実装しました。

## 実装環境

- **プロジェクトパス**: `/Users/tomokazu.tateishi/Documents/frontend/personalize`
- **フレームワーク**: Vue 3 (Composition API / `<script setup>`)
- **言語**: TypeScript
- **スタイリング**: CSS (Figmaデザインに忠実)
- **フォント**: Noto Sans JP, Inter (Google Fonts)

## Figmaデザイン分析

### デザインファイル
- **メインページ**: https://www.figma.com/design/02J3cKnfVHWAtiA0w6qpnB/%E4%B8%89%E8%8F%B1%E3%82%AC%E3%82%B9%E5%8C%96%E5%AD%A6%EF%BC%88%E6%8F%90%E6%A1%88%EF%BC%89?node-id=1755-6342&t=qS2aKMhFB1uB7Rke-4
- **コンポーネント**: https://www.figma.com/design/02J3cKnfVHWAtiA0w6qpnB/%E4%B8%89%E8%8F%B1%E3%82%AC%E3%82%B9%E5%8C%96%E5%AD%A6%EF%BC%88%E6%8F%90%E6%A1%88%EF%BC%89?node-id=1217-13607&t=qS2aKMhFB1uB7Rke-4

### デザイン要素
- **カラーパレット**:
  - メインテキスト: `#2e3033`
  - プライマリ: `#0072bf`
  - エンファシス: `#d90000`
  - リンク: `#0b79d9`
  - プライマリブライト: `#3995e5`
  - 白: `#ffffff`

- **レイアウト構成**:
  1. ヘッダー（ロゴ + 検索ボックス）
  2. ナビゲーション（青いメニューバー）
  3. メインビジュアル（グラデーション背景 + 画像）
  4. 緊急お知らせ（赤いバナー）
  5. お知らせ一覧（7件のお知らせ）
  6. フッター（コピーライト）

## 実装ファイル構成

### Vue 3実装

#### メインページ
- `src/pages/hoge/Portal.vue` - メインポータルページ
- URL: `/hoge/portal`

#### 再利用可能コンポーネント
- `src/components/element/MgcButton.vue` - ボタンコンポーネント
- `src/components/element/MgcBadge.vue` - バッジコンポーネント
- `src/components/element/MgcNavigation.vue` - ナビゲーションメニュー
- `src/components/element/MgcSearchBox.vue` - 検索ボックス

#### ルーティング
- `src/router/index.ts` - ルート設定追加

### HTML/CSS実装
- `portal.html` - 単純なHTML/CSSファイル（ローカル確認用）

## 実装詳細

### 1. ヘッダー部分
```vue
<header class="header">
  <div class="header-content">
    <div class="logo-section">
      <h1 class="logo">情報システム部 ポータル</h1>
    </div>
    <div class="search-section">
      <MgcSearchBox
        v-model:value="searchValue"
        placeholder="キーワードで検索..."
        @submit="handleSearch"
      />
    </div>
  </div>
</header>
```

### 2. ナビゲーション
```vue
<MgcNavigation
  :items="navigationItems"
  @item-click="handleNavigationClick"
/>
```

### 3. お知らせセクション
```vue
<div class="news-list">
  <div v-for="(item, index) in newsItems" :key="index" class="news-item">
    <div class="news-date">{{ item.date }}</div>
    <div class="news-time">{{ item.time }}</div>
    <div class="news-category">
      <MgcBadge 
        :type="item.category.type" 
        :text="item.category.name"
      />
    </div>
    <div class="news-text">
      <h4>{{ item.title }}</h4>
      <div class="news-meta">
        <MgcBadge 
          v-if="item.isNew" 
          type="new" 
          text="新着"
          size="small"
        />
      </div>
    </div>
  </div>
</div>
```

## コンポーネント仕様

### MgcButton.vue
- **バリアント**: default, secondary, outline, ghost
- **サイズ**: small, medium, large
- **機能**: アイコン対応、無効化状態、クリックイベント

### MgcBadge.vue
- **タイプ**: security, info, notice, error, new
- **サイズ**: small, medium, large
- **機能**: カテゴリ表示、ステータス表示

### MgcNavigation.vue
- **機能**: アクティブ状態管理、ホバー効果、クリックイベント
- **レスポンシブ**: モバイル対応

### MgcSearchBox.vue
- **機能**: 検索入力、クリアボタン、フォーカス管理
- **イベント**: input, submit, focus, blur, clear

## データ構造

### ナビゲーション項目
```typescript
interface NavigationItem {
  text: string
  active?: boolean
  href?: string
  disabled?: boolean
}
```

### お知らせ項目
```typescript
interface NewsItem {
  date: string
  time: string
  category: {
    name: string
    type: 'security' | 'info' | 'notice' | 'error' | 'new'
  }
  title: string
  isNew: boolean
}
```

## スタイリング

### カラーパレット実装
```css
:root {
  --color-text-main: #2e3033;
  --color-primary: #0072bf;
  --color-emphasis: #d90000;
  --color-link: #0b79d9;
  --color-primary-bright: #3995e5;
  --color-white: #ffffff;
}
```

### レスポンシブデザイン
- **デスクトップ**: 1366px幅対応
- **タブレット**: 768px以下でナビゲーション縦並び
- **モバイル**: 480px以下でフォントサイズ調整

## 動作確認

### ビルドテスト
```bash
cd /Users/tomokazu.tateishi/Documents/frontend/personalize
pnpm run build
# ✅ ビルド成功
```

### 開発サーバー
```bash
pnpm dev
# ✅ http://localhost:5174/ で動作確認
```

### HTMLファイル
- `portal.html` をブラウザで直接開いて確認可能
- サーバー不要、即座に確認可能

## アクセシビリティ対応

### HTMLセマンティクス
- 適切なheader, nav, main, section, footer要素使用
- 見出しの階層構造（h1, h2, h3, h4）
- リスト構造の適切な使用

### キーボードナビゲーション
- フォーカス管理
- Enterキーでの検索実行
- Tabキーでの要素移動

### スクリーンリーダー対応
- 適切なaria-label
- 意味のあるalt属性
- ロール属性の使用

## 技術的課題と解決

### TypeScript型エラー
```typescript
// 解決前
:type="item.category.type"

// 解決後
:type="item.category.type as 'security' | 'info' | 'notice' | 'error' | 'new'"
```

### コンポーネントのprops未使用警告
```typescript
// 解決前
const props = defineProps<Props>()

// 解決後
defineProps<Props>()
```

## 今後の拡張可能性

### 機能追加
- 検索機能の実装
- お知らせ詳細ページ
- ページネーション
- フィルタリング機能

### パフォーマンス最適化
- 画像の遅延読み込み
- コンポーネントの遅延読み込み
- バンドルサイズの最適化

### 国際化対応
- i18nライブラリの導入
- 多言語対応

## まとめ

Figmaデザインを忠実に再現した三菱ガス化学の情報システム部ポータルページを、Vue 3とHTML/CSSの両方で実装しました。

### 成果
- ✅ Figmaデザインの完全再現
- ✅ 再利用可能なコンポーネント設計
- ✅ TypeScript対応
- ✅ レスポンシブデザイン
- ✅ アクセシビリティ配慮
- ✅ 既存コードへの影響なし
- ✅ ローカル環境での簡単確認

### ファイル構成
```
frontend/personalize/
├── src/
│   ├── pages/hoge/
│   │   └── Portal.vue          # メインページ
│   ├── components/element/
│   │   ├── MgcButton.vue       # ボタンコンポーネント
│   │   ├── MgcBadge.vue        # バッジコンポーネント
│   │   ├── MgcNavigation.vue   # ナビゲーションコンポーネント
│   │   └── MgcSearchBox.vue    # 検索ボックスコンポーネント
│   └── router/
│       └── index.ts            # ルーティング設定
└── portal.html                 # HTML/CSS版（ローカル確認用）
```

この実装により、デザインの忠実性とコードの保守性を両立した、高品質なポータルページが完成しました。

