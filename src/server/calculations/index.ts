/**
 * Calculation Worker - Computational heavy lifting
 * Port: 8788
 * 
 * Responsibilities:
 * - Solar energy production calculations
 * - Bitcoin mining profitability projections
 * - Monte Carlo risk analysis simulations
 * - Financial metrics (NPV, IRR, payback period)
 * - Equipment degradation modeling
 * - Power system optimization
 */

import type { CalculationWorkerEnv } from '../types/environment';

interface Env extends CalculationWorkerEnv {}

// Export Durable Object classes
export { CalculationEngine, MonteCarloEngine } from './durable-objects';

export default {
  async fetch(request: Request, env: Env, _ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    const method = request.method;
    
    // CORS headers
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
          worker: 'calculations',
          timestamp: new Date().toISOString(),
          capabilities: [
            'solar-production',
            'mining-projections', 
            'monte-carlo',
            'financial-analysis'
          ]
        }, { headers: corsHeaders });
      }

      // Solar production calculations
      if (url.pathname === '/calculate/solar-production' && method === 'POST') {
        return handleSolarProduction(request, env, corsHeaders);
      }

      // Mining profitability projections
      if (url.pathname === '/calculate/mining-projection' && method === 'POST') {
        return handleMiningProjection(request, env, corsHeaders);
      }

      // Monte Carlo simulations
      if (url.pathname === '/calculate/monte-carlo' && method === 'POST') {
        return handleMonteCarloSimulation(request, env, corsHeaders);
      }

      // Financial analysis
      if (url.pathname === '/calculate/financial-metrics' && method === 'POST') {
        return handleFinancialMetrics(request, env, corsHeaders);
      }

      // System optimization
      if (url.pathname === '/calculate/optimize-system' && method === 'POST') {
        return handleSystemOptimization(request, env, corsHeaders);
      }

      return new Response('Calculation endpoint not found', { 
        status: 404, 
        headers: corsHeaders 
      });

    } catch (error) {
      console.error('Calculation Worker Error:', error);
      return Response.json({
        error: 'Calculation Error',
        message: error instanceof Error ? error.message : 'Unknown calculation error'
      }, { 
        status: 500, 
        headers: corsHeaders 
      });
    }
  },

  // Queue handler for background calculations
  async queue(batch: MessageBatch<any>, env: Env): Promise<void> {
    for (const message of batch.messages) {
      try {
        await handleQueuedCalculation(message.body, env);
        message.ack();
      } catch (error) {
        console.error('Queue calculation error:', error);
        message.retry();
      }
    }
  }
} satisfies ExportedHandler<Env>;

async function handleSolarProduction(
  request: Request, 
  _env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  try {
    const body = await request.json();
    
    // TODO: Implement solar production calculation
    // This would use the solar calculation engines
    
    const result = {
      message: 'Solar production calculation',
      input: body,
      // TODO: Replace with actual calculation results
      estimated_annual_kwh: 0,
      monthly_production: [],
      capacity_factor: 0
    };

    return Response.json(result, { headers: corsHeaders });
  } catch (error) {
    return Response.json({
      error: 'Solar calculation failed',
      message: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 400, headers: corsHeaders });
  }
}

async function handleMiningProjection(
  request: Request, 
  _env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  try {
    const body = await request.json();
    
    // TODO: Implement mining projection calculation
    // This would use the mining calculation engines
    
    const result = {
      message: 'Mining projection calculation',
      input: body,
      // TODO: Replace with actual calculation results
      projected_btc_annual: 0,
      projected_revenue_usd: 0,
      break_even_btc_price: 0
    };

    return Response.json(result, { headers: corsHeaders });
  } catch (error) {
    return Response.json({
      error: 'Mining projection failed',
      message: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 400, headers: corsHeaders });
  }
}

async function handleMonteCarloSimulation(
  request: Request, 
  _env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  try {
    const body = await request.json();
    
    // TODO: Implement Monte Carlo simulation
    // This would use the monte-carlo calculation engine
    
    const result = {
      message: 'Monte Carlo simulation',
      input: body,
      // TODO: Replace with actual simulation results
      scenarios_analyzed: 0,
      confidence_intervals: {},
      risk_metrics: {}
    };

    return Response.json(result, { headers: corsHeaders });
  } catch (error) {
    return Response.json({
      error: 'Monte Carlo simulation failed',
      message: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 400, headers: corsHeaders });
  }
}

async function handleFinancialMetrics(
  request: Request, 
  _env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  try {
    const body = await request.json();
    
    // TODO: Implement financial metrics calculation
    // This would use the financial calculation engine
    
    const result = {
      message: 'Financial metrics calculation',
      input: body,
      // TODO: Replace with actual financial metrics
      npv: 0,
      irr: 0,
      payback_period_years: 0,
      roi_percent: 0
    };

    return Response.json(result, { headers: corsHeaders });
  } catch (error) {
    return Response.json({
      error: 'Financial metrics calculation failed',
      message: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 400, headers: corsHeaders });
  }
}

async function handleSystemOptimization(
  request: Request, 
  _env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  try {
    const body = await request.json();
    
    // TODO: Implement system optimization
    // This would analyze different configurations and recommend optimal setup
    
    const result = {
      message: 'System optimization',
      input: body,
      // TODO: Replace with actual optimization results
      optimal_configuration: {},
      projected_improvement: 0,
      recommendations: []
    };

    return Response.json(result, { headers: corsHeaders });
  } catch (error) {
    return Response.json({
      error: 'System optimization failed',
      message: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 400, headers: corsHeaders });
  }
}

async function handleQueuedCalculation(messageBody: any, _env: Env): Promise<void> {
  // TODO: Implement background calculation processing
  // This would handle long-running calculations that are queued
  console.log('Processing queued calculation:', messageBody);
}