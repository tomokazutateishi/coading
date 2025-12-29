<template>
  <div class="mgc-search-box">
    <div class="search-container">
      <div class="search-icon">
        <slot name="icon">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none">
            <path 
              d="M21 21L16.514 16.506L21 21ZM19 10.5C19 15.194 15.194 19 10.5 19C5.806 19 2 15.194 2 10.5C2 5.806 5.806 2 10.5 2C15.194 2 19 5.806 19 10.5Z" 
              stroke="currentColor" 
              stroke-width="2" 
              stroke-linecap="round" 
              stroke-linejoin="round"
            />
          </svg>
        </slot>
      </div>
      <input
        ref="inputRef"
        v-model="inputValue"
        type="text"
        :placeholder="placeholder"
        class="search-input"
        @input="handleInput"
        @keydown.enter="handleSubmit"
        @focus="handleFocus"
        @blur="handleBlur"
      />
      <button 
        v-if="showClear && inputValue"
        class="clear-button"
        @click="handleClear"
        type="button"
        aria-label="検索をクリア"
      >
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
          <path d="M18 6L6 18M6 6L18 18" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

interface Props {
  placeholder?: string
  value?: string
  showClear?: boolean
  disabled?: boolean
}

interface Emits {
  (e: 'update:value', value: string): void
  (e: 'input', value: string): void
  (e: 'submit', value: string): void
  (e: 'focus'): void
  (e: 'blur'): void
  (e: 'clear'): void
}

const props = withDefaults(defineProps<Props>(), {
  placeholder: 'キーワードで検索...',
  value: '',
  showClear: true,
  disabled: false
})

const emit = defineEmits<Emits>()

const inputRef = ref<HTMLInputElement>()
const inputValue = ref(props.value)

watch(() => props.value, (newValue) => {
  inputValue.value = newValue
})

watch(inputValue, (newValue) => {
  emit('update:value', newValue)
  emit('input', newValue)
})

const handleInput = () => {
  // Input handling is done by watcher
}

const handleSubmit = () => {
  emit('submit', inputValue.value)
}

const handleFocus = () => {
  emit('focus')
}

const handleBlur = () => {
  emit('blur')
}

const handleClear = () => {
  inputValue.value = ''
  emit('clear')
  inputRef.value?.focus()
}

const focus = () => {
  inputRef.value?.focus()
}

defineExpose({
  focus
})
</script>

<style scoped>
.mgc-search-box {
  width: 100%;
  max-width: 400px;
}

.search-container {
  background-color: #f0f2f5;
  border: 1px solid #d3d6db;
  border-radius: 4px;
  padding: 6px 12px;
  display: flex;
  align-items: center;
  gap: 4px;
  height: 36px;
  transition: all 0.2s ease;
  position: relative;
}

.search-container:focus-within {
  border-color: #0072bf;
  box-shadow: 0 0 0 2px rgba(0, 114, 191, 0.2);
}

.search-icon {
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #999;
  flex-shrink: 0;
}

.search-input {
  border: none;
  background: none;
  outline: none;
  flex: 1;
  font-family: 'Inter', 'Noto Sans JP', sans-serif;
  font-size: 14px;
  color: #2e3033;
  line-height: 1.4;
}

.search-input::placeholder {
  color: rgba(46, 48, 51, 0.6);
}

.search-input:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.clear-button {
  width: 20px;
  height: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: none;
  border: none;
  cursor: pointer;
  color: #999;
  border-radius: 2px;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.clear-button:hover {
  background-color: rgba(0, 0, 0, 0.1);
  color: #666;
}

.clear-button:focus {
  outline: 2px solid #0072bf;
  outline-offset: 2px;
}

/* Size variants */
.mgc-search-box.small .search-container {
  height: 32px;
  padding: 4px 8px;
}

.mgc-search-box.small .search-input {
  font-size: 12px;
}

.mgc-search-box.large .search-container {
  height: 40px;
  padding: 8px 16px;
}

.mgc-search-box.large .search-input {
  font-size: 16px;
}

/* Disabled state */
.mgc-search-box.disabled .search-container {
  background-color: #f8f9fa;
  border-color: #e9ecef;
  cursor: not-allowed;
}

.mgc-search-box.disabled .search-input {
  cursor: not-allowed;
}

/* Responsive */
@media (max-width: 768px) {
  .mgc-search-box {
    max-width: 100%;
  }
  
  .search-container {
    height: 40px;
    padding: 8px 12px;
  }
  
  .search-input {
    font-size: 16px; /* Prevents zoom on iOS */
  }
}
</style>

