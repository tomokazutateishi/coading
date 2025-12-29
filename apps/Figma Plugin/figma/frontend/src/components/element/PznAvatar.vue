<template>
  <div class="pzn-avatar">
    <img :src="src" :alt="alt" />
  </div>
</template>

<script setup lang="ts">
defineProps<{
  src?: string
  alt?: string
}>()
</script>

<style scoped>
.pzn-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: #BFBFBF;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}
.pzn-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
</style>
