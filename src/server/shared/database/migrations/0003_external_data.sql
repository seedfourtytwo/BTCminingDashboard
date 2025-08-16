-- Migration 0003: External Data
-- Description: Bitcoin data, environmental data, and API management
-- Dependencies: 0001_core_foundation.sql

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
    
    -- Enhanced Network Data
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
    
    -- Enhanced Price Data
    market_cap_usd REAL,
    volume_24h_usd REAL,
    price_change_24h_percent REAL,
    volatility_30d REAL,
    price_change_7d_percent REAL,
    price_change_30d_percent REAL,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- ENVIRONMENTAL DATA
-- =============================================================================

-- Table: monthly_solar_data
-- Monthly solar resource data from NREL API
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

-- Table: daily_forecast_data
-- Daily weather forecasts from OpenWeatherMap API
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
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY(location_id) REFERENCES locations(id)
);

-- Table: hourly_forecast_data
-- Hourly weather forecasts for detailed short-term planning
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
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY(location_id) REFERENCES locations(id)
);

-- =============================================================================
-- API DATA MANAGEMENT
-- =============================================================================

-- Table: api_data_sources
-- Track external API sources and their status
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

-- Environmental Data Constraints
ALTER TABLE monthly_solar_data ADD CONSTRAINT chk_ghi_positive CHECK (ghi_monthly_avg >= 0);
ALTER TABLE monthly_solar_data ADD CONSTRAINT chk_dni_positive CHECK (dni_monthly_avg >= 0);
ALTER TABLE monthly_solar_data ADD CONSTRAINT chk_sun_hours_reasonable CHECK (sun_hours_monthly_avg BETWEEN 0 AND 24);

ALTER TABLE daily_forecast_data ADD CONSTRAINT chk_forecast_ghi_positive CHECK (ghi_forecast >= 0);
ALTER TABLE daily_forecast_data ADD CONSTRAINT chk_forecast_temp_reasonable CHECK (temperature_forecast BETWEEN -50 AND 80);
ALTER TABLE daily_forecast_data ADD CONSTRAINT chk_cloud_cover_range CHECK (cloud_cover_forecast BETWEEN 0 AND 100);

-- =============================================================================
-- EXTERNAL DATA INDEXES
-- =============================================================================

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

-- API management indexes
CREATE INDEX idx_api_data_sources_active ON api_data_sources(is_active, last_fetch_time);
CREATE INDEX idx_api_errors_source_time ON api_errors(source_name, created_at);
CREATE INDEX idx_bitcoin_price_freshness ON bitcoin_price_data(data_freshness_minutes);
CREATE INDEX idx_bitcoin_network_freshness ON bitcoin_network_data(data_freshness_minutes);
CREATE INDEX idx_daily_forecast_freshness ON daily_forecast_data(data_freshness_minutes);
CREATE INDEX idx_hourly_forecast_freshness ON hourly_forecast_data(data_freshness_minutes);
