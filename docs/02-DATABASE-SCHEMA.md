# Database Schema - Solar Bitcoin Mining Calculator

## Schema Overview

The database is organized into four main categories of tables, each serving a specific purpose in the solar mining calculation system:

1. **Reference Data Tables**: Static catalogs and specifications
2. **Time-Series Data Tables**: Historical market and environmental data
3. **Configuration Tables**: User-defined system setups and scenarios
4. **Results Tables**: Calculated projections and performance data

## Table Categories and Relationships

```
REFERENCE DATA (Static/Catalog)
├── locations
├── power_source_types
├── power_source_models
├── miner_models
└── storage_models

TIME-SERIES DATA (Historical)
├── bitcoin_network_history
├── bitcoin_price_history
└── environmental_history

CONFIGURATION DATA (User-Defined)
├── system_configs
└── projection_scenarios

RESULTS DATA (Calculated)
├── projection_results
└── equipment_performance_history
```

## Detailed Table Specifications

### 1. REFERENCE DATA TABLES

#### 1.1 locations
**Purpose**: Geographic locations for solar/wind resource calculations

```sql
CREATE TABLE locations (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,              -- "San Francisco, CA"
    latitude REAL NOT NULL,                  -- 37.7749 (decimal degrees)
    longitude REAL NOT NULL,                 -- -122.4194 (decimal degrees)
    elevation REAL NOT NULL,                 -- 16 (meters above sea level)
    timezone VARCHAR(50) NOT NULL,           -- "America/Los_Angeles"
    magnetic_declination REAL,               -- 13.5 (degrees, for solar calculations)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Key Relationships**: Referenced by `system_configs` and `environmental_history`

#### 1.2 power_source_types
**Purpose**: Defines available power source categories with flexible specification schemas

```sql
CREATE TABLE power_source_types (
    id INTEGER PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,          -- "solar_panel", "wind_turbine", "grid", "generator"
    category VARCHAR(30) NOT NULL,           -- "renewable", "grid", "backup", "hybrid"
    description TEXT,                        -- Human-readable description
    spec_schema JSON NOT NULL,               -- Defines required/optional fields for this type
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**Example spec_schema for solar_panel**:
```json
{
  "required": ["rated_power_w", "efficiency_percent", "temperature_coefficient"],
  "optional": ["degradation_rate_annual", "warranty_years", "technology"],
  "units": {
    "rated_power_w": "watts",
    "efficiency_percent": "%", 
    "temperature_coefficient": "%/°C"
  }
}
```

**Example spec_schema for wind_turbine**:
```json
{
  "required": ["rated_power_w", "cut_in_speed_ms", "rated_speed_ms", "cut_out_speed_ms"],
  "optional": ["hub_height_m", "rotor_diameter_m", "power_curve"],
  "units": {
    "rated_power_w": "watts",
    "cut_in_speed_ms": "m/s",
    "rated_speed_ms": "m/s",
    "cut_out_speed_ms": "m/s"
  }
}
```

#### 1.3 power_source_models
**Purpose**: Unified catalog for all power generation equipment

```sql
CREATE TABLE power_source_models (
    id INTEGER PRIMARY KEY,
    type_id INTEGER NOT NULL,                -- References power_source_types.id
    manufacturer VARCHAR(50) NOT NULL,       -- "Canadian Solar", "Vestas", "Tesla"
    model_name VARCHAR(100) NOT NULL,        -- "CS3W-400MS", "V47-660", "Powerwall 2"
    
    -- Flexible specifications matching the type's schema
    specifications JSON NOT NULL,            -- Type-specific technical specifications
    
    -- Common economic data
    cost_per_unit REAL,                     -- USD per unit
    availability VARCHAR(20),               -- "In Stock", "Backorder", "Discontinued"
    warranty_years INTEGER,                 -- Manufacturer warranty period
    expected_lifespan_years REAL,           -- Expected operational life
    
    -- Common physical data
    dimensions JSON,                        -- {"length_mm": 2000, "width_mm": 1000, "height_mm": 40}
    weight_kg REAL,                         -- Weight in kilograms
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(type_id) REFERENCES power_source_types(id),
    INDEX idx_type_manufacturer (type_id, manufacturer),
    INDEX idx_model_name (model_name)
);
```

**Example specifications for solar panel**:
```json
{
  "rated_power_w": 400,
  "efficiency_percent": 20.5,
  "temperature_coefficient": -0.35,
  "degradation_rate_annual": 0.5,
  "technology": "Monocrystalline",
  "voltage_mpp": 40.1,
  "current_mpp": 9.98,
  "voltage_oc": 48.4,
  "current_sc": 10.58
}
```

#### 1.4 miner_models
**Purpose**: Comprehensive Bitcoin ASIC miner specifications with degradation modeling

```sql
CREATE TABLE miner_models (
    id INTEGER PRIMARY KEY,
    manufacturer VARCHAR(50) NOT NULL,       -- "Bitmain", "MicroBT", "Canaan"
    model_name VARCHAR(100) NOT NULL,        -- "Antminer S19 Pro", "WhatsMiner M30S++"
    generation VARCHAR(20),                  -- "7nm", "5nm", "3nm"
    release_date DATE,                       -- Product release date
    
    -- Core Performance Specifications
    hashrate_th REAL NOT NULL,              -- 110 (TH/s at optimal conditions)
    power_consumption_w INTEGER NOT NULL,    -- 3250 (Watts at optimal conditions)
    efficiency_j_th REAL NOT NULL,          -- 29.5 (J/TH at optimal conditions)
    
    -- Performance Degradation Model
    hashrate_degradation_annual REAL DEFAULT 0.05,     -- 5% per year
    efficiency_degradation_annual REAL DEFAULT 0.03,   -- 3% per year  
    failure_rate_annual REAL DEFAULT 0.10,             -- 10% per year
    performance_curve JSON,                             -- Detailed degradation over time
    
    -- Technical Specifications
    chip_architecture VARCHAR(20),           -- "SHA-256 ASIC"
    chip_count INTEGER,                     -- 576
    hash_boards INTEGER,                    -- 3
    cooling_type VARCHAR(30),               -- "Air", "Immersion", "Hydro"
    
    -- Environmental Operating Limits
    operating_temp_min INTEGER,             -- 5 (Celsius)
    operating_temp_max INTEGER,             -- 40 (Celsius)
    humidity_max INTEGER,                   -- 85 (percentage)
    altitude_max INTEGER,                   -- 2000 (meters)
    
    -- Economic Data
    msrp_usd REAL,                         -- 5000 (Manufacturer suggested retail price)
    current_price_usd REAL,                -- 3500 (Current market price)
    warranty_months INTEGER,               -- 36
    expected_lifespan_years REAL,          -- 5
    
    -- Physical Specifications
    dimensions_l_mm INTEGER,               -- 400 (length)
    dimensions_w_mm INTEGER,               -- 195 (width)
    dimensions_h_mm INTEGER,               -- 290 (height)
    weight_kg REAL,                        -- 13.2
    noise_level_db INTEGER,                -- 75
    
    -- Power Requirements
    voltage_v INTEGER,                     -- 220
    power_connection_type VARCHAR(20),     -- "C19", "C13", "Hardwired"
    power_factor REAL,                     -- 0.93
    startup_current_a REAL,                -- 20
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_manufacturer_model (manufacturer, model_name),
    INDEX idx_efficiency (efficiency_j_th),
    INDEX idx_hashrate (hashrate_th)
);
```

**Example performance_curve JSON**:
```json
{
  "months": [0, 6, 12, 18, 24, 30, 36, 42, 48],
  "hashrate_retention": [1.00, 0.98, 0.95, 0.92, 0.90, 0.87, 0.85, 0.82, 0.80],
  "efficiency_retention": [1.00, 0.99, 0.97, 0.95, 0.93, 0.91, 0.89, 0.87, 0.85],
  "failure_probability": [0.00, 0.02, 0.05, 0.08, 0.12, 0.16, 0.20, 0.25, 0.30]
}
```

#### 1.5 storage_models
**Purpose**: Battery and energy storage system specifications

```sql
CREATE TABLE storage_models (
    id INTEGER PRIMARY KEY,
    manufacturer VARCHAR(50) NOT NULL,       -- "Tesla", "LG Chem", "BYD"
    model_name VARCHAR(100) NOT NULL,        -- "Powerwall 2", "RESU 10H", "B-Box Pro 13.8"
    technology VARCHAR(20) NOT NULL,         -- "LiFePO4", "Li-ion", "Lead-acid"
    
    -- Capacity & Performance
    capacity_kwh REAL NOT NULL,             -- 13.5 (Total capacity)
    usable_capacity_kwh REAL NOT NULL,      -- 13.5 (Usable capacity)
    max_charge_rate_kw REAL NOT NULL,       -- 5 (Maximum charge rate)
    max_discharge_rate_kw REAL NOT NULL,    -- 5 (Maximum discharge rate)
    round_trip_efficiency REAL NOT NULL,    -- 0.90 (90% round-trip efficiency)
    
    -- Degradation Model
    cycle_life INTEGER NOT NULL,            -- 6000 (Expected cycle life)
    capacity_retention_curve JSON,          -- Detailed capacity loss over cycles
    calendar_degradation_annual REAL DEFAULT 0.02, -- 2% per year regardless of use
    
    -- Operating Conditions
    depth_of_discharge_max REAL NOT NULL,   -- 0.95 (95% maximum DoD)
    operating_temp_min INTEGER,             -- -20 (Celsius)
    operating_temp_max INTEGER,             -- 50 (Celsius)
    
    -- Economic Data
    cost_per_kwh REAL,                      -- 500 (USD per kWh of capacity)
    warranty_years INTEGER,                 -- 10
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_manufacturer_model (manufacturer, model_name),
    INDEX idx_capacity (capacity_kwh)
);
```

**Example capacity_retention_curve JSON**:
```json
{
  "cycles": [0, 1000, 2000, 3000, 4000, 5000, 6000],
  "capacity_retention": [1.00, 0.95, 0.90, 0.85, 0.80, 0.75, 0.70],
  "years": [0, 2, 4, 6, 8, 10, 12]
}
```

### 2. TIME-SERIES DATA TABLES

#### 2.1 bitcoin_network_history
**Purpose**: Historical Bitcoin network statistics for trend analysis and projections

```sql
CREATE TABLE bitcoin_network_history (
    id INTEGER PRIMARY KEY,
    recorded_date DATE NOT NULL,            -- 2024-08-11
    difficulty BIGINT NOT NULL,             -- 90666502495565 (Current network difficulty)
    network_hashrate REAL NOT NULL,        -- 650.5 (EH/s - Exahashes per second)
    block_reward REAL NOT NULL,            -- 6.25 (BTC per block, includes halvings)
    avg_block_time REAL NOT NULL,          -- 605 (seconds - average over 2016 blocks)
    avg_transaction_fee REAL NOT NULL,     -- 0.0025 (BTC - average fee per transaction)
    total_blocks INTEGER NOT NULL,         -- 856789 (Total blocks in blockchain)
    halving_countdown_blocks INTEGER,      -- 144000 (Blocks until next halving)
    data_source VARCHAR(50) NOT NULL,      -- "blockchain.info", "blockstream.info"
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_date (recorded_date),
    INDEX idx_difficulty (difficulty)
);
```

#### 2.2 bitcoin_price_history
**Purpose**: Historical Bitcoin price data for revenue projections

```sql
CREATE TABLE bitcoin_price_history (
    id INTEGER PRIMARY KEY,
    recorded_date DATE NOT NULL,            -- 2024-08-11
    price_usd REAL NOT NULL,               -- 45250.50 (Closing price)
    price_open REAL NOT NULL,              -- 44800.00 (Opening price)
    price_high REAL NOT NULL,              -- 45500.00 (Daily high)
    price_low REAL NOT NULL,               -- 44650.00 (Daily low)
    volume_24h REAL,                       -- 28500000000 (24h trading volume in USD)
    market_cap REAL,                       -- 890000000000 (Total market cap)
    volatility_30d REAL,                   -- 0.045 (30-day volatility)
    data_source VARCHAR(50) NOT NULL,      -- "coingecko", "coinmarketcap"
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_date (recorded_date),
    INDEX idx_price (price_usd)
);
```

#### 2.3 environmental_history
**Purpose**: Historical weather and environmental data for power generation modeling

```sql
CREATE TABLE environmental_history (
    id INTEGER PRIMARY KEY,
    location_id INTEGER NOT NULL,           -- References locations.id
    recorded_date DATE NOT NULL,            -- 2024-08-11
    
    -- Solar Data
    ghi_daily REAL,                        -- 6.2 (kWh/m²/day - Global Horizontal Irradiance)
    dni_daily REAL,                        -- 7.8 (kWh/m²/day - Direct Normal Irradiance)
    dhi_daily REAL,                        -- 1.4 (kWh/m²/day - Diffuse Horizontal Irradiance)
    sun_hours REAL,                        -- 8.5 (hours of direct sunlight)
    
    -- Wind Data (for wind turbines)
    wind_speed_avg REAL,                   -- 6.2 (m/s - average wind speed)
    wind_speed_max REAL,                   -- 12.5 (m/s - maximum wind speed)
    wind_direction_avg REAL,               -- 245 (degrees - average wind direction)
    
    -- General Weather Conditions
    temperature_avg REAL,                  -- 22.5 (Celsius - average temperature)
    temperature_min REAL,                  -- 18.0 (Celsius - minimum temperature)
    temperature_max REAL,                  -- 28.0 (Celsius - maximum temperature)
    humidity_avg REAL,                     -- 65 (percentage - average humidity)
    cloud_cover_avg REAL,                  -- 25 (percentage - average cloud cover)
    precipitation REAL,                    -- 0.0 (mm - precipitation)
    atmospheric_pressure REAL,            -- 1013.25 (hPa - atmospheric pressure)
    
    data_source VARCHAR(50) NOT NULL,      -- "openweathermap", "nrel"
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(location_id) REFERENCES locations(id),
    INDEX idx_location_date (location_id, recorded_date),
    INDEX idx_ghi (ghi_daily),
    INDEX idx_wind_speed (wind_speed_avg)
);
```

### 3. CONFIGURATION DATA TABLES

#### 3.1 system_configs
**Purpose**: User-defined mining system configurations

```sql
CREATE TABLE system_configs (
    id INTEGER PRIMARY KEY,
    config_name VARCHAR(100) NOT NULL,      -- "My Solar Mining Rig v2"
    description TEXT,                       -- User description of the configuration
    location_id INTEGER NOT NULL,           -- References locations.id
    
    -- Power Generation Configuration
    power_sources JSON NOT NULL,            -- Array of power source configurations
    inverter_config JSON,                   -- Inverter specifications and settings
    
    -- Energy Storage Configuration  
    storage_systems JSON,                   -- Array of battery system configurations
    
    -- Mining Equipment Configuration
    miners JSON NOT NULL,                   -- Array of miner configurations
    
    -- Economic Parameters
    electricity_rates JSON NOT NULL,        -- Rate structures and economic parameters
    
    -- System Layout and Installation
    installation_date DATE,                 -- When system was/will be installed
    system_layout JSON,                     -- Physical layout, wiring, etc.
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(location_id) REFERENCES locations(id),
    INDEX idx_config_name (config_name)
);
```

**Example power_sources JSON**:
```json
[
  {
    "type": "solar_panel",
    "model_id": 15,
    "quantity": 50,
    "config": {
      "tilt_angle": 30,
      "azimuth": 180,
      "row_spacing": 3.0,
      "shading_factor": 0.02
    }
  },
  {
    "type": "wind_turbine", 
    "model_id": 3,
    "quantity": 2,
    "config": {
      "hub_height": 30,
      "wake_effect": 0.05
    }
  }
]
```

**Example miners JSON**:
```json
[
  {
    "model_id": 8,
    "quantity": 10,
    "config": {
      "power_limit_w": 3000,
      "target_temperature": 60,
      "overclock_percentage": 0,
      "pool_address": "stratum+tcp://us-east.slushpool.com:4444"
    }
  }
]
```

**Example electricity_rates JSON**:
```json
{
  "grid_rate_kwh": 0.12,
  "net_metering_rate": 0.08,
  "demand_charge_kw": 15.0,
  "time_of_use": {
    "peak_hours": "16:00-21:00",
    "peak_rate": 0.18,
    "off_peak_rate": 0.09
  },
  "interconnection_cost": 2500,
  "monthly_service_charge": 25.0
}
```

#### 3.2 projection_scenarios
**Purpose**: Projection scenario definitions with economic and technical assumptions

```sql
CREATE TABLE projection_scenarios (
    id INTEGER PRIMARY KEY,
    scenario_name VARCHAR(100) NOT NULL,    -- "Conservative 5-Year Projection"
    description TEXT,                       -- Detailed scenario description
    system_config_id INTEGER NOT NULL,      -- References system_configs.id
    
    -- Bitcoin Economic Assumptions
    btc_price_model JSON NOT NULL,          -- Bitcoin price projection model
    difficulty_model JSON NOT NULL,         -- Network difficulty projection model
    
    -- Environmental Assumptions
    climate_model JSON,                     -- Climate and weather assumptions
    
    -- Equipment Degradation Overrides
    equipment_degradation_overrides JSON,   -- Custom degradation parameters
    
    -- Projection Parameters
    projection_start_date DATE NOT NULL,    -- 2024-08-11
    projection_end_date DATE NOT NULL,      -- 2029-08-11
    calculation_frequency VARCHAR(10) NOT NULL, -- "daily", "weekly", "monthly"
    
    -- Monte Carlo Simulation Parameters
    simulation_runs INTEGER DEFAULT 1000,   -- Number of simulation runs
    confidence_intervals JSON DEFAULT '[0.05, 0.25, 0.50, 0.75, 0.95]',
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(system_config_id) REFERENCES system_configs(id),
    INDEX idx_scenario_name (scenario_name),
    INDEX idx_config_id (system_config_id)
);
```

**Example btc_price_model JSON**:
```json
{
  "type": "stochastic",
  "parameters": {
    "start_price": 45000,
    "drift_annual": 0.15,
    "volatility_annual": 0.80,
    "price_floor": 20000,
    "price_ceiling": 500000,
    "halving_impact": 1.5
  }
}
```

**Example difficulty_model JSON**:
```json
{
  "type": "exponential_with_variance",
  "parameters": {
    "base_annual_growth": 0.20,
    "adjustment_variance": 0.05,
    "market_cycle_factor": 0.8,
    "technological_improvement": 0.02
  }
}
```

### 4. RESULTS DATA TABLES

#### 4.1 projection_results
**Purpose**: Calculated projection results for visualization and analysis

```sql
CREATE TABLE projection_results (
    id INTEGER PRIMARY KEY,
    scenario_id INTEGER NOT NULL,           -- References projection_scenarios.id
    projection_date DATE NOT NULL,          -- 2024-08-11
    simulation_run INTEGER DEFAULT 0,       -- 0 for deterministic, >0 for Monte Carlo
    
    -- Power Generation Results
    total_generation_kwh REAL NOT NULL,     -- 145.5 (Total daily generation)
    solar_generation_kwh REAL DEFAULT 0,    -- 125.0 (Solar contribution)
    wind_generation_kwh REAL DEFAULT 0,     -- 20.5 (Wind contribution)
    other_generation_kwh REAL DEFAULT 0,    -- 0.0 (Other sources)
    
    -- Energy Flow Analysis
    mining_consumption_kwh REAL NOT NULL,   -- 780.0 (Total mining consumption)
    facility_consumption_kwh REAL DEFAULT 0, -- 25.0 (Cooling, lighting, etc.)
    battery_charge_kwh REAL DEFAULT 0,      -- 50.0 (Energy stored)
    battery_discharge_kwh REAL DEFAULT 0,   -- 75.0 (Energy retrieved)
    grid_import_kwh REAL DEFAULT 0,         -- 655.0 (Grid electricity used)
    grid_export_kwh REAL DEFAULT 0,         -- 15.0 (Excess solar exported)
    
    -- Mining Performance (with degradation effects)
    total_hashrate_th REAL NOT NULL,        -- 1100.0 (Total hashrate)
    effective_hashrate_th REAL NOT NULL,    -- 1045.0 (After degradation)
    btc_mined REAL NOT NULL,               -- 0.0125 (BTC earned this period)
    btc_price_usd REAL NOT NULL,           -- 45250.0 (BTC price used)
    pool_fees_btc REAL DEFAULT 0,          -- 0.000125 (Pool fees paid)
    
    -- Economic Results
    mining_revenue_usd REAL NOT NULL,       -- 565.625 (Gross mining revenue)
    electricity_cost_usd REAL NOT NULL,     -- 78.60 (Grid electricity cost)
    maintenance_cost_usd REAL DEFAULT 0,    -- 5.50 (Equipment maintenance)
    net_profit_usd REAL NOT NULL,          -- 481.525 (Daily net profit)
    cumulative_profit_usd REAL NOT NULL,   -- 125698.50 (Total profit to date)
    
    -- System Performance Metrics
    solar_capacity_factor REAL,            -- 0.21 (Solar capacity factor)
    wind_capacity_factor REAL,             -- 0.35 (Wind capacity factor)
    mining_uptime_percent REAL DEFAULT 100, -- 98.5 (Mining uptime percentage)
    system_efficiency REAL,                -- 0.875 (Overall system efficiency)
    
    calculated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(scenario_id) REFERENCES projection_scenarios(id),
    INDEX idx_scenario_date (scenario_id, projection_date),
    INDEX idx_simulation_run (scenario_id, simulation_run)
);
```

#### 4.2 equipment_performance_history
**Purpose**: Track actual vs. projected equipment performance over time

```sql
CREATE TABLE equipment_performance_history (
    id INTEGER PRIMARY KEY,
    config_id INTEGER NOT NULL,             -- References system_configs.id
    equipment_type VARCHAR(20) NOT NULL,    -- "miner", "solar_panel", "wind_turbine", "battery"
    equipment_model_id INTEGER NOT NULL,    -- References appropriate model table
    equipment_instance_id VARCHAR(50),      -- "SN123456789" (Serial number)
    
    recorded_date DATE NOT NULL,            -- 2024-08-11
    age_months INTEGER NOT NULL,            -- 18 (Age since installation)
    
    -- Performance Metrics (varies by equipment type)
    performance_metrics JSON NOT NULL,      -- Type-specific performance data
    
    -- Degradation Analysis
    performance_ratio REAL,                 -- 0.92 (Current vs rated performance)
    degradation_rate_actual REAL,          -- 0.045 (Actual degradation rate)
    
    data_source VARCHAR(50),               -- "measured", "calculated", "estimated"
    notes TEXT,                            -- Additional observations
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(config_id) REFERENCES system_configs(id),
    INDEX idx_config_equipment (config_id, equipment_type, equipment_model_id),
    INDEX idx_date_type (recorded_date, equipment_type)
);
```

**Example performance_metrics for miner**:
```json
{
  "hashrate_th": 95.5,
  "power_consumption_w": 3150,
  "efficiency_j_th": 32.98,
  "temperature_avg": 67,
  "uptime_hours": 23.8,
  "error_rate": 0.002
}
```

**Example performance_metrics for solar_panel**:
```json
{
  "power_output_avg_w": 385,
  "efficiency_current": 19.8,
  "temperature_avg": 42,
  "irradiance_avg": 650,
  "soiling_factor": 0.97
}
```

## Database Indexes and Performance

### Critical Indexes
```sql
-- Time-series query optimization
CREATE INDEX idx_projection_scenario_date ON projection_results(scenario_id, projection_date);
CREATE INDEX idx_environmental_location_date ON environmental_history(location_id, recorded_date);
CREATE INDEX idx_bitcoin_network_date ON bitcoin_network_history(recorded_date);

-- Equipment lookup optimization  
CREATE INDEX idx_miner_efficiency ON miner_models(efficiency_j_th);
CREATE INDEX idx_power_source_type ON power_source_models(type_id, manufacturer);

-- Search optimization
CREATE INDEX idx_config_name ON system_configs(config_name);
CREATE INDEX idx_scenario_name ON projection_scenarios(scenario_name);
```

### Data Retention Policies
- **Real-time data**: Keep indefinitely for trend analysis
- **Projection results**: Archive after 2 years, keep aggregated summaries
- **Equipment performance**: Keep detailed data for warranty periods, summarize afterwards

## Migration Strategy

### Phase 1: Core Tables
1. Reference data tables (locations, equipment catalogs)
2. Basic time-series tables (Bitcoin network, price data)

### Phase 2: Configuration System
1. Power source type system
2. System configuration tables
3. Scenario management

### Phase 3: Results and Analytics
1. Projection results tables
2. Performance tracking
3. Advanced indexing and optimization

---

**Document Status**: Draft v1.0  
**Last Updated**: 2024-08-11  
**Next Review**: After API specification completion