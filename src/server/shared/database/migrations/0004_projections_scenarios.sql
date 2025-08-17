-- Migration 0004: Projections and Scenarios
-- Description: Projection scenarios and results tables
-- Dependencies: 0001_core_foundation.sql, 0002_system_configuration.sql

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
    bitcoin_parameters JSON CHECK (json_valid(bitcoin_parameters)),
    
    -- Economic Parameters
    economic_parameters JSON CHECK (json_valid(economic_parameters)),
    
    -- Environmental Parameters
    environmental_parameters JSON CHECK (json_valid(environmental_parameters)),
    
    -- Equipment Performance Parameters
    equipment_parameters JSON CHECK (json_valid(equipment_parameters)),
    
    -- Scenario metadata
    is_baseline BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT false,
    is_user_created BOOLEAN DEFAULT true,
    
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
    scenario_id INTEGER NOT NULL,
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
    mining_revenue_usd REAL NOT NULL CHECK (mining_revenue_usd >= 0),
    electricity_cost_usd REAL NOT NULL CHECK (electricity_cost_usd >= 0),
    net_profit_usd REAL NOT NULL CHECK (net_profit_usd >= -1000000),
    
    -- System Performance Metrics
    solar_capacity_factor REAL,
    system_efficiency REAL,
    
    -- Battery-Free Mining Results
    solar_direct_to_mining_kwh REAL DEFAULT 0,
    solar_wasted_kwh REAL DEFAULT 0,
    mining_hours_solar_only REAL DEFAULT 0,
    mining_hours_grid_assisted REAL DEFAULT 0,
    effective_mining_hours REAL DEFAULT 0,
    solar_availability_hours REAL DEFAULT 0,
    mining_availability_percent REAL DEFAULT 0,
    
    -- Seasonal Performance Tracking
    season VARCHAR(10),
    cloud_cover_avg_percent REAL,
    weather_impact_factor REAL DEFAULT 1.0,
    
    -- Business Analysis Fields
    roi_percent REAL CHECK (roi_percent BETWEEN -100 AND 10000),
    payback_period_months REAL CHECK (payback_period_months BETWEEN 0 AND 600),
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
    
    -- Equipment Resale Value Tracking
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
-- SCENARIO JSON VALIDATION
-- =============================================================================

-- Note: All constraints have been moved to their respective CREATE TABLE statements
-- for SQLite compatibility. Constraints are now defined at table creation time.

-- =============================================================================
-- SCENARIO DOCUMENTATION
-- =============================================================================

-- bitcoin_parameters: Bitcoin market params: {"price_usd": 30000, "difficulty_multiplier": 1.2}
-- All fields optional - null = use current API data
--
-- economic_parameters: Economic params: {"electricity_rate_usd_kwh": 0.15, "maintenance_cost_multiplier": 1.2}
-- All fields optional - null = use system config values

-- =============================================================================
-- PROJECTION INDEXES
-- =============================================================================

-- Projection scenarios indexes
CREATE INDEX idx_projection_scenarios_user ON projection_scenarios(user_id);
CREATE INDEX idx_projection_scenarios_config ON projection_scenarios(system_config_id);
CREATE INDEX idx_projection_scenarios_baseline ON projection_scenarios(is_baseline);
CREATE INDEX idx_projection_scenarios_active ON projection_scenarios(is_active);
CREATE INDEX idx_projection_scenarios_user_created ON projection_scenarios(is_user_created);

-- Projection results indexes
CREATE INDEX idx_projection_results_user ON projection_results(user_id);
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
