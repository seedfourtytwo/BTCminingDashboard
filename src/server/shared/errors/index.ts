/**
 * Custom error classes for the application
 */

export abstract class AppError extends Error {
  abstract readonly code: string;
  abstract readonly statusCode: number;

  constructor(
    message: string,
    public readonly context?: Record<string, unknown>
  ) {
    super(message);
    this.name = this.constructor.name;

    // Maintains proper stack trace for where our error was thrown
    if (typeof Error.captureStackTrace === 'function') {
      Error.captureStackTrace(this, this.constructor);
    }
  }

  toJSON() {
    return {
      name: this.name,
      message: this.message,
      code: this.code,
      statusCode: this.statusCode,
      context: this.context,
      stack: this.stack,
    };
  }
}

export class ValidationError extends AppError {
  readonly code = 'VALIDATION_ERROR';
  readonly statusCode = 400;

  constructor(
    message: string,
    public readonly field?: string,
    public readonly value?: unknown,
    context?: Record<string, unknown>
  ) {
    super(message, context);
  }
}

export class DatabaseError extends AppError {
  readonly code = 'DATABASE_ERROR';
  readonly statusCode = 500;

  constructor(message: string, context?: Record<string, unknown>) {
    super(message, context);
  }
}

export class CalculationError extends AppError {
  readonly code = 'CALCULATION_ERROR';
  readonly statusCode = 422;

  constructor(
    message: string,
    public readonly calculationType?: string,
    context?: Record<string, unknown>
  ) {
    super(message, context);
  }
}

export class ExternalAPIError extends AppError {
  readonly code = 'EXTERNAL_API_ERROR';
  readonly statusCode = 502;

  constructor(
    message: string,
    public readonly apiProvider?: string,
    public readonly apiStatusCode?: number,
    context?: Record<string, unknown>
  ) {
    super(message, context);
  }
}

export class NotFoundError extends AppError {
  readonly code = 'NOT_FOUND';
  readonly statusCode = 404;

  constructor(resource: string, identifier?: string, context?: Record<string, unknown>) {
    const message = identifier
      ? `${resource} with identifier '${identifier}' not found`
      : `${resource} not found`;
    super(message, context);
  }
}

export class AuthenticationError extends AppError {
  readonly code = 'AUTHENTICATION_ERROR';
  readonly statusCode = 401;

  constructor(message: string = 'Authentication required', context?: Record<string, unknown>) {
    super(message, context);
  }
}

export class AuthorizationError extends AppError {
  readonly code = 'AUTHORIZATION_ERROR';
  readonly statusCode = 403;

  constructor(
    message: string = 'Insufficient permissions',
    public readonly requiredPermission?: string,
    context?: Record<string, unknown>
  ) {
    super(message, context);
  }
}

export class RateLimitError extends AppError {
  readonly code = 'RATE_LIMIT_ERROR';
  readonly statusCode = 429;

  constructor(
    message: string = 'Rate limit exceeded',
    public readonly retryAfter?: number,
    context?: Record<string, unknown>
  ) {
    super(message, context);
  }
}

export class ConfigurationError extends AppError {
  readonly code = 'CONFIGURATION_ERROR';
  readonly statusCode = 500;

  constructor(
    message: string,
    public readonly configKey?: string,
    context?: Record<string, unknown>
  ) {
    super(message, context);
  }
}

export class TimeoutError extends AppError {
  readonly code = 'TIMEOUT_ERROR';
  readonly statusCode = 408;

  constructor(operation: string, timeoutMs: number, context?: Record<string, unknown>) {
    super(`Operation '${operation}' timed out after ${timeoutMs}ms`, context);
  }
}

// Error handler for Workers
export function handleError(error: unknown): Response {
  console.error('Error occurred:', error);

  // Handle known application errors
  if (error instanceof AppError) {
    return Response.json(
      {
        success: false,
        error: {
          code: error.code,
          message: error.message,
          context: error.context,
        },
      },
      {
        status: error.statusCode,
        headers: {
          'Content-Type': 'application/json',
        },
      }
    );
  }

  // Handle standard JavaScript errors
  if (error instanceof Error) {
    return Response.json(
      {
        success: false,
        error: {
          code: 'INTERNAL_ERROR',
          message: 'An internal error occurred',
          details:
            typeof process !== 'undefined' && process.env?.NODE_ENV === 'development'
              ? error.message
              : undefined,
        },
      },
      {
        status: 500,
        headers: {
          'Content-Type': 'application/json',
        },
      }
    );
  }

  // Handle unknown errors
  return Response.json(
    {
      success: false,
      error: {
        code: 'UNKNOWN_ERROR',
        message: 'An unknown error occurred',
      },
    },
    {
      status: 500,
      headers: {
        'Content-Type': 'application/json',
      },
    }
  );
}

// Utility functions for error handling
export function isAppError(error: unknown): error is AppError {
  return error instanceof AppError;
}

export function isValidationError(error: unknown): error is ValidationError {
  return error instanceof ValidationError;
}

export function isDatabaseError(error: unknown): error is DatabaseError {
  return error instanceof DatabaseError;
}

export function isCalculationError(error: unknown): error is CalculationError {
  return error instanceof CalculationError;
}

export function isExternalAPIError(error: unknown): error is ExternalAPIError {
  return error instanceof ExternalAPIError;
}

export function isNotFoundError(error: unknown): error is NotFoundError {
  return error instanceof NotFoundError;
}

// Error logging utility
export interface ErrorLogContext {
  worker: 'api' | 'calculations' | 'data';
  requestId?: string;
  userId?: string;
  endpoint?: string;
  userAgent?: string;
  ipAddress?: string;
}

export function logError(
  error: unknown,
  context: ErrorLogContext,
  additionalContext?: Record<string, unknown>
): void {
  const logData = {
    timestamp: new Date().toISOString(),
    worker: context.worker,
    error: {
      name: error instanceof Error ? error.name : 'UnknownError',
      message: error instanceof Error ? error.message : String(error),
      stack: error instanceof Error ? error.stack : undefined,
      code: error instanceof AppError ? error.code : undefined,
      statusCode: error instanceof AppError ? error.statusCode : undefined,
    },
    request: {
      id: context.requestId,
      endpoint: context.endpoint,
      userAgent: context.userAgent,
      ipAddress: context.ipAddress,
      userId: context.userId,
    },
    context: {
      ...additionalContext,
      ...(error instanceof AppError ? error.context : {}),
    },
  };

  console.error('Application Error:', JSON.stringify(logData, null, 2));
}
