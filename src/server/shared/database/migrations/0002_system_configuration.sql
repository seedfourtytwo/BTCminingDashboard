-- Migration 0002: System Configuration
-- Description: System configurations, JSON validation, and helper functions
-- Dependencies: 0001_core_foundation.sql

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
    electricity_rate_usd_kwh REAL NOT NULL CHECK (electricity_rate_usd_kwh > 0),
    net_metering_rate_usd_kwh REAL CHECK (net_metering_rate_usd_kwh IS NULL OR net_metering_rate_usd_kwh >= 0),
    
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
    FOREIGN KEY(inverter_id) REFERENCES inverter_models(id),
    
    -- JSON Validation Constraints
    CHECK (json_valid(solar_panels) AND json_type(solar_panels) = 'array'),
    CHECK (json_valid(miners) AND json_type(miners) = 'array'),
    CHECK (storage_systems IS NULL OR (json_valid(storage_systems) AND json_type(storage_systems) = 'array')),
    CHECK (
      json_array_length(solar_panels) = 0 OR
      (json_extract(solar_panels, '$[0].model_id') IS NOT NULL AND 
       json_extract(solar_panels, '$[0].quantity') IS NOT NULL AND 
       json_extract(solar_panels, '$[0].quantity') > 0)
    ),
    CHECK (
      json_array_length(miners) = 0 OR
      (json_extract(miners, '$[0].model_id') IS NOT NULL AND 
       json_extract(miners, '$[0].quantity') IS NOT NULL AND 
       json_extract(miners, '$[0].quantity') > 0)
    )
);

-- =============================================================================
-- JSON VALIDATION AND HELPER FUNCTIONS
-- =============================================================================

-- Note: JSON validation constraints have been moved to the CREATE TABLE statement
-- for SQLite compatibility. All constraints are now defined at table creation time.

-- Core Helper Functions (Application Level)
-- Note: These functions will be implemented in application code for better performance
-- SQLite doesn't support complex functions, so we'll use application-level calculations
-- Functions: get_system_solar_capacity_w(), get_system_total_hashrate_th(), get_system_mining_power_w()

-- JSON Schema Documentation
-- solar_panels: Array of solar panel configs: [{"model_id": 15, "quantity": 50, "tilt_angle": 30, "azimuth": 180}]
-- Required: model_id, quantity. Optional: tilt_angle (0-90), azimuth (0-360)
--
-- miners: Array of miner configs: [{"model_id": 8, "quantity": 10, "power_limit_w": 3000}]
-- Required: model_id, quantity. Optional: power_limit_w
--
-- storage_systems: Array of storage configs: [{"model_id": 3, "quantity": 2}]
-- Required: model_id, quantity. Optional field.

-- =============================================================================
-- SYSTEM CONFIGURATION INDEXES
-- =============================================================================

CREATE INDEX idx_system_configs_user ON system_configs(user_id);
CREATE INDEX idx_system_config_name ON system_configs(config_name);
CREATE INDEX idx_system_config_mining_mode ON system_configs(mining_mode);
CREATE INDEX idx_system_config_grid_type ON system_configs(grid_connection_type);
CREATE INDEX idx_system_config_inverter ON system_configs(inverter_id);
