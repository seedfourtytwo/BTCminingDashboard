-- Migration: Initial Schema for Solar Mining Calculator
-- Version: 0001
-- Description: Create core tables for miners, solar panels, projections, and related data

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- Table: miners
-- Stores ASIC miner specifications and performance data
CREATE TABLE miners (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    manufacturer TEXT NOT NULL,
    model TEXT NOT NULL,
    
    -- Performance specifications
    hashrate_th REAL NOT NULL CHECK (hashrate_th > 0),
    power_consumption_w INTEGER NOT NULL CHECK (power_consumption_w > 0),
    efficiency_j_th REAL NOT NULL CHECK (efficiency_j_th > 0),
    
    -- Physical specifications
    dimensions_mm TEXT, -- JSON: {"length": 400, "width": 195, "height": 290}
    weight_kg REAL,
    noise_level_db INTEGER,
    operating_temp_range TEXT, -- JSON: {"min": -5, "max": 40}
    
    -- Economic data
    msrp_usd REAL,
    release_date DATE,
    discontinuation_date DATE,
    
    -- Performance characteristics
    hashrate_degradation_annual REAL DEFAULT 0.005 CHECK (hashrate_degradation_annual >= 0),
    efficiency_degradation_annual REAL DEFAULT 0.002 CHECK (efficiency_degradation_annual >= 0),
    failure_rate_annual REAL DEFAULT 0.02 CHECK (failure_rate_annual >= 0 AND failure_rate_annual <= 1),
    
    -- Metadata
    data_source TEXT,
    verified BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: solar_panels
-- Stores solar panel specifications and performance data
CREATE TABLE solar_panels (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    manufacturer TEXT NOT NULL,
    model TEXT NOT NULL,
    
    -- Electrical specifications (STC - Standard Test Conditions)
    rated_power_w REAL NOT NULL CHECK (rated_power_w > 0),
    voltage_vmp REAL NOT NULL CHECK (voltage_vmp > 0),
    current_imp REAL NOT NULL CHECK (current_imp > 0),
    voltage_voc REAL NOT NULL CHECK (voltage_voc > 0),
    current_isc REAL NOT NULL CHECK (current_isc > 0),
    
    -- Physical specifications
    panel_area_m2 REAL NOT NULL CHECK (panel_area_m2 > 0),
    dimensions_mm TEXT, -- JSON: {"length": 2108, "width": 1048, "height": 40}
    weight_kg REAL,
    
    -- Performance characteristics
    efficiency_percent REAL NOT NULL CHECK (efficiency_percent > 0 AND efficiency_percent <= 100),
    temperature_coefficient REAL NOT NULL, -- %/°C (typically negative)
    degradation_rate_annual REAL DEFAULT 0.005 CHECK (degradation_rate_annual >= 0),
    
    -- Durability and ratings
    max_system_voltage INTEGER,
    fire_rating TEXT,
    hail_rating TEXT,
    wind_load_rating INTEGER,
    
    -- Economic data
    msrp_usd REAL,
    warranty_years INTEGER DEFAULT 25,
    
    -- Technology details
    cell_technology TEXT, -- Monocrystalline, Polycrystalline, Thin-film, etc.
    number_of_cells INTEGER,
    
    -- Metadata
    data_source TEXT,
    verified BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: wind_turbines
-- Stores wind turbine specifications and performance data
CREATE TABLE wind_turbines (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    manufacturer TEXT NOT NULL,
    model TEXT NOT NULL,
    
    -- Power specifications
    rated_power_w REAL NOT NULL CHECK (rated_power_w > 0),
    cut_in_speed_ms REAL NOT NULL CHECK (cut_in_speed_ms > 0),
    cut_out_speed_ms REAL NOT NULL CHECK (cut_out_speed_ms > cut_in_speed_ms),
    rated_wind_speed_ms REAL NOT NULL CHECK (rated_wind_speed_ms > 0),
    
    -- Physical specifications
    rotor_diameter_m REAL NOT NULL CHECK (rotor_diameter_m > 0),
    hub_height_m REAL NOT NULL CHECK (hub_height_m > 0),
    swept_area_m2 REAL NOT NULL CHECK (swept_area_m2 > 0),
    
    -- Power curve data (JSON array of {wind_speed, power} points)
    power_curve TEXT NOT NULL, -- JSON array
    
    -- Economic data
    msrp_usd REAL,
    installation_cost_usd REAL,
    maintenance_cost_annual_usd REAL,
    
    -- Metadata
    data_source TEXT,
    verified BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: system_configurations
-- Stores complete system configurations for projections
CREATE TABLE system_configurations (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    
    -- Mining equipment
    miner_id TEXT NOT NULL,
    miner_quantity INTEGER NOT NULL CHECK (miner_quantity > 0),
    miner_efficiency_factor REAL DEFAULT 1.0 CHECK (miner_efficiency_factor > 0),
    
    -- Solar power system
    solar_panel_id TEXT,
    solar_panel_quantity INTEGER DEFAULT 0 CHECK (solar_panel_quantity >= 0),
    solar_system_efficiency REAL DEFAULT 0.85 CHECK (solar_system_efficiency > 0 AND solar_system_efficiency <= 1),
    solar_inverter_efficiency REAL DEFAULT 0.95 CHECK (solar_inverter_efficiency > 0 AND solar_inverter_efficiency <= 1),
    
    -- Wind power system (optional)
    wind_turbine_id TEXT,
    wind_turbine_quantity INTEGER DEFAULT 0 CHECK (wind_turbine_quantity >= 0),
    wind_hub_height_m REAL,
    
    -- Location and environmental data
    latitude REAL NOT NULL CHECK (latitude >= -90 AND latitude <= 90),
    longitude REAL NOT NULL CHECK (longitude >= -180 AND longitude <= 180),
    elevation_m REAL DEFAULT 0,
    timezone TEXT NOT NULL,
    
    -- Battery storage (optional)
    battery_capacity_kwh REAL DEFAULT 0 CHECK (battery_capacity_kwh >= 0),
    battery_efficiency REAL DEFAULT 0.90 CHECK (battery_efficiency > 0 AND battery_efficiency <= 1),
    
    -- Grid connection
    grid_connection BOOLEAN DEFAULT FALSE,
    electricity_rate_usd_kwh REAL DEFAULT 0.10 CHECK (electricity_rate_usd_kwh >= 0),
    net_metering BOOLEAN DEFAULT FALSE,
    
    -- Economic parameters
    discount_rate REAL DEFAULT 0.08 CHECK (discount_rate >= 0),
    electricity_rate_escalation REAL DEFAULT 0.02,
    
    -- Metadata
    created_by TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    FOREIGN KEY (miner_id) REFERENCES miners(id),
    FOREIGN KEY (solar_panel_id) REFERENCES solar_panels(id),
    FOREIGN KEY (wind_turbine_id) REFERENCES wind_turbines(id)
);

-- Table: projections
-- Stores calculation results and projection scenarios
CREATE TABLE projections (
    id TEXT PRIMARY KEY,
    system_config_id TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    
    -- Projection parameters
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    calculation_interval TEXT DEFAULT 'daily', -- daily, weekly, monthly
    
    -- Bitcoin network assumptions
    btc_price_model TEXT NOT NULL, -- JSON configuration
    difficulty_model TEXT NOT NULL, -- JSON configuration
    block_reward_halvings TEXT, -- JSON array of halving dates
    
    -- Results summary (JSON data)
    results_summary TEXT NOT NULL, -- JSON with key metrics
    daily_results TEXT, -- JSON array of daily calculations
    monthly_results TEXT, -- JSON array of monthly summaries
    annual_results TEXT, -- JSON array of annual summaries
    
    -- Financial metrics
    total_investment_usd REAL,
    total_revenue_usd REAL,
    total_profit_usd REAL,
    roi_percent REAL,
    payback_period_years REAL,
    npv_usd REAL,
    irr_percent REAL,
    
    -- Performance metrics
    total_energy_generated_kwh REAL,
    total_btc_mined REAL,
    average_capacity_factor REAL,
    
    -- Calculation metadata
    calculation_time_ms INTEGER,
    calculation_version TEXT,
    
    -- Metadata
    created_by TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (system_config_id) REFERENCES system_configurations(id)
);

-- Table: weather_data
-- Stores historical and forecast weather data for locations
CREATE TABLE weather_data (
    id TEXT PRIMARY KEY,
    location_hash TEXT NOT NULL, -- Hash of lat/lng for grouping
    latitude REAL NOT NULL,
    longitude REAL NOT NULL,
    
    -- Date and time
    date DATE NOT NULL,
    hour INTEGER CHECK (hour >= 0 AND hour <= 23),
    
    -- Solar irradiance data (W/m²)
    ghi REAL, -- Global Horizontal Irradiance
    dni REAL, -- Direct Normal Irradiance
    dhi REAL, -- Diffuse Horizontal Irradiance
    
    -- Weather conditions
    temperature_c REAL,
    humidity_percent REAL,
    wind_speed_ms REAL,
    wind_direction_deg REAL,
    pressure_hpa REAL,
    cloud_cover_percent REAL,
    
    -- Data source and quality
    data_source TEXT NOT NULL,
    data_quality TEXT DEFAULT 'good', -- good, fair, poor, estimated
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(location_hash, date, hour)
);

-- Table: bitcoin_network_data
-- Stores historical Bitcoin network statistics
CREATE TABLE bitcoin_network_data (
    id TEXT PRIMARY KEY,
    recorded_date DATE NOT NULL UNIQUE,
    
    -- Price data
    price_usd REAL NOT NULL CHECK (price_usd > 0),
    market_cap_usd REAL,
    volume_24h_usd REAL,
    
    -- Network data
    network_hashrate_eh REAL NOT NULL CHECK (network_hashrate_eh > 0),
    difficulty REAL NOT NULL CHECK (difficulty > 0),
    block_height INTEGER NOT NULL CHECK (block_height > 0),
    block_reward REAL NOT NULL CHECK (block_reward > 0),
    transaction_fees_btc REAL DEFAULT 0,
    
    -- Mining economics
    revenue_per_th_usd REAL,
    profit_per_th_usd REAL,
    
    -- Data source
    data_source TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: calculation_cache
-- Caches expensive calculation results
CREATE TABLE calculation_cache (
    cache_key TEXT PRIMARY KEY,
    cache_data TEXT NOT NULL, -- JSON data
    expires_at DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: api_usage_log
-- Tracks API usage for rate limiting and analytics
CREATE TABLE api_usage_log (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    endpoint TEXT NOT NULL,
    method TEXT NOT NULL,
    status_code INTEGER NOT NULL,
    response_time_ms INTEGER,
    request_size_bytes INTEGER,
    response_size_bytes INTEGER,
    ip_address TEXT,
    user_agent TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance optimization

-- Miners table indexes
CREATE INDEX idx_miners_efficiency ON miners(efficiency_j_th);
CREATE INDEX idx_miners_hashrate ON miners(hashrate_th DESC);
CREATE INDEX idx_miners_manufacturer ON miners(manufacturer);
CREATE INDEX idx_miners_release_date ON miners(release_date DESC);

-- Solar panels table indexes
CREATE INDEX idx_solar_panels_efficiency ON solar_panels(efficiency_percent DESC);
CREATE INDEX idx_solar_panels_power ON solar_panels(rated_power_w DESC);
CREATE INDEX idx_solar_panels_manufacturer ON solar_panels(manufacturer);

-- Wind turbines table indexes
CREATE INDEX idx_wind_turbines_power ON wind_turbines(rated_power_w DESC);
CREATE INDEX idx_wind_turbines_manufacturer ON wind_turbines(manufacturer);

-- System configurations table indexes
CREATE INDEX idx_system_configs_location ON system_configurations(latitude, longitude);
CREATE INDEX idx_system_configs_created_by ON system_configurations(created_by);
CREATE INDEX idx_system_configs_public ON system_configurations(is_public, created_at DESC);

-- Projections table indexes
CREATE INDEX idx_projections_system_config ON projections(system_config_id);
CREATE INDEX idx_projections_created_by ON projections(created_by, created_at DESC);
CREATE INDEX idx_projections_public ON projections(is_public, created_at DESC);
CREATE INDEX idx_projections_roi ON projections(roi_percent DESC);

-- Weather data table indexes
CREATE INDEX idx_weather_data_location_date ON weather_data(location_hash, date, hour);
CREATE INDEX idx_weather_data_date ON weather_data(date DESC);

-- Bitcoin network data table indexes
CREATE INDEX idx_bitcoin_network_date ON bitcoin_network_data(recorded_date DESC);
CREATE INDEX idx_bitcoin_network_price ON bitcoin_network_data(price_usd, recorded_date DESC);

-- Calculation cache table indexes
CREATE INDEX idx_calculation_cache_expires ON calculation_cache(expires_at);

-- API usage log table indexes
CREATE INDEX idx_api_usage_user ON api_usage_log(user_id, created_at DESC);
CREATE INDEX idx_api_usage_endpoint ON api_usage_log(endpoint, created_at DESC);
CREATE INDEX idx_api_usage_date ON api_usage_log(created_at DESC);

-- Views for common queries

-- Efficient miners view (top performers by efficiency)
CREATE VIEW v_efficient_miners AS
SELECT 
    m.*,
    ROUND(m.efficiency_j_th, 2) as efficiency_rounded,
    ROUND(m.hashrate_th / (m.power_consumption_w / 1000.0), 2) as th_per_kw
FROM miners m
WHERE m.verified = TRUE
ORDER BY m.efficiency_j_th ASC;

-- High-power solar panels view
CREATE VIEW v_high_power_solar_panels AS
SELECT 
    sp.*,
    ROUND(sp.rated_power_w / sp.panel_area_m2, 2) as power_density_w_m2
FROM solar_panels sp
WHERE sp.verified = TRUE
  AND sp.rated_power_w >= 400
ORDER BY sp.rated_power_w DESC;

-- Recent Bitcoin network data view
CREATE VIEW v_recent_btc_data AS
SELECT 
    *,
    LAG(price_usd) OVER (ORDER BY recorded_date) as prev_price_usd,
    LAG(network_hashrate_eh) OVER (ORDER BY recorded_date) as prev_hashrate_eh
FROM bitcoin_network_data
ORDER BY recorded_date DESC
LIMIT 30;

-- Triggers for automatic timestamp updates

-- Update miners.updated_at on changes
CREATE TRIGGER trigger_miners_updated_at
    AFTER UPDATE ON miners
    FOR EACH ROW
BEGIN
    UPDATE miners SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Update solar_panels.updated_at on changes
CREATE TRIGGER trigger_solar_panels_updated_at
    AFTER UPDATE ON solar_panels
    FOR EACH ROW
BEGIN
    UPDATE solar_panels SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Update wind_turbines.updated_at on changes
CREATE TRIGGER trigger_wind_turbines_updated_at
    AFTER UPDATE ON wind_turbines
    FOR EACH ROW
BEGIN
    UPDATE wind_turbines SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Update system_configurations.updated_at on changes
CREATE TRIGGER trigger_system_configurations_updated_at
    AFTER UPDATE ON system_configurations
    FOR EACH ROW
BEGIN
    UPDATE system_configurations SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Update projections.updated_at on changes
CREATE TRIGGER trigger_projections_updated_at
    AFTER UPDATE ON projections
    FOR EACH ROW
BEGIN
    UPDATE projections SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
END;

-- Clean up expired cache entries
CREATE TRIGGER trigger_cleanup_expired_cache
    AFTER INSERT ON calculation_cache
    FOR EACH ROW
BEGIN
    DELETE FROM calculation_cache WHERE expires_at < CURRENT_TIMESTAMP;
END;