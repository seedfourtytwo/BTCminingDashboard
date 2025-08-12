/**
 * Data Worker - External data management
 * Port: 8789
 * 
 * Responsibilities:
 * - External API integration (Bitcoin prices, weather data)
 * - Data caching and invalidation strategies
 * - Rate limiting and API quota management
 * - Scheduled data updates via Cron triggers
 * - Data transformation and normalization
 * - Data quality monitoring
 */

import type { DataWorkerEnv } from '../types/environment';

interface Env extends DataWorkerEnv {}

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
          worker: 'data',
          timestamp: new Date().toISOString(),
          data_sources: [
            'bitcoin-prices',
            'weather-data',
            'equipment-specs'
          ]
        }, { headers: corsHeaders });
      }

      // Bitcoin data endpoints
      if (url.pathname.startsWith('/bitcoin')) {
        return handleBitcoinData(request, env, corsHeaders);
      }

      // Weather data endpoints
      if (url.pathname.startsWith('/weather')) {
        return handleWeatherData(request, env, corsHeaders);
      }

      // Equipment data endpoints
      if (url.pathname.startsWith('/equipment-data')) {
        return handleEquipmentData(request, env, corsHeaders);
      }

      // Cache management endpoints
      if (url.pathname.startsWith('/cache')) {
        return handleCacheManagement(request, env, corsHeaders);
      }

      return new Response('Data endpoint not found', { 
        status: 404, 
        headers: corsHeaders 
      });

    } catch (error) {
      console.error('Data Worker Error:', error);
      return Response.json({
        error: 'Data Worker Error',
        message: error instanceof Error ? error.message : 'Unknown data error'
      }, { 
        status: 500, 
        headers: corsHeaders 
      });
    }
  },

  // Scheduled event handler for data updates
  async scheduled(event: ScheduledEvent, env: Env, _ctx: ExecutionContext): Promise<void> {
    try {
      console.log('Running scheduled data update:', event.cron);
      
      switch (event.cron) {
        case '0 */6 * * *': // Every 6 hours - Bitcoin price updates
          await updateBitcoinPrices(env);
          break;
        case '0 0 * * *': // Daily - Equipment database updates
          await updateEquipmentData(env);
          break;
        case '0 12 * * 1': // Weekly Monday noon - Weather data refresh
          await updateWeatherData(env);
          break;
        default:
          console.log('Unknown cron schedule:', event.cron);
      }
    } catch (error) {
      console.error('Scheduled task error:', error);
    }
  }
} satisfies ExportedHandler<Env>;

async function handleBitcoinData(
  request: Request, 
  env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  const url = new URL(request.url);
  const path = url.pathname.replace('/bitcoin', '');

  try {
    // Current Bitcoin price
    if (path === '/current-price') {
      return await getBitcoinPrice(env, corsHeaders);
    }

    // Bitcoin network statistics
    if (path === '/network-stats') {
      return await getBitcoinNetworkStats(env, corsHeaders);
    }

    // Historical price data
    if (path === '/historical-prices') {
      return await getBitcoinHistoricalPrices(url.searchParams, env, corsHeaders);
    }

    return Response.json({ error: 'Bitcoin endpoint not found' }, { 
      status: 404, 
      headers: corsHeaders 
    });
  } catch (error) {
    return Response.json({
      error: 'Bitcoin data fetch failed',
      message: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500, headers: corsHeaders });
  }
}

async function handleWeatherData(
  request: Request, 
  env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  const url = new URL(request.url);
  const path = url.pathname.replace('/weather', '');

  try {
    // Current weather for location
    if (path === '/current') {
      return await getCurrentWeather(url.searchParams, env, corsHeaders);
    }

    // Solar irradiance data
    if (path === '/solar-irradiance') {
      return await getSolarIrradiance(url.searchParams, env, corsHeaders);
    }

    // Wind data
    if (path === '/wind') {
      return await getWindData(url.searchParams, env, corsHeaders);
    }

    return Response.json({ error: 'Weather endpoint not found' }, { 
      status: 404, 
      headers: corsHeaders 
    });
  } catch (error) {
    return Response.json({
      error: 'Weather data fetch failed',
      message: error instanceof Error ? error.message : 'Unknown error'
    }, { status: 500, headers: corsHeaders });
  }
}

async function handleEquipmentData(
  _request: Request, 
  _env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  // TODO: Implement equipment data fetching from external sources
  return Response.json({ 
    message: 'Equipment data endpoints coming soon',
    available_sources: ['manufacturer-apis', 'manual-updates']
  }, { headers: corsHeaders });
}

async function handleCacheManagement(
  request: Request, 
  _env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  const url = new URL(request.url);
  const path = url.pathname.replace('/cache', '');

  if (path === '/status' && request.method === 'GET') {
    // TODO: Return cache statistics
    return Response.json({ 
      cache_status: 'operational',
      hit_rate: 0.85,
      entries: 0
    }, { headers: corsHeaders });
  }

  if (path === '/clear' && request.method === 'POST') {
    // TODO: Clear cache entries
    return Response.json({ 
      message: 'Cache cleared successfully' 
    }, { headers: corsHeaders });
  }

  return Response.json({ error: 'Cache endpoint not found' }, { 
    status: 404, 
    headers: corsHeaders 
  });
}

// Bitcoin data functions
async function getBitcoinPrice(_env: Env, corsHeaders: Record<string, string>): Promise<Response> {
  // TODO: Implement actual Bitcoin price fetching with caching
  const mockPrice = {
    price_usd: 45000,
    market_cap_usd: 900000000000,
    volume_24h_usd: 25000000000,
    last_updated: new Date().toISOString(),
    source: 'coingecko'
  };
  
  return Response.json(mockPrice, { headers: corsHeaders });
}

async function getBitcoinNetworkStats(_env: Env, corsHeaders: Record<string, string>): Promise<Response> {
  // TODO: Implement actual network stats fetching
  const mockStats = {
    network_hashrate_eh: 350,
    difficulty: 45000000000000,
    block_height: 800000,
    block_reward: 6.25,
    next_halving_estimate: '2024-04-20',
    last_updated: new Date().toISOString()
  };
  
  return Response.json(mockStats, { headers: corsHeaders });
}

async function getBitcoinHistoricalPrices(
  searchParams: URLSearchParams, 
  _env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  // TODO: Implement historical price fetching
  const days = searchParams.get('days') || '30';
  
  const mockData = {
    prices: [],
    days: parseInt(days),
    message: 'Historical price data coming soon'
  };
  
  return Response.json(mockData, { headers: corsHeaders });
}

// Weather data functions
async function getCurrentWeather(
  searchParams: URLSearchParams, 
  _env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  const lat = searchParams.get('lat');
  const lon = searchParams.get('lon');
  
  if (!lat || !lon) {
    return Response.json({ 
      error: 'Latitude and longitude required' 
    }, { status: 400, headers: corsHeaders });
  }
  
  // TODO: Implement actual weather data fetching
  const mockWeather = {
    temperature_c: 25,
    humidity_percent: 65,
    wind_speed_ms: 3.5,
    cloud_cover_percent: 20,
    ghi: 800, // Global Horizontal Irradiance
    location: { lat: parseFloat(lat), lon: parseFloat(lon) },
    last_updated: new Date().toISOString()
  };
  
  return Response.json(mockWeather, { headers: corsHeaders });
}

async function getSolarIrradiance(
  _searchParams: URLSearchParams, 
  _env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  // TODO: Implement solar irradiance data fetching
  return Response.json({ 
    message: 'Solar irradiance data coming soon' 
  }, { headers: corsHeaders });
}

async function getWindData(
  _searchParams: URLSearchParams, 
  _env: Env, 
  corsHeaders: Record<string, string>
): Promise<Response> {
  // TODO: Implement wind data fetching
  return Response.json({ 
    message: 'Wind data coming soon' 
  }, { headers: corsHeaders });
}

// Scheduled update functions
async function updateBitcoinPrices(_env: Env): Promise<void> {
  console.log('Updating Bitcoin prices...');
  // TODO: Implement scheduled Bitcoin price updates
}

async function updateEquipmentData(_env: Env): Promise<void> {
  console.log('Updating equipment data...');
  // TODO: Implement scheduled equipment data updates
}

async function updateWeatherData(_env: Env): Promise<void> {
  console.log('Updating weather data...');
  // TODO: Implement scheduled weather data updates
}