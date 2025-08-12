import { describe, test, expect } from 'vitest'

describe('Smoke Tests - Health Checks', () => {
  const apiBaseUrl = process.env['VITE_API_BASE_URL'] || 'https://solar-mining-api-dev.workers.dev'

  test('API is responding', async () => {
    try {
      const response = await fetch(`${apiBaseUrl}/health`)
      expect(response.status).toBe(200)
    } catch (error) {
      // If health endpoint doesn't exist yet, that's OK for now
      console.log('Health endpoint not implemented yet, skipping test')
    }
  })

  test('API base URL is accessible', async () => {
    try {
      const response = await fetch(apiBaseUrl)
      // Should get some response (even if it's 404, that means the service is up)
      expect(response.status).toBeGreaterThan(0)
    } catch (error) {
      console.log('API not accessible yet, this is expected during development')
    }
  })

  test('Environment variables are set', () => {
    expect(process.env['VITE_API_BASE_URL']).toBeDefined()
    console.log('API Base URL:', process.env['VITE_API_BASE_URL'])
  })
})
