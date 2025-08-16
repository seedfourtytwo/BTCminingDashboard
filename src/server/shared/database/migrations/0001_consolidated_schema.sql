-- Consolidated Schema: Solar Mining Calculator Database
-- Version: 0001 (Consolidated from 7 previous migrations)
-- Description: Complete database schema for solar-powered Bitcoin mining calculator
-- 
-- This schema consolidates all previous migrations:
-- - 0001: Initial schema (miners, solar panels, storage, basic projections)
-- - 0002: Battery-free mining support
-- - 0003: Inverter specifications and seasonal support
-- - 0004: API data alignment (monthly/daily/hourly environmental data)
-- - 0005: Single-user enhancement and business analysis
-- - 0006: Miner price depreciation tracking
-- - 0007: Complete environmental coverage and redundancy removal

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
    
    -- User-Friendly Fields (Migration 0005)
    user_nickname VARCHAR(100),
    purchase_date DATE,
    purchase_price_usd REAL,
    warranty_expiry DATE,
    notes TEXT,
    
    -- Price Depreciation Fields (Migration 0006)
    estimated_resale_value_usd REAL,
    depreciation_rate_annual REAL DEFAULT 0.25, -- 25% annual depreciation
    market_demand_factor REAL DEFAULT 1.0, -- How in-demand this model is (0.5-1.5)
    technology_obsolescence_factor REAL DEFAULT 1.0, -- How quickly tech becomes obsolete (0.5-1.5)
    last_price_update_date DATE,
    manual_price_override BOOLEAN DEFAULT false, -- If true, use manual price instead of calculated
    manual_current_price_usd REAL, -- User's manual price override
    manual_price_notes TEXT, -- Notes about manual price
    
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
    
    -- User-Friendly Fields (Migration 0005)
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
    
    -- User-Friendly Fields (Migration 0005)
    user_nickname VARCHAR(100),
    purchase_date DATE,
    purchase_price_usd REAL,
    installation_date DATE,
    warranty_expiry DATE,
    notes TEXT,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

-- Table: inverter_models (Migration 0003)
-- Inverter specifications for solar system
CREATE TABLE inverter_models (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    manufacturer VARCHAR(50) NOT NULL,
    model_name VARCHAR(100) NOT NULL,
    
    -- Core Specifications
    rated_power_w INTEGER NOT NULL,
    efficiency_percent REAL NOT NULL,
    input_voltage_range VARCHAR(50) NOT NULL, -- "200-800V"
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
    
    -- User-Friendly Fields (Migration 0005)
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
-- BITCOIN DATA
-- =============================================================================

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
    
    -- Enhanced Network Data (Migration 0005)
    avg_transaction_fee_sat_vb REAL,
    mempool_size_mb REAL,
    blocks_until_halving INTEGER,
    next_difficulty_estimate BIGINT,
    hashprice_usd_per_th REAL,
    revenue_per_th_usd REAL,
    profit_per_th_usd REAL,
    
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
    
    -- Enhanced Price Data (Migration 0005)
    market_cap_usd REAL,
    volume_24h_usd REAL,
    price_change_24h_percent REAL,
    volatility_30d REAL,
    price_change_7d_percent REAL,
    price_change_30d_percent REAL,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- ENVIRONMENTAL DATA (API-Aligned)
-- =============================================================================

-- Table: monthly_solar_data (Migration 0004 + 0007)
-- Monthly solar resource data from NREL API
CREATE TABLE monthly_solar_data (
    id INTEGER PRIMARY KEY,
    location_id INTEGER NOT NULL,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,  -- 1-12
    
    -- Monthly averages from NREL API
    ghi_monthly_avg REAL,    -- Average daily GHI for the month (kWh/m²/day)
    dni_monthly_avg REAL,    -- Average daily DNI for the month (kWh/m²/day)
    sun_hours_monthly_avg REAL,  -- Average daily sun hours for the month
    temperature_monthly_avg REAL, -- Average daily temperature for the month (°C)
    
    -- Enhanced environmental data (Migration 0007)
    temperature_min_monthly_avg REAL, -- Monthly average of daily minimum temperature
    temperature_max_monthly_avg REAL, -- Monthly average of daily maximum temperature
    humidity_monthly_avg REAL, -- Monthly average humidity
    atmospheric_pressure_monthly_avg REAL, -- Monthly average atmospheric pressure
    
    -- Derived seasonal classification
    season VARCHAR(10),      -- 'spring', 'summer', 'fall', 'winter'
    
    data_source VARCHAR(50) NOT NULL,  -- 'nrel', 'nasa_power'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(location_id, year, month),
    FOREIGN KEY(location_id) REFERENCES locations(id)
);

-- Table: daily_forecast_data (Migration 0004 + 0007)
-- Daily weather forecasts from OpenWeatherMap API
CREATE TABLE daily_forecast_data (
    id INTEGER PRIMARY KEY,
    location_id INTEGER NOT NULL,
    forecast_date DATE NOT NULL,
    
    -- Daily forecast data from OpenWeatherMap
    ghi_forecast REAL,       -- Forecasted daily GHI (kWh/m²/day)
    temperature_forecast REAL, -- Forecasted daily temperature (°C)
    cloud_cover_forecast REAL, -- Forecasted cloud cover percentage (0-100)
    humidity_forecast REAL,   -- Forecasted humidity percentage (0-100)
    wind_speed_forecast REAL, -- Forecasted wind speed (m/s)
    
    -- Enhanced environmental data (Migration 0007)
    dni_forecast REAL, -- Forecasted daily DNI
    sun_hours_forecast REAL, -- Forecasted daily sun hours
    temperature_min_forecast REAL, -- Forecasted daily minimum temperature
    temperature_max_forecast REAL, -- Forecasted daily maximum temperature
    weather_condition_forecast VARCHAR(20), -- Forecasted weather condition
    atmospheric_pressure_forecast REAL, -- Forecasted atmospheric pressure
    
    -- Forecast metadata
    forecast_horizon_days INTEGER,  -- How many days ahead this forecast is
    confidence_level REAL,          -- Forecast confidence level (0-1)
    
    data_source VARCHAR(50) NOT NULL,  -- 'openweathermap', 'nws'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY(location_id) REFERENCES locations(id)
);

-- Table: hourly_forecast_data (Migration 0004 + 0007)
-- Hourly weather forecasts for detailed short-term planning
CREATE TABLE hourly_forecast_data (
    id INTEGER PRIMARY KEY,
    location_id INTEGER NOT NULL,
    forecast_datetime DATETIME NOT NULL,  -- Specific hour being forecasted
    
    -- Hourly forecast data
    ghi_hourly_forecast REAL,     -- Forecasted hourly GHI (W/m²)
    temperature_hourly_forecast REAL, -- Forecasted hourly temperature (°C)
    cloud_cover_hourly_forecast REAL, -- Forecasted hourly cloud cover (%)
    
    -- Enhanced environmental data (Migration 0007)
    dni_hourly_forecast REAL, -- Forecasted hourly DNI
    temperature_min_hourly_forecast REAL, -- Forecasted hourly minimum temperature
    temperature_max_hourly_forecast REAL, -- Forecasted hourly maximum temperature
    humidity_hourly_forecast REAL, -- Forecasted hourly humidity
    weather_condition_hourly_forecast VARCHAR(20), -- Forecasted hourly weather condition
    atmospheric_pressure_hourly_forecast REAL, -- Forecasted hourly atmospheric pressure
    
    -- Forecast metadata
    forecast_horizon_hours INTEGER,  -- How many hours ahead this forecast is
    confidence_level REAL,           -- Forecast confidence level (0-1)
    
    data_source VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY(location_id) REFERENCES locations(id)
);

-- =============================================================================
-- SYSTEM CONFIGURATIONS
-- =============================================================================

-- Table: system_configs
-- User-defined mining system configurations
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
    
    -- Battery-Free Mining Support (Migration 0002)
    grid_connection_type VARCHAR(20) DEFAULT 'none',
    mining_mode VARCHAR(20) DEFAULT 'solar_only',
    max_grid_power_kw REAL DEFAULT 0,
    mining_schedule JSON,
    auto_calculate_hours BOOLEAN DEFAULT true,
    manual_mining_hours_per_day REAL DEFAULT 0,
    
    -- Inverter Configuration (Migration 0003)
    inverter_id INTEGER,
    inverter_quantity INTEGER DEFAULT 1,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(location_id) REFERENCES locations(id),
    FOREIGN KEY(inverter_id) REFERENCES inverter_models(id)
);

-- =============================================================================
-- PROJECTION SCENARIOS
-- =============================================================================

-- Table: projection_scenarios
-- User-customizable projection parameters for "what-if" analysis
CREATE TABLE projection_scenarios (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    system_config_id INTEGER NOT NULL,
    scenario_name VARCHAR(100) NOT NULL,
    description TEXT,
    
    -- Bitcoin Market Parameters (JSON for flexibility)
    bitcoin_parameters JSON, -- {"price_usd": 30000, "difficulty_multiplier": 1.2, "hashprice_usd_per_th": 0.08}
    
    -- Economic Parameters
    economic_parameters JSON, -- {"electricity_rate_usd_kwh": 0.15, "net_metering_rate_usd_kwh": 0.08}
    
    -- Environmental Parameters
    environmental_parameters JSON, -- {"weather_impact_multiplier": 0.9, "temperature_impact_multiplier": 0.95}
    
    -- Equipment Performance Parameters
    equipment_parameters JSON, -- {"degradation_multiplier": 1.1, "efficiency_multiplier": 0.98}
    
    -- Scenario metadata
    is_baseline BOOLEAN DEFAULT false, -- Current market conditions (from APIs)
    is_active BOOLEAN DEFAULT false, -- Currently selected for calculations
    is_user_created BOOLEAN DEFAULT true, -- True if user created, false if system-generated
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(system_config_id) REFERENCES system_configs(id),
    UNIQUE(system_config_id, scenario_name)
);

-- =============================================================================
-- PROJECTION RESULTS
-- =============================================================================

-- Table: projection_results
-- Calculated projection results
CREATE TABLE projection_results (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    system_config_id INTEGER NOT NULL,
    scenario_id INTEGER NOT NULL, -- Link to projection_scenarios
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
    
    -- Battery-Free Mining Results (Migration 0002)
    solar_direct_to_mining_kwh REAL DEFAULT 0,
    solar_wasted_kwh REAL DEFAULT 0,
    mining_hours_solar_only REAL DEFAULT 0,
    mining_hours_grid_assisted REAL DEFAULT 0,
    effective_mining_hours REAL DEFAULT 0,
    solar_availability_hours REAL DEFAULT 0,
    mining_availability_percent REAL DEFAULT 0,
    
    -- Seasonal Performance Tracking (Migration 0003)
    season VARCHAR(10),
    cloud_cover_avg_percent REAL,
    weather_impact_factor REAL DEFAULT 1.0,
    
    -- Business Analysis Fields (Migration 0005)
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
    
    -- Equipment Resale Value Tracking (Migration 0006)
    equipment_resale_value_usd REAL,
    total_investment_with_resale_usd REAL,
    adjusted_roi_percent REAL,
    net_equipment_value_usd REAL,
    
    calculated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(system_config_id) REFERENCES system_configs(id),
    FOREIGN KEY(scenario_id) REFERENCES projection_scenarios(id)
);

-- =============================================================================
-- HISTORICAL DATA
-- =============================================================================

-- Table: miner_price_history (Migration 0006)
-- Historical price tracking for miners
CREATE TABLE miner_price_history (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    miner_model_id INTEGER NOT NULL,
    recorded_date DATE NOT NULL,
    market_price_usd REAL NOT NULL,
    resale_price_usd REAL,
    market_demand_level VARCHAR(20), -- 'high', 'medium', 'low'
    depreciation_rate_used REAL, -- The depreciation rate used for this calculation
    calculation_method VARCHAR(20), -- 'automatic', 'manual', 'external'
    data_source VARCHAR(50),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(miner_model_id) REFERENCES miner_models(id)
);

-- =============================================================================
-- JSON VALIDATION AND HELPER FUNCTIONS
-- =============================================================================

-- JSON Validation: Ensure valid JSON structure
ALTER TABLE system_configs ADD CONSTRAINT chk_solar_panels_json 
CHECK (json_valid(solar_panels) AND json_type(solar_panels) = 'array');

ALTER TABLE system_configs ADD CONSTRAINT chk_miners_json 
CHECK (json_valid(miners) AND json_type(miners) = 'array');

ALTER TABLE system_configs ADD CONSTRAINT chk_storage_systems_json 
CHECK (storage_systems IS NULL OR (json_valid(storage_systems) AND json_type(storage_systems) = 'array'));

-- JSON Structure: Ensure required fields exist
ALTER TABLE system_configs ADD CONSTRAINT chk_solar_panel_structure
CHECK (
  json_array_length(solar_panels) = 0 OR
  (json_extract(solar_panels, '$[0].model_id') IS NOT NULL AND 
   json_extract(solar_panels, '$[0].quantity') IS NOT NULL AND 
   json_extract(solar_panels, '$[0].quantity') > 0)
);

ALTER TABLE system_configs ADD CONSTRAINT chk_miner_structure
CHECK (
  json_array_length(miners) = 0 OR
  (json_extract(miners, '$[0].model_id') IS NOT NULL AND 
   json_extract(miners, '$[0].quantity') IS NOT NULL AND 
   json_extract(miners, '$[0].quantity') > 0)
);

-- Core Helper Functions
CREATE FUNCTION get_system_solar_capacity_w(system_id INTEGER) RETURNS REAL AS $$
BEGIN
  RETURN COALESCE((
    SELECT SUM(json_extract(panel, '$.quantity')::INTEGER * spm.rated_power_w)
    FROM system_configs sc,
         json_array_elements(sc.solar_panels) AS panel,
         solar_panel_models spm
    WHERE sc.id = system_id 
      AND json_extract(panel, '$.model_id')::INTEGER = spm.id
      AND sc.user_id = spm.user_id
  ), 0);
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION get_system_total_hashrate_th(system_id INTEGER) RETURNS REAL AS $$
BEGIN
  RETURN COALESCE((
    SELECT SUM(json_extract(miner, '$.quantity')::INTEGER * mm.hashrate_th)
    FROM system_configs sc,
         json_array_elements(sc.miners) AS miner,
         miner_models mm
    WHERE sc.id = system_id 
      AND json_extract(miner, '$.model_id')::INTEGER = mm.id
      AND sc.user_id = mm.user_id
  ), 0);
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION get_system_mining_power_w(system_id INTEGER) RETURNS REAL AS $$
BEGIN
  RETURN COALESCE((
    SELECT SUM(json_extract(miner, '$.quantity')::INTEGER * 
               COALESCE(json_extract(miner, '$.power_limit_w')::INTEGER, mm.power_consumption_w))
    FROM system_configs sc,
         json_array_elements(sc.miners) AS miner,
         miner_models mm
    WHERE sc.id = system_id 
      AND json_extract(miner, '$.model_id')::INTEGER = mm.id
      AND sc.user_id = mm.user_id
  ), 0);
END;
$$ LANGUAGE plpgsql;

-- JSON Schema Documentation
COMMENT ON COLUMN system_configs.solar_panels IS '
Array of solar panel configs: [{"model_id": 15, "quantity": 50, "tilt_angle": 30, "azimuth": 180}]
Required: model_id, quantity. Optional: tilt_angle (0-90), azimuth (0-360)
';

COMMENT ON COLUMN system_configs.miners IS '
Array of miner configs: [{"model_id": 8, "quantity": 10, "power_limit_w": 3000}]
Required: model_id, quantity. Optional: power_limit_w
';

COMMENT ON COLUMN system_configs.storage_systems IS '
Array of storage configs: [{"model_id": 3, "quantity": 2}]
Required: model_id, quantity. Optional field.
';

COMMENT ON COLUMN projection_scenarios.bitcoin_parameters IS '
Bitcoin market params: {"price_usd": 30000, "difficulty_multiplier": 1.2}
All fields optional - null = use current API data
';

COMMENT ON COLUMN projection_scenarios.economic_parameters IS '
Economic params: {"electricity_rate_usd_kwh": 0.15, "maintenance_cost_multiplier": 1.2}
All fields optional - null = use system config values
';

-- =============================================================================
-- DATA VALIDATION CONSTRAINTS
-- =============================================================================

-- Equipment Performance Constraints
ALTER TABLE miner_models ADD CONSTRAINT chk_hashrate_positive CHECK (hashrate_th > 0);
ALTER TABLE miner_models ADD CONSTRAINT chk_power_positive CHECK (power_consumption_w > 0);
ALTER TABLE miner_models ADD CONSTRAINT chk_efficiency_positive CHECK (efficiency_j_th > 0);
ALTER TABLE miner_models ADD CONSTRAINT chk_degradation_range CHECK (hashrate_degradation_annual BETWEEN 0 AND 1);
ALTER TABLE miner_models ADD CONSTRAINT chk_failure_rate_range CHECK (failure_rate_annual BETWEEN 0 AND 1);

ALTER TABLE solar_panel_models ADD CONSTRAINT chk_solar_power_positive CHECK (rated_power_w > 0);
ALTER TABLE solar_panel_models ADD CONSTRAINT chk_solar_efficiency_range CHECK (efficiency_percent BETWEEN 0 AND 100);
ALTER TABLE solar_panel_models ADD CONSTRAINT chk_solar_degradation_range CHECK (degradation_rate_annual BETWEEN 0 AND 10);

ALTER TABLE storage_models ADD CONSTRAINT chk_storage_capacity_positive CHECK (capacity_kwh > 0);
ALTER TABLE storage_models ADD CONSTRAINT chk_storage_efficiency_range CHECK (round_trip_efficiency BETWEEN 0 AND 1);
ALTER TABLE storage_models ADD CONSTRAINT chk_storage_cycle_life_positive CHECK (cycle_life > 0);

ALTER TABLE inverter_models ADD CONSTRAINT chk_inverter_power_positive CHECK (rated_power_w > 0);
ALTER TABLE inverter_models ADD CONSTRAINT chk_inverter_efficiency_range CHECK (efficiency_percent BETWEEN 0 AND 100);

-- Geographic Constraints
ALTER TABLE locations ADD CONSTRAINT chk_latitude_range CHECK (latitude BETWEEN -90 AND 90);
ALTER TABLE locations ADD CONSTRAINT chk_longitude_range CHECK (longitude BETWEEN -180 AND 180);
ALTER TABLE locations ADD CONSTRAINT chk_elevation_range CHECK (elevation BETWEEN -1000 AND 10000);

-- Economic Constraints
ALTER TABLE system_configs ADD CONSTRAINT chk_electricity_rate_positive CHECK (electricity_rate_usd_kwh > 0);
ALTER TABLE system_configs ADD CONSTRAINT chk_net_metering_rate_positive CHECK (net_metering_rate_usd_kwh IS NULL OR net_metering_rate_usd_kwh >= 0);

-- Bitcoin Data Constraints
ALTER TABLE bitcoin_network_data ADD CONSTRAINT chk_difficulty_positive CHECK (difficulty > 0);
ALTER TABLE bitcoin_network_data ADD CONSTRAINT chk_hashrate_positive CHECK (network_hashrate > 0);
ALTER TABLE bitcoin_network_data ADD CONSTRAINT chk_block_reward_positive CHECK (block_reward > 0);

ALTER TABLE bitcoin_price_data ADD CONSTRAINT chk_price_positive CHECK (price_usd > 0);

-- Projection Results Constraints
ALTER TABLE projection_results ADD CONSTRAINT chk_revenue_positive CHECK (mining_revenue_usd >= 0);
ALTER TABLE projection_results ADD CONSTRAINT chk_cost_positive CHECK (electricity_cost_usd >= 0);
ALTER TABLE projection_results ADD CONSTRAINT chk_profit_reasonable CHECK (net_profit_usd >= -1000000); -- Allow negative but not extreme
ALTER TABLE projection_results ADD CONSTRAINT chk_roi_reasonable CHECK (roi_percent BETWEEN -100 AND 10000); -- Allow negative ROI but not extreme
ALTER TABLE projection_results ADD CONSTRAINT chk_payback_reasonable CHECK (payback_period_months BETWEEN 0 AND 600); -- 0-50 years

-- Environmental Data Constraints
ALTER TABLE monthly_solar_data ADD CONSTRAINT chk_ghi_positive CHECK (ghi_monthly_avg >= 0);
ALTER TABLE monthly_solar_data ADD CONSTRAINT chk_dni_positive CHECK (dni_monthly_avg >= 0);
ALTER TABLE monthly_solar_data ADD CONSTRAINT chk_sun_hours_reasonable CHECK (sun_hours_monthly_avg BETWEEN 0 AND 24);

ALTER TABLE daily_forecast_data ADD CONSTRAINT chk_forecast_ghi_positive CHECK (ghi_forecast >= 0);
ALTER TABLE daily_forecast_data ADD CONSTRAINT chk_forecast_temp_reasonable CHECK (temperature_forecast BETWEEN -50 AND 80);
ALTER TABLE daily_forecast_data ADD CONSTRAINT chk_cloud_cover_range CHECK (cloud_cover_forecast BETWEEN 0 AND 100);

-- =============================================================================
-- API DATA MANAGEMENT
-- =============================================================================

-- Table: api_data_sources
-- Track external API sources and their status
CREATE TABLE api_data_sources (
    id INTEGER PRIMARY KEY,
    source_name VARCHAR(50) NOT NULL UNIQUE, -- 'coingecko', 'nrel', 'openweathermap'
    endpoint_url TEXT NOT NULL,
    last_fetch_time DATETIME,
    is_active BOOLEAN DEFAULT true,
    error_count INTEGER DEFAULT 0,
    last_error_message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: api_errors
-- Track API errors for debugging and monitoring
CREATE TABLE api_errors (
    id INTEGER PRIMARY KEY,
    source_name VARCHAR(50) NOT NULL,
    error_message TEXT NOT NULL,
    error_data JSON,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Add data freshness tracking to existing tables
ALTER TABLE bitcoin_price_data ADD COLUMN data_freshness_minutes INTEGER;
ALTER TABLE bitcoin_network_data ADD COLUMN data_freshness_minutes INTEGER;
ALTER TABLE daily_forecast_data ADD COLUMN data_freshness_minutes INTEGER;
ALTER TABLE hourly_forecast_data ADD COLUMN data_freshness_minutes INTEGER;

-- =============================================================================
-- INDEXES FOR PERFORMANCE
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
CREATE INDEX idx_system_configs_user ON system_configs(user_id);
CREATE INDEX idx_projection_scenarios_user ON projection_scenarios(user_id);
CREATE INDEX idx_projection_results_user ON projection_results(user_id);
CREATE INDEX idx_miner_price_history_user ON miner_price_history(user_id);

-- Bitcoin data indexes
CREATE INDEX idx_bitcoin_network_date ON bitcoin_network_data(recorded_date);
CREATE INDEX idx_bitcoin_network_hashprice ON bitcoin_network_data(hashprice_usd_per_th);
CREATE INDEX idx_bitcoin_network_revenue_per_th ON bitcoin_network_data(revenue_per_th_usd);

CREATE INDEX idx_bitcoin_price_date ON bitcoin_price_data(recorded_date);
CREATE INDEX idx_bitcoin_price_volatility ON bitcoin_price_data(volatility_30d);
CREATE INDEX idx_bitcoin_price_change_24h ON bitcoin_price_data(price_change_24h_percent);

-- Environmental data indexes
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

-- System configuration indexes
CREATE INDEX idx_system_config_name ON system_configs(config_name);
CREATE INDEX idx_system_config_mining_mode ON system_configs(mining_mode);
CREATE INDEX idx_system_config_grid_type ON system_configs(grid_connection_type);
CREATE INDEX idx_system_config_inverter ON system_configs(inverter_id);

-- Projection scenarios indexes
CREATE INDEX idx_projection_scenarios_config ON projection_scenarios(system_config_id);
CREATE INDEX idx_projection_scenarios_baseline ON projection_scenarios(is_baseline);
CREATE INDEX idx_projection_scenarios_active ON projection_scenarios(is_active);
CREATE INDEX idx_projection_scenarios_user_created ON projection_scenarios(is_user_created);

-- Projection results indexes
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

-- Historical data indexes
CREATE INDEX idx_miner_price_history_model_date ON miner_price_history(miner_model_id, recorded_date);
CREATE INDEX idx_miner_price_history_demand ON miner_price_history(market_demand_level);
CREATE INDEX idx_miner_price_history_calculation ON miner_price_history(calculation_method);

-- API management indexes
CREATE INDEX idx_api_data_sources_active ON api_data_sources(is_active, last_fetch_time);
CREATE INDEX idx_api_errors_source_time ON api_errors(source_name, created_at);
CREATE INDEX idx_bitcoin_price_freshness ON bitcoin_price_data(data_freshness_minutes);
CREATE INDEX idx_bitcoin_network_freshness ON bitcoin_network_data(data_freshness_minutes);
CREATE INDEX idx_daily_forecast_freshness ON daily_forecast_data(data_freshness_minutes);
CREATE INDEX idx_hourly_forecast_freshness ON hourly_forecast_data(data_freshness_minutes);

-- =============================================================================
-- SCHEMA COMPLETION NOTES
-- =============================================================================

-- This consolidated schema includes all features from the original 7 migrations plus scenario management:
-- 
-- 1. Core equipment specifications (miners, solar panels, storage, inverters)
-- 2. Battery-free and grid-free mining support
-- 3. Seasonal and weather impact analysis
-- 4. API-aligned environmental data (monthly, daily, hourly)
-- 5. Single-user manual equipment entry capabilities
-- 6. Comprehensive business analysis metrics
-- 7. Equipment value depreciation tracking
-- 8. Complete environmental coverage without redundancy
-- 9. Projection scenario management for "what-if" analysis
--
-- The schema is designed for:
-- - Personal but business-oriented use
-- - Manual equipment entry via frontend
-- - Battery-free solar mining scenarios
-- - Detailed financial projections
-- - Environmental performance optimization
-- - Equipment value tracking over time
-- - Flexible scenario-based projections

-- =============================================================================
-- JSON PARAMETER STRUCTURES FOR PROJECTION SCENARIOS
-- =============================================================================

-- bitcoin_parameters JSON structure:
-- {
--   "price_usd": 30000,                    -- Override Bitcoin price (null = use API)
--   "difficulty_multiplier": 1.2,          -- Multiply current difficulty by this factor
--   "hashprice_usd_per_th": 0.08,         -- Override hashprice (null = calculate from price/difficulty)
--   "network_hashrate_multiplier": 1.1,   -- Multiply current network hashrate
--   "block_reward_multiplier": 1.0        -- Multiply current block reward
-- }

-- economic_parameters JSON structure:
-- {
--   "electricity_rate_usd_kwh": 0.15,     -- Override electricity rate
--   "net_metering_rate_usd_kwh": 0.08,    -- Override net metering rate
--   "maintenance_cost_multiplier": 1.2,   -- Multiply maintenance costs
--   "insurance_cost_multiplier": 1.0,     -- Multiply insurance costs
--   "property_tax_multiplier": 1.0        -- Multiply property tax
-- }

-- environmental_parameters JSON structure:
-- {
--   "weather_impact_multiplier": 0.9,     -- Multiply solar generation (0.9 = 10% reduction)
--   "temperature_impact_multiplier": 0.95, -- Multiply mining efficiency due to temperature
--   "cloud_cover_adjustment": 0.1,        -- Add/subtract from cloud cover percentage
--   "seasonal_adjustment": "summer"       -- Override season for calculations
-- }

-- equipment_parameters JSON structure:
-- {
--   "degradation_multiplier": 1.1,        -- Multiply annual degradation rates
--   "efficiency_multiplier": 0.98,        -- Multiply equipment efficiency
--   "failure_rate_multiplier": 1.2,       -- Multiply failure rates
--   "lifespan_multiplier": 0.9            -- Multiply expected lifespan
-- }
