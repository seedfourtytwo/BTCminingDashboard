# API Specification - Solar Bitcoin Mining Calculator

## API Overview

The Solar Bitcoin Mining Calculator provides a comprehensive REST API built on Cloudflare Workers for managing equipment, configurations, scenarios, and projections. The API follows RESTful principles and returns JSON responses.

## Base Configuration

```
Base URL: https://solar-mining-calculator.your-worker.workers.dev
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
  "pagination": { ... }, // Only for paginated responses
  "meta": {
    "timestamp": "2024-08-11T10:30:00Z",
    "version": "1.0",
    "request_id": "req_123456789"
  }
}
```

### Error Response
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid equipment configuration",
    "details": {
      "field": "power_consumption_w",
      "reason": "Value must be greater than 0"
    }
  },
  "meta": {
    "timestamp": "2024-08-11T10:30:00Z",
    "version": "1.0",
    "request_id": "req_123456789"
  }
}
```

## API Endpoints

### 1. EQUIPMENT MANAGEMENT

#### 1.1 Power Source Types

**GET /api/v1/power-source-types**
Get all available power source types

```http
GET /api/v1/power-source-types
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "type_name": "solar_panel",
      "category": "renewable",
      "description": "Photovoltaic solar panels",
      "spec_schema": {
        "required": ["rated_power_w", "efficiency_percent"],
        "optional": ["degradation_rate_annual", "warranty_years"],
        "units": {
          "rated_power_w": "watts",
          "efficiency_percent": "%"
        }
      }
    }
  ]
}
```

**POST /api/v1/power-source-types**
Create a new power source type (admin only)

```http
POST /api/v1/power-source-types
Content-Type: application/json

{
  "type_name": "micro_hydro",
  "category": "renewable",
  "description": "Small-scale hydroelectric generators",
  "spec_schema": {
    "required": ["rated_power_w", "flow_rate_lps", "head_height_m"],
    "optional": ["efficiency_percent", "minimum_flow"],
    "units": {
      "rated_power_w": "watts",
      "flow_rate_lps": "liters/second",
      "head_height_m": "meters"
    }
  }
}
```

#### 1.2 Power Source Models

**GET /api/v1/power-sources**
Get all power source models with filtering

```http
GET /api/v1/power-sources?type=solar_panel&manufacturer=Canadian Solar&limit=20&offset=0
```

**Query Parameters:**
- `type`: Filter by power source type
- `manufacturer`: Filter by manufacturer
- `min_power`: Minimum power rating
- `max_power`: Maximum power rating
- `limit`: Number of results per page (default: 50)
- `offset`: Pagination offset (default: 0)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 15,
      "type_id": 1,
      "type_name": "solar_panel",
      "manufacturer": "Canadian Solar",
      "model_name": "CS3W-400MS",
      "specifications": {
        "rated_power_w": 400,
        "efficiency_percent": 20.5,
        "temperature_coefficient": -0.35,
        "degradation_rate_annual": 0.5,
        "technology": "Monocrystalline"
      },
      "cost_per_unit": 250.00,
      "availability": "In Stock",
      "warranty_years": 25,
      "expected_lifespan_years": 30,
      "dimensions": {
        "length_mm": 2000,
        "width_mm": 1000,
        "height_mm": 40
      },
      "weight_kg": 22.5
    }
  ],
  "pagination": {
    "total": 156,
    "limit": 20,
    "offset": 0,
    "has_more": true
  }
}
```

**POST /api/v1/power-sources**
Add a new power source model

```http
POST /api/v1/power-sources
Content-Type: application/json

{
  "type_id": 1,
  "manufacturer": "Tesla",
  "model_name": "Solar Roof Tile V3",
  "specifications": {
    "rated_power_w": 71.67,
    "efficiency_percent": 20.0,
    "temperature_coefficient": -0.32,
    "degradation_rate_annual": 0.25,
    "technology": "Monocrystalline"
  },
  "cost_per_unit": 15.00,
  "availability": "Backorder",
  "warranty_years": 25,
  "expected_lifespan_years": 30,
  "dimensions": {
    "length_mm": 1877,
    "width_mm": 356,
    "height_mm": 11
  },
  "weight_kg": 13.0
}
```

#### 1.3 Miner Models

**GET /api/v1/miners**
Get all miner models with filtering and sorting

```http
GET /api/v1/miners?manufacturer=Bitmain&min_efficiency=25&max_efficiency=35&sort=efficiency_j_th&order=asc
```

**Query Parameters:**
- `manufacturer`: Filter by manufacturer
- `generation`: Filter by chip generation (7nm, 5nm, etc.)
- `min_hashrate`: Minimum hashrate in TH/s
- `max_hashrate`: Maximum hashrate in TH/s
- `min_efficiency`: Minimum efficiency in J/TH
- `max_efficiency`: Maximum efficiency in J/TH
- `sort`: Sort field (hashrate_th, efficiency_j_th, current_price_usd)
- `order`: Sort order (asc, desc)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 8,
      "manufacturer": "Bitmain",
      "model_name": "Antminer S19 Pro",
      "generation": "7nm",
      "release_date": "2021-03-15",
      "hashrate_th": 110.0,
      "power_consumption_w": 3250,
      "efficiency_j_th": 29.5,
      "hashrate_degradation_annual": 0.05,
      "efficiency_degradation_annual": 0.03,
      "failure_rate_annual": 0.10,
      "performance_curve": {
        "months": [0, 12, 24, 36, 48],
        "hashrate_retention": [1.00, 0.95, 0.90, 0.85, 0.80]
      },
      "current_price_usd": 3500.00,
      "warranty_months": 36,
      "expected_lifespan_years": 5,
      "operating_temp_min": 5,
      "operating_temp_max": 40,
      "dimensions_l_mm": 400,
      "dimensions_w_mm": 195,
      "dimensions_h_mm": 290,
      "weight_kg": 13.2,
      "noise_level_db": 75
    }
  ]
}
```

**POST /api/v1/miners**
Add a new miner model

```http
POST /api/v1/miners
Content-Type: application/json

{
  "manufacturer": "Canaan",
  "model_name": "AvalonMiner 1246",
  "generation": "7nm",
  "release_date": "2021-09-01",
  "hashrate_th": 90.0,
  "power_consumption_w": 3420,
  "efficiency_j_th": 38.0,
  "hashrate_degradation_annual": 0.06,
  "efficiency_degradation_annual": 0.04,
  "failure_rate_annual": 0.12,
  "current_price_usd": 2800.00,
  "warranty_months": 24,
  "expected_lifespan_years": 4,
  "operating_temp_min": 0,
  "operating_temp_max": 40
}
```

#### 1.4 Storage Models

**GET /api/v1/storage**
Get battery and storage system models

```http
GET /api/v1/storage?technology=LiFePO4&min_capacity=10&max_capacity=100
```

**POST /api/v1/storage**
Add a new storage model

```http
POST /api/v1/storage
Content-Type: application/json

{
  "manufacturer": "Tesla",
  "model_name": "Powerwall 2",
  "technology": "Li-ion",
  "capacity_kwh": 13.5,
  "usable_capacity_kwh": 13.5,
  "max_charge_rate_kw": 5.0,
  "max_discharge_rate_kw": 5.0,
  "round_trip_efficiency": 0.90,
  "cycle_life": 6000,
  "cost_per_kwh": 500.00,
  "warranty_years": 10
}
```

### 2. LOCATION MANAGEMENT

**GET /api/v1/locations**
Get available locations

```http
GET /api/v1/locations?country=US&state=CA
```

**POST /api/v1/locations**
Add a new location

```http
POST /api/v1/locations
Content-Type: application/json

{
  "name": "Phoenix, AZ",
  "latitude": 33.4484,
  "longitude": -112.0740,
  "elevation": 331,
  "timezone": "America/Phoenix",
  "magnetic_declination": 9.5
}
```

### 3. SYSTEM CONFIGURATION

**GET /api/v1/configs**
Get user system configurations

```http
GET /api/v1/configs?user_id=user123
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 5,
      "config_name": "My Solar Mining Rig v2",
      "description": "50kW solar array with 10 Antminer S19 Pro units",
      "location_id": 12,
      "location_name": "Phoenix, AZ",
      "power_sources": [
        {
          "type": "solar_panel",
          "model_id": 15,
          "model_name": "Canadian Solar CS3W-400MS",
          "quantity": 125,
          "config": {
            "tilt_angle": 30,
            "azimuth": 180,
            "row_spacing": 3.0
          }
        }
      ],
      "miners": [
        {
          "model_id": 8,
          "model_name": "Antminer S19 Pro",
          "quantity": 10,
          "config": {
            "power_limit_w": 3000,
            "target_temperature": 60
          }
        }
      ],
      "electricity_rates": {
        "grid_rate_kwh": 0.12,
        "net_metering_rate": 0.08
      },
      "created_at": "2024-08-11T10:30:00Z",
      "updated_at": "2024-08-11T15:45:00Z"
    }
  ]
}
```

**POST /api/v1/configs**
Create a new system configuration

```http
POST /api/v1/configs
Content-Type: application/json

{
  "config_name": "Hybrid Solar+Wind Setup",
  "description": "Combined solar and wind power mining operation",
  "location_id": 12,
  "power_sources": [
    {
      "type": "solar_panel",
      "model_id": 15,
      "quantity": 100,
      "config": {
        "tilt_angle": 25,
        "azimuth": 185
      }
    },
    {
      "type": "wind_turbine",
      "model_id": 3,
      "quantity": 3,
      "config": {
        "hub_height": 30
      }
    }
  ],
  "storage_systems": [
    {
      "model_id": 2,
      "quantity": 8,
      "config": {
        "series_parallel": "2s4p"
      }
    }
  ],
  "miners": [
    {
      "model_id": 8,
      "quantity": 15,
      "config": {
        "power_limit_w": 3100
      }
    }
  ],
  "electricity_rates": {
    "grid_rate_kwh": 0.14,
    "net_metering_rate": 0.09,
    "demand_charge_kw": 18.0
  }
}
```

**PUT /api/v1/configs/{id}**
Update an existing configuration

**DELETE /api/v1/configs/{id}**
Delete a configuration

### 4. SCENARIO MANAGEMENT

**GET /api/v1/scenarios**
Get projection scenarios

```http
GET /api/v1/scenarios?config_id=5
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 15,
      "scenario_name": "Conservative 5-Year Projection",
      "description": "Conservative Bitcoin price growth with realistic degradation",
      "system_config_id": 5,
      "btc_price_model": {
        "type": "exponential",
        "parameters": {
          "start_price": 45000,
          "annual_growth": 0.08,
          "volatility": 0.60
        }
      },
      "difficulty_model": {
        "type": "exponential",
        "parameters": {
          "annual_growth": 0.15,
          "adjustment_variance": 0.05
        }
      },
      "projection_start_date": "2024-08-11",
      "projection_end_date": "2029-08-11",
      "calculation_frequency": "monthly",
      "simulation_runs": 1000,
      "created_at": "2024-08-11T10:30:00Z"
    }
  ]
}
```

**POST /api/v1/scenarios**
Create a new projection scenario

```http
POST /api/v1/scenarios
Content-Type: application/json

{
  "scenario_name": "Optimistic Bull Market",
  "description": "High Bitcoin price growth scenario",
  "system_config_id": 5,
  "btc_price_model": {
    "type": "stochastic",
    "parameters": {
      "start_price": 45000,
      "drift_annual": 0.25,
      "volatility_annual": 0.80,
      "halving_impact": 1.8
    }
  },
  "difficulty_model": {
    "type": "exponential_with_variance",
    "parameters": {
      "base_annual_growth": 0.22,
      "adjustment_variance": 0.08
    }
  },
  "projection_start_date": "2024-08-11",
  "projection_end_date": "2027-08-11",
  "calculation_frequency": "weekly",
  "simulation_runs": 5000
}
```

### 5. PROJECTION CALCULATIONS

**POST /api/v1/projections/calculate**
Calculate projections for a scenario

```http
POST /api/v1/projections/calculate
Content-Type: application/json

{
  "scenario_id": 15,
  "force_recalculate": false,
  "include_monte_carlo": true,
  "detail_level": "daily"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "scenario_id": 15,
    "calculation_status": "completed",
    "calculation_time_ms": 2450,
    "results_summary": {
      "total_projection_days": 1826,
      "monte_carlo_runs": 1000,
      "total_btc_mined": 45.67,
      "total_revenue_usd": 2847500,
      "total_costs_usd": 425600,
      "net_profit_usd": 2421900,
      "roi_percent": 348.2,
      "payback_period_months": 18.5
    },
    "confidence_intervals": {
      "net_profit_usd": {
        "p5": 1856000,
        "p25": 2125000,
        "p50": 2421900,
        "p75": 2784000,
        "p95": 3542000
      }
    }
  }
}
```

**GET /api/v1/projections/{scenario_id}/results**
Get calculated projection results

```http
GET /api/v1/projections/15/results?start_date=2024-08-11&end_date=2024-12-11&granularity=weekly
```

**Query Parameters:**
- `start_date`: Filter results from this date
- `end_date`: Filter results to this date
- `granularity`: daily, weekly, monthly, yearly
- `simulation_run`: Specific Monte Carlo run (0 for deterministic)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "projection_date": "2024-08-11",
      "simulation_run": 0,
      "total_generation_kwh": 145.5,
      "solar_generation_kwh": 125.0,
      "wind_generation_kwh": 20.5,
      "mining_consumption_kwh": 780.0,
      "grid_import_kwh": 634.5,
      "total_hashrate_th": 1100.0,
      "effective_hashrate_th": 1100.0,
      "btc_mined": 0.0125,
      "btc_price_usd": 45250.0,
      "mining_revenue_usd": 565.625,
      "electricity_cost_usd": 76.14,
      "net_profit_usd": 489.485,
      "cumulative_profit_usd": 489.485,
      "solar_capacity_factor": 0.25,
      "system_efficiency": 0.875
    }
  ],
  "meta": {
    "total_records": 1826,
    "granularity": "daily",
    "scenario_name": "Conservative 5-Year Projection"
  }
}
```

### 6. MARKET DATA

**GET /api/v1/market/bitcoin**
Get current Bitcoin network data

```http
GET /api/v1/market/bitcoin
```

**Response:**
```json
{
  "success": true,
  "data": {
    "current_price_usd": 45250.50,
    "price_change_24h": 2.15,
    "difficulty": 90666502495565,
    "network_hashrate": 650.5,
    "blocks_until_halving": 144000,
    "estimated_halving_date": "2028-04-15",
    "avg_block_time": 605,
    "avg_transaction_fee": 0.0025,
    "last_updated": "2024-08-11T15:30:00Z"
  }
}
```

**GET /api/v1/market/bitcoin/history**
Get historical Bitcoin data

```http
GET /api/v1/market/bitcoin/history?start_date=2024-01-01&end_date=2024-08-11&metrics=price,difficulty
```

### 7. ENVIRONMENTAL DATA

**GET /api/v1/environmental/{location_id}**
Get current environmental conditions

```http
GET /api/v1/environmental/12
```

**Response:**
```json
{
  "success": true,
  "data": {
    "location_id": 12,
    "location_name": "Phoenix, AZ",
    "current_conditions": {
      "ghi_current": 0.75,
      "temperature": 28.5,
      "wind_speed": 3.2,
      "cloud_cover": 15,
      "humidity": 42
    },
    "today_forecast": {
      "ghi_daily_estimated": 7.2,
      "temperature_max": 35,
      "wind_speed_avg": 4.1
    },
    "last_updated": "2024-08-11T15:30:00Z"
  }
}
```

**GET /api/v1/environmental/{location_id}/history**
Get historical environmental data

```http
GET /api/v1/environmental/12/history?start_date=2024-01-01&end_date=2024-08-11
```

## Error Codes

### Standard HTTP Status Codes
- `200 OK`: Successful request
- `201 Created`: Resource created successfully
- `400 Bad Request`: Invalid request data
- `404 Not Found`: Resource not found
- `422 Unprocessable Entity`: Validation errors
- `429 Too Many Requests`: Rate limit exceeded
- `500 Internal Server Error`: Server error

### Application Error Codes
- `VALIDATION_ERROR`: Input validation failed
- `EQUIPMENT_NOT_FOUND`: Specified equipment model not found
- `CONFIG_INVALID`: System configuration is invalid
- `CALCULATION_ERROR`: Projection calculation failed
- `DATA_UNAVAILABLE`: Required external data not available
- `SCENARIO_LIMIT_EXCEEDED`: Too many scenarios for user
- `PROJECTION_IN_PROGRESS`: Calculation already in progress

## Rate Limiting

API requests are rate-limited to prevent abuse:

- **Standard endpoints**: 100 requests per minute
- **Calculation endpoints**: 10 requests per minute  
- **Data ingestion**: 1000 requests per hour

Rate limit headers are included in responses:
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1628700000
```

## Webhook Support

The API supports webhooks for real-time notifications:

### Available Events
- `projection.completed`: Projection calculation finished
- `market.significant_change`: Major Bitcoin price/difficulty change
- `equipment.degradation_alert`: Equipment performance below threshold

### Webhook Configuration
```http
POST /api/v1/webhooks
Content-Type: application/json

{
  "url": "https://your-app.com/webhooks/mining-calculator",
  "events": ["projection.completed", "market.significant_change"],
  "secret": "your-webhook-secret"
}
```

---

**Document Status**: Draft v1.0  
**Last Updated**: 2024-08-11  
**Next Review**: After calculation engine documentation