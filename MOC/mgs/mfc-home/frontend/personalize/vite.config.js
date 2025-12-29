import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  root: '.',
  plugins: [vue()],
  build: {
    outDir: 'dist',
    rollupOptions: {
      input: './mockup.html'
    }
  },
  server: {
    open: '/mockup.html',
    port: 5173
  }
});
