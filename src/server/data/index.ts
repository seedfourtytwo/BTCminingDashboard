/**
 * Data Worker - External data collection and management
 * Port: 8789
 *
 * Responsibilities:
 * - Bitcoin network data collection
 * - Environmental data collection
 * - Equipment data management
 * - Data caching and synchronization
 */

import type { DataWorkerEnv } from '../types/environment';

interface Env extends DataWorkerEnv {}

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
            worker: 'data',
            timestamp: new Date().toISOString(),
          },
          { headers: corsHeaders }
        );
      }

      // Data collection endpoints
      if (url.pathname.startsWith('/data')) {
        return handleDataRoutes(request, env, ctx, corsHeaders);
      }

      // Default response for unmatched routes
      return new Response('Not Found', {
        status: 404,
        headers: corsHeaders,
      });
    } catch (error) {
      console.error('Data Worker Error:', error);
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

async function handleDataRoutes(
  request: Request,
  env: Env,
  _ctx: ExecutionContext,
  corsHeaders: Record<string, string>
): Promise<Response> {
  const url = new URL(request.url);
  const method = request.method;
  const path = url.pathname.replace('/data', '');

  // Bitcoin data
  if (path.startsWith('/bitcoin')) {
    return Response.json({ message: 'Bitcoin data collection coming soon' }, { headers: corsHeaders });
  }

  // Environmental data
  if (path.startsWith('/environmental')) {
    return Response.json({ message: 'Environmental data collection coming soon' }, { headers: corsHeaders });
  }

  // Equipment data
  if (path.startsWith('/equipment')) {
    return Response.json({ message: 'Equipment data management coming soon' }, { headers: corsHeaders });
  }

  // Cache management
  if (path.startsWith('/cache')) {
    return Response.json({ message: 'Cache management coming soon' }, { headers: corsHeaders });
  }

  // Default data response
  return Response.json(
    {
      message: 'Solar Bitcoin Mining Calculator - Data Collection',
      version: '1.0.0',
      status: 'development',
      endpoints: {
        bitcoin: '/data/bitcoin',
        environmental: '/data/environmental',
        equipment: '/data/equipment',
        cache: '/data/cache',
      },
    },
    { headers: corsHeaders }
  );
}
