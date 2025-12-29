<template>
  <label class="personalize-radio">
    <input
      type="radio"
      :name="name"
      :value="value"
      :checked="modelValue === value"
      @change="$emit('update:modelValue', value)"
    />
    <span class="radio-custom"></span>
    <span class="radio-label"><slot /></span>
  </label>
</template>

<script setup lang="ts">
defineProps({
  name: { type: String, required: true },
  value: { type: [String, Number], required: true },
  modelValue: { type: [String, Number], required: true }
});
</script>

<style scoped>
.personalize-radio {
  display: flex;
  align-items: center;
  cursor: pointer;
  font-family: 'Noto Sans JP', 'Roboto', sans-serif;
  font-size: 16px;
  font-weight: 400;
  line-height: 24px;
  color: #222;
  gap: 8px;
}
.personalize-radio input[type="radio"] {
  display: none;
}
.radio-custom {
  width: 20px;
  height: 20px;
  border: 2px solid #0070c0;
  border-radius: 50%;
  background: #fff;
  position: relative;
  transition: border-color 0.2s;
}
.personalize-radio input[type="radio"]:checked + .radio-custom {
  border-color: #0070c0;
  background: #0070c0;
}
.personalize-radio input[type="radio"]:checked + .radio-custom::after {
  content: '';
  display: block;
  width: 10px;
  height: 10px;
  background: #fff;
  border-radius: 50%;
  position: absolute;
  top: 4px;
  left: 4px;
}
.radio-label {
  user-select: none;
}
</style>
