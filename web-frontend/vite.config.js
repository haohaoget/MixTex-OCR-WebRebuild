import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 3000,
    host: true,
    proxy: {
      '/predict': {
        target: 'http://localhost:8000',
        changeOrigin: true
      },
      '/predict_base64': {
        target: 'http://localhost:8000',
        changeOrigin: true
      },
      '/predict_clipboard': {
        target: 'http://localhost:8000',
        changeOrigin: true
      },
      '/feedback': {
        target: 'http://localhost:8000',
        changeOrigin: true
      },
      '/statistics': {
        target: 'http://localhost:8000',
        changeOrigin: true
      },
      '/reload_model': {
        target: 'http://localhost:8000',
        changeOrigin: true
      },
      '/health': {
        target: 'http://localhost:8000',
        changeOrigin: true
      }
    }
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: false,
    minify: 'terser',
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['vue', 'element-plus'],
          icons: ['@element-plus/icons-vue']
        }
      }
    }
  }
})
