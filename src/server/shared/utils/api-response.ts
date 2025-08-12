/**
 * Shared API response envelope utilities
 * Ensures consistent response format across all API endpoints
 */

import type { APIResponse, PaginationMeta } from '../../types/api';

/**
 * Create a successful API response
 */
export function createSuccessResponse<T>(
  data: T,
  meta?: {
    pagination?: PaginationMeta;
    timestamp?: string;
    request_id?: string;
  }
): APIResponse<T> {
  return {
    success: true,
    data,
    meta: {
      timestamp: new Date().toISOString(),
      ...meta,
    },
  };
}

/**
 * Create an error API response
 */
export function createErrorResponse(
  error: string,
  message?: string,
  meta?: {
    timestamp?: string;
    request_id?: string;
  }
): APIResponse<never> {
  const result: APIResponse<never> = {
    success: false,
    error,
    meta: {
      timestamp: new Date().toISOString(),
      ...meta,
    },
  };

  if (message !== undefined) {
    result.message = message;
  }

  return result;
}

/**
 * Create a paginated success response
 */
export function createPaginatedResponse<T>(
  data: T[],
  pagination: PaginationMeta,
  meta?: {
    timestamp?: string;
    request_id?: string;
  }
): APIResponse<T[]> {
  return {
    success: true,
    data,
    meta: {
      timestamp: new Date().toISOString(),
      pagination,
      ...meta,
    },
  };
}

/**
 * Wrap Response.json with consistent API envelope
 */
export function jsonResponse<T>(
  data: T,
  options?: {
    status?: number;
    headers?: HeadersInit;
    pagination?: PaginationMeta;
    request_id?: string;
  }
): Response {
  const { status = 200, headers = {}, pagination, request_id } = options || {};

  const metaData: any = { request_id };
  if (pagination) {
    metaData.pagination = pagination;
  }
  const responseData = createSuccessResponse(data, metaData);

  const responseHeaders = {
    'Content-Type': 'application/json',
    ...headers,
  };

  return new Response(JSON.stringify(responseData), {
    status,
    headers: responseHeaders,
  });
}

/**
 * Wrap Response.json for error responses
 */
export function errorResponse(
  error: string,
  options?: {
    status?: number;
    headers?: HeadersInit;
    message?: string;
    request_id?: string;
  }
): Response {
  const { status = 500, headers = {}, message, request_id } = options || {};

  const metaData: any = {};
  if (request_id) {
    metaData.request_id = request_id;
  }
  const responseData = createErrorResponse(error, message, metaData);

  const responseHeaders = {
    'Content-Type': 'application/json',
    ...headers,
  };

  return new Response(JSON.stringify(responseData), {
    status,
    headers: responseHeaders,
  });
}

/**
 * Create a validation error response
 */
export function validationErrorResponse(
  errors: Array<{ field: string; message: string }>,
  options?: {
    headers?: HeadersInit;
    request_id?: string;
  }
): Response {
  const { headers = {}, request_id } = options || {};

  const responseData: APIResponse<never> = {
    success: false,
    error: 'Validation Error',
    message: 'Request validation failed',
    meta: {
      timestamp: new Date().toISOString(),
      ...(request_id && { request_id }),
      validation_errors: errors,
    } as any,
  };

  const responseHeaders = {
    'Content-Type': 'application/json',
    ...headers,
  };

  return new Response(JSON.stringify(responseData), {
    status: 400,
    headers: responseHeaders,
  });
}

/**
 * Create a not found error response
 */
export function notFoundResponse(
  resource: string,
  options?: {
    headers?: HeadersInit;
    request_id?: string;
  }
): Response {
  const { headers = {}, request_id } = options || {};

  return errorResponse('Not Found', {
    status: 404,
    headers,
    message: `${resource} not found`,
    ...(request_id && { request_id }),
  });
}

/**
 * Extract request ID from request headers for consistent tracking
 */
export function getRequestId(request: Request): string {
  return (
    request.headers.get('x-request-id') ||
    `req_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`
  );
}

/**
 * Add CORS headers to response
 */
export function withCORS(response: Response, allowedOrigins: string[] = ['*']): Response {
  const headers = new Headers(response.headers);

  headers.set('Access-Control-Allow-Origin', allowedOrigins.join(', '));
  headers.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  headers.set('Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Request-ID');
  headers.set('Access-Control-Max-Age', '86400');

  return new Response(response.body, {
    status: response.status,
    statusText: response.statusText,
    headers,
  });
}
