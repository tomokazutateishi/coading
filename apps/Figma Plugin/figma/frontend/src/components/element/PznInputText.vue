<script setup lang="ts">
import { computed } from 'vue';

interface Props {
  modelValue: string | number;
  type?: string;
  placeholder?: string;
  label?: string;
  id?: string;
}

const props = withDefaults(defineProps<Props>(), {
  type: 'text',
  placeholder: '',
  label: '',
  id: '',
});

const emit = defineEmits(['update:modelValue']);

const updateValue = (event: Event) => {
  emit('update:modelValue', (event.target as HTMLInputElement).value);
};

const inputId = computed(() => props.id || `pzn-input-${Math.random().toString(36).substring(2, 9)}`);
</script>

<template>
  <div class="pzn-input-wrapper">
    <label v-if="label" :for="inputId" class="pzn-input-label">{{ label }}</label>
    <input
      :id="inputId"
      :type="type"
      :value="modelValue"
      @input="updateValue"
      :placeholder="placeholder"
      class="pzn-input-field"
    />
  </div>
</template>

<style scoped>
.pzn-input-wrapper {
  margin-bottom: 15px;
}

.pzn-input-label {
  display: block;
  font-family: 'Inter', sans-serif;
  font-size: 14px;
  font-weight: 500;
  color: #555;
  margin-bottom: 8px;
}

.pzn-input-field {
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-family: 'Inter', sans-serif;
  font-size: 16px;
  box-sizing: border-box;
}

.pzn-input-field:focus {
  border-color: #4CAF50;
  outline: none;
  box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.2);
}
</style>