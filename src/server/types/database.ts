/**
 * Database type definitions matching the schema
 */

export interface MinerModel {
  id: string;
  name: string;
  manufacturer: string;
  model: string;

  // Performance specifications
  hashrate_th: number;
  power_consumption_w: number;
  efficiency_j_th: number;

  // Physical specifications (JSON stored as string)
  dimensions_mm?: string; // {"length": 400, "width": 195, "height": 290}
  weight_kg?: number;
  noise_level_db?: number;
  operating_temp_range?: string; // {"min": -5, "max": 40}

  // Environmental efficiency factors
  temperature_coefficient?: number; // Performance degradation per °C above optimal
  optimal_temp_c?: number; // Optimal operating temperature
  cooling_requirements_cfm?: number; // Cooling airflow requirements
  heat_output_btu_h?: number; // Heat generation in BTU/hour
  humidity_tolerance?: string; // {"min": 5, "max": 95} in percentage

  // Economic data
  msrp_usd?: number;
  release_date?: string; // ISO date string
  discontinuation_date?: string; // ISO date string

  // Enhanced performance characteristics
  hashrate_degradation_annual: number;
  efficiency_degradation_annual: number;
  failure_rate_annual: number;
  temperature_degradation_factor: number; // Additional degradation from high temperatures
  dust_sensitivity_factor: number; // Performance impact from dust accumulation
  altitude_derating_factor: number; // Performance reduction at high altitude

  // Pool and network compatibility
  supported_mining_protocols?: string; // JSON array of supported protocols
  stratum_compatibility?: string; // Stratum protocol versions
  firmware_update_frequency?: string; // How often firmware updates are released

  // Metadata
  data_source?: string;
  verified: boolean;
  created_at: string; // ISO date string
  updated_at: string; // ISO date string
}

export interface SolarPanelModel {
  id: string;
  name: string;
  manufacturer: string;
  model: string;

  // Electrical specifications (STC)
  rated_power_w: number;
  voltage_vmp: number;
  current_imp: number;
  voltage_voc: number;
  current_isc: number;

  // Physical specifications
  panel_area_m2: number;
  dimensions_mm?: string; // {"length": 2108, "width": 1048, "height": 40}
  weight_kg?: number;

  // Performance characteristics
  efficiency_percent: number;
  temperature_coefficient: number;
  degradation_rate_annual: number;

  // Enhanced environmental performance
  temperature_coefficient_power: number; // Power temperature coefficient (%/°C)
  temperature_coefficient_voc: number; // Voltage temperature coefficient (%/°C)
  low_light_performance: number; // Performance ratio at 200 W/m²
  spectral_response?: string; // JSON data of spectral efficiency curve
  angle_of_incidence_modifier?: string; // JSON data for AOI performance
  shading_tolerance_factor: number; // Performance under partial shading (0-1)
  soiling_sensitivity: number; // Performance degradation from soiling (%/mm dust)

  // Advanced durability factors
  thermal_cycling_rating?: number; // Thermal cycling test cycles passed
  humidity_freeze_rating?: number; // Humidity-freeze cycles passed
  uv_degradation_factor: number; // Annual degradation from UV exposure
  potential_induced_degradation?: number; // PID susceptibility factor

  // Durability and ratings
  max_system_voltage?: number;
  fire_rating?: string;
  hail_rating?: string;
  wind_load_rating?: number;
  snow_load_rating?: number; // Snow load capacity in Pa

  // Economic data
  msrp_usd?: number;
  warranty_years: number;
  performance_warranty_years?: number; // Linear performance warranty period
  installation_cost_factor?: number; // Multiplier for installation complexity

  // Technology details
  cell_technology?: string;
  number_of_cells?: number;
  bypass_diodes?: number; // Number of bypass diodes
  junction_box_rating?: string; // IP rating of junction box

  // Metadata
  data_source?: string;
  verified: boolean;
  created_at: string;
  updated_at: string;
}

export interface WindTurbineModel {
  id: string;
  name: string;
  manufacturer: string;
  model: string;

  // Power specifications
  rated_power_w: number;
  cut_in_speed_ms: number;
  cut_out_speed_ms: number;
  rated_wind_speed_ms: number;

  // Physical specifications
  rotor_diameter_m: number;
  hub_height_m: number;
  swept_area_m2: number;

  // Power curve data (JSON)
  power_curve: string; // JSON array of {wind_speed, power} points

  // Economic data
  msrp_usd?: number;
  installation_cost_usd?: number;
  maintenance_cost_annual_usd?: number;

  // Metadata
  data_source?: string;
  verified: boolean;
  created_at: string;
  updated_at: string;
}

export interface SystemConfiguration {
  id: string;
  name: string;
  description?: string;

  // Mining equipment
  miner_id: string;
  miner_quantity: number;
  miner_efficiency_factor: number;
  miner_overclocking_factor?: number; // Performance increase from overclocking (1.0 = default)
  miner_undervolting_savings?: number; // Power reduction from undervolting (% of rated consumption)

  // Solar power system
  solar_panel_id?: string;
  solar_panel_quantity: number;
  solar_system_efficiency: number;
  solar_inverter_efficiency: number;
  solar_tilt_angle?: number; // Panel tilt angle in degrees
  solar_azimuth_angle?: number; // Panel azimuth angle (0° = south)
  solar_shading_factor?: number; // System-level shading factor (0-1)
  solar_soiling_factor?: number; // Performance reduction from soiling (0-1)

  // Wind power system
  wind_turbine_id?: string;
  wind_turbine_quantity: number;
  wind_hub_height_m?: number;
  wind_turbulence_factor?: number; // Site turbulence impact on performance

  // Location and environmental data
  latitude: number;
  longitude: number;
  elevation_m: number;
  timezone: string;
  climate_zone?: string; // Köppen climate classification
  avg_ambient_temp_c?: number; // Average ambient temperature

  // Battery storage
  battery_capacity_kwh: number;
  battery_efficiency: number;
  battery_depth_discharge?: number; // Maximum depth of discharge (0-1)
  battery_cycle_life?: number; // Expected number of charge cycles
  battery_degradation_annual?: number; // Annual capacity degradation (%)

  // Grid connection and pricing
  grid_connection: boolean;
  electricity_rate_usd_kwh: number;
  net_metering: boolean;
  net_metering_rate?: number; // Rate for selling back to grid ($/kWh)
  demand_charges_usd_kw?: number; // Monthly demand charges ($/kW)
  time_of_use_pricing?: string; // JSON object with TOU rate structure
  grid_connection_fee_monthly?: number; // Monthly grid connection fee

  // Mining pool configuration
  mining_pool_fee?: number; // Pool fee percentage (0-1)
  mining_pool_payout_threshold?: number; // Minimum payout threshold in BTC
  preferred_mining_pools?: string; // JSON array of preferred pool configurations

  // Economic parameters
  discount_rate: number;
  electricity_rate_escalation: number;
  equipment_replacement_schedule?: string; // JSON object with replacement timeline
  maintenance_cost_annual_percent?: number; // Annual maintenance as % of equipment cost
  insurance_cost_annual_percent?: number; // Annual insurance as % of equipment cost

  // Risk and optimization parameters
  btc_price_volatility_factor?: number; // Expected Bitcoin price volatility (0-1)
  network_difficulty_growth_rate?: number; // Expected annual difficulty growth
  renewable_energy_certificate_value?: number; // Value of RECs in $/MWh

  // Metadata
  created_by?: string;
  is_public: boolean;
  template_category?: string; // Template category for common configurations
  configuration_version?: string; // Version for configuration compatibility
  created_at: string;
  updated_at: string;
}

export interface Projection {
  id: string;
  system_config_id: string;
  name: string;
  description?: string;

  // Projection parameters
  start_date: string; // ISO date string
  end_date: string; // ISO date string
  calculation_interval: 'daily' | 'weekly' | 'monthly';

  // Bitcoin network assumptions (JSON)
  btc_price_model: string;
  difficulty_model: string;
  block_reward_halvings?: string;

  // Results (JSON)
  results_summary: string;
  daily_results?: string;
  monthly_results?: string;
  annual_results?: string;

  // Financial metrics
  total_investment_usd?: number;
  total_revenue_usd?: number;
  total_profit_usd?: number;
  roi_percent?: number;
  payback_period_years?: number;
  npv_usd?: number;
  irr_percent?: number;

  // Performance metrics
  total_energy_generated_kwh?: number;
  total_btc_mined?: number;
  average_capacity_factor?: number;

  // Calculation metadata
  calculation_time_ms?: number;
  calculation_version?: string;

  // Metadata
  created_by?: string;
  is_public: boolean;
  created_at: string;
  updated_at: string;
}

export interface WeatherData {
  id: string;
  location_hash: string;
  latitude: number;
  longitude: number;

  date: string; // ISO date string
  hour?: number;

  // Solar irradiance (W/m²)
  ghi?: number; // Global Horizontal Irradiance
  dni?: number; // Direct Normal Irradiance
  dhi?: number; // Diffuse Horizontal Irradiance
  poa_irradiance?: number; // Plane of Array irradiance for tilted surfaces
  clearsky_ghi?: number; // Clear sky GHI for comparison
  clearsky_dni?: number; // Clear sky DNI for comparison

  // Enhanced solar data
  solar_zenith_angle?: number; // Sun's zenith angle in degrees
  solar_azimuth_angle?: number; // Sun's azimuth angle in degrees
  airmass?: number; // Atmospheric air mass value
  precipitable_water?: number; // Atmospheric water vapor (cm)
  aerosol_optical_depth?: number; // Atmospheric aerosol content

  // Weather conditions
  temperature_c?: number;
  humidity_percent?: number;
  wind_speed_ms?: number;
  wind_direction_deg?: number;
  pressure_hpa?: number;
  cloud_cover_percent?: number;

  // Enhanced weather parameters
  dewpoint_c?: number; // Dew point temperature
  visibility_km?: number; // Atmospheric visibility
  uv_index?: number; // UV index value
  precipitation_mm?: number; // Precipitation amount
  snow_depth_cm?: number; // Snow depth on ground
  surface_albedo?: number; // Ground reflectance (0-1)

  // Air quality factors affecting solar performance
  pm25_ugm3?: number; // PM2.5 particulate matter concentration
  pm10_ugm3?: number; // PM10 particulate matter concentration
  dust_density_mgm2?: number; // Dust accumulation density

  // Forecasting metadata
  is_forecast: boolean; // True if forecast data, false if historical
  forecast_horizon_hours?: number; // How many hours ahead this forecast is
  forecast_confidence?: number; // Forecast confidence level (0-1)

  // Data quality and validation
  data_source: string;
  data_quality: 'excellent' | 'good' | 'fair' | 'poor' | 'estimated' | 'interpolated';
  quality_flags?: string; // JSON array of quality control flags
  measurement_uncertainty?: number; // Measurement uncertainty percentage

  created_at: string;
}

export interface BitcoinNetworkData {
  id: string;
  recorded_date: string; // ISO date string

  // Price data
  price_usd: number;
  market_cap_usd?: number;
  volume_24h_usd?: number;
  price_change_24h_percent?: number;
  price_volatility_30d?: number; // 30-day volatility measure

  // Network data
  network_hashrate_eh: number;
  difficulty: number;
  block_height: number;
  block_reward: number;
  transaction_fees_btc: number;

  // Enhanced network metrics
  hashprice_usd_per_th?: number; // Revenue per TH/s per day in USD
  next_difficulty_estimate?: number; // Estimated next difficulty adjustment
  difficulty_adjustment_percentage?: number; // % change in last difficulty adjustment
  blocks_until_adjustment?: number; // Blocks remaining until next difficulty change
  estimated_adjustment_time?: string; // ISO date string for next adjustment
  mempool_size_mb?: number; // Current mempool size
  avg_block_time_minutes?: number; // Recent average block time

  // Transaction and fee data
  transactions_per_block?: number; // Average transactions per block
  avg_transaction_fee_usd?: number; // Average transaction fee in USD
  fee_rate_sat_vb?: number; // Fee rate in satoshis per vByte
  high_priority_fee_sat_vb?: number; // High priority fee rate

  // Market microstructure
  bid_ask_spread_percent?: number; // Current bid-ask spread
  order_book_depth_btc?: number; // Order book depth at 1% from mid

  // Mining pool data
  largest_pool_percentage?: number; // Largest pool's network share
  pool_concentration_hhi?: number; // Herfindahl-Hirschman Index for pools

  // Network health metrics
  node_count?: number; // Estimated number of full nodes
  lightning_capacity_btc?: number; // Lightning Network capacity

  // Mining economics (enhanced)
  revenue_per_th_usd?: number;
  profit_per_th_usd?: number; // Assumes $0.05/kWh electricity
  break_even_electricity_cost?: number; // $/kWh for break-even
  mining_revenue_7d_ma?: number; // 7-day moving average of mining revenue

  // Long-term indicators
  stock_to_flow_ratio?: number; // Current stock-to-flow ratio
  days_until_halving?: number; // Days remaining until next halving
  puell_multiple?: number; // Puell Multiple indicator
  miner_capitulation_indicator?: number; // Miner stress indicator (0-1)

  // Metadata and quality
  data_source: string;
  data_freshness_minutes?: number; // How old this data is in minutes
  data_reliability_score?: number; // Data quality score (0-1)
  created_at: string;
}

export interface CalculationCache {
  cache_key: string;
  cache_data: string; // JSON data
  expires_at: string; // ISO date string
  cache_type: 'weather' | 'bitcoin_network' | 'calculation_result' | 'hardware_data';
  cache_size_bytes?: number;
  hit_count?: number; // Number of times this cache entry has been accessed
  created_at: string;
}

// New interfaces for enhanced functionality

export interface MiningPoolConfiguration {
  id: string;
  pool_name: string;
  pool_url: string;

  // Pool characteristics
  fee_percentage: number;
  payout_method: 'pps' | 'pplns' | 'fpps' | 'solo'; // Pay Per Share, Pay Per Last N Shares, etc.
  minimum_payout_btc: number;
  payout_frequency: 'immediate' | 'daily' | 'weekly' | 'manual';

  // Pool performance metrics
  pool_hashrate_percentage?: number; // Percentage of total network hashrate
  pool_uptime_percentage?: number; // Historical uptime
  block_finding_variance?: number; // Variance in block finding (luck factor)
  stale_share_rate?: number; // Percentage of stale shares

  // Geographic and latency
  server_locations?: string; // JSON array of server locations
  avg_latency_ms?: number; // Average latency for connections

  // Features and compatibility
  supported_mining_software?: string; // JSON array of compatible mining software
  supports_merged_mining?: boolean; // Whether pool supports merged mining
  supports_ssl?: boolean; // SSL/TLS support

  // Metadata
  data_source?: string;
  verified: boolean;
  created_at: string;
  updated_at: string;
}

export interface HardwareComparisonTemplate {
  id: string;
  template_name: string;
  template_category: 'beginner' | 'intermediate' | 'advanced' | 'commercial' | 'industrial';

  // Template configuration
  recommended_miners?: string; // JSON array of miner IDs
  recommended_solar_panels?: string; // JSON array of solar panel IDs
  recommended_inverters?: string; // JSON array of inverter specifications

  // Use case parameters
  target_hashrate_th?: number; // Target total hashrate
  target_power_generation_kw?: number; // Target solar generation
  budget_range_usd?: string; // JSON object with min/max budget
  space_requirements_m2?: number; // Required installation space

  // Geographic suitability
  suitable_climate_zones?: string; // JSON array of Köppen climate codes
  min_solar_irradiance_kwh_m2?: number; // Minimum required annual irradiance

  // Performance expectations
  expected_roi_months?: number; // Expected payback period
  expected_capacity_factor?: number; // Expected renewable energy capacity factor
  risk_level: 'low' | 'medium' | 'high';

  // Documentation
  description?: string;
  setup_instructions?: string; // Markdown text with setup guide
  maintenance_schedule?: string; // JSON object with maintenance requirements

  // Metadata
  created_by?: string;
  usage_count?: number; // How many times this template has been used
  average_rating?: number; // User rating (1-5)
  is_featured: boolean;
  created_at: string;
  updated_at: string;
}

export interface RiskAnalysisScenario {
  id: string;
  system_config_id: string;
  scenario_name: string;
  scenario_type: 'monte_carlo' | 'sensitivity' | 'stress_test' | 'what_if';

  // Scenario parameters (JSON)
  variable_ranges: string; // JSON object defining parameter ranges
  correlation_matrix?: string; // JSON matrix of variable correlations
  simulation_runs?: number; // Number of Monte Carlo runs
  confidence_intervals?: string; // JSON array of confidence levels to calculate

  // Results summary (JSON)
  risk_metrics: string; // JSON object with VaR, CVaR, etc.
  probability_distributions?: string; // JSON object with result distributions

  // Key outcomes
  probability_of_loss?: number; // Probability of negative ROI
  expected_roi_percent?: number; // Expected return on investment
  roi_standard_deviation?: number; // Volatility of returns
  worst_case_loss_percent?: number; // Maximum loss in worst-case scenario
  best_case_gain_percent?: number; // Maximum gain in best-case scenario

  // Breakeven analysis
  breakeven_btc_price?: number; // BTC price needed to break even
  breakeven_electricity_cost?: number; // Max electricity cost for profitability
  breakeven_hashrate?: number; // Minimum required hashrate

  // Metadata
  calculation_time_ms?: number;
  created_at: string;
  updated_at: string;
}

export interface RealTimeDataStream {
  id: string;
  data_type: 'bitcoin_price' | 'network_hashrate' | 'weather' | 'electricity_price';
  source_api: string;

  // Data stream configuration
  update_frequency_seconds: number;
  data_retention_days: number;
  quality_threshold: number; // Minimum acceptable data quality (0-1)

  // Current status
  is_active: boolean;
  last_update: string; // ISO date string
  consecutive_failures: number;
  total_requests: number;
  successful_requests: number;

  // Rate limiting
  requests_per_hour_limit?: number;
  current_hour_requests?: number;
  rate_limit_reset_time?: string;

  // Data validation
  validation_rules?: string; // JSON object with validation criteria
  outlier_detection_enabled: boolean;
  data_smoothing_enabled: boolean;

  // API configuration
  api_endpoint: string;
  api_key_required: boolean;
  request_headers?: string; // JSON object with custom headers
  timeout_seconds?: number;

  // Metadata
  created_at: string;
  updated_at: string;
}

export interface OptimizationResult {
  id: string;
  system_config_id: string;
  optimization_type: 'equipment_mix' | 'sizing' | 'placement' | 'operational' | 'financial';

  // Optimization parameters
  objective_function: 'maximize_roi' | 'minimize_payback' | 'maximize_hashrate' | 'minimize_risk';
  constraints?: string; // JSON object with optimization constraints
  optimization_algorithm: 'genetic' | 'simulated_annealing' | 'gradient_descent' | 'brute_force';

  // Results
  optimal_configuration: string; // JSON object with optimal parameter values
  objective_value: number; // Value of the objective function at optimum
  improvement_percentage?: number; // Improvement over baseline configuration

  // Solution quality
  convergence_iterations?: number; // Number of iterations to converge
  solution_confidence?: number; // Confidence in solution quality (0-1)
  local_optimum_risk?: number; // Risk that solution is only locally optimal

  // Alternative solutions
  pareto_frontier?: string; // JSON array of Pareto-optimal solutions
  sensitivity_to_changes?: string; // JSON object showing sensitivity analysis

  // Computational details
  computation_time_ms: number;
  memory_usage_mb?: number;
  cpu_cores_used?: number;

  // Metadata
  created_at: string;
}

export interface APIUsageLog {
  id: string;
  user_id?: string;
  endpoint: string;
  method: string;
  status_code: number;
  response_time_ms?: number;
  request_size_bytes?: number;
  response_size_bytes?: number;
  ip_address?: string;
  user_agent?: string;
  created_at: string;
}

// Helper types for parsing JSON fields
export interface MinerDimensions {
  length: number;
  width: number;
  height: number;
}

export interface MinerTempRange {
  min: number;
  max: number;
}

export interface PowerCurvePoint {
  wind_speed: number;
  power: number;
}

export interface BTCPriceModel {
  type: 'fixed' | 'growth' | 'historical' | 'monte_carlo';
  parameters: Record<string, unknown>;
}

export interface DifficultyModel {
  type: 'fixed' | 'growth' | 'historical' | 'network_based';
  parameters: Record<string, unknown>;
}
