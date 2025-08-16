-- Seed data for Solar Mining Calculator
-- Location: Saint-Affrique, France (43.952496, 2.907711)
-- Focus: European equipment, metric units, Celsius temperatures

-- =============================================================================
-- USER DATA
-- =============================================================================

-- Create default user
INSERT INTO users (id, email, password_hash, first_name, last_name, is_active) VALUES
(1, 'admin@solar-mining.fr', '$2b$10$example.hash.for.demo', 'Admin', 'User', true);

-- =============================================================================
-- LOCATION DATA
-- =============================================================================

-- Saint-Affrique, France (main location)
INSERT INTO locations (id, user_id, name, latitude, longitude, elevation, timezone) VALUES
(1, 1, 'Saint-Affrique, France', 43.952496, 2.907711, 320, 'Europe/Paris');

-- Additional European locations for examples
INSERT INTO locations (id, user_id, name, latitude, longitude, elevation, timezone) VALUES
(2, 1, 'Barcelona, Spain', 41.3851, 2.1734, 12, 'Europe/Madrid'),
(3, 1, 'Munich, Germany', 48.1351, 11.5820, 519, 'Europe/Berlin'),
(4, 1, 'Amsterdam, Netherlands', 52.3676, 4.9041, 2, 'Europe/Amsterdam'),
(5, 1, 'Rome, Italy', 41.9028, 12.4964, 21, 'Europe/Rome');

-- =============================================================================
-- MINER MODELS (European Market Focus)
-- =============================================================================

INSERT INTO miner_models (
    id, user_id, manufacturer, model_name, hashrate_th, power_consumption_w, 
    efficiency_j_th, hashrate_degradation_annual, efficiency_degradation_annual, 
    failure_rate_annual, operating_temp_min, operating_temp_max, humidity_max,
    current_price_usd, expected_lifespan_years, voltage_v, power_connection_type,
    user_nickname, purchase_date, purchase_price_usd, warranty_expiry, notes
) VALUES
-- Bitmain Models (Most Common in Europe)
(1, 1, 'Bitmain', 'Antminer S19 XP', 140.0, 3010, 21.5, 0.05, 0.03, 0.10, 5, 40, 85, 2800, 5, 220, 'C19', 'S19 XP Main', '2024-01-15', 2800, '2027-01-15', 'High efficiency model, great for European electricity prices'),
(2, 1, 'Bitmain', 'Antminer S19 Pro', 110.0, 3250, 29.5, 0.05, 0.03, 0.10, 5, 40, 85, 2200, 5, 220, 'C19', 'S19 Pro Backup', '2024-02-01', 2200, '2027-02-01', 'Reliable workhorse, good resale value'),
(3, 1, 'Bitmain', 'Antminer S19j Pro', 104.0, 3054, 29.3, 0.05, 0.03, 0.10, 5, 40, 85, 2000, 5, 220, 'C19', 'S19j Pro', '2024-01-20', 2000, '2027-01-20', 'Good balance of efficiency and cost'),

-- MicroBT Models (Popular in Europe)
(4, 1, 'MicroBT', 'WhatsMiner M50S', 126.0, 3276, 26.0, 0.05, 0.03, 0.10, 5, 40, 85, 2500, 5, 220, 'C19', 'M50S High Power', '2024-02-10', 2500, '2027-02-10', 'High hashrate, good for cold climates'),
(5, 1, 'MicroBT', 'WhatsMiner M30S++', 112.0, 3472, 31.0, 0.05, 0.03, 0.10, 5, 40, 85, 2100, 5, 220, 'C19', 'M30S++', '2024-01-25', 2100, '2027-01-25', 'Proven reliability, easy maintenance');

-- =============================================================================
-- SOLAR PANEL MODELS (European Manufacturers)
-- =============================================================================

INSERT INTO solar_panel_models (
    id, user_id, manufacturer, model_name, rated_power_w, efficiency_percent,
    temperature_coefficient, degradation_rate_annual, cost_per_watt, expected_lifespan_years,
    user_nickname, purchase_date, purchase_price_usd, installation_date, warranty_expiry, notes
) VALUES
-- European Premium Brands
(1, 1, 'REC Solar', 'REC Alpha Pure 430W', 430, 21.9, -0.26, 0.5, 0.45, 25, 'REC Alpha 430W', '2024-03-01', 193.5, '2024-03-15', '2049-03-01', 'Premium European panels, excellent warranty'),
(2, 1, 'Solarwatt', 'Vision 60M 400W', 400, 20.8, -0.30, 0.5, 0.48, 25, 'Solarwatt Vision', '2024-02-15', 192.0, '2024-03-01', '2049-02-15', 'German quality, glass-glass construction'),
(3, 1, 'Meyer Burger', 'White 400W', 400, 21.8, -0.28, 0.5, 0.52, 25, 'Meyer Burger White', '2024-02-20', 208.0, '2024-03-10', '2049-02-20', 'Swiss precision, high efficiency'),

-- Popular European Brands
(4, 1, 'Axitec', 'AC-400MH/120S 400W', 400, 20.5, -0.35, 0.5, 0.42, 25, 'Axitec 400W', '2024-01-30', 168.0, '2024-02-15', '2049-01-30', 'German engineering, good value'),
(5, 1, 'SunPower', 'Maxeon 3 400W', 400, 22.6, -0.29, 0.5, 0.55, 25, 'SunPower Maxeon', '2024-03-05', 220.0, '2024-03-20', '2049-03-05', 'Highest efficiency, premium price');

-- =============================================================================
-- STORAGE MODELS (European Battery Systems)
-- =============================================================================

INSERT INTO storage_models (
    id, user_id, manufacturer, model_name, technology, capacity_kwh, usable_capacity_kwh,
    max_charge_rate_kw, max_discharge_rate_kw, round_trip_efficiency, cycle_life,
    calendar_degradation_annual, cost_per_kwh, user_nickname, purchase_date, 
    purchase_price_usd, installation_date, warranty_expiry, notes
) VALUES
-- European Home Storage Systems
(1, 1, 'Tesla', 'Powerwall 2', 'Li-ion', 13.5, 13.5, 5.0, 5.0, 0.90, 4000, 0.02, 500, 'Tesla Powerwall', '2024-02-01', 6750, '2024-02-15', '2034-02-01', 'Most popular home storage in Europe'),
(2, 1, 'LG Chem', 'RESU 10H', 'Li-ion', 9.8, 9.3, 5.0, 5.0, 0.95, 6000, 0.02, 600, 'LG RESU 10H', '2024-01-15', 5880, '2024-02-01', '2034-01-15', 'High cycle life, excellent efficiency'),
(3, 1, 'Sonnen', 'Batterie 10', 'LiFePO4', 10.0, 9.5, 3.3, 3.3, 0.92, 10000, 0.01, 700, 'Sonnen Batterie', '2024-02-10', 7000, '2024-02-25', '2034-02-10', 'German engineering, very long life'),

-- Commercial/Industrial Systems
(4, 1, 'BYD', 'Battery-Box Premium HVS', 'LiFePO4', 15.36, 14.6, 7.5, 7.5, 0.95, 8000, 0.02, 450, 'BYD Battery-Box', '2024-01-20', 6912, '2024-02-05', '2034-01-20', 'Commercial grade, scalable'),
(5, 1, 'Pylontech', 'US3000C', 'LiFePO4', 3.5, 3.3, 1.5, 1.5, 0.95, 6000, 0.02, 400, 'Pylontech US3000C', '2024-02-05', 1400, '2024-02-20', '2034-02-05', 'Modular system, easy expansion');

-- =============================================================================
-- INVERTER MODELS (European Market)
-- =============================================================================

INSERT INTO inverter_models (
    id, user_id, manufacturer, model_name, rated_power_w, efficiency_percent,
    input_voltage_range, output_voltage_v, mppt_trackers, max_input_current_a,
    max_output_current_a, power_factor, operating_temp_min, operating_temp_max,
    humidity_max, cost_usd, expected_lifespan_years, user_nickname, purchase_date,
    purchase_price_usd, installation_date, warranty_expiry, notes
) VALUES
-- European Premium Inverters
(1, 1, 'SMA', 'Sunny Boy 5.0', 5000, 98.0, '200-800V', 230, 2, 12.5, 21.7, 0.99, -25, 60, 95, 1200, 15, 'SMA Sunny Boy 5kW', '2024-02-01', 1200, '2024-02-15', '2039-02-01', 'German quality, excellent monitoring'),
(2, 1, 'Fronius', 'Symo 5.0-3-M', 5000, 98.2, '200-800V', 230, 2, 12.5, 21.7, 0.99, -25, 60, 95, 1300, 15, 'Fronius Symo 5kW', '2024-01-20', 1300, '2024-02-05', '2039-01-20', 'Austrian precision, great efficiency'),
(3, 1, 'SolarEdge', 'SE5000H', 5000, 99.0, '200-800V', 230, 1, 12.5, 21.7, 0.99, -25, 60, 95, 1400, 15, 'SolarEdge SE5000H', '2024-02-10', 1400, '2024-02-25', '2039-02-10', 'Power optimizers, excellent monitoring'),

-- Popular European Brands
(4, 1, 'Growatt', 'MIN 5000TL-X', 5000, 97.5, '200-800V', 230, 2, 12.5, 21.7, 0.99, -25, 60, 95, 800, 15, 'Growatt MIN 5kW', '2024-01-25', 800, '2024-02-10', '2039-01-25', 'Good value, reliable performance'),
(5, 1, 'Huawei', 'SUN2000-5KTL-L1', 5000, 98.5, '200-800V', 230, 2, 12.5, 21.7, 0.99, -25, 60, 95, 1100, 15, 'Huawei SUN2000 5kW', '2024-02-05', 1100, '2024-02-20', '2039-02-05', 'Smart features, good efficiency');

-- =============================================================================
-- API DATA SOURCES
-- =============================================================================

INSERT INTO api_data_sources (id, source_name, endpoint_url, last_fetch_time, is_active, error_count) VALUES
(1, 'coingecko', 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd', NULL, true, 0),
(2, 'blockchain.info', 'https://blockchain.info/stats?format=json', NULL, true, 0),
(3, 'openweathermap', 'https://api.openweathermap.org/data/2.5/weather', NULL, true, 0),
(4, 'nrel', 'https://developer.nrel.gov/api/solar/solar_resource/v1.json', NULL, true, 0);

-- =============================================================================
-- SAMPLE BITCOIN DATA (Current as of 2024)
-- =============================================================================

INSERT INTO bitcoin_network_data (
    id, recorded_date, difficulty, network_hashrate, block_reward, avg_block_time,
    avg_transaction_fee, data_source, avg_transaction_fee_sat_vb, mempool_size_mb,
    blocks_until_halving, next_difficulty_estimate, hashprice_usd_per_th,
    revenue_per_th_usd, profit_per_th_usd, data_freshness_minutes
) VALUES
(1, '2024-12-19', 90666502495565, 650.5, 6.25, 605, 0.0025, 'blockchain.info', 15.5, 45.2, 125000, 92000000000000, 0.085, 0.092, 0.007, 15);

INSERT INTO bitcoin_price_data (
    id, recorded_date, price_usd, volume_24h, data_source, market_cap_usd,
    volume_24h_usd, price_change_24h_percent, volatility_30d, price_change_7d_percent,
    price_change_30d_percent, data_freshness_minutes
) VALUES
(1, '2024-12-19', 45250.50, 28500000000, 'coingecko', 885000000000, 28500000000, 2.5, 0.35, 8.2, 15.7, 5);

-- =============================================================================
-- SAMPLE ENVIRONMENTAL DATA (Saint-Affrique, France)
-- =============================================================================

-- Monthly solar data for Saint-Affrique (approximate values)
INSERT INTO monthly_solar_data (
    id, location_id, year, month, ghi_monthly_avg, dni_monthly_avg, sun_hours_monthly_avg,
    temperature_monthly_avg, temperature_min_monthly_avg, temperature_max_monthly_avg,
    humidity_monthly_avg, atmospheric_pressure_monthly_avg, season, data_source
) VALUES
-- Spring (March-May)
(1, 1, 2024, 3, 3.8, 4.2, 5.2, 12.5, 8.0, 17.0, 70, 1013.25, 'spring', 'nrel'),
(2, 1, 2024, 4, 5.2, 5.8, 6.8, 15.8, 10.5, 21.0, 65, 1013.25, 'spring', 'nrel'),
(3, 1, 2024, 5, 6.5, 7.2, 7.5, 19.2, 13.0, 25.5, 60, 1013.25, 'spring', 'nrel'),

-- Summer (June-August)
(4, 1, 2024, 6, 7.2, 8.0, 8.8, 23.5, 17.0, 30.0, 55, 1013.25, 'summer', 'nrel'),
(5, 1, 2024, 7, 7.8, 8.5, 9.2, 26.8, 20.0, 33.5, 50, 1013.25, 'summer', 'nrel'),
(6, 1, 2024, 8, 6.8, 7.5, 8.5, 26.2, 19.5, 32.8, 55, 1013.25, 'summer', 'nrel'),

-- Autumn (September-November)
(7, 1, 2024, 9, 5.2, 5.8, 6.5, 22.5, 16.0, 29.0, 65, 1013.25, 'autumn', 'nrel'),
(8, 1, 2024, 10, 3.8, 4.2, 5.0, 17.8, 12.0, 23.5, 75, 1013.25, 'autumn', 'nrel'),
(9, 1, 2024, 11, 2.5, 2.8, 3.8, 12.2, 7.5, 17.0, 80, 1013.25, 'autumn', 'nrel'),

-- Winter (December-February)
(10, 1, 2024, 12, 2.0, 2.2, 3.2, 8.5, 4.0, 13.0, 85, 1013.25, 'winter', 'nrel'),
(11, 1, 2024, 1, 2.2, 2.4, 3.5, 7.8, 3.5, 12.0, 85, 1013.25, 'winter', 'nrel'),
(12, 1, 2024, 2, 3.0, 3.3, 4.2, 9.2, 5.0, 13.5, 80, 1013.25, 'winter', 'nrel');

-- =============================================================================
-- SAMPLE SYSTEM CONFIGURATION
-- =============================================================================

INSERT INTO system_configs (
    id, user_id, config_name, description, location_id, solar_panels, storage_systems,
    miners, electricity_rate_usd_kwh, net_metering_rate_usd_kwh, grid_connection_type,
    mining_mode, max_grid_power_kw, auto_calculate_hours, manual_mining_hours_per_day,
    inverter_id, inverter_quantity
) VALUES
(1, 1, 'Saint-Affrique Solar Mining Setup', 'Main solar mining configuration for Saint-Affrique location', 1,
'[{"model_id": 1, "quantity": 20, "tilt_angle": 35, "azimuth": 180}, {"model_id": 2, "quantity": 15, "tilt_angle": 35, "azimuth": 180}]',
'[{"model_id": 1, "quantity": 2}]',
'[{"model_id": 1, "quantity": 3, "power_limit_w": 2800}, {"model_id": 2, "quantity": 2, "power_limit_w": 3000}]',
0.18, 0.12, 'hybrid', 'solar_priority', 10.0, true, 0, 1, 1);

-- =============================================================================
-- SAMPLE PROJECTION SCENARIOS
-- =============================================================================

INSERT INTO projection_scenarios (
    id, user_id, system_config_id, scenario_name, description, bitcoin_parameters,
    economic_parameters, environmental_parameters, equipment_parameters, is_baseline,
    is_active, is_user_created
) VALUES
(1, 1, 1, 'Baseline - Current Market', 'Baseline scenario using current market conditions', 
'{"price_usd": 45250, "difficulty_multiplier": 1.0}',
'{"electricity_rate_usd_kwh": 0.18, "maintenance_cost_multiplier": 1.0}',
'{"temperature_impact_factor": 1.0, "weather_impact_factor": 1.0}',
'{"degradation_rate_multiplier": 1.0, "efficiency_multiplier": 1.0}',
true, true, false),

(2, 1, 1, 'Bull Market - High Bitcoin Price', 'Optimistic scenario with higher Bitcoin prices',
'{"price_usd": 80000, "difficulty_multiplier": 1.2}',
'{"electricity_rate_usd_kwh": 0.18, "maintenance_cost_multiplier": 1.0}',
'{"temperature_impact_factor": 1.0, "weather_impact_factor": 1.0}',
'{"degradation_rate_multiplier": 1.0, "efficiency_multiplier": 1.0}',
false, false, true),

(3, 1, 1, 'Bear Market - Low Bitcoin Price', 'Conservative scenario with lower Bitcoin prices',
'{"price_usd": 25000, "difficulty_multiplier": 0.8}',
'{"electricity_rate_usd_kwh": 0.18, "maintenance_cost_multiplier": 1.0}',
'{"temperature_impact_factor": 1.0, "weather_impact_factor": 1.0}',
'{"degradation_rate_multiplier": 1.0, "efficiency_multiplier": 1.0}',
false, false, true);

-- =============================================================================
-- SAMPLE PROJECTION RESULTS (Example for baseline scenario)
-- =============================================================================

INSERT INTO projection_results (
    id, user_id, system_config_id, scenario_id, projection_date, total_generation_kwh,
    solar_generation_kwh, mining_consumption_kwh, grid_import_kwh, grid_export_kwh,
    total_hashrate_th, effective_hashrate_th, btc_mined, btc_price_usd, mining_revenue_usd,
    electricity_cost_usd, net_profit_usd, solar_capacity_factor, system_efficiency,
    solar_direct_to_mining_kwh, solar_wasted_kwh, mining_hours_solar_only,
    mining_hours_grid_assisted, effective_mining_hours, solar_availability_hours,
    mining_availability_percent, season, cloud_cover_avg_percent, weather_impact_factor,
    roi_percent, payback_period_months, net_present_value_usd, internal_rate_return_percent,
    break_even_btc_price_usd, break_even_electricity_rate_usd_kwh, equipment_depreciation_usd,
    maintenance_cost_usd, insurance_cost_usd, property_tax_usd, total_operating_cost_usd,
    gross_profit_margin_percent, net_profit_margin_percent, total_investment_usd,
    total_revenue_usd, total_costs_usd, cumulative_profit_usd, monthly_cash_flow_usd,
    annual_cash_flow_usd, equipment_resale_value_usd, total_investment_with_resale_usd,
    adjusted_roi_percent, net_equipment_value_usd
) VALUES
(1, 1, 1, 1, '2024-12-19', 145.5, 145.5, 156.0, 10.5, 0.0, 680.0, 646.0, 0.0125, 45250.0, 565.625, 18.90, 546.725, 0.21, 0.875, 135.0, 10.5, 8.5, 15.5, 24.0, 8.5, 100.0, 'winter', 45.0, 0.85, 15.2, 48.5, 12500.0, 18.5, 38000.0, 0.25, 25.0, 15.0, 5.0, 2.0, 47.0, 85.2, 78.5, 45000.0, 20250.0, 24750.0, -4500.0, 546.725, 6560.70, 8000.0, 37000.0, 12.1, 8000.0);

-- =============================================================================
-- SAMPLE MINER PRICE HISTORY
-- =============================================================================

INSERT INTO miner_price_history (
    id, user_id, miner_model_id, recorded_date, market_price_usd, resale_price_usd,
    market_demand_level, depreciation_rate_used, calculation_method, data_source, notes
) VALUES
(1, 1, 1, '2024-01-01', 3000, 2400, 'high', 0.20, 'automatic', 'manual', 'New year pricing'),
(2, 1, 1, '2024-06-01', 2800, 2240, 'medium', 0.20, 'automatic', 'manual', 'Mid-year adjustment'),
(3, 1, 1, '2024-12-01', 2600, 2080, 'medium', 0.20, 'automatic', 'manual', 'Year-end pricing'),
(4, 1, 2, '2024-01-01', 2400, 1920, 'high', 0.20, 'automatic', 'manual', 'S19 Pro pricing'),
(5, 1, 2, '2024-12-01', 2200, 1760, 'medium', 0.20, 'automatic', 'manual', 'Year-end S19 Pro');

-- =============================================================================
-- SAMPLE ERROR LOGS (for testing error handling)
-- =============================================================================

INSERT INTO application_errors (
    id, user_id, error_type, error_category, error_message, error_context,
    severity_level, user_action, ip_address, user_agent
) VALUES
(1, 1, 'calculation', 'solar_calc', 'Solar generation calculation failed due to invalid weather data', '{"location_id": 1, "date": "2024-12-19", "weather_data": null}', 'error', 'Calculating daily projections', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(2, 1, 'validation', 'user_input', 'Invalid equipment configuration detected', '{"system_config_id": 1, "issue": "solar_panels array empty"}', 'warning', 'Creating system configuration', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'),
(3, 1, 'api', 'external_data', 'Failed to fetch Bitcoin price data from CoinGecko', '{"source": "coingecko", "endpoint": "/api/v3/simple/price", "status_code": 429}', 'error', 'Updating market data', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');

-- =============================================================================
-- SEED COMPLETION
-- =============================================================================

-- Update sequences to continue from the highest used ID
-- Note: SQLite doesn't use sequences like PostgreSQL, but this documents the next IDs to use

/*
Next IDs to use:
- users: 2
- locations: 6
- miner_models: 6
- solar_panel_models: 6
- storage_models: 6
- inverter_models: 6
- system_configs: 2
- projection_scenarios: 4
- projection_results: 2
- miner_price_history: 6
- application_errors: 4
*/

-- Seed data completed successfully!
-- Total records inserted: 50+ records across all tables
-- Location: Saint-Affrique, France (43.952496, 2.907711)
-- Focus: European equipment, metric units, Celsius temperatures