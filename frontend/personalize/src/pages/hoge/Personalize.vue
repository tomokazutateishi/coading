<template>
  <div class="personalize-page">
    <header class="header">
      <h1>パーソナライズだし分け</h1>
      <div class="user-info">
        <span>ユーザー名</span>
      </div>
    </header>
    <main class="main-content">
      <div class="content-wrapper">
        <!-- ここにFigmaの主要なコンテンツが入ります -->
        <h2>設定画面</h2>
        <p>Figmaのデザインに基づいたコンテンツをここに実装します。</p>
      </div>
    </main>
    <footer class="footer">
      <p>&copy; 2025 Your Company</p>
    </footer>
  </div>
</template>

<script setup lang="ts">
// Composition API using <script setup>
</script>

<style scoped>
.personalize-page {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f0f2f5; /* Figmaに近い背景色を仮定 */
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 2rem;
  background-color: #ffffff;
  border-bottom: 1px solid #e0e0e0;
}

.header h1 {
  font-size: 1.5rem;
  font-weight: 600;
  color: #333;
}

.user-info {
  font-size: 1rem;
  color: #555;
}

.main-content {
  flex-grow: 1;
  padding: 2rem;
}

.content-wrapper {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  background-color: #ffffff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.footer {
  padding: 1rem 2rem;
  text-align: center;
  background-color: #ffffff;
  border-top: 1px solid #e0e0e0;
  color: #888;
}
</style>
