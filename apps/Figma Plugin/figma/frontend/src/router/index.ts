import { createRouter, createWebHistory } from 'vue-router'
import PersonalizePage from '../hoge/personalize.vue' // 新しいページをインポート

const router = createRouter({
  history: createWebHistory('/hoge/'), // ベースパスを/hoge/に設定
  routes: [
    {
      path: '/personalize',
      name: 'personalize',
      component: PersonalizePage
    }
    // 他のルートはここに追加
  ]
})

export default router