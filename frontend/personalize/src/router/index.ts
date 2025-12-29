import { createRouter, createWebHistory } from 'vue-router';
import Personalize from '../pages/hoge/Personalize.vue';
import Portal from '../pages/hoge/Portal.vue';
import MGCPage from '../pages/MGCPage.vue';

const routes = [
  {
    path: '/hoge/personalize',
    name: 'Personalize',
    component: Personalize,
  },
  {
    path: '/hoge/portal',
    name: 'Portal',
    component: Portal,
  },
  {
    path: '/mgc',
    name: 'MGCPage',
    component: MGCPage,
  },
];

const router = createRouter({
  history: createWebHistory('/'),
  routes,
});

export default router;
