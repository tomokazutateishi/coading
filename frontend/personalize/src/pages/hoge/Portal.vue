<template>
  <MgcBackground variant="default" size="container">
    <div class="portal-page">
    <!-- Header -->
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

    <!-- Navigation -->
    <MgcNavigation
      :items="navigationItems"
      @item-click="handleNavigationClick"
    />

    <!-- Main Visual -->
    <section class="main-visual">
      <div class="visual-content">
        <div class="visual-text">
          <h2 class="visual-title">情報システム部 ポータル</h2>
          <p class="visual-subtitle">※サイト内の情報は社外秘です</p>
        </div>
        <div class="visual-image">
          <!-- モック画像 -->
          <div class="mock-image"></div>
        </div>
      </div>
    </section>

    <!-- Main Content -->
    <main class="main-content">
      <!-- Emergency Notice -->
      <div class="emergency-notice">
        <div class="notice-content">
          <div class="notice-badge emergency">緊急のお知らせ</div>
          <p class="notice-text">
            4月20日(日) 18:00～21:00 にシステムメンテナンスを実施いたします。期間中は利用できませんのでご注意ください。
          </p>
          <div class="notice-arrow">
            <svg width="12" height="12" viewBox="0 0 24 24" fill="none">
              <path d="M8.59 16.59L13.17 12L8.59 7.41L10 6L16 12L10 18L8.59 16.59Z" fill="#999"/>
            </svg>
          </div>
        </div>
      </div>

      <!-- News Section -->
      <section class="news-section">
        <div class="news-header">
          <div class="news-title">
            <div class="title-bar"></div>
            <h3>お知らせ</h3>
            <a href="#" class="news-link">
              お知らせ一覧
              <svg width="12" height="12" viewBox="0 0 24 24" fill="none">
                <path d="M8.59 16.59L13.17 12L8.59 7.41L10 6L16 12L10 18L8.59 16.59Z" fill="#0b79d9"/>
              </svg>
            </a>
          </div>
        </div>

        <div class="news-content">
          <div class="news-list">
            <div 
              v-for="(item, index) in newsItems" 
              :key="index" 
              class="news-item"
            >
              <div class="news-date">{{ item.date }}</div>
              <div class="news-time">{{ item.time }}</div>
              <div class="news-category">
                <MgcBadge 
                  :type="item.category.type as 'security' | 'info' | 'notice' | 'error' | 'new'" 
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
                  <svg width="26" height="26" viewBox="0 0 24 24" fill="none">
                    <path d="M8.59 16.59L13.17 12L8.59 7.41L10 6L16 12L10 18L8.59 16.59Z" fill="#999"/>
                  </svg>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <!-- Footer -->
    <footer class="footer">
      <p>Copyright © MITSUBISHI GAS CHEMICAL COMPANY, INC. All rights reserved.</p>
    </footer>
    </div>
  </MgcBackground>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import MgcSearchBox from '../../components/element/MgcSearchBox.vue'
import MgcNavigation from '../../components/element/MgcNavigation.vue'
import MgcBadge from '../../components/element/MgcBadge.vue'
import MgcBackground from '../../components/element/MgcBackground.vue'

// 検索値
const searchValue = ref('')

// ナビゲーション項目
const navigationItems = ref([
  { text: 'ホーム', active: true },
  { text: '機器・コミュニケーションツール', active: false },
  { text: 'アプリケーションツール', active: false },
  { text: '情報システムセキュリティ', active: false },
  { text: '申請書・問い合わせ', active: false }
])

// お知らせデータ
const newsItems = ref([
  {
    date: '2025年 04月 23日',
    time: '09時30分',
    category: { name: 'セキュリティ', type: 'security' },
    title: '【障害報告】VPN接続に関する一時的な不具合について',
    isNew: true
  },
  {
    date: '2025年 04月 23日',
    time: '10時30分',
    category: { name: 'セキュリティ', type: 'security' },
    title: 'ファイルサーバの空き容量不足による不要なファイル削除のお願い',
    isNew: true
  },
  {
    date: '2025年 04月 24日',
    time: '11時39分',
    category: { name: 'お知らせ', type: 'info' },
    title: 'ファイルサーバの空き容量不足による不要なファイル削除のお願い',
    isNew: true
  },
  {
    date: '2025年 04月 24日',
    time: '12時17分',
    category: { name: '通達', type: 'notice' },
    title: 'テキストテキストテキストテキストテキスト',
    isNew: true
  },
  {
    date: '2025年 04月 25日',
    time: '09時17分',
    category: { name: 'セキュリティ', type: 'security' },
    title: '5月にSFAシステムの移行を実施予定です',
    isNew: false
  },
  {
    date: '2025年 04月 26日',
    time: '09時17分',
    category: { name: 'お知らせ', type: 'info' },
    title: '業務用PCのセキュリティアップデートについて：来週3月28日(金) 18:00〜0:00 に、全社PCを対象としたWindowsのセキュリティパッチ適用を実施します。自動再起動が発生する場合がございますので、作業中のファイル未保存にご注意ください。詳細はこちらをご覧ください。',
    isNew: false
  },
  {
    date: '2025年 04月 28日',
    time: '09時17分',
    category: { name: 'システム障害', type: 'error' },
    title: 'Microsoft Teams 一部機能障害の報告がありましたが、復旧しました。調査内容はこちらをご覧ください。',
    isNew: false
  }
])

// イベントハンドラー
const handleSearch = (value: string) => {
  console.log('検索:', value)
  // 検索ロジックをここに実装
}

const handleNavigationClick = (item: any, index: number) => {
  // アクティブ状態を更新
  navigationItems.value.forEach((navItem, i) => {
    navItem.active = i === index
  })
  console.log('ナビゲーションクリック:', item.text)
  // ナビゲーションロジックをここに実装
}
</script>

<style scoped>
.portal-page {
  width: 100%;
  max-width: 1280px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  background-color: #dddddd;
}

/* Header Styles */
.header {
  background-color: #ffffff;
  padding: 12px 16px;
  box-shadow: 0px 0px 15px 0px rgba(0, 47, 97, 0.2);
  position: sticky;
  top: 0;
  z-index: 4;
}

.header-content {
  display: flex;
  align-items: center;
  gap: 154px;
  width: 100%;
}

.logo-section h1 {
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 700;
  font-size: 20px;
  color: #2e3033;
  margin: 0;
  line-height: 1;
}

.search-section {
  flex: 1;
  max-width: 400px;
}

/* Main Visual Styles */
.main-visual {
  background: linear-gradient(to right, #e8f3fa 0%, #ccdbed 42.819%);
  height: 130px;
  position: relative;
  overflow: hidden;
}

.visual-content {
  position: relative;
  height: 100%;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 80px;
}

.visual-text {
  z-index: 2;
}

.visual-title {
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 700;
  font-size: 28px;
  color: #004473;
  margin: 0 0 16px 0;
  line-height: 1;
}

.visual-subtitle {
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 400;
  font-size: 16px;
  color: #004473;
  margin: 0;
  line-height: 1;
}

.visual-image {
  position: absolute;
  right: 0;
  top: 0;
  width: 689px;
  height: 130px;
  overflow: hidden;
}

.mock-image {
  width: 100%;
  height: 100%;
  background: linear-gradient(45deg, #f0f0f0, #e0e0e0);
  position: relative;
}

.mock-image::after {
  content: '画像エリア';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #999;
  font-size: 14px;
}

/* Main Content Styles */
.main-content {
  background-color: #ffffff;
  padding: 16px 40px 40px;
  flex: 1;
}

/* Emergency Notice Styles */
.emergency-notice {
  margin-bottom: 32px;
}

.notice-content {
  background-color: #fff3f2;
  border: 0.5px solid #d90000;
  border-radius: 2px;
  padding: 8px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.notice-badge {
  background-color: #d90000;
  color: #ffffff;
  padding: 4px 16px;
  border-radius: 2px;
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 500;
  font-size: 12px;
  white-space: nowrap;
}

.notice-text {
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 500;
  font-size: 14px;
  color: #d90000;
  margin: 0;
  flex: 1;
}

.notice-arrow {
  width: 12px;
  height: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* News Section Styles */
.news-section {
  margin-bottom: 80px;
}

.news-header {
  margin-bottom: 8px;
}

.news-title {
  display: flex;
  align-items: end;
  gap: 16px;
  padding-bottom: 8px;
}

.title-bar {
  width: 5px;
  height: 24px;
  background-color: #0072bf;
}

.news-title h3 {
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 700;
  font-size: 20px;
  color: #0072bf;
  margin: 0;
  line-height: 1.2;
}

.news-link {
  display: flex;
  align-items: center;
  gap: 4px;
  text-decoration: none;
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 500;
  font-size: 14px;
  color: #0b79d9;
  white-space: nowrap;
}

.news-content {
  border: 6px solid #dfeaf7;
  border-radius: 4px;
  padding: 32px 24px;
}

.news-list {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.news-item {
  display: flex;
  align-items: start;
  gap: 16px;
  padding: 8px 16px;
  border-bottom: 1px solid #f0f0f0;
}

.news-item:last-child {
  border-bottom: none;
}

.news-date {
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 400;
  font-size: 15px;
  color: #2e3033;
  width: 120px;
  flex-shrink: 0;
  line-height: 1.2;
}

.news-time {
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 400;
  font-size: 15px;
  color: #2e3033;
  width: 70px;
  flex-shrink: 0;
  line-height: 1.2;
}

.news-category {
  width: 86px;
  flex-shrink: 0;
}

.news-text {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 8px;
}

.news-text h4 {
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 500;
  font-size: 16px;
  color: #2e3033;
  margin: 0;
  line-height: 1.6;
  flex: 1;
}

.news-meta {
  display: flex;
  align-items: center;
  gap: 8px;
}

/* Footer Styles */
.footer {
  background-color: #f0f2f5;
  padding: 24px 40px;
  text-align: right;
}

.footer p {
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 400;
  font-size: 12px;
  color: #2e3033;
  margin: 0;
  line-height: 1.2;
}

/* Responsive Design */
@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: 16px;
  }
  
  .search-section {
    max-width: 100%;
  }
  
  .nav-menu {
    flex-direction: column;
  }
  
  .nav-item {
    border-right: none;
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  }
  
  .visual-content {
    flex-direction: column;
    text-align: center;
    padding: 20px;
  }
  
  .visual-image {
    position: relative;
    width: 100%;
    height: 100px;
  }
  
  .news-item {
    flex-direction: column;
    gap: 8px;
  }
  
  .news-date,
  .news-time,
  .news-category {
    width: auto;
  }
}
</style>
