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

-- Core Helper Functions (SQLite Compatible)
-- Note: These functions will be implemented in application code for better performance
-- SQLite doesn't support complex functions like PostgreSQL, so we'll use application-level calculations

-- Helper function for getting solar capacity (simplified for SQLite)
CREATE FUNCTION get_system_solar_capacity_w(system_id INTEGER) RETURNS REAL AS $$
  SELECT COALESCE((
    SELECT SUM(CAST(json_extract(panel.value, '$.quantity') AS INTEGER) * spm.rated_power_w)
    FROM system_configs sc,
         json_each(sc.solar_panels) AS panel,
         solar_panel_models spm
    WHERE sc.id = system_id 
      AND CAST(json_extract(panel.value, '$.model_id') AS INTEGER) = spm.id
      AND sc.user_id = spm.user_id
  ), 0);
$$;

-- Helper function for getting total hashrate (simplified for SQLite)
CREATE FUNCTION get_system_total_hashrate_th(system_id INTEGER) RETURNS REAL AS $$
  SELECT COALESCE((
    SELECT SUM(CAST(json_extract(miner.value, '$.quantity') AS INTEGER) * mm.hashrate_th)
    FROM system_configs sc,
         json_each(sc.miners) AS miner,
         miner_models mm
    WHERE sc.id = system_id 
      AND CAST(json_extract(miner.value, '$.model_id') AS INTEGER) = mm.id
      AND sc.user_id = mm.user_id
  ), 0);
$$;

-- Helper function for getting mining power (simplified for SQLite)
CREATE FUNCTION get_system_mining_power_w(system_id INTEGER) RETURNS REAL AS $$
  SELECT COALESCE((
    SELECT SUM(CAST(json_extract(miner.value, '$.quantity') AS INTEGER) * 
               COALESCE(CAST(json_extract(miner.value, '$.power_limit_w') AS INTEGER), mm.power_consumption_w))
    FROM system_configs sc,
         json_each(sc.miners) AS miner,
         miner_models mm
    WHERE sc.id = system_id 
      AND CAST(json_extract(miner.value, '$.model_id') AS INTEGER) = mm.id
      AND sc.user_id = mm.user_id
  ), 0);
$$;

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

-- =============================================================================
-- SYSTEM CONFIGURATION INDEXES
-- =============================================================================

CREATE INDEX idx_system_configs_user ON system_configs(user_id);
CREATE INDEX idx_system_config_name ON system_configs(config_name);
CREATE INDEX idx_system_config_mining_mode ON system_configs(mining_mode);
CREATE INDEX idx_system_config_grid_type ON system_configs(grid_connection_type);
CREATE INDEX idx_system_config_inverter ON system_configs(inverter_id);
