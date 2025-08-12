-- Seed data for Solar Mining Calculator
-- This file contains sample data for development and testing

-- Sample ASIC miners data
INSERT INTO miners (id, name, manufacturer, model, hashrate_th, power_consumption_w, efficiency_j_th, release_date, verified, created_at, updated_at) VALUES
('miner_001', 'Antminer S19 Pro', 'Bitmain', 'S19 Pro', 110.0, 3250, 29.5, '2021-01-15', true, datetime('now'), datetime('now')),
('miner_002', 'Antminer S19j Pro', 'Bitmain', 'S19j Pro', 104.0, 3068, 29.5, '2021-06-01', true, datetime('now'), datetime('now')),
('miner_003', 'WhatsMiner M30S++', 'MicroBT', 'M30S++', 112.0, 3472, 31.0, '2021-03-01', true, datetime('now'), datetime('now')),
('miner_004', 'Antminer S19 XP', 'Bitmain', 'S19 XP', 140.0, 3010, 21.5, '2022-01-01', true, datetime('now'), datetime('now')),
('miner_005', 'WhatsMiner M50S', 'MicroBT', 'M50S', 126.0, 3276, 26.0, '2022-05-01', true, datetime('now'), datetime('now'));

-- Sample solar panels data
INSERT INTO solar_panels (id, name, manufacturer, model, rated_power_w, voltage_vmp, current_imp, voltage_voc, current_isc, panel_area_m2, efficiency_percent, temperature_coefficient, warranty_years, cell_technology, verified, created_at, updated_at) VALUES
('panel_001', 'SunPower Maxeon 3', 'SunPower', 'SPR-400-COM', 400, 67.5, 5.93, 85.6, 6.46, 2.067, 19.4, -0.29, 25, 'Monocrystalline', true, datetime('now'), datetime('now')),
('panel_002', 'LG NeON R', 'LG', 'LG365Q1C-A5', 365, 40.4, 9.03, 48.6, 9.65, 1.686, 21.6, -0.30, 25, 'Monocrystalline', true, datetime('now'), datetime('now')),
('panel_003', 'Canadian Solar HiKu6', 'Canadian Solar', 'CS6W-550MS', 550, 41.4, 13.29, 49.8, 14.18, 2.384, 21.2, -0.35, 25, 'Monocrystalline', true, datetime('now'), datetime('now')),
('panel_004', 'Jinko Tiger Pro', 'JinkoSolar', 'JKM535M-7RL3', 535, 41.05, 13.03, 49.85, 13.78, 2.382, 20.8, -0.38, 25, 'Monocrystalline', true, datetime('now'), datetime('now')),
('panel_005', 'REC Alpha Pure', 'REC', 'REC380AA', 380, 40.5, 9.39, 48.7, 9.87, 1.821, 20.9, -0.26, 20, 'Monocrystalline', true, datetime('now'), datetime('now'));

-- Sample wind turbines data
INSERT INTO wind_turbines (id, name, manufacturer, model, rated_power_w, cut_in_speed_ms, cut_out_speed_ms, rated_wind_speed_ms, rotor_diameter_m, hub_height_m, swept_area_m2, power_curve, verified, created_at, updated_at) VALUES
('turbine_001', 'Skystream 3.7', 'Xzeres', 'Skystream 3.7', 2400, 3.5, 25.0, 9.0, 3.72, 10.7, 10.87, '[{"wind_speed":3,"power":0},{"wind_speed":4,"power":100},{"wind_speed":6,"power":400},{"wind_speed":8,"power":1000},{"wind_speed":10,"power":1800},{"wind_speed":12,"power":2400}]', true, datetime('now'), datetime('now')),
('turbine_002', 'Bergey Excel 10', 'Bergey Windpower', 'Excel 10', 10000, 2.5, 22.0, 11.0, 7.0, 24.4, 38.48, '[{"wind_speed":3,"power":0},{"wind_speed":5,"power":500},{"wind_speed":8,"power":3000},{"wind_speed":11,"power":8000},{"wind_speed":15,"power":10000}]', true, datetime('now'), datetime('now'));

-- Sample system configurations
INSERT INTO system_configurations (id, name, description, miner_id, miner_quantity, solar_panel_id, solar_panel_quantity, solar_system_efficiency, latitude, longitude, timezone, grid_connection, electricity_rate_usd_kwh, is_public, created_at, updated_at) VALUES
('config_001', 'Texas Solar Mining Setup', 'Basic solar-powered mining operation in Texas', 'miner_001', 10, 'panel_003', 50, 0.85, 31.9686, -99.9018, 'America/Chicago', true, 0.12, true, datetime('now'), datetime('now')),
('config_002', 'California High-Efficiency Setup', 'High-efficiency miners with premium solar panels', 'miner_004', 15, 'panel_001', 80, 0.88, 36.7783, -119.4179, 'America/Los_Angeles', true, 0.25, true, datetime('now'), datetime('now')),
('config_003', 'Off-Grid Nevada Operation', 'Completely off-grid operation in Nevada desert', 'miner_002', 8, 'panel_004', 60, 0.82, 39.1638, -116.7669, 'America/Los_Angeles', false, 0.00, true, datetime('now'), datetime('now'));

-- Sample historical Bitcoin network data (last 30 days)
INSERT INTO bitcoin_network_data (id, recorded_date, price_usd, network_hashrate_eh, difficulty, block_height, block_reward, data_source, created_at) VALUES
('btc_001', date('now', '-30 days'), 42000.0, 520.0, 67957581722924.0, 820000, 6.25, 'sample_data', datetime('now')),
('btc_002', date('now', '-25 days'), 43500.0, 525.0, 68234567890123.0, 820500, 6.25, 'sample_data', datetime('now')),
('btc_003', date('now', '-20 days'), 41800.0, 515.0, 67456789012345.0, 821000, 6.25, 'sample_data', datetime('now')),
('btc_004', date('now', '-15 days'), 44200.0, 530.0, 68567890123456.0, 821500, 6.25, 'sample_data', datetime('now')),
('btc_005', date('now', '-10 days'), 43000.0, 522.0, 68123456789012.0, 822000, 6.25, 'sample_data', datetime('now')),
('btc_006', date('now', '-5 days'), 45000.0, 535.0, 68789012345678.0, 822500, 6.25, 'sample_data', datetime('now')),
('btc_007', date('now'), 44500.0, 532.0, 68654321098765.0, 823000, 6.25, 'sample_data', datetime('now'));

-- Sample weather data for major solar mining locations
INSERT INTO weather_data (id, location_hash, latitude, longitude, date, ghi, dni, temperature_c, humidity_percent, wind_speed_ms, data_source, data_quality, created_at) VALUES
('weather_001', 'texas_central', 31.9686, -99.9018, date('now'), 850.0, 920.0, 28.5, 45.0, 4.2, 'sample_data', 'good', datetime('now')),
('weather_002', 'california_central', 36.7783, -119.4179, date('now'), 780.0, 850.0, 25.8, 55.0, 3.8, 'sample_data', 'good', datetime('now')),
('weather_003', 'nevada_desert', 39.1638, -116.7669, date('now'), 950.0, 1050.0, 32.1, 25.0, 5.5, 'sample_data', 'good', datetime('now')),
('weather_004', 'arizona_phoenix', 33.4484, -112.0740, date('now'), 920.0, 980.0, 35.2, 30.0, 2.8, 'sample_data', 'good', datetime('now'));

-- Sample API usage log entries
INSERT INTO api_usage_log (id, endpoint, method, status_code, response_time_ms, created_at) VALUES
('log_001', '/api/v1/equipment', 'GET', 200, 45, datetime('now', '-1 hour')),
('log_002', '/api/v1/bitcoin/current-price', 'GET', 200, 120, datetime('now', '-30 minutes')),
('log_003', '/api/v1/projections', 'POST', 201, 850, datetime('now', '-15 minutes')),
('log_004', '/health', 'GET', 200, 12, datetime('now', '-5 minutes'));