<template>
  <div class="mockup-home">
    <!-- Header -->
    <header class="mockup-header">
      <div class="mockup-header__title">情報システム部 ポータル</div>
      <div class="mockup-header__search">
        <span class="mockup-header__search-icon" aria-hidden="true"></span>
        <span class="mockup-header__search-placeholder">キーワードで検索...</span>
      </div>
    </header>
    <!-- Navigation -->
    <nav class="mockup-gnav">
      <ul>
        <li>ホーム</li>
        <li>機器・コミュニケーション</li>
        <li>アプリケーション</li>
        <li>情報システムセキュリティ</li>
        <li>申請書・問い合わせ</li>
      </ul>
    </nav>
    <!-- Hero -->
    <section class="mockup-hero">
      <div class="mockup-hero__text">
        <div class="mockup-hero__title">情報システム部 ポータル</div>
        <div class="mockup-hero__subtitle">※サイト内の情報は社外秘です</div>
      </div>
      <div class="mockup-hero__image" aria-hidden="true"></div>
    </section>
    <!-- Emergency Notice -->
    <section class="mockup-emergency">
      <span class="mockup-emergency__label">緊急のお知らせ</span>
      <span class="mockup-emergency__text">4月20日(日) 18:00～21:00 にシステムメンテナンスを実施いたします。期間中は利用できませんのでご注意ください。</span>
      <span class="mockup-emergency__arrow" aria-hidden="true"></span>
    </section>
    <!-- News List -->
    <section class="mockup-news">
      <div class="mockup-news__header">
        <span class="mockup-news__bar"></span>
        <span class="mockup-news__title">お知らせ</span>
        <span class="mockup-news__list">お知らせ一覧</span>
        <span class="mockup-news__arrow" aria-hidden="true"></span>
      </div>
      <ul class="mockup-news__list-items">
        <li class="mockup-news__item">
          <span class="mockup-news__date">2025年 04月 23日</span>
          <span class="mockup-news__time">09時30分</span>
          <span class="mockup-news__category mockup-news__category--red">セキュリティ</span>
          <span class="mockup-news__headline">【障害報告】VPN接続に関する一時的な不具合について</span>
          <span class="mockup-news__badge mockup-news__badge--blue">新着</span>
          <span class="mockup-news__arrow" aria-hidden="true"></span>
        </li>
        <!-- 他のニュースも同様に追加 -->
      </ul>
    </section>
    <!-- Copyright -->
    <footer class="mockup-footer">
      Copyright © MITSUBISHI GAS CHEMICAL COMPANY, INC. All rights reserved.
    </footer>
  </div>
</template>

<script setup>
// Figmaの構造を忠実に再現するため、必要に応じて分割・props化
</script>

<style scoped>
.mockup-home {
  background: #dddddd;
  min-width: 1366px;
  min-height: 849px;
  font-family: 'Noto Sans JP', 'Inter', sans-serif;
}
.mockup-header {
  display: flex;
  align-items: center;
  gap: 154px;
  background: #fff;
  padding: 12px 16px;
  box-sizing: border-box;
}
.mockup-header__title {
  font-weight: bold;
  font-size: 20px;
  color: #2e3033;
}
.mockup-header__search {
  display: flex;
  align-items: center;
  background: #f0f2f5;
  border: 1px solid #d3d6db;
  border-radius: 4px;
  padding: 6px 12px;
  width: 400px;
  height: 36px;
}
.mockup-header__search-icon {
  width: 20px;
  height: 20px;
  background: #eee;
  border-radius: 50%;
  margin-right: 4px;
  display: inline-block;
}
.mockup-header__search-placeholder {
  color: rgba(46,48,51,0.6);
  font-size: 14px;
}
.mockup-gnav {
  background: #0072bf;
  color: #fff;
  width: 100%;
}
.mockup-gnav ul {
  display: flex;
  margin: 0;
  padding: 0;
  list-style: none;
}
.mockup-gnav li {
  padding: 14px 24px;
  border-right: 1px solid rgba(255,255,255,0.2);
  font-size: 15px;
  font-weight: 500;
  cursor: pointer;
}
.mockup-gnav li:last-child {
  border-right: none;
}
.mockup-hero {
  display: flex;
  align-items: center;
  background: linear-gradient(90deg, #e8f3fa 0%, #ccdbed 42.819%);
  height: 130px;
  position: relative;
}
.mockup-hero__text {
  margin-left: 80px;
  color: #004473;
}
.mockup-hero__title {
  font-size: 28px;
  font-weight: bold;
}
.mockup-hero__subtitle {
  font-size: 16px;
}
.mockup-hero__image {
  position: absolute;
  right: 0;
  top: -92px;
  width: 689px;
  height: 130px;
  background: #eee;
  border-radius: 16px;
}
.mockup-emergency {
  background: #fff3f2;
  border: 0.5px solid #d90000;
  border-radius: 2px;
  padding: 8px;
  display: flex;
  align-items: center;
  gap: 12px;
  margin: 16px 40px 0 40px;
}
.mockup-emergency__label {
  background: #d90000;
  color: #fff;
  border-radius: 2px;
  padding: 4px 16px 4px 8px;
  font-size: 12px;
  font-weight: 500;
}
.mockup-emergency__text {
  color: #d90000;
  font-size: 14px;
  font-weight: 500;
}
.mockup-emergency__arrow {
  width: 12px;
  height: 12px;
  background: #eee;
  border-radius: 50%;
  margin-left: 8px;
  display: inline-block;
}
.mockup-news {
  background: #fff;
  margin: 32px 40px 0 40px;
  border-radius: 4px;
  box-shadow: 0 0 15px 0 rgba(0,47,97,0.2);
  padding: 32px 24px;
}
.mockup-news__header {
  display: flex;
  align-items: end;
  gap: 16px;
  margin-bottom: 24px;
}
.mockup-news__bar {
  width: 5px;
  height: 24px;
  background: #0072bf;
  border-radius: 2px;
}
.mockup-news__title {
  font-size: 20px;
  font-weight: bold;
  color: #0072bf;
}
.mockup-news__list {
  color: #0b79d9;
  font-size: 14px;
  font-weight: 500;
  margin-left: auto;
}
.mockup-news__arrow {
  width: 12px;
  height: 12px;
  background: #eee;
  border-radius: 50%;
  margin-left: 4px;
  display: inline-block;
}
.mockup-news__list-items {
  list-style: none;
  padding: 0;
  margin: 0;
}
.mockup-news__item {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 8px 0;
  border-bottom: 1px solid #dfeaf7;
}
.mockup-news__item:last-child {
  border-bottom: none;
}
.mockup-news__date, .mockup-news__time {
  color: #2e3033;
  font-size: 15px;
}
.mockup-news__category {
  border: 1px solid #d90000;
  border-radius: 2px;
  padding: 3px 8px 3px 0;
  font-size: 12px;
  font-weight: 500;
  color: #d90000;
}
.mockup-news__category--red {
  background: #fff;
}
.mockup-news__headline {
  color: #2e3033;
  font-size: 16px;
  font-weight: 500;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 400px;
}
.mockup-news__badge {
  border-radius: 2px;
  padding: 3px 14px 3px 6px;
  font-size: 12px;
  font-weight: 500;
  color: #fff;
}
.mockup-news__badge--blue {
  background: #3995e5;
}
.mockup-footer {
  background: #f0f2f5;
  color: #2e3033;
  font-size: 12px;
  text-align: right;
  padding: 24px 40px;
  margin-top: 40px;
}
</style>
