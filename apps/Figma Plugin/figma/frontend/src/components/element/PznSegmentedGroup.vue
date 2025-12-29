<template>
  <div class="pzn-segmented-group" role="tablist">
    <button
      v-for="item in items"
      :key="item.value"
      :class="['pzn-segmented-group__item', { selected: item.value === modelValue }]"
      @click="$emit('update:modelValue', item.value)"
      :aria-pressed="item.value === modelValue"
      :tabindex="item.value === modelValue ? 0 : -1"
      role="tab"
      type="button"
    >
      <span v-if="item.icon" class="pzn-segmented-group__icon">{{ item.icon }}</span>
      {{ item.label }}
    </button>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  items: { label: string; value: string; icon?: string }[]
  modelValue: string
}>()

defineEmits(['update:modelValue'])
</script>

<style scoped>
.pzn-segmented-group {
  display: flex;
  gap: 8px;
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
}
.pzn-segmented-group__item {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 7px 11px;
  border-radius: 6px;
  border: none;
  background: #FFF;
  color: #000;
  font-size: 14px;
  cursor: pointer;
  transition: background 0.2s, color 0.2s, box-shadow 0.2s;
  outline: none;
}
.pzn-segmented-group__item.selected {
  background: #1890FF;
  color: #FFF;
  box-shadow: 0px 2px 8px 0px rgba(24,144,255,0.08);
}
.pzn-segmented-group__item:focus,
.pzn-segmented-group__item:hover {
  background: #E6F7FF;
  color: #1890FF;
}
.pzn-segmented-group__icon {
  font-size: 16px;
}
</style>
