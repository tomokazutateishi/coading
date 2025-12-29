<template>
  <button
    class="personalize-btn"
    :type="type"
    :disabled="disabled"
    @click="$emit('click', $event)"
  >
    <slot />
  </button>
</template>

<script setup lang="ts">
defineProps({
  type: { type: String, default: 'button' },
  disabled: { type: Boolean, default: false }
});
</script>

<style scoped>
.personalize-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 12px 32px;
  font-family: 'Noto Sans JP', 'Roboto', sans-serif;
  font-size: 16px;
  font-weight: 700;
  line-height: 24px;
  color: #fff;
  background: #0070c0;
  border: none;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  cursor: pointer;
  transition: background 0.2s, box-shadow 0.2s;
}
.personalize-btn:hover:not(:disabled),
.personalize-btn:focus-visible:not(:disabled) {
  background: #005fa3;
  box-shadow: 0 4px 16px rgba(0,112,192,0.15);
}
.personalize-btn:disabled {
  background: #b0b0b0;
  cursor: not-allowed;
}
</style>
