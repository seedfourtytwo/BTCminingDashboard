# Database Migration Guide

## Overview

The database schema has been split into 5 logical migrations for better deployment safety and maintainability.

## Migration Files

### 0001_core_foundation.sql (238 lines)
**Purpose**: Core foundation tables and user management
**Dependencies**: None
**Tables**:
- `users` - User accounts and authentication
- `locations` - Geographic locations for solar calculations
- `miner_models` - ASIC miner specifications
- `solar_panel_models` - Solar panel specifications
- `storage_models` - Battery storage specifications
- `inverter_models` - Solar inverter specifications

**Features**:
- User management system (multi-user ready)
- Equipment inventory tables with user fields
- Core performance indexes
- User data isolation indexes

### 0002_system_configuration.sql (147 lines)
**Purpose**: System configurations and JSON validation
**Dependencies**: 0001_core_foundation.sql
**Tables**:
- `system_configs` - User system configurations

**Features**:
- JSON-based equipment configuration
- JSON validation constraints
- Helper functions for capacity calculations
- System configuration indexes

### 0003_external_data.sql (271 lines)
**Purpose**: External data integration and API management
**Dependencies**: 0001_core_foundation.sql
**Tables**:
- `bitcoin_network_data` - Bitcoin network statistics
- `bitcoin_price_data` - Bitcoin price data
- `monthly_solar_data` - Monthly solar resource data
- `daily_forecast_data` - Daily weather forecasts
- `hourly_forecast_data` - Hourly weather forecasts
- `api_data_sources` - API source tracking
- `api_errors` - API error logging

**Features**:
- External API data tables
- API management and monitoring
- Data freshness tracking
- Comprehensive data validation constraints
- Performance indexes for all data types

### 0004_projections_scenarios.sql (191 lines)
**Purpose**: Projection scenarios and results
**Dependencies**: 0001_core_foundation.sql, 0002_system_configuration.sql
**Tables**:
- `projection_scenarios` - Custom scenario parameters
- `projection_results` - Calculated projection results

**Features**:
- Scenario-based "what-if" analysis
- JSON parameter overrides
- Comprehensive financial metrics
- Business analysis fields
- Projection performance indexes

### 0005_historical_data.sql (35 lines)
**Purpose**: Historical data tracking
**Dependencies**: 0001_core_foundation.sql
**Tables**:
- `miner_price_history` - Equipment value tracking

**Features**:
- Historical price tracking
- Depreciation monitoring
- Market demand analysis

### 0006_error_handling.sql (75 lines)
**Purpose**: Application error logging and debugging
**Dependencies**: 0001_core_foundation.sql
**Tables**:
- `application_errors` - Error logging and monitoring

**Features**:
- Comprehensive error tracking
- Error categorization and severity levels
- Context and stack trace logging
- Automatic cleanup function
- Performance indexes for error querying

## Deployment Strategy

### Development Environment
- Run migrations in order: 0001 → 0002 → 0003 → 0004 → 0005 → 0006
- Each migration is self-contained and can be tested independently
- Rollback is easier with smaller migrations

### Production Deployment
1. **Test each migration individually** in staging
2. **Deploy in sequence** to ensure dependencies are met
3. **Monitor each migration** for any issues
4. **Rollback plan** - each migration can be rolled back independently

### Migration Benefits

**Safety**:
- Smaller migrations reduce timeout risk
- Easier to identify which migration failed
- Safer rollback process

**Maintainability**:
- Logical separation of concerns
- Easier to understand and modify
- Better team collaboration

**Testing**:
- Can test each migration independently
- Easier to debug issues
- Better development workflow

## Migration Dependencies

```
0001_core_foundation.sql
├── 0002_system_configuration.sql
├── 0003_external_data.sql
├── 0004_projections_scenarios.sql
├── 0005_historical_data.sql
└── 0006_error_handling.sql
```

## Rollback Strategy

If a migration fails:
1. **Identify the failing migration**
2. **Rollback the specific migration** (if possible)
3. **Fix the issue** in the migration file
4. **Redeploy** the fixed migration

## Legacy Migration

The original `0001_consolidated_schema.sql` (903 lines) is kept for reference but should not be used for new deployments.

## Next Steps

1. **Test migrations** in development environment
2. **Update deployment scripts** to use new migration structure
3. **Document any application changes** needed for the new structure
4. **Plan production deployment** with the new migrations
