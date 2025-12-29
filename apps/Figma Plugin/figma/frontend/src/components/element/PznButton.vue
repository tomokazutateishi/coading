<script setup lang="ts">
import { computed } from 'vue';

type ButtonVariant = 'primary' | 'danger' | 'secondary';

interface Props {
  variant?: ButtonVariant;
  disabled?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'primary',
  disabled: false,
});

const buttonClass = computed(() => {
  return {
    'pzn-button': true,
    [`pzn-button--${props.variant}`]: true,
    'pzn-button--disabled': props.disabled,
  };
});
</script>

<template>
  <button :class="buttonClass" :disabled="disabled">
    <slot></slot>
  </button>
</template>

<style scoped>
.pzn-button {
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  font-family: 'Inter', sans-serif;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
  box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.05);
}

.pzn-button--primary {
  background-color: #4CAF50;
  color: white;
}

.pzn-button--primary:hover:not(:disabled) {
  background-color: #45a049;
  box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
}

.pzn-button--danger {
  background-color: #F44336;
  color: white;
}

.pzn-button--danger:hover:not(:disabled) {
  background-color: #da190b;
  box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
}

.pzn-button--secondary {
  background-color: #e0e0e0;
  color: #333;
}

.pzn-button--secondary:hover:not(:disabled) {
  background-color: #c0c0c0;
  box-shadow: 0px 2px 4px rgba(0, 0, 0, 0.1);
}

.pzn-button--disabled {
  background-color: #cccccc;
  cursor: not-allowed;
  opacity: 0.7;
  box-shadow: none;
}
</style>