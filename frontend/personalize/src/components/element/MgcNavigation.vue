<template>
  <nav class="mgc-navigation">
    <div class="nav-container">
      <div 
        v-for="(item, index) in items" 
        :key="index"
        :class="['nav-item', { active: item.active, hover: hoveredIndex === index }]"
        @mouseenter="hoveredIndex = index"
        @mouseleave="hoveredIndex = -1"
        @click="handleItemClick(item, index)"
      >
        <div class="nav-content">
          <span class="nav-text">{{ item.text }}</span>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface NavigationItem {
  text: string
  active?: boolean
  href?: string
  disabled?: boolean
}

interface Props {
  items: NavigationItem[]
}

interface Emits {
  (e: 'item-click', item: NavigationItem, index: number): void
}

defineProps<Props>()
const emit = defineEmits<Emits>()

const hoveredIndex = ref(-1)

const handleItemClick = (item: NavigationItem, index: number) => {
  if (!item.disabled) {
    emit('item-click', item, index)
  }
}
</script>

<style scoped>
.mgc-navigation {
  background-color: #0072bf;
  position: sticky;
  top: 60px;
  z-index: 3;
  box-shadow: 0px 0px 15px 0px rgba(0, 47, 97, 0.2);
}

.nav-container {
  display: flex;
  max-width: 1280px;
  margin: 0 auto;
}

.nav-item {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 14px 0;
  border-right: 1px solid rgba(255, 255, 255, 0.2);
  cursor: pointer;
  transition: all 0.2s ease;
  position: relative;
}

.nav-item:last-child {
  border-right: none;
}

.nav-item:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.nav-item.active {
  background-color: rgba(255, 255, 255, 0.2);
}

.nav-item.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 2px;
  background-color: #ffffff;
}

.nav-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  width: 100%;
  height: 100%;
  padding: 0;
}

.nav-text {
  font-family: 'Inter', 'Noto Sans JP', sans-serif;
  font-weight: 500;
  font-size: 15px;
  color: #ffffff;
  text-align: center;
  line-height: 1.2;
  white-space: nowrap;
}

/* Responsive Design */
@media (max-width: 768px) {
  .nav-container {
    flex-direction: column;
  }
  
  .nav-item {
    border-right: none;
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  }
  
  .nav-item:last-child {
    border-bottom: none;
  }
  
  .nav-text {
    font-size: 14px;
  }
}

@media (max-width: 480px) {
  .nav-text {
    font-size: 12px;
  }
  
  .nav-item {
    padding: 12px 0;
  }
}
</style>
