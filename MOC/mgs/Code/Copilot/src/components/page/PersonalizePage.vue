<template>
  <main class="personalize-main">
    <section class="personalize-hero">
      <img
        class="hero-image"
        src="/mock/personalize-hero.png"
        alt="パーソナライズ ヒーロー画像（モック）"
      />
      <div class="hero-content">
        <h1 class="hero-title">三菱ガス化学 パーソナライズ</h1>
        <p class="hero-desc">
          あなたに最適な製品・サービスをご提案します。<br />
          下記の質問にお答えください。
        </p>
      </div>
    </section>
    <form class="personalize-form" @submit.prevent>
      <div class="form-group">
        <label class="form-label">ご利用目的</label>
        <PersonalizeSelect v-model="purpose">
          <option value="">選択してください</option>
          <option value="research">研究用途</option>
          <option value="business">ビジネス用途</option>
          <option value="other">その他</option>
        </PersonalizeSelect>
      </div>
      <div class="form-group">
        <label class="form-label">ご興味のある分野</label>
        <div class="radio-group">
          <PersonalizeRadio
            v-for="item in interests"
            :key="item.value"
            name="interest"
            :value="item.value"
            v-model="interest"
          >
            {{ item.label }}
          </PersonalizeRadio>
        </div>
      </div>
      <div class="form-group">
        <label class="form-label">ご希望の連絡方法</label>
        <PersonalizeSelect v-model="contact">
          <option value="">選択してください</option>
          <option value="email">メール</option>
          <option value="phone">電話</option>
        </PersonalizeSelect>
      </div>
      <div class="form-actions">
        <PersonalizeButton type="submit">診断する</PersonalizeButton>
      </div>
    </form>
  </main>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import PersonalizeButton from '../element/PersonalizeButton.vue';
import PersonalizeRadio from '../element/PersonalizeRadio.vue';
import PersonalizeSelect from '../element/PersonalizeSelect.vue';

const purpose = ref('');
const interest = ref('');
const contact = ref('');
const interests = [
  { value: 'chemistry', label: '化学' },
  { value: 'materials', label: '材料' },
  { value: 'environment', label: '環境' },
  { value: 'other', label: 'その他' }
];
</script>

<style scoped>
.personalize-main {
  min-height: 100vh;
  background: #f7fafd;
  font-family: 'Noto Sans JP', 'Roboto', sans-serif;
  padding: 0;
}
.personalize-hero {
  display: flex;
  align-items: center;
  gap: 40px;
  background: #e6f0fa;
  padding: 48px 32px 32px 32px;
  border-radius: 0 0 32px 32px;
  box-shadow: 0 4px 24px rgba(0,112,192,0.08);
}
.hero-image {
  width: 180px;
  height: 180px;
  object-fit: cover;
  border-radius: 16px;
  background: #d0e3f7;
}
.hero-content {
  flex: 1;
}
.hero-title {
  font-size: 32px;
  font-weight: 700;
  color: #0070c0;
  margin: 0 0 12px 0;
  line-height: 1.2;
}
.hero-desc {
  font-size: 18px;
  color: #333;
  line-height: 1.7;
  margin: 0;
}
.personalize-form {
  max-width: 520px;
  margin: 40px auto 0 auto;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 2px 16px rgba(0,112,192,0.10);
  padding: 40px 32px 32px 32px;
  display: flex;
  flex-direction: column;
  gap: 32px;
}
.form-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.form-label {
  font-size: 16px;
  font-weight: 600;
  color: #0070c0;
  margin-bottom: 4px;
}
.radio-group {
  display: flex;
  flex-wrap: wrap;
  gap: 20px 32px;
}
.form-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 12px;
}
@media (max-width: 700px) {
  .personalize-hero {
    flex-direction: column;
    gap: 20px;
    padding: 32px 12px 20px 12px;
    border-radius: 0 0 20px 20px;
  }
  .hero-image {
    width: 120px;
    height: 120px;
  }
  .personalize-form {
    padding: 24px 8px 20px 8px;
  }
}
</style>
