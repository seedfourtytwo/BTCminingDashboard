/**
 * Durable Object classes for stateful calculations
 * These are stubs that will be implemented when needed
 */

export class CalculationEngine {
  constructor() {
    // TODO: Add state and env parameters when implementing
  }

  async fetch(_request: Request): Promise<Response> {
    // TODO: Implement stateful calculation engine
    return new Response(
      JSON.stringify({
        message: 'Calculation Engine - Not implemented yet',
        timestamp: new Date().toISOString(),
      }),
      {
        headers: { 'Content-Type': 'application/json' },
      }
    );
  }
}

export class MonteCarloEngine {
  constructor() {
    // TODO: Add state and env parameters when implementing
  }

  async fetch(_request: Request): Promise<Response> {
    // TODO: Implement Monte Carlo simulation engine
    return new Response(
      JSON.stringify({
        message: 'Monte Carlo Engine - Not implemented yet',
        timestamp: new Date().toISOString(),
      }),
      {
        headers: { 'Content-Type': 'application/json' },
      }
    );
  }
}
