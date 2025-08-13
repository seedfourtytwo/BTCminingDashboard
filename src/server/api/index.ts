/**
 * API Worker - Main application server
 * Port: 8787
 *
 * Responsibilities:
 * - HTTP routing and request handling
 * - Database CRUD operations (D1)
 * - Data validation and sanitization
 * - Service orchestration (calls to other workers)
 * - API versioning and documentation
 */

import type { APIWorkerEnv } from '../types/environment';

interface Env extends APIWorkerEnv {}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    const method = request.method;

    // CORS headers for development
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    };

    // Handle preflight requests
    if (method === 'OPTIONS') {
      return new Response(null, { headers: corsHeaders });
    }

    try {
      // Health check endpoint
      if (url.pathname === '/health') {
        return Response.json(
          {
            status: 'healthy',
            worker: 'api',
            timestamp: new Date().toISOString(),
          },
          { headers: corsHeaders }
        );
      }

      // API versioning - all API routes start with /api/v1
      if (url.pathname.startsWith('/api/v1')) {
        return handleAPIRoutes(request, env, ctx, corsHeaders);
      }

      // Default response for unmatched routes
      return new Response('Not Found', {
        status: 404,
        headers: corsHeaders,
      });
    } catch (error) {
      console.error('API Worker Error:', error);
      return Response.json(
        {
          error: 'Internal Server Error',
          message: error instanceof Error ? error.message : 'Unknown error',
        },
        {
          status: 500,
          headers: corsHeaders,
        }
      );
    }
  },
} satisfies ExportedHandler<Env>;

async function handleAPIRoutes(
  request: Request,
  env: Env,
  _ctx: ExecutionContext,
  corsHeaders: Record<string, string>
): Promise<Response> {
  const url = new URL(request.url);
  const method = request.method;
  const path = url.pathname.replace('/api/v1', '');

  // Equipment routes
  if (path.startsWith('/equipment')) {
    return Response.json({ message: 'Equipment endpoints coming soon' }, { headers: corsHeaders });
  }

  // Projection routes
  if (path.startsWith('/projections')) {
    return Response.json({ message: 'Projection endpoints coming soon' }, { headers: corsHeaders });
  }

  // System configuration routes
  if (path.startsWith('/system-configs')) {
    return Response.json(
      { message: 'System config endpoints coming soon' },
      { headers: corsHeaders }
    );
  }

  // Location routes
  if (path.startsWith('/locations')) {
    return Response.json({ message: 'Location endpoints coming soon' }, { headers: corsHeaders });
  }

  // Bitcoin data routes
  if (path.startsWith('/bitcoin')) {
    return Response.json({ message: 'Bitcoin data endpoints coming soon' }, { headers: corsHeaders });
  }

  // Environmental data routes
  if (path.startsWith('/environmental')) {
    return Response.json({ message: 'Environmental data endpoints coming soon' }, { headers: corsHeaders });
  }

  // Default API response
  return Response.json(
    {
      message: 'Solar Bitcoin Mining Calculator API',
      version: '1.0.0',
      status: 'development',
      endpoints: {
        equipment: '/api/v1/equipment',
        projections: '/api/v1/projections',
        'system-configs': '/api/v1/system-configs',
        locations: '/api/v1/locations',
        bitcoin: '/api/v1/bitcoin',
        environmental: '/api/v1/environmental',
      },
    },
    { headers: corsHeaders }
  );
}
