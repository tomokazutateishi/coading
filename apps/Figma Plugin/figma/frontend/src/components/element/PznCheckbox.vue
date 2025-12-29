<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  modelValue: string | number;
  value: string | number;
  label: string;
  name: string;
}

const props = defineProps<Props>();
const emit = defineEmits(['update:modelValue']);

const isChecked = computed(() => props.modelValue === props.value);

const inputId = computed(() => `pzn-radio-${props.name}-${props.value}`);

const onChange = () => {
  emit('update:modelValue', props.value);
};
</script>

<template>
  <label :for="inputId" class="pzn-radio-label">
    <input
      type="radio"
      :id="inputId"
      :value="value"
      :name="name"
      :checked="isChecked"
      @change="onChange"
      class="pzn-radio-input"
    />
    <span class="pzn-radio-custom"></span>
    <span class="pzn-radio-text">{{ label }}</span>
  </label>
</template>

<style scoped>
.pzn-radio-label {
  display: inline-flex;
  align-items: center;
  cursor: pointer;
  font-family: 'Inter', sans-serif;
  font-size: 16px;
  color: #333;
  user-select: none;
  margin-right: 20px;
}

.pzn-radio-input {
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
}

.pzn-radio-custom {
  display: inline-block;
  width: 20px;
  height: 20px;
  border: 2px solid #ccc;
  border-radius: 50%;
  margin-right: 8px;
  position: relative;
  transition: all 0.2s ease-in-out;
}

.pzn-radio-input:checked + .pzn-radio-custom {
  border-color: #4CAF50;
  background-color: white;
}

.pzn-radio-input:checked + .pzn-radio-custom::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background-color: #4CAF50;
}

.pzn-radio-input:focus + .pzn-radio-custom {
  box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.4);
}

.pzn-radio-label:hover .pzn-radio-custom {
  border-color: #777;
}
</style>