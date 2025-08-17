# API Specification - Solar Bitcoin Mining Calculator

## Table of Contents
- [API Overview](#api-overview)
- [Base Configuration](#base-configuration)
- [Response Format](#response-format)
- [Core API Endpoints](#core-api-endpoints)
  - [Equipment Management](#1-equipment-management)
  - [Location Management](#2-location-management)
  - [System Configuration](#3-system-configuration)
  - [Projection Calculations](#4-projection-calculations)
  - [Bitcoin Data](#5-bitcoin-data)
  - [Environmental Data](#6-environmental-data)
- [Error Codes](#error-codes)
- [Rate Limiting](#rate-limiting)
- [Future Implementation](#future-implementation)

## API Overview

The Solar Bitcoin Mining Calculator provides a REST API built on Cloudflare Workers for managing equipment, configurations, and basic projections. The API follows RESTful principles and returns JSON responses.

> **Note**: Equipment database updates (miner prices, solar panel specs, etc.) are handled via manual user-triggered API calls rather than automated cron jobs to stay within Cloudflare's 5 cron trigger limit. Users can update equipment data on-demand through the UI.
>
> **Cron Trigger Strategy**: 
> - **Staging**: No cron triggers (for development/testing)
> - **Production**: 2 cron triggers (Bitcoin updates every 6h, Weather updates weekly)
> - **Future**: Manual update buttons for on-demand data refresh (Bitcoin, Weather, Equipment)

## Base Configuration

```
Base URL: https://solar-mining-api.christopher-k.workers.dev
API Version: v1
Content-Type: application/json
```

## Response Format

All API responses follow a consistent format:

### Success Response
```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "timestamp": "2025-08-17T10:30:00Z",
    "version": "1.0"
  }
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid equipment configuration"
  },
  "meta": {
    "timestamp": "2025-08-17T10:30:00Z",
    "version": "1.0"
  }
}
```

**Note**: Full response schemas are defined in the API implementation files.

## Core API Endpoints

### 1. EQUIPMENT MANAGEMENT

#### 1.1 Get Mining Equipment
**GET /api/v1/equipment/miners**

Get all available mining equipment with basic filtering.

```http
GET /api/v1/equipment/miners?manufacturer=Bitmain&limit=20
```

**Query Parameters:**
- `manufacturer`: Filter by manufacturer (optional)
- `limit`: Number of results (default: 50, max: 100)
- `offset`: Pagination offset (default: 0)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "manufacturer": "Bitmain",
      "model_name": "Antminer S19 Pro",
      "hashrate_th": 110.0,
      "power_consumption_w": 3250,
      "efficiency_j_th": 29.5,
      "current_price_usd": 3500.00,
      "expected_lifespan_years": 5
    }
  ],
  "meta": {
    "total": 25,
    "limit": 20,
    "offset": 0
  }
}
```

#### 1.2 Get Solar Panels
**GET /api/v1/equipment/solar-panels**

Get all available solar panel models.

```http
GET /api/v1/equipment/solar-panels?manufacturer=Canadian Solar
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "manufacturer": "Canadian Solar",
      "model_name": "CS3W-400MS",
      "rated_power_w": 400,
      "efficiency_percent": 20.5,
      "cost_per_watt": 0.45,
      "expected_lifespan_years": 25
    }
  ]
}
```

#### 1.3 Get Storage Systems
**GET /api/v1/equipment/storage**

Get all available battery storage systems.

```http
GET /api/v1/equipment/storage?technology=LiFePO4
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "manufacturer": "Tesla",
      "model_name": "Powerwall 2",
      "technology": "Li-ion",
      "capacity_kwh": 13.5,
      "cost_per_kwh": 500.00
    }
  ]
}
```

### 2. LOCATION MANAGEMENT

#### 2.1 Get Locations
**GET /api/v1/locations**

Get available geographic locations for solar calculations.

```http
GET /api/v1/locations?country=US
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Phoenix, AZ",
      "latitude": 33.4484,
      "longitude": -112.0740,
      "elevation": 331,
      "timezone": "America/Phoenix"
    }
  ]
}
```

#### 2.2 Add Location
**POST /api/v1/locations**

Add a new location for solar calculations.

```http
POST /api/v1/locations
Content-Type: application/json

{
  "name": "Austin, TX",
  "latitude": 30.2672,
  "longitude": -97.7431,
  "elevation": 149,
  "timezone": "America/Chicago"
}
```

### 3. SYSTEM CONFIGURATION

#### 3.1 Get System Configurations
**GET /api/v1/system-configs**

Get user system configurations.

```http
GET /api/v1/system-configs
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "config_name": "My Solar Mining Setup",
      "description": "50kW solar array with 10 Antminer S19 Pro units",
      "location_id": 1,
      "solar_panels": [
        {
          "model_id": 1,
          "quantity": 125,
          "tilt_angle": 30,
          "azimuth": 180
        }
      ],
      "miners": [
        {
          "model_id": 1,
          "quantity": 10,
          "power_limit_w": 3000
        }
      ],
      "electricity_rate_usd_kwh": 0.12,
      "created_at": "2025-08-17T10:30:00Z"
    }
  ]
}
```

#### 3.2 Create System Configuration
**POST /api/v1/system-configs**

Create a new system configuration.

```http
POST /api/v1/system-configs
Content-Type: application/json

{
  "config_name": "New Mining Setup",
  "description": "Solar-powered Bitcoin mining operation",
  "location_id": 1,
  "solar_panels": [
    {
      "model_id": 1,
      "quantity": 100,
      "tilt_angle": 25,
      "azimuth": 180
    }
  ],
  "miners": [
    {
      "model_id": 1,
      "quantity": 8,
      "power_limit_w": 3000
    }
  ],
  "electricity_rate_usd_kwh": 0.14
}
```

### 4. PROJECTION CALCULATIONS

#### 4.1 Calculate Projection
**POST /api/v1/projections/calculate**

Calculate a basic projection for a system configuration.

```http
POST /api/v1/projections/calculate
Content-Type: application/json

{
  "system_config_id": 1,
  "projection_years": 5,
  "calculation_frequency": "monthly"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "system_config_id": 1,
    "projection_years": 5,
    "total_investment_usd": 85000,
    "total_revenue_usd": 2847500,
    "total_costs_usd": 425600,
    "net_profit_usd": 2421900,
    "roi_percent": 348.2,
    "payback_period_months": 18.5,
    "monthly_results": [
      {
        "month": "2025-09",
        "solar_generation_kwh": 3750,
        "mining_consumption_kwh": 23400,
        "btc_mined": 0.375,
        "revenue_usd": 16968.75,
        "costs_usd": 2808,
        "profit_usd": 14160.75
      }
    ]
  }
}
```

#### 4.2 Get Projection Results
**GET /api/v1/projections/{id}**

Get calculated projection results.

```http
GET /api/v1/projections/123
```

### 5. BITCOIN DATA

#### 5.1 Get Current Bitcoin Data
**GET /api/v1/bitcoin/current**

Get current Bitcoin network and price data.

```http
GET /api/v1/bitcoin/current
```

**Response:**
```json
{
  "success": true,
  "data": {
    "current_price_usd": 45250.50,
    "difficulty": 90666502495565,
    "network_hashrate": 650.5,
    "blocks_until_halving": 144000,
    "last_updated": "2024-08-11T15:30:00Z"
  }
}
```

#### 5.2 Get Bitcoin Price History
**GET /api/v1/bitcoin/history**

Get historical Bitcoin price data.

```http
GET /api/v1/bitcoin/history?start_date=2025-01-01&end_date=2025-08-17
```

### 6. ENVIRONMENTAL DATA

#### 6.1 Get Environmental Data
**GET /api/v1/environmental/{location_id}**

Get environmental data for a specific location.

```http
GET /api/v1/environmental/1
```

**Response:**
```json
{
  "success": true,
  "data": {
    "location_id": 1,
    "location_name": "Phoenix, AZ",
    "current_conditions": {
      "ghi_current": 0.75,
      "temperature": 28.5,
      "humidity": 42
    },
    "today_forecast": {
      "ghi_daily_estimated": 7.2,
      "temperature_max": 35
    },
    "last_updated": "2025-08-17T15:30:00Z"
  }
}
```

## Error Codes

### Standard HTTP Status Codes
- `200 OK`: Successful request
- `201 Created`: Resource created successfully
- `400 Bad Request`: Invalid request data
- `404 Not Found`: Resource not found
- `422 Unprocessable Entity`: Validation errors
- `500 Internal Server Error`: Server error

### Application Error Codes
- `VALIDATION_ERROR`: Input validation failed
- `EQUIPMENT_NOT_FOUND`: Specified equipment model not found
- `CONFIG_INVALID`: System configuration is invalid
- `CALCULATION_ERROR`: Projection calculation failed
- `DATA_UNAVAILABLE`: Required external data not available

## Rate Limiting

API requests are rate-limited to prevent abuse:

- **Standard endpoints**: 100 requests per minute
- **Calculation endpoints**: 10 requests per minute

Rate limit headers are included in responses:
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1628700000
```

---

## Future Implementation

### Advanced Features (Planned for Later Phases)

#### Advanced Equipment Management
- Equipment comparison tools
- Advanced filtering and search
- Equipment performance tracking
- Manufacturer API integration

#### Enhanced Projections
- Monte Carlo simulations
- Sensitivity analysis
- Multiple scenario comparison
- Real-time updates

#### Advanced Data Features
- Webhook support for real-time notifications
- Advanced caching strategies
- Data export capabilities
- Historical data analysis

#### User Management
- User authentication and authorization
- User-specific configurations
- Configuration sharing
- Community features

---

**Document Status**: Current Plan v1.0  
**Last Updated**: 2025-08-17  
**Next Review**: After Phase 1 implementation