import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig({
  plugins: [react()],
  
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
  
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./tests/setup.ts'],
    include: [
      'src/**/*.{test,spec}.{js,ts,jsx,tsx}',
      'tests/**/*.{test,spec}.{js,ts,jsx,tsx}'
    ],
    exclude: [
      'node_modules',
      'dist',
      'build',
      '.wrangler'
    ],
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html', 'lcov'],
      exclude: [
        'node_modules/',
        'tests/',
        '**/*.test.{js,ts,jsx,tsx}',
        '**/*.spec.{js,ts,jsx,tsx}',
        'src/**/*.d.ts',
        'dist/',
        'build/',
        '.wrangler/'
      ],
      thresholds: {
        global: {
          branches: 80,
          functions: 80,
          lines: 80,
          statements: 80
        }
      }
    }
  }
});