# Deployment Guide - Solar Bitcoin Mining Calculator

## Overview

This guide covers the complete deployment process for the Solar Bitcoin Mining Calculator, from local development setup to production deployment on Cloudflare's edge infrastructure.

## Prerequisites

### Required Software
```bash
# Node.js (v18 or later)
node --version  # Should be v18.0.0+
npm --version   # Should be 9.0.0+

# Git
git --version

# Cloudflare CLI (Wrangler)
npm install -g wrangler
wrangler --version
```

### Required Accounts
1. **Cloudflare Account** (Free tier sufficient for development)
2. **API Access Accounts**:
   - OpenWeatherMap (for weather data)
   - CoinGecko (for Bitcoin price data)
   - Optional: Custom Bitcoin node access

## Local Development Setup

### 1. Repository Setup

```bash
# Clone the repository
git clone https://github.com/your-username/solar-mining-calculator.git
cd solar-mining-calculator

# Install dependencies
npm install

# Install frontend dependencies
cd src/frontend
npm install
cd ../..
```

### 2. Environment Configuration

Create development environment file:
```bash
# Copy example environment file
cp .env.example .env.local

# Edit with your API keys
nano .env.local
```

Required environment variables:
```env
# API Keys
OPENWEATHER_API_KEY=your_openweather_api_key_here
COINGECKO_API_KEY=your_coingecko_api_key_here
BLOCKCHAIN_INFO_API_KEY=optional_blockchain_info_key

# Database
DATABASE_URL=local_d1_database_path

# Application Settings
ENVIRONMENT=development
LOG_LEVEL=debug
RATE_LIMIT_ENABLED=false

# API Configuration
API_RATE_LIMIT=1000
API_TIMEOUT_MS=5000

# External Service URLs
BITCOIN_NODE_URL=https://bitcoin-node.example.com:8332
NREL_API_URL=https://developer.nrel.gov/api
```

### 3. Database Setup

#### Initialize local D1 database:
```bash
# Create local D1 database for development
wrangler d1 create solar-mining-db-dev

# Update wrangler.toml with the database ID
# Copy the database_id from the output above
```

#### Run database migrations:
```bash
# Create the database schema
wrangler d1 execute solar-mining-db-dev --local --file=src/database/schema.sql

# Seed with initial data
npm run db:seed
```

#### Verify database setup:
```bash
# Connect to local database
wrangler d1 execute solar-mining-db-dev --local --command="SELECT * FROM locations LIMIT 5;"
```

### 4. Local Development Server

#### Start the backend worker:
```bash
# Start Cloudflare Workers development server
npm run dev

# The API will be available at http://localhost:8787
```

#### Start the frontend development server:
```bash
# In a new terminal window
npm run frontend:dev

# The frontend will be available at http://localhost:5173
```

#### Verify the setup:
```bash
# Test API health endpoint
curl http://localhost:8787/api/health

# Expected response:
# {"success": true, "status": "healthy", "version": "1.0.0"}
```

## Production Deployment

### 1. Cloudflare Account Setup

#### Create Cloudflare account and get API token:
```bash
# Login to Cloudflare
wrangler login

# Verify authentication
wrangler whoami
```

#### Create production database:
```bash
# Create production D1 database
wrangler d1 create solar-mining-db-prod

# Note the database ID for production configuration
```

### 2. Production Environment Configuration

#### Update wrangler.toml for production:
```toml
name = "solar-mining-calculator"
main = "src/workers/index.ts"
compatibility_date = "2024-10-01"
compatibility_flags = ["nodejs_compat"]

[env.production]
name = "solar-mining-calculator-prod"

[[d1_databases]]
binding = "DB"
database_name = "solar-mining-db-prod"
database_id = "your-production-database-id-here"
migrations_dir = "src/database/migrations"

[vars]
ENVIRONMENT = "production"
LOG_LEVEL = "info"
RATE_LIMIT_ENABLED = "true"
```

#### Set production secrets:
```bash
# Set API keys as secrets (encrypted)
wrangler secret put OPENWEATHER_API_KEY --env production
wrangler secret put COINGECKO_API_KEY --env production
wrangler secret put JWT_SECRET --env production
wrangler secret put API_KEY_SALT --env production

# Set optional secrets
wrangler secret put BITCOIN_NODE_URL --env production
wrangler secret put BLOCKCHAIN_INFO_API_KEY --env production
```

### 3. Database Migration to Production

#### Run production migrations:
```bash
# Apply database schema to production
wrangler d1 execute solar-mining-db-prod --env production --file=src/database/schema.sql

# Seed production database with initial data
wrangler d1 execute solar-mining-db-prod --env production --file=src/database/seed-data/initial-data.sql
```

#### Verify production database:
```bash
# Test database connection
wrangler d1 execute solar-mining-db-prod --env production --command="SELECT COUNT(*) as equipment_count FROM miner_models;"
```

### 4. Deploy Backend (Cloudflare Workers)

#### Build and deploy:
```bash
# Type check the project
npm run type-check

# Deploy to production
wrangler deploy --env production

# Verify deployment
curl https://solar-mining-calculator-prod.your-subdomain.workers.dev/api/health
```

#### Set up cron triggers:
```bash
# Cron triggers are automatically deployed with the worker
# Verify they're active in Cloudflare dashboard > Workers > Triggers

# Test cron endpoints manually
curl https://solar-mining-calculator-prod.your-subdomain.workers.dev/cron/bitcoin-data
```

### 5. Deploy Frontend (Cloudflare Pages)

#### Build frontend:
```bash
cd src/frontend

# Install production dependencies
npm ci --only=production

# Build for production
npm run build

# Verify build output
ls -la dist/
```

#### Deploy to Cloudflare Pages:
```bash
# Initialize Pages project
wrangler pages project create solar-mining-calculator-frontend

# Deploy frontend
wrangler pages deploy dist --project-name solar-mining-calculator-frontend

# Set environment variables for frontend
wrangler pages secret put VITE_API_BASE_URL --project-name solar-mining-calculator-frontend
# Value: https://solar-mining-calculator-prod.your-subdomain.workers.dev
```

#### Configure custom domain (optional):
```bash
# Add custom domain in Cloudflare dashboard
# DNS settings will be provided after domain verification
```

## Configuration Management

### 1. Environment Variables

#### Development vs Production:
```javascript
// Environment-specific configurations
const config = {
  development: {
    logLevel: 'debug',
    rateLimitEnabled: false,
    apiTimeout: 30000,
    cacheTimeout: 300000, // 5 minutes
  },
  production: {
    logLevel: 'info',
    rateLimitEnabled: true,
    apiTimeout: 10000,
    cacheTimeout: 3600000, // 1 hour
  }
};
```

### 2. Database Configuration

#### Connection settings:
```typescript
// Database configuration based on environment
export const dbConfig = {
  development: {
    maxConnections: 5,
    queryTimeout: 30000,
    retryAttempts: 3,
  },
  production: {
    maxConnections: 25,
    queryTimeout: 10000,
    retryAttempts: 5,
  }
};
```

### 3. External API Configuration

#### Rate limiting and failover:
```typescript
export const apiConfig = {
  bitcoin: {
    primary: 'https://api.blockchain.info',
    fallback: 'https://blockstream.info/api',
    rateLimit: 100, // requests per minute
    timeout: 5000,
  },
  weather: {
    primary: 'https://api.openweathermap.org/data/2.5',
    rateLimit: 1000, // requests per day (free tier)
    timeout: 3000,
  },
  price: {
    primary: 'https://api.coingecko.com/api/v3',
    fallback: 'https://api.coinmarketcap.com/v1',
    rateLimit: 50, // requests per minute (free tier)
    timeout: 3000,
  }
};
```

## Monitoring and Observability

### 1. Application Monitoring

#### Cloudflare Analytics:
```typescript
// Custom analytics events
export const trackEvent = (eventName: string, data: any) => {
  if (typeof navigator !== 'undefined' && 'sendBeacon' in navigator) {
    navigator.sendBeacon('/api/analytics', JSON.stringify({
      event: eventName,
      data,
      timestamp: Date.now(),
      userAgent: navigator.userAgent
    }));
  }
};

// Key events to track
trackEvent('scenario_calculated', { scenarioId, calculationTime });
trackEvent('equipment_selected', { equipmentType, modelId });
trackEvent('projection_exported', { format, timeRange });
```

#### Performance Monitoring:
```typescript
// Worker performance metrics
export const performanceMetrics = {
  async measureExecutionTime<T>(
    operation: string,
    fn: () => Promise<T>
  ): Promise<T> {
    const start = Date.now();
    try {
      const result = await fn();
      const duration = Date.now() - start;
      
      // Log to Cloudflare Analytics
      console.log(`${operation} completed in ${duration}ms`);
      
      return result;
    } catch (error) {
      const duration = Date.now() - start;
      console.error(`${operation} failed after ${duration}ms:`, error);
      throw error;
    }
  }
};
```

### 2. Error Tracking

#### Error reporting:
```typescript
export class ErrorReporter {
  static report(error: Error, context: any = {}) {
    const errorData = {
      message: error.message,
      stack: error.stack,
      context,
      timestamp: new Date().toISOString(),
      environment: ENV.ENVIRONMENT
    };
    
    // Log to console (captured by Cloudflare)
    console.error('Application Error:', errorData);
    
    // Send to external error tracking service if configured
    if (ENV.SENTRY_DSN) {
      // Sentry integration code
    }
  }
}
```

### 3. Health Checks

#### API health endpoint:
```typescript
export const healthCheck = async (request: Request): Promise<Response> => {
  const checks = {
    database: await checkDatabaseHealth(),
    externalAPIs: await checkExternalAPIHealth(),
    calculations: await checkCalculationEngineHealth()
  };
  
  const allHealthy = Object.values(checks).every(check => check.healthy);
  
  return new Response(JSON.stringify({
    status: allHealthy ? 'healthy' : 'unhealthy',
    timestamp: new Date().toISOString(),
    checks
  }), {
    status: allHealthy ? 200 : 503,
    headers: { 'Content-Type': 'application/json' }
  });
};
```

## Security Configuration

### 1. API Security

#### Rate limiting:
```typescript
export class RateLimiter {
  private static limits = new Map<string, { count: number; resetTime: number }>();
  
  static async checkRateLimit(
    identifier: string,
    maxRequests: number = 100,
    windowMinutes: number = 1
  ): Promise<boolean> {
    const now = Date.now();
    const windowMs = windowMinutes * 60 * 1000;
    const key = `${identifier}:${Math.floor(now / windowMs)}`;
    
    const current = this.limits.get(key) || { count: 0, resetTime: now + windowMs };
    
    if (current.count >= maxRequests) {
      return false; // Rate limit exceeded
    }
    
    current.count++;
    this.limits.set(key, current);
    
    return true;
  }
}
```

#### Input validation:
```typescript
import { z } from 'zod';

export const requestSchemas = {
  createScenario: z.object({
    scenario_name: z.string().min(1).max(100),
    system_config_id: z.number().int().positive(),
    btc_price_model: z.object({
      type: z.enum(['exponential', 'stochastic', 'conservative']),
      parameters: z.record(z.number())
    }),
    projection_start_date: z.string().date(),
    projection_end_date: z.string().date()
  })
};

export const validateRequest = (schema: z.ZodSchema, data: any) => {
  const result = schema.safeParse(data);
  if (!result.success) {
    throw new ValidationError(result.error.issues);
  }
  return result.data;
};
```

### 2. Data Protection

#### Sensitive data handling:
```typescript
export class DataProtection {
  // Hash API keys for storage
  static hashAPIKey(key: string): string {
    const encoder = new TextEncoder();
    const data = encoder.encode(key + ENV.API_KEY_SALT);
    return crypto.subtle.digest('SHA-256', data).then(
      buffer => Array.from(new Uint8Array(buffer))
        .map(b => b.toString(16).padStart(2, '0'))
        .join('')
    );
  }
  
  // Encrypt sensitive configuration data
  static async encryptConfig(config: any): Promise<string> {
    const key = await crypto.subtle.importKey(
      'raw',
      new TextEncoder().encode(ENV.JWT_SECRET),
      { name: 'AES-GCM' },
      false,
      ['encrypt']
    );
    
    const iv = crypto.getRandomValues(new Uint8Array(12));
    const encrypted = await crypto.subtle.encrypt(
      { name: 'AES-GCM', iv },
      key,
      new TextEncoder().encode(JSON.stringify(config))
    );
    
    return btoa(String.fromCharCode(...new Uint8Array(encrypted)));
  }
}
```

## Backup and Recovery

### 1. Database Backup

#### Automated backup script:
```bash
#!/bin/bash
# backup-database.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backup_${DATE}.sql"

echo "Creating database backup: ${BACKUP_FILE}"

# Export database schema and data
wrangler d1 export solar-mining-db-prod --output ${BACKUP_FILE}

# Upload to cloud storage (optional)
# aws s3 cp ${BACKUP_FILE} s3://your-backup-bucket/database-backups/

echo "Backup completed: ${BACKUP_FILE}"
```

#### Schedule automated backups:
```bash
# Add to crontab for daily backups at 2 AM
# crontab -e
0 2 * * * /path/to/backup-database.sh >> /var/log/backup.log 2>&1
```

### 2. Configuration Backup

#### Export configuration:
```typescript
export const exportConfiguration = async () => {
  const config = {
    equipment_models: await DB.prepare('SELECT * FROM miner_models').all(),
    power_sources: await DB.prepare('SELECT * FROM power_source_models').all(),
    storage_models: await DB.prepare('SELECT * FROM storage_models').all(),
    locations: await DB.prepare('SELECT * FROM locations').all()
  };
  
  return JSON.stringify(config, null, 2);
};
```

## Troubleshooting

### 1. Common Issues

#### Database Connection Issues:
```bash
# Check database status
wrangler d1 info solar-mining-db-prod

# Test database connectivity
wrangler d1 execute solar-mining-db-prod --command="SELECT 1 as test;"

# Reset database if corrupted
wrangler d1 execute solar-mining-db-prod --file=src/database/schema.sql
```

#### API Rate Limiting:
```typescript
// Check rate limit status
const checkRateLimits = async () => {
  const apis = ['bitcoin', 'weather', 'price'];
  
  for (const api of apis) {
    const response = await fetch(`/api/status/${api}`);
    const status = await response.json();
    console.log(`${api} API:`, status);
  }
};
```

#### Worker Deployment Issues:
```bash
# Check worker status
wrangler status

# View worker logs
wrangler tail

# Force redeploy
wrangler deploy --force
```

### 2. Performance Optimization

#### Optimize calculation performance:
```typescript
// Use Worker KV for caching expensive calculations
export const cacheCalculation = async (
  key: string,
  calculation: () => Promise<any>,
  ttlSeconds: number = 3600
) => {
  // Check cache first
  const cached = await KV.get(key);
  if (cached) {
    return JSON.parse(cached);
  }
  
  // Perform calculation
  const result = await calculation();
  
  // Cache result
  await KV.put(key, JSON.stringify(result), { expirationTtl: ttlSeconds });
  
  return result;
};
```

#### Database query optimization:
```sql
-- Add indexes for common queries
CREATE INDEX idx_projection_results_scenario_date 
ON projection_results(scenario_id, projection_date);

CREATE INDEX idx_equipment_performance_config_date 
ON equipment_performance_history(config_id, recorded_date);

-- Use EXPLAIN QUERY PLAN to analyze slow queries
EXPLAIN QUERY PLAN SELECT * FROM projection_results 
WHERE scenario_id = ? AND projection_date >= ?;
```

## Maintenance Tasks

### 1. Regular Maintenance

#### Weekly tasks:
```bash
# Update equipment prices from manufacturers
npm run update-equipment-prices

# Clean up old projection results (>1 year)
npm run cleanup-old-projections

# Update Bitcoin network statistics
npm run update-network-stats
```

#### Monthly tasks:
```bash
# Update solar irradiance historical data
npm run update-solar-data

# Review and update equipment specifications
npm run review-equipment-specs

# Generate usage analytics report
npm run generate-analytics-report
```

### 2. Version Updates

#### Update dependencies:
```bash
# Check for outdated packages
npm outdated

# Update packages (test thoroughly)
npm update

# Update Wrangler CLI
npm install -g wrangler@latest
```

#### Deploy updates:
```bash
# Test in development first
npm run dev
npm run test

# Deploy to staging
wrangler deploy --env staging

# Deploy to production after verification
wrangler deploy --env production
```

---

**Document Status**: Draft v1.0  
**Last Updated**: 2024-08-11  
**Next Review**: After CLAUDE.md completion