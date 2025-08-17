# Worker Architecture - Solar Mining Calculator

## Table of Contents
- [Overview](#overview)
- [Architecture Principles](#architecture-principles)
- [Worker Responsibilities](#worker-responsibilities)
  - [API Worker](#api-worker)
  - [Calculation Worker](#calculation-worker)
  - [Data Worker](#data-worker)
- [Communication Patterns](#communication-patterns)
- [Data Flow](#data-flow)
- [Error Handling](#error-handling)
- [Performance](#performance)
- [Security](#security)
- [Monitoring](#monitoring)
- [Deployment](#deployment)

## Overview

The Solar Mining Calculator uses a modular Cloudflare Workers architecture with clear separation of concerns. This design provides maintainability, independent scaling, and isolated failure domains.

## Architecture Diagram

**Source**: Worker configurations in project root:

**Project Structure**: See [`docs/09-PROJECT-STRUCTURE.md`](09-PROJECT-STRUCTURE.md) for detailed file organization
- [`wrangler.api.toml`](../wrangler.api.toml)
- [`wrangler.calculations.toml`](../wrangler.calculations.toml)
- [`wrangler.data.toml`](../wrangler.data.toml)

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

### 1. API Worker
**Source**: [`src/server/api/index.ts`](../src/server/api/index.ts)

Primary application server handling UI interactions and data management.

**Responsibilities**:
- HTTP routing and request handling
- Database CRUD operations (D1)
- Data validation and sanitization
- Service orchestration (calls to other workers)
- API versioning and documentation

**Resources**:
- **Database**: Full D1 access for all tables
- **CPU Limit**: 50ms (optimized for fast API responses)
- **Service Bindings**: Connections to Calculation and Data workers
- **Analytics**: API usage tracking

**Example Routes**:
```
GET  /api/v1/equipment              # List mining equipment
POST /api/v1/projections            # Create new projection
GET  /api/v1/projections/:id        # Get projection details
PUT  /api/v1/system-configs/:id     # Update system configuration
```

### 2. Calculation Worker
**Source**: [`src/server/calculations/index.ts`](../src/server/calculations/index.ts)

Handles computational operations and mathematical calculations.

**Responsibilities**:
- Solar energy production calculations
- Bitcoin mining profitability projections
- Monte Carlo risk analysis simulations
- Financial metrics (NPV, IRR, payback period)
- Equipment degradation modeling
- Power system optimization

**Resources**:
- **CPU Limit**: 30,000ms (30 seconds for complex calculations)
- **Durable Objects**: Stateful calculation engines
- **Queues**: Background processing for batch calculations
- **KV Storage**: Calculation result caching
- **Analytics**: Performance monitoring

**Key Features**:
- **Stateful Calculations**: Using Durable Objects for long-running projections
- **Queue Processing**: Batch calculations for multiple scenarios
- **Result Caching**: Aggressive caching of expensive calculations
- **Timeout Handling**: Graceful handling of long-running operations

### 3. Data Worker
**Source**: [`src/server/data/index.ts`](../src/server/data/index.ts)

Manages external data collection, caching, and scheduled operations.

**Responsibilities**:
- External API data collection (Bitcoin, weather, equipment)
- Data caching and rate limiting
- Scheduled data updates and maintenance
- Data validation and quality control
- Backup and recovery operations

**Resources**:
- **CPU Limit**: 10,000ms (10 seconds for data processing)
- **KV Storage**: External data caching
- **Queues**: Scheduled data collection jobs
- **Cron Triggers**: Automated data updates
- **Analytics**: Data collection monitoring

**Data Sources**:
- **Bitcoin Network**: Price, difficulty, hashrate data
- **Weather APIs**: Solar irradiance, temperature data
- **Equipment APIs**: Manufacturer specifications and pricing
- **Financial APIs**: Exchange rates and market data

## Communication Patterns

### Inter-Worker Communication
**Source**: Service bindings defined in worker configurations

**Request-Response Pattern**:
- API Worker → Calculation Worker: Projection requests
- API Worker → Data Worker: External data requests
- Calculation Worker → Data Worker: Historical data requests

**Event-Driven Pattern**:
- Data Worker → API Worker: Data update notifications
- Calculation Worker → API Worker: Calculation completion events

### Error Handling
- **Circuit Breaker**: Prevents cascade failures
- **Retry Logic**: Automatic retry with exponential backoff
- **Fallback Responses**: Graceful degradation when services unavailable
- **Error Propagation**: Structured error responses to clients

## Data Flow

### Request Flow
1. **Client Request**: Frontend makes API request to API Worker
2. **Request Validation**: API Worker validates and sanitizes input
3. **Service Orchestration**: API Worker calls Calculation/Data workers as needed
4. **Database Operations**: API Worker performs database operations
5. **Response Assembly**: API Worker assembles and returns response

### Data Collection Flow
1. **Scheduled Triggers**: Cron jobs trigger data collection
2. **External API Calls**: Data Worker calls external APIs
3. **Data Processing**: Raw data is processed and validated
4. **Caching**: Processed data is cached in KV storage
5. **Database Updates**: Data is stored in D1 database

### Calculation Flow
1. **Calculation Request**: API Worker sends calculation request
2. **Engine Initialization**: Calculation Worker initializes calculation engine
3. **Data Retrieval**: Calculation Worker retrieves required data
4. **Computation**: Mathematical calculations are performed
5. **Result Caching**: Results are cached for future use
6. **Response**: Results are returned to API Worker

## Error Handling

### Error Categories
- **Validation Errors**: Invalid input data or parameters
- **External API Errors**: Failures in external service calls
- **Calculation Errors**: Mathematical computation failures
- **Database Errors**: Data storage and retrieval failures
- **Timeout Errors**: Long-running operation failures

### Error Response Format
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid equipment specification",
    "details": {
      "field": "hashrate",
      "value": "invalid",
      "expected": "number"
    },
    "timestamp": "2025-08-17T10:30:00Z",
    "request_id": "req_123456"
  }
}
```

### Error Recovery Strategies
- **Automatic Retries**: Retry failed operations with backoff
- **Fallback Data**: Use cached data when external APIs fail
- **Graceful Degradation**: Return partial results when possible
- **Error Logging**: Error tracking and monitoring

## Performance

### Optimization Strategies
- **Caching**: Aggressive caching of expensive operations
- **Parallel Processing**: Concurrent execution of independent operations
- **Lazy Loading**: Load data only when needed
- **Connection Pooling**: Efficient database connection management

### Performance Targets
- **API Response Time**: <500ms for standard operations
- **Calculation Time**: <30 seconds for complex projections
- **Data Collection**: <10 seconds for external API calls
- **Database Operations**: <100ms for CRUD operations

### Monitoring Metrics
- **Response Times**: API and calculation response times
- **Error Rates**: Error frequency and types
- **Resource Usage**: CPU, memory, and storage utilization
- **Throughput**: Requests per second and concurrent users

## Security

### Authentication and Authorization
- **API Keys**: Secure API key management
- **Rate Limiting**: Request rate limiting per user
- **Input Validation**: Input sanitization
- **CORS Configuration**: Proper cross-origin resource sharing

### Data Protection
- **Encryption**: Data encryption in transit and at rest
- **Access Control**: Role-based access to sensitive data
- **Audit Logging**: Audit trail of operations
- **Data Minimization**: Collect only necessary data

### External API Security
- **API Key Rotation**: Regular rotation of external API keys
- **Request Signing**: Cryptographic signing of external requests
- **Error Handling**: Secure error handling without information leakage
- **Rate Limiting**: Respect external API rate limits

## Monitoring

### Health Checks
- **Worker Health**: Regular health check endpoints
- **Database Connectivity**: Database connection monitoring
- **External API Status**: External service availability monitoring
- **Performance Metrics**: Real-time performance monitoring

### Logging
- **Structured Logging**: JSON-formatted log entries
- **Log Levels**: Appropriate log levels for different types of events
- **Log Aggregation**: Centralized log collection and analysis
- **Log Retention**: Configurable log retention policies

### Alerting
- **Error Alerts**: Immediate alerts for critical errors
- **Performance Alerts**: Alerts for performance degradation
- **Availability Alerts**: Alerts for service unavailability
- **Capacity Alerts**: Alerts for resource capacity issues

## Deployment

### Environment Strategy
- **Development**: Local development environment
- **Staging**: Pre-production testing environment
- **Production**: Live production environment

### Deployment Process
1. **Code Review**: Pull request review and approval
2. **Automated Testing**: Unit and integration tests
3. **Staging Deployment**: Deploy to staging environment
4. **Testing**: Testing in staging
5. **Production Deployment**: Deploy to production environment
6. **Monitoring**: Post-deployment monitoring and validation

### Rollback Strategy
- **Automatic Rollback**: Automatic rollback on critical failures
- **Manual Rollback**: Manual rollback for non-critical issues
- **Database Migrations**: Safe database migration rollback
- **Configuration Management**: Version-controlled configuration management

---

**Document Status**: Current Plan v1.0  
**Last Updated**: 2025-08-17  
**Next Review**: After Phase 1 implementation