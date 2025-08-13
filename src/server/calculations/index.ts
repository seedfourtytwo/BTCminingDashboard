/**
 * Calculation Worker - Computational heavy lifting
 * Port: 8788
 *
 * Responsibilities:
 * - Solar energy production calculations
 * - Bitcoin mining profitability projections
 * - Financial metrics (NPV, IRR, payback period)
 * - Equipment degradation modeling
 */

import type { CalculationWorkerEnv } from '../types/environment';

interface Env extends CalculationWorkerEnv {}

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
            worker: 'calculations',
            timestamp: new Date().toISOString(),
          },
          { headers: corsHeaders }
        );
      }

      // Calculation endpoints
      if (url.pathname.startsWith('/calculate')) {
        return handleCalculationRoutes(request, env, ctx, corsHeaders);
      }

      // Default response for unmatched routes
      return new Response('Not Found', {
        status: 404,
        headers: corsHeaders,
      });
    } catch (error) {
      console.error('Calculation Worker Error:', error);
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

async function handleCalculationRoutes(
  request: Request,
  env: Env,
  _ctx: ExecutionContext,
  corsHeaders: Record<string, string>
): Promise<Response> {
  const url = new URL(request.url);
  const method = request.method;
  const path = url.pathname.replace('/calculate', '');

  // Solar calculations
  if (path.startsWith('/solar')) {
    return Response.json({ message: 'Solar calculations coming soon' }, { headers: corsHeaders });
  }

  // Mining calculations
  if (path.startsWith('/mining')) {
    return Response.json({ message: 'Mining calculations coming soon' }, { headers: corsHeaders });
  }

  // Financial calculations
  if (path.startsWith('/financial')) {
    return Response.json({ message: 'Financial calculations coming soon' }, { headers: corsHeaders });
  }

  // Projection calculations
  if (path.startsWith('/projection')) {
    return Response.json({ message: 'Projection calculations coming soon' }, { headers: corsHeaders });
  }

  // Default calculation response
  return Response.json(
    {
      message: 'Solar Bitcoin Mining Calculator - Calculation Engine',
      version: '1.0.0',
      status: 'development',
      endpoints: {
        solar: '/calculate/solar',
        mining: '/calculate/mining',
        financial: '/calculate/financial',
        projection: '/calculate/projection',
      },
    },
    { headers: corsHeaders }
  );
}
