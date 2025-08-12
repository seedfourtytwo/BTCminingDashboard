# Worker Architecture - Solar Mining Calculator

## Overview

The Solar Mining Calculator uses a modular Cloudflare Workers architecture with clear separation of concerns. This design provides better maintainability, independent scaling, and isolated failure domains.

## Architecture Diagram

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   API Worker    │    │ Calculation     │
│   (React SPA)   │◄───┤   Port: 8787    │◄───┤ Worker          │
│   Cloudflare    │    │                 │    │ Port: 8788      │
│   Pages         │    │ • CRUD Ops      │    │                 │
└─────────────────┘    │ • Routing       │    │ • Projections   │
                       │ • Validation    │    │ • Monte Carlo   │
                       │ • Database      │    │ • Financial     │
                       └─────────────────┘    │   Analysis      │
                                 │            └─────────────────┘
                                 │                     │
                                 ▼                     │
                       ┌─────────────────┐             │
                       │   Data Worker   │◄────────────┘
                       │   Port: 8789    │
                       │                 │
                       │ • External APIs │
                       │ • Caching       │
                       │ • Rate Limiting │
                       │ • Scheduled Jobs│
                       └─────────────────┘
```

## Worker Responsibilities

### 1. API Worker (`wrangler.toml`)
**Port: 8787** | **Entry Point: `src/server/api/index.ts`**

Primary application server handling UI interactions and data management.

#### Responsibilities:
- ✅ HTTP routing and request handling
- ✅ Database CRUD operations (D1)
- ✅ Data validation and sanitization
- ✅ Service orchestration (calls to other workers)
- ✅ API versioning and documentation

#### Resources:
- **Database**: Full D1 access for all tables
- **CPU Limit**: 50ms (optimized for fast API responses)
- **Service Bindings**: Connections to Calculation and Data workers
- **Analytics**: API usage tracking

#### Example Routes:
```
GET  /api/v1/equipment              # List mining equipment
POST /api/v1/projections            # Create new projection
GET  /api/v1/projections/:id        # Get projection details
PUT  /api/v1/system-configs/:id     # Update system configuration
```

### 2. Calculation Worker (`wrangler.calculations.toml`)
**Port: 8788** | **Entry Point: `src/server/calculations/index.ts`**

Handles all computational heavy lifting and mathematical operations.

#### Responsibilities:
- 🧮 Solar energy production calculations
- 📊 Bitcoin mining profitability projections
- 🎲 Monte Carlo risk analysis simulations
- 💰 Financial metrics (NPV, IRR, payback period)
- 📉 Equipment degradation modeling
- ⚡ Power system optimization

#### Resources:
- **CPU Limit**: 30,000ms (30 seconds for complex calculations)
- **Durable Objects**: Stateful calculation engines
- **Queues**: Background processing for batch calculations
- **KV Storage**: Calculation result caching
- **Analytics**: Performance monitoring

#### Key Features:
- **Stateful Calculations**: Using Durable Objects for long-running projections
- **Queue Processing**: Batch calculations for multiple scenarios
- **Result Caching**: Aggressive caching of expensive calculations
- **Timeout Handling**: Graceful handling of long-running operations

#### Example Calculations:
```typescript
// Solar production calculation
POST /calculations/solar-production
{
  "panelSpecs": {...},
  "location": {...},
  "timeframe": "2024-2029"
}

// Monte Carlo simulation
POST /calculations/monte-carlo
{
  "scenarios": [...],
  "iterations": 10000,
  "variables": {...}
}
```

### 3. Data Worker (`wrangler.data.toml`)
**Port: 8789** | **Entry Point: `src/server/data/index.ts`**

Manages all external data sources and provides clean APIs for internal consumption.

#### Responsibilities:
- 🌐 External API integration (Bitcoin prices, weather data)
- 💾 Data caching and invalidation strategies
- 🚦 Rate limiting and API quota management
- 📅 Scheduled data updates via Cron triggers
- 🔄 Data transformation and normalization
- 📈 Data quality monitoring

#### External Data Sources:
- **Bitcoin Data**: CoinGecko API, blockchain.info
- **Weather Data**: OpenWeatherMap, NREL Solar API
- **Equipment Data**: Manufacturer APIs, manual updates
- **Market Data**: Mining pool statistics, electricity rates

#### Caching Strategy:
- **Bitcoin Prices**: 5-minute cache (high volatility)
- **Weather Data**: 1-hour cache (moderate changes)
- **Equipment Specs**: 24-hour cache (rarely changes)
- **Historical Data**: 7-day cache (archival data)

#### Scheduled Jobs:
```toml
# Every 6 hours - Bitcoin price updates
crons = ["0 */6 * * *"]

# Daily - Equipment database updates  
crons = ["0 0 * * *"]

# Weekly Monday noon - Weather data refresh
crons = ["0 12 * * 1"]
```

## Development Workflow

### Starting Development Environment
```bash
# Start all services
npm run dev

# Start individual services
npm run dev:client        # Frontend only (port 3000)
npm run dev:api           # API Worker only (port 8787)
npm run dev:calculations  # Calculation Worker only (port 8788)
npm run dev:data          # Data Worker only (port 8789)
```

### Building and Deployment
```bash
# Build all components
npm run build

# Deploy to production
npm run deploy

# Deploy to development
npm run deploy:dev

# Deploy individual workers
npm run deploy:api
npm run deploy:calculations
npm run deploy:data
```

### Monitoring and Debugging
```bash
# View logs from specific workers
npm run logs:api
npm run logs:calculations
npm run logs:data

# Monitor performance
wrangler analytics --binding ANALYTICS
```

## Inter-Worker Communication

### Service Bindings
Workers communicate using Cloudflare's Service Bindings for type-safe, low-latency communication.

```typescript
// API Worker calling Calculation Worker
const projectionResult = await env.CALCULATIONS.fetch('/calculate/projection', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify(calculationRequest)
});

// API Worker calling Data Worker  
const bitcoinPrice = await env.DATA_SERVICE.fetch('/bitcoin/current-price');
```

### Queue-Based Processing
For long-running calculations, the API Worker can queue requests:

```typescript
// Queue a calculation request
await env.CALCULATION_QUEUE.send({
  type: 'MONTE_CARLO_SIMULATION',
  projectId: 'proj_123',
  parameters: simulationParams
});
```

## Scaling Considerations

### Automatic Scaling
Each worker scales independently based on demand:
- **API Worker**: Scales with user traffic
- **Calculation Worker**: Scales with computational load
- **Data Worker**: Scales with external API demand

### Resource Optimization
- **API Worker**: Optimized for low latency (50ms CPU limit)
- **Calculation Worker**: Optimized for throughput (30s CPU limit)
- **Data Worker**: Optimized for external API efficiency (10s CPU limit)

### Cost Management
- Isolated scaling prevents one heavy operation from affecting others
- Calculation Worker only scales when needed for complex operations
- Data Worker's caching strategy minimizes external API costs

## Security Considerations

### API Keys and Secrets
```bash
# Set secrets for each worker
wrangler secret put BITCOIN_API_KEY --config wrangler.data.toml
wrangler secret put WEATHER_API_KEY --config wrangler.data.toml
wrangler secret put DATABASE_ENCRYPTION_KEY --config wrangler.toml
```

### Network Security
- Service bindings provide secure worker-to-worker communication
- External APIs only accessible from Data Worker
- Database access restricted to API Worker only

### Rate Limiting
- Per-user rate limiting in API Worker
- External API rate limiting in Data Worker
- Calculation throttling in Calculation Worker

## Monitoring and Observability

### Analytics Integration
Each worker reports to separate Analytics datasets:
- `solar_mining_api_analytics`: API usage and performance
- `solar_mining_calc_analytics`: Calculation performance
- `solar_mining_data_analytics`: External API usage

### Error Tracking
```typescript
// Structured error logging across all workers
console.error(JSON.stringify({
  worker: 'api',
  error: error.message,
  request_id: requestId,
  timestamp: new Date().toISOString()
}));
```

### Performance Monitoring
- CPU usage monitoring per worker
- Request latency tracking
- Cache hit/miss ratios
- External API response times

## Future Expansion

### Adding New Workers
To add a new worker (e.g., machine learning worker):

1. Create `wrangler.ml.toml`
2. Add service binding to API Worker
3. Update package.json scripts
4. Document responsibilities in this file

### Microservice Migration
If any worker becomes too complex, it can be split:
- Calculation Worker → Separate Solar and Bitcoin calculation workers
- Data Worker → Separate per external API workers

This modular architecture makes such migrations straightforward without affecting other components.

## Troubleshooting

### Common Issues

#### Worker Communication Failures
```bash
# Check service binding configuration
wrangler dev --config wrangler.toml --inspect

# Verify worker is running
curl http://localhost:8788/health
```

#### Database Connection Issues
```bash
# Check D1 database status
wrangler d1 info solar-mining-db-dev

# Test database connection
wrangler d1 execute solar-mining-db-dev --command "SELECT 1"
```

#### External API Failures
```bash
# Check Data Worker logs
npm run logs:data

# Test external API directly
curl "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"
```

### Performance Issues

#### High CPU Usage
- Check which worker is consuming resources
- Review calculation complexity
- Consider breaking down large operations

#### Slow Response Times
- Check cache hit rates
- Review database query performance
- Monitor external API response times

This architecture provides a solid foundation for growth while maintaining simplicity for solo development.