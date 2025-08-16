-- Migration 0001: Core Foundation
-- Description: User management, basic equipment tables, and locations
-- Dependencies: None

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- =============================================================================
-- USER MANAGEMENT SYSTEM
-- =============================================================================

-- Table: users
-- User accounts for data isolation (single-user initially, multi-user ready)
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

-- =============================================================================
-- CORE LOCATION DATA
-- =============================================================================

-- Table: locations
-- Geographic locations for solar resource calculations
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

-- =============================================================================
-- EQUIPMENT SPECIFICATIONS
-- =============================================================================

-- Table: miner_models
-- Essential Bitcoin ASIC miner specifications
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

-- Table: solar_panel_models
-- Essential solar panel specifications
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

-- Table: storage_models
-- Essential battery storage specifications
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

-- Table: inverter_models
-- Inverter specifications for solar system
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

-- =============================================================================
-- CORE INDEXES
-- =============================================================================

-- Equipment indexes
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

-- User data isolation indexes
CREATE INDEX idx_locations_user ON locations(user_id);
CREATE INDEX idx_miner_models_user ON miner_models(user_id);
CREATE INDEX idx_solar_panel_models_user ON solar_panel_models(user_id);
CREATE INDEX idx_storage_models_user ON storage_models(user_id);
CREATE INDEX idx_inverter_models_user ON inverter_models(user_id);
