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
        return Response.json({ 
          status: 'healthy', 
          worker: 'api',
          timestamp: new Date().toISOString() 
        }, { headers: corsHeaders });
      }

      // API versioning - all API routes start with /api/v1
      if (url.pathname.startsWith('/api/v1')) {
        return handleAPIRoutes(request, env, ctx, corsHeaders);
      }

      // Default response for unmatched routes
      return new Response('Not Found', { 
        status: 404, 
        headers: corsHeaders 
      });

    } catch (error) {
      console.error('API Worker Error:', error);
      return Response.json({
        error: 'Internal Server Error',
        message: error instanceof Error ? error.message : 'Unknown error'
      }, { 
        status: 500, 
        headers: corsHeaders 
      });
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
    // TODO: Import and use equipment handlers
    return Response.json({ message: 'Equipment endpoints coming soon' }, { headers: corsHeaders });
  }

  // Projection routes
  if (path.startsWith('/projections')) {
    // TODO: Import and use projection handlers
    return Response.json({ message: 'Projection endpoints coming soon' }, { headers: corsHeaders });
  }

  // System configuration routes
  if (path.startsWith('/system-configs')) {
    // TODO: Import and use system config handlers
    return Response.json({ message: 'System config endpoints coming soon' }, { headers: corsHeaders });
  }

  // Bitcoin network data routes
  if (path.startsWith('/bitcoin')) {
    // Delegate to Data Worker for external API calls
    const body = method !== 'GET' ? await request.text() : undefined;
    const upstream = new Request(new URL(`/bitcoin${url.search}`, 'http://internal'), {
      method,
      headers: request.headers,
      ...(body && { body })
    });
    const response = await env.DATA_SERVICE.fetch(upstream);
    
    const data = await response.json();
    return Response.json(data, { 
      status: response.status, 
      headers: corsHeaders 
    });
  }

  // Weather data routes
  if (path.startsWith('/weather')) {
    // Delegate to Data Worker for external API calls
    const weatherBody = method !== 'GET' ? await request.text() : undefined;
    const weatherUpstream = new Request(new URL(`/weather${url.search}`, 'http://internal'), {
      method,
      headers: request.headers,
      ...(weatherBody && { body: weatherBody })
    });
    const response = await env.DATA_SERVICE.fetch(weatherUpstream);
    
    const data = await response.json();
    return Response.json(data, { 
      status: response.status, 
      headers: corsHeaders 
    });
  }

  return new Response('API endpoint not found', { 
    status: 404, 
    headers: corsHeaders 
  });
}