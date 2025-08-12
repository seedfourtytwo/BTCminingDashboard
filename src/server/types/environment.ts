/**
 * Shared environment type definitions for all workers
 */

export interface BaseWorkerEnv {
  // Environment identifier
  ENVIRONMENT: string;
  
  // Analytics (optional for all workers)
  ANALYTICS?: AnalyticsEngine;
}

export interface APIWorkerEnv extends BaseWorkerEnv {
  // Database binding
  DB: D1Database;
  
  // Service bindings to other workers
  CALCULATIONS: Fetcher;
  DATA_SERVICE: Fetcher;
  
  // API-specific environment variables
  API_KEY?: string;
  JWT_SECRET?: string;
  CORS_ORIGIN?: string;
}

export interface CalculationWorkerEnv extends BaseWorkerEnv {
  // Durable Objects for stateful calculations
  CALCULATION_ENGINE?: DurableObjectNamespace;
  
  // Queues for background processing
  CALCULATION_QUEUE?: Queue;
  
  // KV Storage for calculation result caching
  CALC_CACHE?: KVNamespace;
  
  // Calculation-specific settings
  MAX_CALCULATION_TIME_MS?: string;
  MONTE_CARLO_MAX_ITERATIONS?: string;
}

export interface DataWorkerEnv extends BaseWorkerEnv {
  // KV Storage for data caching
  DATA_CACHE?: KVNamespace;
  
  // External API keys
  BITCOIN_API_KEY?: string;
  WEATHER_API_KEY?: string;
  COINGECKO_API_KEY?: string;
  OPENWEATHER_API_KEY?: string;
  NREL_API_KEY?: string;
  
  // Rate limiting settings
  RATE_LIMIT_REQUESTS_PER_MINUTE?: string;
  CACHE_TTL_SECONDS?: string;
}

// Common types for all workers
export interface RequestContext {
  requestId: string;
  timestamp: Date;
  userAgent?: string;
  ipAddress?: string;
  userId?: string;
}

export interface ErrorContext {
  worker: 'api' | 'calculations' | 'data';
  error: Error;
  request?: Request;
  context?: Record<string, unknown>;
}

export interface LogContext {
  worker: 'api' | 'calculations' | 'data';
  level: 'debug' | 'info' | 'warn' | 'error';
  message: string;
  data?: Record<string, unknown>;
  timestamp: Date;
}