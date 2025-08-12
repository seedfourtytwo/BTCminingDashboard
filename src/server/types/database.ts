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
  
  // Economic data
  msrp_usd?: number;
  release_date?: string; // ISO date string
  discontinuation_date?: string; // ISO date string
  
  // Performance characteristics
  hashrate_degradation_annual: number;
  efficiency_degradation_annual: number;
  failure_rate_annual: number;
  
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
  
  // Durability and ratings
  max_system_voltage?: number;
  fire_rating?: string;
  hail_rating?: string;
  wind_load_rating?: number;
  
  // Economic data
  msrp_usd?: number;
  warranty_years: number;
  
  // Technology details
  cell_technology?: string;
  number_of_cells?: number;
  
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
  
  // Solar power system
  solar_panel_id?: string;
  solar_panel_quantity: number;
  solar_system_efficiency: number;
  solar_inverter_efficiency: number;
  
  // Wind power system
  wind_turbine_id?: string;
  wind_turbine_quantity: number;
  wind_hub_height_m?: number;
  
  // Location and environmental data
  latitude: number;
  longitude: number;
  elevation_m: number;
  timezone: string;
  
  // Battery storage
  battery_capacity_kwh: number;
  battery_efficiency: number;
  
  // Grid connection
  grid_connection: boolean;
  electricity_rate_usd_kwh: number;
  net_metering: boolean;
  
  // Economic parameters
  discount_rate: number;
  electricity_rate_escalation: number;
  
  // Metadata
  created_by?: string;
  is_public: boolean;
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
  
  // Weather conditions
  temperature_c?: number;
  humidity_percent?: number;
  wind_speed_ms?: number;
  wind_direction_deg?: number;
  pressure_hpa?: number;
  cloud_cover_percent?: number;
  
  // Data quality
  data_source: string;
  data_quality: 'good' | 'fair' | 'poor' | 'estimated';
  
  created_at: string;
}

export interface BitcoinNetworkData {
  id: string;
  recorded_date: string; // ISO date string
  
  // Price data
  price_usd: number;
  market_cap_usd?: number;
  volume_24h_usd?: number;
  
  // Network data
  network_hashrate_eh: number;
  difficulty: number;
  block_height: number;
  block_reward: number;
  transaction_fees_btc: number;
  
  // Mining economics
  revenue_per_th_usd?: number;
  profit_per_th_usd?: number;
  
  // Metadata
  data_source: string;
  created_at: string;
}

export interface CalculationCache {
  cache_key: string;
  cache_data: string; // JSON data
  expires_at: string; // ISO date string
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