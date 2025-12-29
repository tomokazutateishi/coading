<template>
  <div class="pzn-search-box" role="search">
    <input
      :placeholder="placeholder"
      type="text"
      aria-label="検索"
      class="pzn-search-box__input"
    />
    <span class="pzn-search-box__icon" aria-hidden="true">🔍</span>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  placeholder?: string
}>()
</script>

<style scoped>
.pzn-search-box {
  display: flex;
  align-items: center;
  border: 1px solid #D9D9D9;
  border-radius: 8px;
  background: #FFF;
  padding: 8px 12px;
  width: 100%;
  max-width: 480px;
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.pzn-search-box:focus-within,
.pzn-search-box:hover {
  border-color: #1890FF;
  box-shadow: 0 0 0 2px rgba(24,144,255,0.12);
}
.pzn-search-box__input {
  border: none;
  outline: none;
  flex: 1;
  font-size: 16px;
  background: transparent;
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
}
.pzn-search-box__icon {
  margin-left: 8px;
  color: #BFBFBF;
  font-size: 18px;
}
</style>
