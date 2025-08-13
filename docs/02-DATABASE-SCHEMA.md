# Database Schema - Solar Bitcoin Mining Calculator (Simplified)

## Schema Overview

The database is organized into four main categories of tables, each serving a specific purpose in the solar mining calculation system:

1. **Reference Data Tables**: Essential equipment specifications
2. **Time-Series Data Tables**: Current Bitcoin and environmental data
3. **Configuration Tables**: User-defined system setups
4. **Results Tables**: Calculated projections

## Table Categories and Relationships

```
REFERENCE DATA (Essential Specifications)
├── locations
├── miner_models
├── solar_panel_models
└── storage_models

TIME-SERIES DATA (Current Data)
├── bitcoin_network_data
├── bitcoin_price_data
└── environmental_data

CONFIGURATION DATA (User-Defined)
└── system_configs

RESULTS DATA (Calculated)
└── projection_results
```

## Detailed Table Specifications

### 1. REFERENCE DATA TABLES

#### 1.1 locations
**Purpose**: Geographic locations for solar resource calculations

```sql
CREATE TABLE locations (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,              -- "San Francisco, CA"
    latitude REAL NOT NULL,                  -- 37.7749 (decimal degrees)
    longitude REAL NOT NULL,                 -- -122.4194 (decimal degrees)
    elevation REAL NOT NULL,                 -- 16 (meters above sea level)
    timezone VARCHAR(50) NOT NULL,           -- "America/Los_Angeles"
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### 1.2 miner_models
**Purpose**: Essential Bitcoin ASIC miner specifications

```sql
CREATE TABLE miner_models (
    id INTEGER PRIMARY KEY,
    manufacturer VARCHAR(50) NOT NULL,       -- "Bitmain", "MicroBT", "Canaan"
    model_name VARCHAR(100) NOT NULL,        -- "Antminer S19 Pro", "WhatsMiner M30S++"
    
    -- Core Performance Specifications
    hashrate_th REAL NOT NULL,              -- 110 (TH/s at optimal conditions)
    power_consumption_w INTEGER NOT NULL,    -- 3250 (Watts at optimal conditions)
    efficiency_j_th REAL NOT NULL,          -- 29.5 (J/TH at optimal conditions)
    
    -- Performance Degradation Model
    hashrate_degradation_annual REAL DEFAULT 0.05,     -- 5% per year
    efficiency_degradation_annual REAL DEFAULT 0.03,   -- 3% per year  
    failure_rate_annual REAL DEFAULT 0.10,             -- 10% per year
    
    -- Environmental Operating Limits
    operating_temp_min INTEGER,             -- 5 (Celsius)
    operating_temp_max INTEGER,             -- 40 (Celsius)
    humidity_max INTEGER,                   -- 85 (percentage)
    
    -- Economic Data
    current_price_usd REAL,                -- 3500 (Current Bitcoin price)
    expected_lifespan_years REAL,          -- 5
    
    -- Power Requirements
    voltage_v INTEGER,                     -- 220
    power_connection_type VARCHAR(20),     -- "C19", "C13", "Hardwired"
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_manufacturer_model (manufacturer, model_name),
    INDEX idx_efficiency (efficiency_j_th),
    INDEX idx_hashrate (hashrate_th)
);
```

#### 1.3 solar_panel_models
**Purpose**: Essential solar panel specifications

```sql
CREATE TABLE solar_panel_models (
    id INTEGER PRIMARY KEY,
    manufacturer VARCHAR(50) NOT NULL,       -- "Canadian Solar", "SunPower", "Panasonic"
    model_name VARCHAR(100) NOT NULL,        -- "CS3W-400MS", "Maxeon 3 400W"
    
    -- Core Performance Specifications
    rated_power_w INTEGER NOT NULL,         -- 400 (Watts at STC)
    efficiency_percent REAL NOT NULL,       -- 20.5 (Efficiency percentage)
    temperature_coefficient REAL NOT NULL,  -- -0.35 (%/°C)
    
    -- Degradation Model
    degradation_rate_annual REAL DEFAULT 0.5, -- 0.5% per year
    
    -- Economic Data
    cost_per_watt REAL,                     -- 0.45 (USD per watt)
    expected_lifespan_years REAL,           -- 25
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_manufacturer_model (manufacturer, model_name),
    INDEX idx_efficiency (efficiency_percent)
);
```

#### 1.4 storage_models
**Purpose**: Essential battery storage specifications

```sql
CREATE TABLE storage_models (
    id INTEGER PRIMARY KEY,
    manufacturer VARCHAR(50) NOT NULL,       -- "Tesla", "LG Chem", "BYD"
    model_name VARCHAR(100) NOT NULL,        -- "Powerwall 2", "RESU 10H"
    technology VARCHAR(20) NOT NULL,         -- "LiFePO4", "Li-ion"
    
    -- Capacity & Performance
    capacity_kwh REAL NOT NULL,             -- 13.5 (Total capacity)
    usable_capacity_kwh REAL NOT NULL,      -- 13.5 (Usable capacity)
    max_charge_rate_kw REAL NOT NULL,       -- 5 (Maximum charge rate)
    max_discharge_rate_kw REAL NOT NULL,    -- 5 (Maximum discharge rate)
    round_trip_efficiency REAL NOT NULL,    -- 0.90 (90% round-trip efficiency)
    
    -- Degradation Model
    cycle_life INTEGER NOT NULL,            -- 6000 (Expected cycle life)
    calendar_degradation_annual REAL DEFAULT 0.02, -- 2% per year
    
    -- Economic Data
    cost_per_kwh REAL,                      -- 500 (USD per kWh of capacity)
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_manufacturer_model (manufacturer, model_name),
    INDEX idx_capacity (capacity_kwh)
);
```

### 2. TIME-SERIES DATA TABLES

#### 2.1 bitcoin_network_data
**Purpose**: Current Bitcoin network statistics

```sql
CREATE TABLE bitcoin_network_data (
    id INTEGER PRIMARY KEY,
    recorded_date DATE NOT NULL,            -- 2024-08-11
    difficulty BIGINT NOT NULL,             -- 90666502495565 (Current network difficulty)
    network_hashrate REAL NOT NULL,        -- 650.5 (EH/s - Exahashes per second)
    block_reward REAL NOT NULL,            -- 6.25 (BTC per block, includes halvings)
    avg_block_time REAL NOT NULL,          -- 605 (seconds - average over 2016 blocks)
    avg_transaction_fee REAL NOT NULL,     -- 0.0025 (BTC - average fee per transaction)
    data_source VARCHAR(50) NOT NULL,      -- "blockchain.info", "blockstream.info"
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_date (recorded_date)
);
```

#### 2.2 bitcoin_price_data
**Purpose**: Current Bitcoin price data

```sql
CREATE TABLE bitcoin_price_data (
    id INTEGER PRIMARY KEY,
    recorded_date DATE NOT NULL,            -- 2024-08-11
    price_usd REAL NOT NULL,               -- 45250.50 (Closing price)
    volume_24h REAL,                       -- 28500000000 (24h trading volume in USD)
    data_source VARCHAR(50) NOT NULL,      -- "coingecko", "coinmarketcap"
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_date (recorded_date)
);
```

#### 2.3 environmental_data
**Purpose**: Current environmental data for power generation

```sql
CREATE TABLE environmental_data (
    id INTEGER PRIMARY KEY,
    location_id INTEGER NOT NULL,           -- References locations.id
    recorded_date DATE NOT NULL,            -- 2024-08-11
    
    -- Solar Data
    ghi_daily REAL,                        -- 6.2 (kWh/m²/day - Global Horizontal Irradiance)
    dni_daily REAL,                        -- 7.8 (kWh/m²/day - Direct Normal Irradiance)
    sun_hours REAL,                        -- 8.5 (hours of direct sunlight)
    
    -- Weather Conditions
    temperature_avg REAL,                  -- 22.5 (Celsius - average temperature)
    temperature_min REAL,                  -- 18.0 (Celsius - minimum temperature)
    temperature_max REAL,                  -- 28.0 (Celsius - maximum temperature)
    humidity_avg REAL,                     -- 65 (percentage - average humidity)
    
    data_source VARCHAR(50) NOT NULL,      -- "openweathermap", "nrel"
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(location_id) REFERENCES locations(id),
    INDEX idx_location_date (location_id, recorded_date)
);
```

### 3. CONFIGURATION DATA TABLES

#### 3.1 system_configs
**Purpose**: User-defined mining system configurations

```sql
CREATE TABLE system_configs (
    id INTEGER PRIMARY KEY,
    config_name VARCHAR(100) NOT NULL,      -- "My Solar Mining Rig"
    description TEXT,                       -- User description of the configuration
    location_id INTEGER NOT NULL,           -- References locations.id
    
    -- Power Generation Configuration
    solar_panels JSON NOT NULL,             -- Array of solar panel configurations
    storage_systems JSON,                   -- Array of battery system configurations
    
    -- Mining Equipment Configuration
    miners JSON NOT NULL,                   -- Array of miner configurations
    
    -- Economic Parameters
    electricity_rate_usd_kwh REAL NOT NULL, -- 0.12 (Grid electricity rate)
    net_metering_rate_usd_kwh REAL,         -- 0.08 (Grid export rate)
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(location_id) REFERENCES locations(id),
    INDEX idx_config_name (config_name)
);
```

**Example solar_panels JSON**:
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

**Example miners JSON**:
```json
[
  {
    "model_id": 8,
    "quantity": 10,
    "power_limit_w": 3000
  }
]
```

### 4. RESULTS DATA TABLES

#### 4.1 projection_results
**Purpose**: Calculated projection results

```sql
CREATE TABLE projection_results (
    id INTEGER PRIMARY KEY,
    system_config_id INTEGER NOT NULL,      -- References system_configs.id
    projection_date DATE NOT NULL,          -- 2024-08-11
    
    -- Power Generation Results
    total_generation_kwh REAL NOT NULL,     -- 145.5 (Total daily generation)
    solar_generation_kwh REAL NOT NULL,     -- 125.0 (Solar contribution)
    
    -- Energy Flow Analysis
    mining_consumption_kwh REAL NOT NULL,   -- 780.0 (Total mining consumption)
    grid_import_kwh REAL DEFAULT 0,         -- 655.0 (Grid electricity used)
    grid_export_kwh REAL DEFAULT 0,         -- 15.0 (Excess solar exported)
    
    -- Mining Performance
    total_hashrate_th REAL NOT NULL,        -- 1100.0 (Total hashrate)
    effective_hashrate_th REAL NOT NULL,    -- 1045.0 (After degradation)
    btc_mined REAL NOT NULL,               -- 0.0125 (BTC earned this period)
    btc_price_usd REAL NOT NULL,           -- 45250.0 (BTC price used)
    
    -- Economic Results
    mining_revenue_usd REAL NOT NULL,       -- 565.625 (Gross mining revenue)
    electricity_cost_usd REAL NOT NULL,     -- 78.60 (Grid electricity cost)
    net_profit_usd REAL NOT NULL,          -- 481.525 (Daily net profit)
    
    -- System Performance Metrics
    solar_capacity_factor REAL,            -- 0.21 (Solar capacity factor)
    system_efficiency REAL,                -- 0.875 (Overall system efficiency)
    
    calculated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(system_config_id) REFERENCES system_configs(id),
    INDEX idx_config_date (system_config_id, projection_date)
);
```

## Database Indexes

### Essential Indexes
```sql
-- Time-series query optimization
CREATE INDEX idx_projection_config_date ON projection_results(system_config_id, projection_date);
CREATE INDEX idx_environmental_location_date ON environmental_data(location_id, recorded_date);
CREATE INDEX idx_bitcoin_network_date ON bitcoin_network_data(recorded_date);

-- Equipment lookup optimization  
CREATE INDEX idx_miner_efficiency ON miner_models(efficiency_j_th);
CREATE INDEX idx_solar_efficiency ON solar_panel_models(efficiency_percent);

-- Search optimization
CREATE INDEX idx_config_name ON system_configs(config_name);
```

## Data Retention Policy

- **Current data**: Keep indefinitely for calculations
- **Historical data**: Archive after 2 years, keep monthly summaries
- **Projection results**: Keep for 1 year, then aggregate to summaries

## Migration Strategy

### Phase 1: Core Tables
1. Reference data tables (locations, equipment catalogs)
2. Current time-series tables (Bitcoin network, price data)

### Phase 2: Configuration System
1. System configuration tables
2. Basic projection calculations

### Phase 3: Results and Analytics
1. Projection results tables
2. Basic performance tracking

---

**Document Status**: Simplified v1.0  
**Last Updated**: 2024-12-19  
**Next Review**: After Phase 1 implementation