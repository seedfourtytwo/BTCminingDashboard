import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig({
  plugins: [react()],
  
  // TypeScript configuration
  esbuild: {
    target: 'es2022'
  },
  
  // Path resolution
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
      '@/client': resolve(__dirname, 'src/client'),
      '@/server': resolve(__dirname, 'src/server'),
      '@/shared': resolve(__dirname, 'src/shared'),
      '@/components': resolve(__dirname, 'src/client/components'),
      '@/hooks': resolve(__dirname, 'src/client/hooks'),
      '@/services': resolve(__dirname, 'src/client/services'),
      '@/utils': resolve(__dirname, 'src/client/utils'),
      '@/types': resolve(__dirname, 'src/shared/types')
    }
  },
  
  // Development server
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8787',
        changeOrigin: true
      }
    }
  },

  // Build configuration
  build: {
    target: 'es2022',
    outDir: 'dist',
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          router: ['react-router-dom'],
          utils: ['date-fns', 'zod', 'clsx']
        }
      }
    }
  },

  // Optimization
  optimizeDeps: {
    include: ['react', 'react-dom', 'react-router-dom', 'date-fns'],
    esbuildOptions: {
      target: 'es2022'
    }
  },

  // Test configuration
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./tests/setup.ts']
  }
});