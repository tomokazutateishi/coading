<script setup lang="ts">
import { computed } from 'vue';

interface Option {
  value: string | number;
  label: string;
}

interface Props {
  modelValue: string | number;
  options: Option[];
  label?: string;
  id?: string;
  placeholder?: string;
}

const props = withDefaults(defineProps<Props>(), {
  label: '',
  id: '',
  placeholder: '選択してください',
});

const emit = defineEmits(['update:modelValue']);

const selectId = computed(() => props.id || `pzn-select-${Math.random().toString(36).substring(2, 9)}`);

const updateValue = (event: Event) => {
  emit('update:modelValue', (event.target as HTMLSelectElement).value);
};
</script>

<template>
  <div class="pzn-select-box" role="listbox">
    <select
      :value="modelValue"
      @change="$emit('update:modelValue', $event.target.value)"
      aria-label="並び順選択"
      class="pzn-select-box__select"
    >
      <option v-for="option in options" :key="option.value" :value="option.value">
        {{ option.label }}
      </option>
    </select>
    <span class="pzn-select-box__icon" aria-hidden="true">▼</span>
  </div>
</template>

<style scoped>
.pzn-select-box {
  display: flex;
  align-items: center;
  border: 1px solid #D9D9D9;
  border-radius: 8px;
  background: #FFF;
  padding: 8px 12px;
  width: 200px;
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.pzn-select-box:focus-within,
.pzn-select-box:hover {
  border-color: #1890FF;
  box-shadow: 0 0 0 2px rgba(24,144,255,0.12);
}
.pzn-select-box__select {
  border: none;
  outline: none;
  flex: 1;
  font-size: 16px;
  background: transparent;
  font-family: 'Roboto', 'Noto Sans JP', sans-serif;
  appearance: none;
}
.pzn-select-box__icon {
  margin-left: 8px;
  color: #BFBFBF;
  font-size: 14px;
  pointer-events: none;
}
</style>