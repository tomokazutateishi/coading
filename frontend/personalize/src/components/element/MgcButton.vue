<template>
  <button 
    :class="['mgc-button', variant, size, { disabled: disabled }]"
    :disabled="disabled"
    @click="handleClick"
  >
    <div v-if="icon" class="button-icon">
      <slot name="icon">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
          <path d="M20 4H4C2.9 4 2.01 4.9 2.01 6L2 18C2 19.1 2.9 20 4 20H20C21.1 20 22 19.1 22 18V6C22 4.9 21.1 4 20 4ZM20 8L12 13L4 8V6L12 11L20 6V8Z" fill="currentColor"/>
        </svg>
      </slot>
    </div>
    <div class="button-content">
      <slot>{{ text }}</slot>
    </div>
  </button>
</template>

<script setup lang="ts">
interface Props {
  variant?: 'default' | 'secondary' | 'outline' | 'ghost'
  size?: 'small' | 'medium' | 'large'
  disabled?: boolean
  text?: string
  icon?: boolean
}

interface Emits {
  (e: 'click', event: MouseEvent): void
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  size: 'medium',
  disabled: false,
  text: '',
  icon: false
})

const emit = defineEmits<Emits>()

const handleClick = (event: MouseEvent) => {
  if (!props.disabled) {
    emit('click', event)
  }
}
</script>

<style scoped>
.mgc-button {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 24px 32px;
  border-radius: 4px;
  border: none;
  cursor: pointer;
  font-family: 'Noto Sans JP', sans-serif;
  font-weight: 500;
  font-size: 16px;
  line-height: 1.3;
  transition: all 0.2s ease;
  position: relative;
  overflow: hidden;
}

.mgc-button:focus {
  outline: 2px solid #0072bf;
  outline-offset: 2px;
}

.mgc-button.disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* Variants */
.mgc-button.default {
  background-color: #3995e5;
  color: #ffffff;
}

.mgc-button.default:hover:not(.disabled) {
  background-color: #2d7bc7;
}

.mgc-button.secondary {
  background-color: #f0f2f5;
  color: #2e3033;
  border: 1px solid #d3d6db;
}

.mgc-button.secondary:hover:not(.disabled) {
  background-color: #e8ebef;
}

.mgc-button.outline {
  background-color: transparent;
  color: #3995e5;
  border: 1px solid #3995e5;
}

.mgc-button.outline:hover:not(.disabled) {
  background-color: #f0f7ff;
}

.mgc-button.ghost {
  background-color: transparent;
  color: #2e3033;
  border: 1px solid transparent;
}

.mgc-button.ghost:hover:not(.disabled) {
  background-color: #f0f2f5;
}

/* Sizes */
.mgc-button.small {
  padding: 12px 20px;
  font-size: 14px;
  gap: 8px;
}

.mgc-button.medium {
  padding: 16px 24px;
  font-size: 16px;
  gap: 12px;
}

.mgc-button.large {
  padding: 24px 32px;
  font-size: 18px;
  gap: 16px;
}

.button-icon {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.button-content {
  flex: 1;
  text-align: left;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* Responsive */
@media (max-width: 768px) {
  .mgc-button {
    padding: 16px 20px;
    font-size: 14px;
    gap: 12px;
  }
  
  .mgc-button.large {
    padding: 20px 24px;
    font-size: 16px;
  }
}
</style>


