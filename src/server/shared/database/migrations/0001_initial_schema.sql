-- Migration: Initial Schema for Solar Mining Calculator (Simplified)
-- Version: 0001
-- Description: Create core tables for miners, solar panels, projections, and related data

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- Table: locations
-- Geographic locations for solar resource calculations
CREATE TABLE locations (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    latitude REAL NOT NULL,
    longitude REAL NOT NULL,
    elevation REAL NOT NULL,
    timezone VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: miner_models
-- Essential Bitcoin ASIC miner specifications
CREATE TABLE miner_models (
    id INTEGER PRIMARY KEY,
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
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: solar_panel_models
-- Essential solar panel specifications
CREATE TABLE solar_panel_models (
    id INTEGER PRIMARY KEY,
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
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: storage_models
-- Essential battery storage specifications
CREATE TABLE storage_models (
    id INTEGER PRIMARY KEY,
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
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: bitcoin_network_data
-- Current Bitcoin network statistics
CREATE TABLE bitcoin_network_data (
    id INTEGER PRIMARY KEY,
    recorded_date DATE NOT NULL,
    difficulty BIGINT NOT NULL,
    network_hashrate REAL NOT NULL,
    block_reward REAL NOT NULL,
    avg_block_time REAL NOT NULL,
    avg_transaction_fee REAL NOT NULL,
    data_source VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: bitcoin_price_data
-- Current Bitcoin price data
CREATE TABLE bitcoin_price_data (
    id INTEGER PRIMARY KEY,
    recorded_date DATE NOT NULL,
    price_usd REAL NOT NULL,
    volume_24h REAL,
    data_source VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: environmental_data
-- Current environmental data for power generation
CREATE TABLE environmental_data (
    id INTEGER PRIMARY KEY,
    location_id INTEGER NOT NULL,
    recorded_date DATE NOT NULL,
    
    -- Solar Data
    ghi_daily REAL,
    dni_daily REAL,
    sun_hours REAL,
    
    -- Weather Conditions
    temperature_avg REAL,
    temperature_min REAL,
    temperature_max REAL,
    humidity_avg REAL,
    
    data_source VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(location_id) REFERENCES locations(id)
);

-- Table: system_configs
-- User-defined mining system configurations
CREATE TABLE system_configs (
    id INTEGER PRIMARY KEY,
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
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(location_id) REFERENCES locations(id)
);

-- Table: projection_results
-- Calculated projection results
CREATE TABLE projection_results (
    id INTEGER PRIMARY KEY,
    system_config_id INTEGER NOT NULL,
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
    
    calculated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(system_config_id) REFERENCES system_configs(id)
);

-- Create essential indexes
CREATE INDEX idx_miner_manufacturer_model ON miner_models(manufacturer, model_name);
CREATE INDEX idx_miner_efficiency ON miner_models(efficiency_j_th);
CREATE INDEX idx_miner_hashrate ON miner_models(hashrate_th);

CREATE INDEX idx_solar_manufacturer_model ON solar_panel_models(manufacturer, model_name);
CREATE INDEX idx_solar_efficiency ON solar_panel_models(efficiency_percent);

CREATE INDEX idx_storage_manufacturer_model ON storage_models(manufacturer, model_name);
CREATE INDEX idx_storage_capacity ON storage_models(capacity_kwh);

CREATE INDEX idx_bitcoin_network_date ON bitcoin_network_data(recorded_date);
CREATE INDEX idx_bitcoin_price_date ON bitcoin_price_data(recorded_date);
CREATE INDEX idx_environmental_location_date ON environmental_data(location_id, recorded_date);

CREATE INDEX idx_system_config_name ON system_configs(config_name);
CREATE INDEX idx_projection_config_date ON projection_results(system_config_id, projection_date);