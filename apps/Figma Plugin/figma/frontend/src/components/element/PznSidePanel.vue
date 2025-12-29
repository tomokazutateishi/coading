<template>
  <nav class="pzn-side-panel" role="navigation" aria-label="サイドパネル">
    <PznAlert v-if="alertMessage" :message="alertMessage" />
    <ul class="pzn-side-panel__folders">
      <li v-for="folder in folders" :key="folder.id" :class="['pzn-side-panel__folder', { selected: folder.selected }]" :aria-selected="folder.selected ? 'true' : 'false'" tabindex="0" role="option">
        <span class="pzn-side-panel__folder-icon">📁</span>
        <span class="pzn-side-panel__folder-name">{{ folder.name }}</span>
      </li>
    </ul>
    <ul class="pzn-side-panel__items">
      <li v-for="item in items" :key="item.id" class="pzn-side-panel__item" tabindex="0" role="option">
        <span class="pzn-side-panel__item-icon">📄</span>
        <span class="pzn-side-panel__item-name">{{ item.name }}</span>
      </li>
    </ul>
  </nav>
</template>

<script setup lang="ts">
import PznAlert from './PznAlert.vue'

defineProps<{
  folders: { id: number; name: string; selected?: boolean }[]
  items: { id: number; name: string }[]
  alertMessage?: string
}>()
</script>

<style scoped>
.pzn-side-panel {
  background: #fff;
  border-radius: 8px;
  min-width: 220px;
  min-height: 600px;
  box-shadow: inset -1px 0 0 0 #f0f0f0, 0px 2px 8px 0px rgba(0,0,0,0.05);
  padding: 16px 0 16px 0;
  display: flex;
  flex-direction: column;
  gap: 16px;
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
}
.pzn-side-panel__folders {
  list-style: none;
  padding: 0 16px;
  margin: 0 0 8px 0;
}
.pzn-side-panel__folder {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 0;
  border-radius: 8px;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
  outline: none;
}
.pzn-side-panel__folder.selected,
.pzn-side-panel__folder:focus,
.pzn-side-panel__folder:hover {
  background: #E6F7FF;
  color: #1890FF;
}
.pzn-side-panel__folder-icon {
  font-size: 16px;
}
.pzn-side-panel__items {
  list-style: none;
  padding: 0 16px;
  margin: 0;
}
.pzn-side-panel__item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 0;
  border-radius: 6px;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
  outline: none;
}
.pzn-side-panel__item:focus,
.pzn-side-panel__item:hover {
  background: #F5F5F5;
  color: #1890FF;
}
.pzn-side-panel__item-icon {
  font-size: 14px;
}
</style>
