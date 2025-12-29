<script setup lang="ts">
// This is a mock-up component based on a Figma design.
// For now, it only contains the structure and styling.
// Interactivity and data binding will be added in the future.
</script>

<template>
  <div class="mgc-page">
    <header class="mgc-header">
      <div class="header-content">
        <div class="logo">
          <img src="@/assets/logo.svg" alt="Mitsubishi Gas Chemical" />
        </div>
        <nav class="main-nav">
          <ul>
            <li><a href="#">事業と製品</a></li>
            <li><a href="#">サステナビリティ</a></li>
            <li><a href="#">研究開発</a></li>
            <li><a href="#">IR情報</a></li>
            <li><a href="#">企業情報</a></li>
            <li><a href="#">採用情報</a></li>
          </ul>
        </nav>
        <div class="header-actions">
          <a href="#">お問い合わせ</a>
          <a href="#">English</a>
          <button class="search-btn">
            <span class="search-icon"></span>
            <span>検索</span>
          </button>
        </div>
      </div>
    </header>

    <main class="mgc-main">
      <section class="hero">
        <div class="hero-content">
          <h1>社会と分かちあう価値を創造する</h1>
          <p>化学にもとづく幅広い知見と技術の融合により、<br>優れた製品・サービスを提供します。</p>
        </div>
      </section>

      <section class="products">
        <h2>事業と製品</h2>
        <div class="product-grid">
          <div class="product-card">
            <div class="card-icon"></div>
            <p>基礎化学品</p>
          </div>
          <div class="product-card">
            <div class="card-icon"></div>
            <p>機能化学品</p>
          </div>
          <div class="product-card">
            <div class="card-icon"></div>
            <p>スペシャリティケミカルズ</p>
          </div>
          <div class="product-card">
            <div class="card-icon"></div>
            <p>情報電子材料</p>
          </div>
           <div class="product-card">
            <div class="card-icon"></div>
            <p>合成樹脂</p>
          </div>
        </div>
      </section>

      <section class="news">
        <h2>ニュース</h2>
        <div class="news-container">
          <div class="news-tabs">
            <button class="active">すべて</button>
            <button>お知らせ</button>
            <button>製品</button>
            <button>IR</button>
            <button>サステナビリティ</button>
            <button>研究開発</button>
          </div>
          <div class="news-list">
            <div class="news-item">
              <time>2025.10.01</time>
              <span class="category">お知らせ</span>
              <p>ウェブサイトをリニューアルしました。</p>
            </div>
            <div class="news-item">
              <time>2025.09.28</time>
              <span class="category ir">IR</span>
              <p>2026年3月期 第2四半期決算説明会資料を掲載しました。</p>
            </div>
            <div class="news-item">
              <time>2025.09.20</time>
              <span class="category product">製品</span>
              <p>新製品「MXナイロン」のサンプル出荷を開始しました。</p>
            </div>
          </div>
          <a href="#" class="view-all">ニュース一覧を見る</a>
        </div>
      </section>
    </main>

    <footer class="mgc-footer">
      <div class="footer-content">
        <div class="footer-nav">
          <ul>
            <li><a href="#">サイトマップ</a></li>
            <li><a href="#">サイトのご利用について</a></li>
            <li><a href="#">プライバシーポリシー</a></li>
            <li><a href="#">特定個人情報等の適正な取扱いに関する基本方針</a></li>
          </ul>
        </div>
        <div class="footer-bottom">
          <p class="copyright">&copy; MITSUBISHI GAS CHEMICAL COMPANY, INC. All rights reserved.</p>
        </div>
      </div>
    </footer>
  </div>
</template>

<style scoped>
/* General Styles */
.mgc-page {
  font-family: 'Noto Sans JP', sans-serif;
  color: #333;
  background-color: #fff;
}

a {
  text-decoration: none;
  color: inherit;
}

ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

/* Header */
.mgc-header {
  border-bottom: 1px solid #eee;
}

.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  max-width: 1440px;
  margin: 0 auto;
  padding: 20px 40px;
}

.logo img {
  height: 40px;
}

.main-nav ul {
  display: flex;
  gap: 30px;
}

.main-nav a {
  font-weight: 500;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 20px;
}

.header-actions .search-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  background-color: #0033a0;
  color: #fff;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
  font-weight: 500;
}

/* Hero Section */
.hero {
  background-image: url('@/assets/hero-background.jpg');
  background-size: cover;
  background-position: center;
  color: #fff;
  text-align: center;
  padding: 120px 20px;
}

.hero-content h1 {
  font-size: 48px;
  font-weight: 700;
  margin-bottom: 16px;
}

.hero-content p {
  font-size: 18px;
  line-height: 1.8;
}

/* Products Section */
.products {
  padding: 80px 40px;
  max-width: 1200px;
  margin: 0 auto;
  text-align: center;
}

.products h2 {
  font-size: 32px;
  font-weight: 700;
  margin-bottom: 40px;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 20px;
}

.product-card {
  border: 1px solid #eee;
  padding: 20px;
  text-align: center;
  cursor: pointer;
  transition: box-shadow 0.3s;
}

.product-card:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

.product-card .card-icon {
  width: 60px;
  height: 60px;
  background-color: #f0f0f0;
  margin: 0 auto 20px;
}

.product-card p {
  font-weight: 500;
}

/* News Section */
.news {
  background-color: #f9f9f9;
  padding: 80px 40px;
}

.news-container {
  max-width: 1200px;
  margin: 0 auto;
}

.news h2 {
  font-size: 32px;
  font-weight: 700;
  margin-bottom: 40px;
  text-align: center;
}

.news-tabs {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-bottom: 30px;
}

.news-tabs button {
  background: none;
  border: 1px solid #ccc;
  padding: 10px 20px;
  cursor: pointer;
}

.news-tabs button.active {
  background-color: #0033a0;
  color: #fff;
  border-color: #0033a0;
}

.news-list {
  margin-bottom: 40px;
}

.news-item {
  display: flex;
  align-items: center;
  gap: 20px;
  padding: 20px 0;
  border-bottom: 1px solid #eee;
}

.news-item time {
  font-weight: 500;
}

.news-item .category {
  background-color: #666;
  color: #fff;
  font-size: 12px;
  padding: 4px 8px;
}
.news-item .category.ir {
  background-color: #0078d4;
}
.news-item .category.product {
  background-color: #4caf50;
}

.news-item p {
  margin: 0;
}

.view-all {
  display: block;
  width: fit-content;
  margin: 0 auto;
  padding: 15px 40px;
  border: 1px solid #0033a0;
  color: #0033a0;
  font-weight: 500;
}

/* Footer */
.mgc-footer {
  background-color: #333;
  color: #fff;
  padding: 40px;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
}

.footer-nav ul {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  margin-bottom: 30px;
  border-bottom: 1px solid #555;
  padding-bottom: 30px;
}

.copyright {
  font-size: 12px;
  text-align: center;
}
</style>
