<template>
  <div :class="['mgc-background', variant, size]">
    <div class="background-content">
      <slot></slot>
    </div>
  </div>
</template>

<script setup lang="ts">
interface Props {
  variant?: 'default' | 'gradient' | 'solid'
  size?: 'full' | 'container' | 'custom'
  width?: string
  height?: string
}

withDefaults(defineProps<Props>(), {
  variant: 'default',
  size: 'container',
  width: '1280px',
  height: '100vh'
})
</script>

<style scoped>
.mgc-background {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  margin: 0 auto;
}

.mgc-background.container {
  max-width: 1280px;
  width: 100%;
}

.mgc-background.full {
  width: 100%;
}

.mgc-background.custom {
  width: v-bind(width);
  height: v-bind(height);
}

/* Variants */
.mgc-background.default {
  background-color: #dddddd;
}

.mgc-background.gradient {
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
}

.mgc-background.solid {
  background-color: #ffffff;
}

.background-content {
  flex: 1;
  display: flex;
  flex-direction: column;
}

/* Responsive */
@media (max-width: 1280px) {
  .mgc-background.container {
    max-width: 100%;
    padding: 0 20px;
  }
}

@media (max-width: 768px) {
  .mgc-background.container {
    padding: 0 16px;
  }
}
</style>


