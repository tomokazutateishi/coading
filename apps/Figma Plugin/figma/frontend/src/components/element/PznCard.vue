<script setup lang="ts">
defineProps<{
  title: string
  meta1?: string
  meta2?: string
  meta3?: string
  description: string
  hasMenu?: boolean
}>()
</script>

<template>
  <div
    class="pzn-card"
    role="region"
    :aria-label="title"
    tabindex="0"
  >
    <div class="pzn-card__header">
      <div class="pzn-card__meta">
        <span class="pzn-card__meta-item">{{ meta1 }}</span>
        <span class="pzn-card__meta-item">{{ meta2 }}</span>
        <span class="pzn-card__meta-item">{{ meta3 }}</span>
      </div>
      <div class="pzn-card__title">{{ title }}</div>
      <div v-if="hasMenu" class="pzn-card__menu" tabindex="0" aria-label="メニュー">
        ⋯
      </div>
    </div>
    <div class="pzn-card__desc">{{ description }}</div>
  </div>
</template>

<style scoped>
.pzn-card {
  background: #FFF;
  border: 1px solid rgba(0,0,0,0.06);
  border-radius: 8px;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 280px;
  position: relative;
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
  box-shadow: 0px 2px 8px 0px rgba(0,0,0,0.05);
  transition: box-shadow 0.2s, border-color 0.2s;
  outline: none;
}
.pzn-card:focus,
.pzn-card:hover {
  box-shadow: 0px 4px 16px 0px rgba(24,144,255,0.12);
  border-color: #1890FF;
}
.pzn-card__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
}
.pzn-card__meta {
  display: flex;
  gap: 8px;
  font-size: 12px;
  color: rgba(0,0,0,0.45);
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
}
.pzn-card__title {
  font-size: 16px;
  font-weight: 700;
  color: #40A9FF;
  flex: 1;
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
}
.pzn-card__menu {
  font-size: 20px;
  color: #BFBFBF;
  cursor: pointer;
  border-radius: 4px;
  padding: 2px 6px;
  transition: background 0.2s;
}
.pzn-card__menu:focus,
.pzn-card__menu:hover {
  background: #F0F2F5;
}
.pzn-card__desc {
  font-size: 12px;
  color: rgba(0,0,0,0.85);
  margin-top: 8px;
  white-space: pre-line;
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
}
</style>