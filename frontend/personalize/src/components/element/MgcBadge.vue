<template>
  <span :class="['mgc-badge', type, size]">
    <slot>{{ text }}</slot>
  </span>
</template>

<script setup lang="ts">
interface Props {
  type?: 'security' | 'info' | 'notice' | 'error' | 'new'
  size?: 'small' | 'medium' | 'large'
  text?: string
}

withDefaults(defineProps<Props>(), {
  type: 'info',
  size: 'medium',
  text: ''
})
</script>

<style scoped>
.mgc-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 3px 8px;
  border-radius: 2px;
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 500;
  font-size: 12px;
  line-height: 1;
  white-space: nowrap;
  border: 1px solid;
  transition: all 0.2s ease;
}

/* Types */
.mgc-badge.security {
  background-color: #d90000;
  color: #ffffff;
  border-color: #d90000;
}

.mgc-badge.info {
  background-color: transparent;
  color: #3995e5;
  border-color: #3995e5;
}

.mgc-badge.notice {
  background-color: #d90000;
  color: #ffffff;
  border-color: #d90000;
}

.mgc-badge.error {
  background-color: transparent;
  color: #2e3033;
  border-color: #2e3033;
}

.mgc-badge.new {
  background-color: #3995e5;
  color: #ffffff;
  border-color: #3995e5;
}

/* Sizes */
.mgc-badge.small {
  padding: 2px 6px;
  font-size: 10px;
}

.mgc-badge.medium {
  padding: 3px 8px;
  font-size: 12px;
}

.mgc-badge.large {
  padding: 4px 10px;
  font-size: 14px;
}

/* Hover effects */
.mgc-badge:not(.security):not(.notice):not(.new):hover {
  opacity: 0.8;
}

/* Focus styles for accessibility */
.mgc-badge:focus {
  outline: 2px solid #0072bf;
  outline-offset: 2px;
}
</style>

