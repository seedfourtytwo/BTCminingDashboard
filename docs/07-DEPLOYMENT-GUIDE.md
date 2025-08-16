# Deployment Guide - Solar Bitcoin Mining Calculator

## Overview

This guide covers the deployment of the Solar Bitcoin Mining Calculator on Cloudflare Workers. The application uses a serverless architecture with separate workers for API, calculations, and data management.

## Architecture Overview

```
Deployment Architecture:
┌─────────────────────────────────────────────────────────┐
│                    Cloudflare Workers                   │
├─────────────────────────────────────────────────────────┤
│  API Worker (wrangler.api.toml)                        │
│  ├── REST API endpoints                                 │
│  ├── Request routing                                    │
│  └── Response formatting                                │
├─────────────────────────────────────────────────────────┤
│  Calculations Worker (wrangler.calculations.toml)      │
│  ├── Solar generation calculations                     │
│  ├── Mining performance modeling                       │
│  └── Financial analysis                                │
├─────────────────────────────────────────────────────────┤
│  Data Worker (wrangler.data.toml)                      │
│  ├── Equipment database                                │
│  ├── User configurations                               │
│  └── Caching layer                                     │
└─────────────────────────────────────────────────────────┘
```

## Prerequisites

### Required Tools
- **Node.js**: Version 18+ (LTS recommended)
- **npm**: Package manager
- **Wrangler CLI**: Cloudflare Workers deployment tool
- **Git**: Version control

### Required Accounts
- **Cloudflare Account**: For Workers and D1 database
- **GitHub Account**: For source code repository (optional)

## Initial Setup

### 1. Install Dependencies

```bash
# Install Node.js dependencies
npm install

# Install Wrangler CLI globally
npm install -g wrangler

# Install development dependencies
npm install --save-dev @cloudflare/workers-types
```

### 2. Cloudflare Account Setup

```bash
# Login to Cloudflare
wrangler login

# Verify account access
wrangler whoami
```

### 3. Environment Configuration

Create environment files for each worker:

```bash
# API Worker environment
cp .env.example .env.api

# Calculations Worker environment  
cp .env.example .env.calculations

# Data Worker environment
cp .env.example .env.data
```

### 4. Database Setup

```bash
# Create D1 database
wrangler d1 create solar-mining-calculator

# Apply migrations
wrangler d1 execute solar-mining-calculator --file=src/server/shared/database/migrations/0001_initial_schema.sql

# Seed initial data
wrangler d1 execute solar-mining-calculator --file=src/server/shared/database/migrations/seed.sql
```

## Worker Configuration

### 1. API Worker Configuration

**File**: `wrangler.api.toml`

```toml
name = "solar-mining-calculator-api"
main = "src/server/api/index.ts"
compatibility_date = "2024-01-15"

[env.production]
name = "solar-mining-calculator-api"
route = "api.solar-mining-calculator.com/*"

[env.staging]
name = "solar-mining-calculator-api-staging"
route = "staging-api.solar-mining-calculator.com/*"

[[env.production.d1_databases]]
binding = "DB"
database_name = "solar-mining-calculator"
database_id = "your-production-db-id"

[[env.staging.d1_databases]]
binding = "DB"
database_name = "solar-mining-calculator-staging"
database_id = "your-staging-db-id"

[env.production.vars]
ENVIRONMENT = "production"
API_VERSION = "v1"

[env.staging.vars]
ENVIRONMENT = "staging"
API_VERSION = "v1"

[env.production.r2_buckets]
binding = "ASSETS"
bucket_name = "solar-mining-calculator-assets"

[env.staging.r2_buckets]
binding = "ASSETS"
bucket_name = "solar-mining-calculator-assets-staging"
```

### 2. Calculations Worker Configuration

**File**: `wrangler.calculations.toml`

```toml
name = "solar-mining-calculator-calculations"
main = "src/server/calculations/index.ts"
compatibility_date = "2024-01-15"

[env.production]
name = "solar-mining-calculator-calculations"
route = "calculations.solar-mining-calculator.com/*"

[env.staging]
name = "solar-mining-calculator-calculations-staging"
route = "staging-calculations.solar-mining-calculator.com/*"

[[env.production.d1_databases]]
binding = "DB"
database_name = "solar-mining-calculator"
database_id = "your-production-db-id"

[[env.staging.d1_databases]]
binding = "DB"
database_name = "solar-mining-calculator-staging"
database_id = "your-staging-db-id"

[env.production.vars]
ENVIRONMENT = "production"
CALCULATION_TIMEOUT = "30000"

[env.staging.vars]
ENVIRONMENT = "staging"
CALCULATION_TIMEOUT = "30000"
```

### 3. Data Worker Configuration

**File**: `wrangler.data.toml`

```toml
name = "solar-mining-calculator-data"
main = "src/server/data/index.ts"
compatibility_date = "2024-01-15"

[env.production]
name = "solar-mining-calculator-data"
route = "data.solar-mining-calculator.com/*"

[env.staging]
name = "solar-mining-calculator-data-staging"
route = "staging-data.solar-mining-calculator.com/*"

[[env.production.d1_databases]]
binding = "DB"
database_name = "solar-mining-calculator"
database_id = "your-production-db-id"

[[env.staging.d1_databases]]
binding = "DB"
database_name = "solar-mining-calculator-staging"
database_id = "your-staging-db-id"

[env.production.vars]
ENVIRONMENT = "production"
CACHE_TTL = "3600"

[env.staging.vars]
ENVIRONMENT = "staging"
CACHE_TTL = "1800"
```

## Deployment Process

### 1. Development Deployment

```bash
# Deploy to development environment
wrangler deploy --config wrangler.api.toml --env development
wrangler deploy --config wrangler.calculations.toml --env development
wrangler deploy --config wrangler.data.toml --env development
```

### 2. Staging Deployment

```bash
# Deploy to staging environment
wrangler deploy --config wrangler.api.toml --env staging
wrangler deploy --config wrangler.calculations.toml --env staging
wrangler deploy --config wrangler.data.toml --env staging
```

### 3. Production Deployment

```bash
# Deploy to production environment
wrangler deploy --config wrangler.api.toml --env production
wrangler deploy --config wrangler.calculations.toml --env production
wrangler deploy --config wrangler.data.toml --env production
```

### 4. Frontend Deployment

```bash
# Build the frontend
npm run build

# Deploy to Cloudflare Pages
wrangler pages deploy dist --project-name solar-mining-calculator-frontend
```

## Environment Variables

### Required Environment Variables

```bash
# Database Configuration
DATABASE_URL="your-d1-database-url"

# API Configuration
API_SECRET="your-api-secret-key"
CORS_ORIGIN="https://solar-mining-calculator.com"

# External API Keys
BITCOIN_API_KEY="your-bitcoin-api-key"
SOLAR_API_KEY="your-solar-resource-api-key"

# Monitoring
LOG_LEVEL="info"
ENVIRONMENT="production"
```

### Optional Environment Variables

```bash
# Rate Limiting
RATE_LIMIT_REQUESTS=100
RATE_LIMIT_WINDOW=60000

# Caching
CACHE_TTL=3600
CACHE_MAX_SIZE=1000

# Performance
CALCULATION_TIMEOUT=30000
MAX_CONCURRENT_CALCULATIONS=10
```

## Database Management

### 1. Migration Management

```bash
# Create new migration
wrangler d1 migrations create solar-mining-calculator add_new_table

# Apply migrations to development
wrangler d1 migrations apply solar-mining-calculator --local

# Apply migrations to production
wrangler d1 migrations apply solar-mining-calculator
```

### 2. Database Backup

```bash
# Export database
wrangler d1 export solar-mining-calculator --output=backup.sql

# Import database
wrangler d1 execute solar-mining-calculator --file=backup.sql
```

### 3. Database Monitoring

```bash
# View database usage
wrangler d1 info solar-mining-calculator

# Execute queries
wrangler d1 execute solar-mining-calculator --command="SELECT COUNT(*) FROM equipment"
```

## Monitoring and Logging

### 1. Cloudflare Analytics

```bash
# View worker analytics
wrangler tail solar-mining-calculator-api

# Monitor specific worker
wrangler tail solar-mining-calculator-calculations
```

### 2. Error Monitoring

```javascript
// Basic error logging in workers
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request).catch(err => {
    console.error('Worker error:', err);
    return new Response('Internal Server Error', { status: 500 });
  }));
});
```

### 3. Performance Monitoring

```javascript
// Performance tracking
const startTime = Date.now();
// ... worker logic ...
const duration = Date.now() - startTime;
console.log(`Request processed in ${duration}ms`);
```

## Security Configuration

### 1. CORS Configuration

```javascript
// CORS headers for API worker
const corsHeaders = {
  'Access-Control-Allow-Origin': env.CORS_ORIGIN,
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  'Access-Control-Max-Age': '86400',
};
```

### 2. Rate Limiting

```javascript
// Basic rate limiting implementation
const rateLimit = {
  requests: 100,
  window: 60000, // 1 minute
  store: new Map(),
};
```

### 3. Input Validation

```javascript
// Request validation
function validateRequest(request) {
  const contentType = request.headers.get('content-type');
  if (!contentType || !contentType.includes('application/json')) {
    throw new Error('Invalid content type');
  }
  // Additional validation logic
}
```

## Troubleshooting

### Common Issues

#### 1. Worker Deployment Failures

```bash
# Check worker status
wrangler whoami

# Verify configuration
wrangler deploy --dry-run

# Check logs
wrangler tail worker-name
```

#### 2. Database Connection Issues

```bash
# Test database connection
wrangler d1 execute database-name --command="SELECT 1"

# Check database permissions
wrangler d1 info database-name
```

#### 3. Environment Variable Issues

```bash
# List environment variables
wrangler secret list

# Set new secret
wrangler secret put SECRET_NAME
```

### Debug Commands

```bash
# Local development
wrangler dev --local

# Remote development
wrangler dev

# Test specific worker
wrangler dev --config wrangler.api.toml
```

## Performance Optimization

### 1. Worker Optimization

```javascript
// Use WebAssembly for calculations
import { calculateSolarGeneration } from './calculations.wasm';

// Implement caching
const cache = new Map();
const CACHE_TTL = 3600000; // 1 hour
```

### 2. Database Optimization

```sql
-- Add indexes for common queries
CREATE INDEX idx_equipment_manufacturer ON equipment(manufacturer);
CREATE INDEX idx_configurations_user ON system_configurations(user_id);
CREATE INDEX idx_projections_config ON projections(system_config_id);
```

### 3. Caching Strategy

```javascript
// Implement multi-level caching
const cacheStrategy = {
  memory: new Map(), // In-memory cache
  kv: env.CACHE_KV,  // Cloudflare KV
  ttl: 3600,         // 1 hour
};
```

## Backup and Recovery

### 1. Automated Backups

```bash
#!/bin/bash
# backup.sh
DATE=$(date +%Y%m%d_%H%M%S)
wrangler d1 export solar-mining-calculator --output=backup_$DATE.sql
aws s3 cp backup_$DATE.sql s3://backup-bucket/
```

### 2. Disaster Recovery

```bash
# Restore from backup
wrangler d1 execute solar-mining-calculator --file=backup_20241219_143022.sql

# Verify restoration
wrangler d1 execute solar-mining-calculator --command="SELECT COUNT(*) FROM equipment"
```

---

## Future Implementation

### Advanced Deployment Features (Planned for Later Phases)

#### Advanced Monitoring
- Real-time performance dashboards
- Advanced error tracking and alerting
- Custom metrics and KPIs
- Automated health checks

#### Advanced Security
- API key management system
- Advanced rate limiting strategies
- DDoS protection
- Security audit tools

#### Advanced Scaling
- Auto-scaling based on demand
- Load balancing across regions
- Advanced caching strategies
- Database sharding

#### Advanced CI/CD
- Automated testing pipelines
- Blue-green deployments
- Canary releases
- Rollback automation

#### Advanced Data Management
- Data archival strategies
- Advanced backup solutions
- Data migration tools
- Multi-region data replication

---

**Document Status**: Current Plan v1.0  
**Last Updated**: 2024-12-19  
**Next Review**: After Phase 1 implementation