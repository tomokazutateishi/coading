<template>
  <div class="pzn-alert" role="status" aria-live="polite">
    {{ message }}
  </div>
</template>

<script setup lang="ts">
defineProps<{
  message: string
}>()
</script>

<style scoped>
.pzn-alert {
  background: #F6FFED;
  border: 1px solid #B7EB8F;
  border-radius: 6px;
  color: rgba(0,0,0,0.85);
  padding: 9px 16px;
  font-size: 14px;
  margin-bottom: 8px;
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
}
</style>
