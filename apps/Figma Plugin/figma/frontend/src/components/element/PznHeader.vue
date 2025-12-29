<template>
  <header class="pzn-header" role="banner" aria-label="ページヘッダー">
    <div class="pzn-header__logo">LOGO</div>
    <nav class="pzn-header__nav" aria-label="メインナビゲーション">
      <ul>
        <li><a href="#" tabindex="0">ホーム</a></li>
        <li><a href="#" tabindex="0">帳票作成履歴</a></li>
      </ul>
    </nav>
    <div class="pzn-header__avatar">
      <PznAvatar />
    </div>
  </header>
</template>

<script setup lang="ts">
import PznAvatar from './PznAvatar.vue'
</script>

<style scoped>
.pzn-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 16px;
  height: 56px;
  background: #FAFAFA;
  border-bottom: 1px solid rgba(0,0,0,0.06);
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
}
.pzn-header__logo {
  font-weight: bold;
  font-size: 18px;
  color: #1890FF;
}
.pzn-header__nav ul {
  display: flex;
  gap: 24px;
  list-style: none;
  margin: 0;
  padding: 0;
}
.pzn-header__nav a {
  color: #1890FF;
  text-decoration: none;
  font-size: 14px;
  padding: 4px 8px;
  border-radius: 4px;
  transition: background 0.2s, color 0.2s;
  outline: none;
}
.pzn-header__nav a:focus,
.pzn-header__nav a:hover {
  background: #E6F7FF;
  color: #0050B3;
}
.pzn-header__avatar {
  /* 仮のアバター位置 */
}
</style>
