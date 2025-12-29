<template>
  <label class="personalize-select-label">
    <span v-if="label" class="label-text">{{ label }}</span>
    <select
      class="personalize-select"
      :value="modelValue"
      @change="$emit('update:modelValue', $event.target.value)"
      :disabled="disabled"
    >
      <slot />
    </select>
  </label>
</template>

<script setup lang="ts">
defineProps({
  label: { type: String, default: '' },
  modelValue: { type: [String, Number], required: true },
  disabled: { type: Boolean, default: false }
});
</script>

<style scoped>
.personalize-select-label {
  display: flex;
  flex-direction: column;
  gap: 4px;
  font-family: 'Noto Sans JP', 'Roboto', sans-serif;
  font-size: 16px;
  color: #222;
}
.label-text {
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 2px;
}
.personalize-select {
  padding: 10px 16px;
  border: 1.5px solid #0070c0;
  border-radius: 8px;
  background: #fff;
  font-size: 16px;
  font-family: inherit;
  color: #222;
  outline: none;
  transition: border-color 0.2s;
}
.personalize-select:focus {
  border-color: #005fa3;
}
.personalize-select:disabled {
  background: #f0f0f0;
  color: #b0b0b0;
  cursor: not-allowed;
}
</style>
