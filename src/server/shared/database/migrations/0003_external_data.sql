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
    difficulty BIGINT NOT NULL CHECK (difficulty > 0),
    network_hashrate REAL NOT NULL CHECK (network_hashrate > 0),
    block_reward REAL NOT NULL CHECK (block_reward > 0),
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
    
    -- Data freshness tracking
    data_freshness_minutes INTEGER,
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table: bitcoin_price_data
-- Current Bitcoin price data
CREATE TABLE bitcoin_price_data (
    id INTEGER PRIMARY KEY,
    recorded_date DATE NOT NULL,
    price_usd REAL NOT NULL CHECK (price_usd > 0),
    volume_24h REAL,
    data_source VARCHAR(50) NOT NULL,
    
    -- Enhanced Price Data
    market_cap_usd REAL,
    volume_24h_usd REAL,
    price_change_24h_percent REAL,
    volatility_30d REAL,
    price_change_7d_percent REAL,
    price_change_30d_percent REAL,
    
    -- Data freshness tracking
    data_freshness_minutes INTEGER,
    
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
    ghi_monthly_avg REAL CHECK (ghi_monthly_avg >= 0),
    dni_monthly_avg REAL CHECK (dni_monthly_avg >= 0),
    sun_hours_monthly_avg REAL CHECK (sun_hours_monthly_avg BETWEEN 0 AND 24),
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
    ghi_forecast REAL CHECK (ghi_forecast >= 0),
    temperature_forecast REAL CHECK (temperature_forecast BETWEEN -50 AND 80),
    cloud_cover_forecast REAL CHECK (cloud_cover_forecast BETWEEN 0 AND 100),
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
    
    -- Data freshness tracking
    data_freshness_minutes INTEGER,
    
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
    ghi_hourly_forecast REAL CHECK (ghi_hourly_forecast >= 0),
    temperature_hourly_forecast REAL CHECK (temperature_hourly_forecast BETWEEN -50 AND 80),
    cloud_cover_hourly_forecast REAL CHECK (cloud_cover_hourly_forecast BETWEEN 0 AND 100),
    
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
    
    -- Data freshness tracking
    data_freshness_minutes INTEGER,
    
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

-- Note: Data freshness tracking columns have been added to CREATE TABLE statements
-- for SQLite compatibility. All columns are now defined at table creation time.

-- =============================================================================
-- DATA VALIDATION CONSTRAINTS
-- =============================================================================

-- Note: All constraints have been moved to their respective CREATE TABLE statements
-- for SQLite compatibility. Constraints are now defined at table creation time.

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
