<script setup lang="ts">
import PersonalizePage from '@/components/page/PersonalizePage.vue'
</script>

<template>
  <PersonalizePage />
</template>

<style scoped>
.personalize-page-container {
  max-width: 800px;
  margin: 40px auto;
  padding: 20px;
  background-color: #f0f2f5;
  border-radius: 8px;
}

.page-header {
  text-align: center;
  margin-bottom: 40px;
}

.page-header h1 {
  font-family: 'Inter', sans-serif;
  font-size: 32px;
  font-weight: 700;
  color: #333;
  margin-bottom: 10px;
}

.page-header p {
  font-family: 'Inter', sans-serif;
  font-size: 16px;
  color: #666;
}

.card-title {
  font-family: 'Inter', sans-serif;
  font-size: 20px;
  font-weight: 600;
  color: #333;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
}

.form-group {
  margin-bottom: 15px;
}

.form-group-inline {
  display: flex;
  gap: 20px;
  margin-bottom: 15px;
}
.form-group-inline > div {
  flex: 1;
}

.radio-group {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}

.button-group {
  display: flex;
  justify-content: flex-end;
  gap: 15px;
  margin-top: 30px;
}
</style>