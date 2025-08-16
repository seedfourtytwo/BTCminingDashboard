# Database Schema - Solar Bitcoin Mining Calculator (Final)

## Schema Overview

The database is organized into six logical migrations, each serving a specific purpose in the solar mining calculation system:

1. **Core Foundation**: User management and equipment specifications
2. **System Configuration**: User-defined system setups with JSON flexibility
3. **External Data**: Bitcoin and environmental data with API management
4. **Projections & Scenarios**: Scenario-based analysis and results
5. **Historical Data**: Equipment value tracking over time
6. **Error Handling**: Application error logging and debugging

## Migration Structure

```
MIGRATION 0001: Core Foundation
├── users (user management)
├── locations (geographic data)
├── miner_models (ASIC specifications)
├── solar_panel_models (solar panel specs)
├── storage_models (battery storage specs)
└── inverter_models (inverter specifications)

MIGRATION 0002: System Configuration
├── system_configs (user system setups)
├── JSON validation constraints
└── Helper functions (capacity calculations)

MIGRATION 0003: External Data
├── bitcoin_network_data (network statistics)
├── bitcoin_price_data (price information)
├── monthly_solar_data (NREL API data)
├── daily_forecast_data (weather forecasts)
├── hourly_forecast_data (detailed forecasts)
├── api_data_sources (API management)
├── api_errors (API error tracking)
└── Data validation constraints

MIGRATION 0004: Projections & Scenarios
├── projection_scenarios (what-if parameters)
├── projection_results (calculated outcomes)
└── Business analysis fields

MIGRATION 0005: Historical Data
└── miner_price_history (equipment value tracking)

MIGRATION 0006: Error Handling
├── application_errors (error logging)
└── Error cleanup functions
```

## Key Features

- **Multi-User Ready**: User management system with data isolation
- **Battery-Free Mining Support**: Grid-free, solar-only mining scenarios
- **JSON-Based Flexibility**: Equipment configurations and scenario parameters
- **Comprehensive Error Handling**: Application error logging and debugging
- **API Data Management**: External data source tracking and monitoring
- **Business Analysis**: ROI, payback, NPV, IRR, break-even analysis
- **Equipment Value Tracking**: Depreciation models and resale value estimation
- **Data Validation**: Comprehensive CHECK constraints and JSON validation
- **Performance Optimization**: Extensive indexing for all query patterns
- **Scenario-Based Projections**: Flexible "what-if" analysis with customizable parameters

## Detailed Table Specifications

### MIGRATION 0001: Core Foundation

#### users
**Purpose**: User accounts for data isolation (multi-user ready)

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    is_active BOOLEAN DEFAULT true,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### locations
**Purpose**: Geographic locations for solar resource calculations

```sql
CREATE TABLE locations (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    name VARCHAR(100) NOT NULL,
    latitude REAL NOT NULL,
    longitude REAL NOT NULL,
    elevation REAL NOT NULL,
    timezone VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id)
);
```

#### miner_models
**Purpose**: Essential Bitcoin ASIC miner specifications

```sql
CREATE TABLE miner_models (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    manufacturer VARCHAR(50) NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    
    -- Core Performance Specifications
    hashrate_th REAL NOT NULL,
    power_consumption_w INTEGER NOT NULL,
    efficiency_j_th REAL NOT NULL,
    
    -- Performance Degradation Model
    hashrate_degradation_annual REAL DEFAULT 0.05,
    efficiency_degradation_annual REAL DEFAULT 0.03,
    failure_rate_annual REAL DEFAULT 0.10,
    
    -- Environmental Operating Limits
    operating_temp_min INTEGER,
    operating_temp_max INTEGER,
    humidity_max INTEGER,
    
    -- Economic Data
    current_price_usd REAL,
    expected_lifespan_years REAL,
    
    -- Power Requirements
    voltage_v INTEGER,
    power_connection_type VARCHAR(20),
    
    -- User-Friendly Fields
    user_nickname VARCHAR(100),
    purchase_date DATE,
    purchase_price_usd REAL,
    warranty_expiry DATE,
    notes TEXT,
    
    -- Price Depreciation Fields
    estimated_resale_value_usd REAL,
    depreciation_rate_annual REAL DEFAULT 0.25,
    market_demand_factor REAL DEFAULT 1.0,
    technology_obsolescence_factor REAL DEFAULT 1.0,
    last_price_update_date DATE,
    manual_price_override BOOLEAN DEFAULT false,
    manual_current_price_usd REAL,
    manual_price_notes TEXT,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id)
);
```

#### solar_panel_models
**Purpose**: Essential solar panel specifications

```sql
CREATE TABLE solar_panel_models (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    manufacturer VARCHAR(50) NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    
    -- Core Performance Specifications
    rated_power_w INTEGER NOT NULL,
    efficiency_percent REAL NOT NULL,
    temperature_coefficient REAL NOT NULL,
    
    -- Degradation Model
    degradation_rate_annual REAL DEFAULT 0.5,
    
    -- Economic Data
    cost_per_watt REAL,
    expected_lifespan_years REAL,
    
    -- User-Friendly Fields
    user_nickname VARCHAR(100),
    purchase_date DATE,
    purchase_price_usd REAL,
    installation_date DATE,
    warranty_expiry DATE,
    notes TEXT,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id)
);
```

#### storage_models
**Purpose**: Essential battery storage specifications

```sql
CREATE TABLE storage_models (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    manufacturer VARCHAR(50) NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    technology VARCHAR(20) NOT NULL,
    
    -- Capacity & Performance
    capacity_kwh REAL NOT NULL,
    usable_capacity_kwh REAL NOT NULL,
    max_charge_rate_kw REAL NOT NULL,
    max_discharge_rate_kw REAL NOT NULL,
    round_trip_efficiency REAL NOT NULL,
    
    -- Degradation Model
    cycle_life INTEGER NOT NULL,
    calendar_degradation_annual REAL DEFAULT 0.02,
    
    -- Economic Data
    cost_per_kwh REAL,
    
    -- User-Friendly Fields
    user_nickname VARCHAR(100),
    purchase_date DATE,
    purchase_price_usd REAL,
    installation_date DATE,
    warranty_expiry DATE,
    notes TEXT,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id)
);
```

#### inverter_models
**Purpose**: Inverter specifications for solar system

```sql
CREATE TABLE inverter_models (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    manufacturer VARCHAR(50) NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    
    -- Core Specifications
    rated_power_w INTEGER NOT NULL,
    efficiency_percent REAL NOT NULL,
    input_voltage_range VARCHAR(50) NOT NULL,
    output_voltage_v INTEGER NOT NULL,
    mppt_trackers INTEGER NOT NULL,
    
    -- Performance Characteristics
    max_input_current_a REAL,
    max_output_current_a REAL,
    power_factor REAL DEFAULT 0.99,
    
    -- Environmental Specifications
    operating_temp_min INTEGER,
    operating_temp_max INTEGER,
    humidity_max INTEGER,
    
    -- Economic Data
    cost_usd REAL,
    expected_lifespan_years REAL DEFAULT 15,
    
    -- User-Friendly Fields
    user_nickname VARCHAR(100),
    purchase_date DATE,
    purchase_price_usd REAL,
    installation_date DATE,
    warranty_expiry DATE,
    notes TEXT,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id)
);
```

### MIGRATION 0002: System Configuration

#### system_configs
**Purpose**: User-defined mining system configurations

```sql
CREATE TABLE system_configs (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    config_name VARCHAR(100) NOT NULL,
    description TEXT,
    location_id INTEGER NOT NULL,
    
    -- Power Generation Configuration
    solar_panels JSON NOT NULL,
    storage_systems JSON,
    
    -- Mining Equipment Configuration
    miners JSON NOT NULL,
    
    -- Economic Parameters
    electricity_rate_usd_kwh REAL NOT NULL,
    net_metering_rate_usd_kwh REAL,
    
    -- Battery-Free Mining Support
    grid_connection_type VARCHAR(20) DEFAULT 'none',
    mining_mode VARCHAR(20) DEFAULT 'solar_only',
    max_grid_power_kw REAL DEFAULT 0,
    mining_schedule JSON,
    auto_calculate_hours BOOLEAN DEFAULT true,
    manual_mining_hours_per_day REAL DEFAULT 0,
    
    -- Inverter Configuration
    inverter_id INTEGER,
    inverter_quantity INTEGER DEFAULT 1,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(location_id) REFERENCES locations(id),
    FOREIGN KEY(inverter_id) REFERENCES inverter_models(id)
);
```

**JSON Schema Examples**:

**solar_panels**:
```json
[
  {
    "model_id": 15,
    "quantity": 50,
    "tilt_angle": 30,
    "azimuth": 180
  }
]
```

**miners**:
```json
[
  {
    "model_id": 8,
    "quantity": 10,
    "power_limit_w": 3000
  }
]
```

**storage_systems**:
```json
[
  {
    "model_id": 3,
    "quantity": 2
  }
]
```

#### Helper Functions
```sql
-- Get total solar capacity for a system
CREATE FUNCTION get_system_solar_capacity_w(system_id INTEGER) RETURNS REAL;

-- Get total hashrate for a system
CREATE FUNCTION get_system_total_hashrate_th(system_id INTEGER) RETURNS REAL;

-- Get total mining power consumption
CREATE FUNCTION get_system_mining_power_w(system_id INTEGER) RETURNS REAL;
```

### MIGRATION 0003: External Data

#### bitcoin_network_data
**Purpose**: Current Bitcoin network statistics

```sql
CREATE TABLE bitcoin_network_data (
    id INTEGER PRIMARY KEY,
    recorded_date DATE NOT NULL,
    difficulty BIGINT NOT NULL,
    network_hashrate REAL NOT NULL,
    block_reward REAL NOT NULL,
    avg_block_time REAL NOT NULL,
    avg_transaction_fee REAL NOT NULL,
    data_source VARCHAR(50) NOT NULL,
    
    -- Enhanced Network Data
    avg_transaction_fee_sat_vb REAL,
    mempool_size_mb REAL,
    blocks_until_halving INTEGER,
    next_difficulty_estimate BIGINT,
    hashprice_usd_per_th REAL,
    revenue_per_th_usd REAL,
    profit_per_th_usd REAL,
    
    data_freshness_minutes INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### bitcoin_price_data
**Purpose**: Current Bitcoin price data

```sql
CREATE TABLE bitcoin_price_data (
    id INTEGER PRIMARY KEY,
    recorded_date DATE NOT NULL,
    price_usd REAL NOT NULL,
    volume_24h REAL,
    data_source VARCHAR(50) NOT NULL,
    
    -- Enhanced Price Data
    market_cap_usd REAL,
    volume_24h_usd REAL,
    price_change_24h_percent REAL,
    volatility_30d REAL,
    price_change_7d_percent REAL,
    price_change_30d_percent REAL,
    
    data_freshness_minutes INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### monthly_solar_data
**Purpose**: Monthly solar resource data from NREL API

```sql
CREATE TABLE monthly_solar_data (
    id INTEGER PRIMARY KEY,
    location_id INTEGER NOT NULL,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    
    -- Monthly averages from NREL API
    ghi_monthly_avg REAL,
    dni_monthly_avg REAL,
    sun_hours_monthly_avg REAL,
    temperature_monthly_avg REAL,
    
    -- Enhanced environmental data
    temperature_min_monthly_avg REAL,
    temperature_max_monthly_avg REAL,
    humidity_monthly_avg REAL,
    atmospheric_pressure_monthly_avg REAL,
    
    -- Derived seasonal classification
    season VARCHAR(10),
    
    data_source VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(location_id, year, month),
    FOREIGN KEY(location_id) REFERENCES locations(id)
);
```

#### daily_forecast_data
**Purpose**: Daily weather forecasts from OpenWeatherMap API

```sql
CREATE TABLE daily_forecast_data (
    id INTEGER PRIMARY KEY,
    location_id INTEGER NOT NULL,
    forecast_date DATE NOT NULL,
    
    -- Daily forecast data from OpenWeatherMap
    ghi_forecast REAL,
    temperature_forecast REAL,
    cloud_cover_forecast REAL,
    humidity_forecast REAL,
    wind_speed_forecast REAL,
    
    -- Enhanced environmental data
    dni_forecast REAL,
    sun_hours_forecast REAL,
    temperature_min_forecast REAL,
    temperature_max_forecast REAL,
    weather_condition_forecast VARCHAR(20),
    atmospheric_pressure_forecast REAL,
    
    -- Forecast metadata
    forecast_horizon_days INTEGER,
    confidence_level REAL,
    
    data_source VARCHAR(50) NOT NULL,
    data_freshness_minutes INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY(location_id) REFERENCES locations(id)
);
```

#### hourly_forecast_data
**Purpose**: Hourly weather forecasts for detailed short-term planning

```sql
CREATE TABLE hourly_forecast_data (
    id INTEGER PRIMARY KEY,
    location_id INTEGER NOT NULL,
    forecast_datetime DATETIME NOT NULL,
    
    -- Hourly forecast data
    ghi_hourly_forecast REAL,
    temperature_hourly_forecast REAL,
    cloud_cover_hourly_forecast REAL,
    
    -- Enhanced environmental data
    dni_hourly_forecast REAL,
    temperature_min_hourly_forecast REAL,
    temperature_max_hourly_forecast REAL,
    humidity_hourly_forecast REAL,
    weather_condition_hourly_forecast VARCHAR(20),
    atmospheric_pressure_hourly_forecast REAL,
    
    -- Forecast metadata
    forecast_horizon_hours INTEGER,
    confidence_level REAL,
    
    data_source VARCHAR(50) NOT NULL,
    data_freshness_minutes INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY(location_id) REFERENCES locations(id)
);
```

#### api_data_sources
**Purpose**: Track external API sources and their status

```sql
CREATE TABLE api_data_sources (
    id INTEGER PRIMARY KEY,
    source_name VARCHAR(50) NOT NULL UNIQUE,
    endpoint_url TEXT NOT NULL,
    last_fetch_time DATETIME,
    is_active BOOLEAN DEFAULT true,
    error_count INTEGER DEFAULT 0,
    last_error_message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### api_errors
**Purpose**: Track API errors for debugging and monitoring

```sql
CREATE TABLE api_errors (
    id INTEGER PRIMARY KEY,
    source_name VARCHAR(50) NOT NULL,
    error_message TEXT NOT NULL,
    error_data JSON,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### MIGRATION 0004: Projections & Scenarios

#### projection_scenarios
**Purpose**: User-customizable projection parameters for "what-if" analysis

```sql
CREATE TABLE projection_scenarios (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    system_config_id INTEGER NOT NULL,
    scenario_name VARCHAR(100) NOT NULL,
    description TEXT,
    
    -- Bitcoin Market Parameters (JSON for flexibility)
    bitcoin_parameters JSON,
    
    -- Economic Parameters
    economic_parameters JSON,
    
    -- Environmental Parameters
    environmental_parameters JSON,
    
    -- Equipment Performance Parameters
    equipment_parameters JSON,
    
    -- Scenario metadata
    is_baseline BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT false,
    is_user_created BOOLEAN DEFAULT true,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(system_config_id) REFERENCES system_configs(id),
    UNIQUE(system_config_id, scenario_name)
);
```

#### projection_results
**Purpose**: Calculated projection results

```sql
CREATE TABLE projection_results (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    system_config_id INTEGER NOT NULL,
    scenario_id INTEGER NOT NULL,
    projection_date DATE NOT NULL,
    
    -- Power Generation Results
    total_generation_kwh REAL NOT NULL,
    solar_generation_kwh REAL NOT NULL,
    
    -- Energy Flow Analysis
    mining_consumption_kwh REAL NOT NULL,
    grid_import_kwh REAL DEFAULT 0,
    grid_export_kwh REAL DEFAULT 0,
    
    -- Mining Performance
    total_hashrate_th REAL NOT NULL,
    effective_hashrate_th REAL NOT NULL,
    btc_mined REAL NOT NULL,
    btc_price_usd REAL NOT NULL,
    
    -- Economic Results
    mining_revenue_usd REAL NOT NULL,
    electricity_cost_usd REAL NOT NULL,
    net_profit_usd REAL NOT NULL,
    
    -- System Performance Metrics
    solar_capacity_factor REAL,
    system_efficiency REAL,
    
    -- Battery-Free Mining Results
    solar_direct_to_mining_kwh REAL DEFAULT 0,
    solar_wasted_kwh REAL DEFAULT 0,
    mining_hours_solar_only REAL DEFAULT 0,
    mining_hours_grid_assisted REAL DEFAULT 0,
    effective_mining_hours REAL DEFAULT 0,
    solar_availability_hours REAL DEFAULT 0,
    mining_availability_percent REAL DEFAULT 0,
    
    -- Seasonal Performance Tracking
    season VARCHAR(10),
    cloud_cover_avg_percent REAL,
    weather_impact_factor REAL DEFAULT 1.0,
    
    -- Business Analysis Fields
    roi_percent REAL,
    payback_period_months REAL,
    net_present_value_usd REAL,
    internal_rate_return_percent REAL,
    break_even_btc_price_usd REAL,
    break_even_electricity_rate_usd_kwh REAL,
    equipment_depreciation_usd REAL,
    maintenance_cost_usd REAL,
    insurance_cost_usd REAL,
    property_tax_usd REAL,
    total_operating_cost_usd REAL,
    gross_profit_margin_percent REAL,
    net_profit_margin_percent REAL,
    total_investment_usd REAL,
    total_revenue_usd REAL,
    total_costs_usd REAL,
    cumulative_profit_usd REAL,
    monthly_cash_flow_usd REAL,
    annual_cash_flow_usd REAL,
    
    -- Equipment Resale Value Tracking
    equipment_resale_value_usd REAL,
    total_investment_with_resale_usd REAL,
    adjusted_roi_percent REAL,
    net_equipment_value_usd REAL,
    
    calculated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(system_config_id) REFERENCES system_configs(id),
    FOREIGN KEY(scenario_id) REFERENCES projection_scenarios(id)
);
```

### MIGRATION 0005: Historical Data

#### miner_price_history
**Purpose**: Historical price tracking for miners

```sql
CREATE TABLE miner_price_history (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    miner_model_id INTEGER NOT NULL,
    recorded_date DATE NOT NULL,
    market_price_usd REAL NOT NULL,
    resale_price_usd REAL,
    market_demand_level VARCHAR(20),
    depreciation_rate_used REAL,
    calculation_method VARCHAR(20),
    data_source VARCHAR(50),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(miner_model_id) REFERENCES miner_models(id)
);
```

### MIGRATION 0006: Error Handling

#### application_errors
**Purpose**: Track application errors for debugging and monitoring

```sql
CREATE TABLE application_errors (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    error_type VARCHAR(50) NOT NULL, -- 'calculation', 'validation', 'system', 'api'
    error_category VARCHAR(50) NOT NULL, -- 'solar_calc', 'mining_calc', 'user_input', 'database'
    error_message TEXT NOT NULL,
    error_context JSON, -- Additional error details and context
    severity_level VARCHAR(20) DEFAULT 'error', -- 'info', 'warning', 'error', 'critical'
    stack_trace TEXT,
    user_action TEXT, -- What user was doing when error occurred
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id)
);
```

## Data Validation Constraints

### Equipment Performance Constraints
- Positive hashrate, power consumption, efficiency values
- Valid degradation and failure rate ranges
- Solar efficiency and degradation rate validation
- Storage capacity and efficiency validation
- Inverter power and efficiency validation

### Geographic Constraints
- Valid latitude (-90 to 90) and longitude (-180 to 180) ranges
- Reasonable elevation range (-1000 to 10000 meters)

### Economic Constraints
- Positive electricity rates
- Valid net metering rates
- Reasonable ROI and payback period ranges

### Bitcoin Data Constraints
- Positive difficulty, hashrate, and block reward values
- Valid Bitcoin price values

### Environmental Data Constraints
- Non-negative solar irradiance values
- Reasonable temperature ranges (-50 to 80°C)
- Valid cloud cover percentages (0-100%)

### JSON Validation
- Valid JSON structure for equipment configurations
- Required fields present in JSON arrays
- Proper data types for JSON fields

## Database Indexes

### User Data Isolation Indexes
```sql
CREATE INDEX idx_locations_user ON locations(user_id);
CREATE INDEX idx_miner_models_user ON miner_models(user_id);
CREATE INDEX idx_solar_panel_models_user ON solar_panel_models(user_id);
CREATE INDEX idx_storage_models_user ON storage_models(user_id);
CREATE INDEX idx_inverter_models_user ON inverter_models(user_id);
CREATE INDEX idx_system_configs_user ON system_configs(user_id);
CREATE INDEX idx_projection_scenarios_user ON projection_scenarios(user_id);
CREATE INDEX idx_projection_results_user ON projection_results(user_id);
CREATE INDEX idx_miner_price_history_user ON miner_price_history(user_id);
```

### Equipment Search Indexes
```sql
CREATE INDEX idx_miner_manufacturer_model ON miner_models(manufacturer, model_name);
CREATE INDEX idx_miner_efficiency ON miner_models(efficiency_j_th);
CREATE INDEX idx_miner_hashrate ON miner_models(hashrate_th);
CREATE INDEX idx_miner_user_nickname ON miner_models(user_nickname);

CREATE INDEX idx_solar_manufacturer_model ON solar_panel_models(manufacturer, model_name);
CREATE INDEX idx_solar_efficiency ON solar_panel_models(efficiency_percent);
CREATE INDEX idx_solar_user_nickname ON solar_panel_models(user_nickname);

CREATE INDEX idx_storage_manufacturer_model ON storage_models(manufacturer, model_name);
CREATE INDEX idx_storage_capacity ON storage_models(capacity_kwh);
CREATE INDEX idx_storage_user_nickname ON storage_models(user_nickname);

CREATE INDEX idx_inverter_manufacturer_model ON inverter_models(manufacturer, model_name);
CREATE INDEX idx_inverter_power_rating ON inverter_models(rated_power_w);
CREATE INDEX idx_inverter_efficiency ON inverter_models(efficiency_percent);
CREATE INDEX idx_inverter_user_nickname ON inverter_models(user_nickname);
```

### System Configuration Indexes
```sql
CREATE INDEX idx_system_config_name ON system_configs(config_name);
CREATE INDEX idx_system_config_mining_mode ON system_configs(mining_mode);
CREATE INDEX idx_system_config_grid_type ON system_configs(grid_connection_type);
CREATE INDEX idx_system_config_inverter ON system_configs(inverter_id);
```

### External Data Indexes
```sql
CREATE INDEX idx_bitcoin_network_date ON bitcoin_network_data(recorded_date);
CREATE INDEX idx_bitcoin_network_hashprice ON bitcoin_network_data(hashprice_usd_per_th);
CREATE INDEX idx_bitcoin_network_revenue_per_th ON bitcoin_network_data(revenue_per_th_usd);

CREATE INDEX idx_bitcoin_price_date ON bitcoin_price_data(recorded_date);
CREATE INDEX idx_bitcoin_price_volatility ON bitcoin_price_data(volatility_30d);
CREATE INDEX idx_bitcoin_price_change_24h ON bitcoin_price_data(price_change_24h_percent);

CREATE INDEX idx_monthly_solar_location_year_month ON monthly_solar_data(location_id, year, month);
CREATE INDEX idx_monthly_solar_season ON monthly_solar_data(season);
CREATE INDEX idx_monthly_solar_data_source ON monthly_solar_data(data_source);
CREATE INDEX idx_monthly_solar_dni ON monthly_solar_data(dni_monthly_avg);
CREATE INDEX idx_monthly_solar_sun_hours ON monthly_solar_data(sun_hours_monthly_avg);
CREATE INDEX idx_monthly_solar_temp_range ON monthly_solar_data(temperature_min_monthly_avg, temperature_max_monthly_avg);

CREATE INDEX idx_daily_forecast_location_date ON daily_forecast_data(location_id, forecast_date);
CREATE INDEX idx_daily_forecast_horizon ON daily_forecast_data(forecast_horizon_days);
CREATE INDEX idx_daily_forecast_data_source ON daily_forecast_data(data_source);
CREATE INDEX idx_daily_forecast_dni ON daily_forecast_data(dni_forecast);
CREATE INDEX idx_daily_forecast_sun_hours ON daily_forecast_data(sun_hours_forecast);
CREATE INDEX idx_daily_forecast_temp_range ON daily_forecast_data(temperature_min_forecast, temperature_max_forecast);
CREATE INDEX idx_daily_forecast_weather ON daily_forecast_data(weather_condition_forecast);

CREATE INDEX idx_hourly_forecast_location_datetime ON hourly_forecast_data(location_id, forecast_datetime);
CREATE INDEX idx_hourly_forecast_horizon ON hourly_forecast_data(forecast_horizon_hours);
CREATE INDEX idx_hourly_forecast_data_source ON hourly_forecast_data(data_source);
CREATE INDEX idx_hourly_forecast_dni ON hourly_forecast_data(dni_hourly_forecast);
CREATE INDEX idx_hourly_forecast_temp_range ON hourly_forecast_data(temperature_min_hourly_forecast, temperature_max_hourly_forecast);
CREATE INDEX idx_hourly_forecast_weather ON hourly_forecast_data(weather_condition_hourly_forecast);
```

### API Management Indexes
```sql
CREATE INDEX idx_api_data_sources_active ON api_data_sources(is_active, last_fetch_time);
CREATE INDEX idx_api_errors_source_time ON api_errors(source_name, created_at);
CREATE INDEX idx_bitcoin_price_freshness ON bitcoin_price_data(data_freshness_minutes);
CREATE INDEX idx_bitcoin_network_freshness ON bitcoin_network_data(data_freshness_minutes);
CREATE INDEX idx_daily_forecast_freshness ON daily_forecast_data(data_freshness_minutes);
CREATE INDEX idx_hourly_forecast_freshness ON hourly_forecast_data(data_freshness_minutes);
```

### Projection Indexes
```sql
CREATE INDEX idx_projection_scenarios_config ON projection_scenarios(system_config_id);
CREATE INDEX idx_projection_scenarios_baseline ON projection_scenarios(is_baseline);
CREATE INDEX idx_projection_scenarios_active ON projection_scenarios(is_active);
CREATE INDEX idx_projection_scenarios_user_created ON projection_scenarios(is_user_created);

CREATE INDEX idx_projection_config_date ON projection_results(system_config_id, projection_date);
CREATE INDEX idx_projection_scenario ON projection_results(scenario_id);
CREATE INDEX idx_projection_mining_hours ON projection_results(effective_mining_hours);
CREATE INDEX idx_projection_season ON projection_results(season);
CREATE INDEX idx_projection_roi ON projection_results(roi_percent);
CREATE INDEX idx_projection_payback ON projection_results(payback_period_months);
CREATE INDEX idx_projection_irr ON projection_results(internal_rate_return_percent);
CREATE INDEX idx_projection_break_even_price ON projection_results(break_even_btc_price_usd);
CREATE INDEX idx_projection_total_investment ON projection_results(total_investment_usd);
CREATE INDEX idx_projection_cumulative_profit ON projection_results(cumulative_profit_usd);
```

### Historical Data Indexes
```sql
CREATE INDEX idx_miner_price_history_model_date ON miner_price_history(miner_model_id, recorded_date);
CREATE INDEX idx_miner_price_history_demand ON miner_price_history(market_demand_level);
CREATE INDEX idx_miner_price_history_calculation ON miner_price_history(calculation_method);
```

### Error Handling Indexes
```sql
CREATE INDEX idx_app_errors_user_time ON application_errors(user_id, created_at);
CREATE INDEX idx_app_errors_type_category ON application_errors(error_type, error_category);
CREATE INDEX idx_app_errors_severity ON application_errors(severity_level);
CREATE INDEX idx_app_errors_created_at ON application_errors(created_at);
```

## Migration Strategy

### Deployment Order
1. **0001_core_foundation.sql** - User management and equipment tables
2. **0002_system_configuration.sql** - System configs and helper functions
3. **0003_external_data.sql** - External data and API management
4. **0004_projections_scenarios.sql** - Scenarios and results
5. **0005_historical_data.sql** - Historical tracking
6. **0006_error_handling.sql** - Error logging

### Rollback Strategy
Each migration can be rolled back independently if issues arise during deployment.

### Testing Strategy
- Test each migration individually
- Verify foreign key relationships
- Test helper functions with sample data
- Validate JSON constraints
- Test error logging functionality

## Data Retention Policy

- **Current data**: Keep indefinitely for calculations
- **Historical data**: Archive after 2 years, keep monthly summaries
- **Projection results**: Keep for 1 year, then aggregate to summaries
- **Error logs**: Auto-cleanup after 30 days

---

**Document Status**: Final v1.0  
**Last Updated**: 2024-12-19  
**Migration Count**: 6 migrations (963 lines total)  
**Tables**: 12 tables with comprehensive indexing and validation