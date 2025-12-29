<template>
  <button class="mockup-btn" :type="type">
    <slot />
  </button>
</template>
<script setup>
defineProps({
  type: { type: String, default: 'button' }
});
</script>
<style scoped>
.mockup-btn {
  background: #0072bf;
  color: #fff;
  border: none;
  border-radius: 4px;
  padding: 8px 20px;
  font-size: 15px;
  font-family: 'Noto Sans JP', 'Inter', sans-serif;
  font-weight: 500;
  cursor: pointer;
  transition: background 0.2s;
}
.mockup-btn:hover, .mockup-btn:focus {
  background: #3995e5;
  outline: none;
}
</style>
