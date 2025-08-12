/**
 * API request/response type definitions
 */

// Common API response wrapper
export interface APIResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
  meta?: {
    pagination?: PaginationMeta;
    timestamp: string;
    request_id?: string;
  };
}

export interface PaginationMeta {
  page: number;
  per_page: number;
  total: number;
  total_pages: number;
  has_next: boolean;
  has_prev: boolean;
}

export interface PaginationParams {
  page?: number;
  per_page?: number;
  sort_by?: string;
  sort_order?: 'asc' | 'desc';
}

// Equipment API types
export interface CreateMinerRequest {
  name: string;
  manufacturer: string;
  model: string;
  hashrate_th: number;
  power_consumption_w: number;
  efficiency_j_th: number;
  dimensions_mm?: Record<string, number>;
  weight_kg?: number;
  noise_level_db?: number;
  operating_temp_range?: Record<string, number>;
  msrp_usd?: number;
  release_date?: string;
  data_source?: string;
}

export interface UpdateMinerRequest extends Partial<CreateMinerRequest> {}

export interface MinerQueryParams extends PaginationParams {
  manufacturer?: string;
  min_hashrate?: number;
  max_hashrate?: number;
  min_efficiency?: number;
  max_efficiency?: number;
  verified_only?: boolean;
}

// Solar panel API types
export interface CreateSolarPanelRequest {
  name: string;
  manufacturer: string;
  model: string;
  rated_power_w: number;
  voltage_vmp: number;
  current_imp: number;
  voltage_voc: number;
  current_isc: number;
  panel_area_m2: number;
  efficiency_percent: number;
  temperature_coefficient: number;
  degradation_rate_annual?: number;
  msrp_usd?: number;
  warranty_years?: number;
  cell_technology?: string;
  data_source?: string;
}

export interface UpdateSolarPanelRequest extends Partial<CreateSolarPanelRequest> {}

// System configuration API types
export interface CreateSystemConfigRequest {
  name: string;
  description?: string;
  miner_id: string;
  miner_quantity: number;
  miner_efficiency_factor?: number;
  solar_panel_id?: string;
  solar_panel_quantity?: number;
  solar_system_efficiency?: number;
  solar_inverter_efficiency?: number;
  wind_turbine_id?: string;
  wind_turbine_quantity?: number;
  wind_hub_height_m?: number;
  latitude: number;
  longitude: number;
  elevation_m?: number;
  timezone: string;
  battery_capacity_kwh?: number;
  battery_efficiency?: number;
  grid_connection?: boolean;
  electricity_rate_usd_kwh?: number;
  net_metering?: boolean;
  discount_rate?: number;
  electricity_rate_escalation?: number;
  is_public?: boolean;
}

export interface UpdateSystemConfigRequest extends Partial<CreateSystemConfigRequest> {}

// Projection API types
export interface CreateProjectionRequest {
  system_config_id: string;
  name: string;
  description?: string;
  start_date: string;
  end_date: string;
  calculation_interval?: 'daily' | 'weekly' | 'monthly';
  btc_price_model: Record<string, unknown>;
  difficulty_model: Record<string, unknown>;
  block_reward_halvings?: string[];
  is_public?: boolean;
}

export interface ProjectionQueryParams extends PaginationParams {
  system_config_id?: string;
  created_by?: string;
  public_only?: boolean;
  min_roi?: number;
  max_payback_years?: number;
}

// Calculation API types
export interface SolarProductionRequest {
  panel_specs: {
    rated_power_w: number;
    efficiency_percent: number;
    temperature_coefficient: number;
    degradation_rate_annual: number;
    panel_area_m2: number;
  };
  system_specs: {
    panel_quantity: number;
    system_efficiency: number;
    inverter_efficiency: number;
  };
  location: {
    latitude: number;
    longitude: number;
    elevation_m?: number;
    timezone: string;
  };
  timeframe: {
    start_date: string;
    end_date: string;
    interval: 'hourly' | 'daily' | 'monthly';
  };
}

export interface SolarProductionResponse {
  estimated_annual_kwh: number;
  monthly_production: Array<{
    month: number;
    year: number;
    kwh: number;
    capacity_factor: number;
  }>;
  daily_production?: Array<{
    date: string;
    kwh: number;
  }>;
  total_lifetime_kwh: number;
  average_capacity_factor: number;
  performance_metrics: {
    first_year_degradation: number;
    annual_degradation: number;
    end_of_life_capacity: number;
  };
}

export interface MiningProjectionRequest {
  miner_specs: {
    hashrate_th: number;
    power_consumption_w: number;
    efficiency_j_th: number;
    quantity: number;
    efficiency_factor: number;
  };
  power_source: {
    type: 'solar' | 'grid' | 'hybrid';
    available_power_kw: number;
    electricity_rate_usd_kwh?: number;
  };
  bitcoin_assumptions: {
    current_price_usd: number;
    price_model: Record<string, unknown>;
    current_difficulty: number;
    difficulty_model: Record<string, unknown>;
    current_block_reward: number;
    halving_dates: string[];
  };
  timeframe: {
    start_date: string;
    end_date: string;
    interval: 'daily' | 'monthly';
  };
}

export interface MiningProjectionResponse {
  projected_btc_annual: number;
  projected_revenue_usd: number;
  projected_costs_usd: number;
  projected_profit_usd: number;
  break_even_btc_price: number;
  monthly_breakdown: Array<{
    month: number;
    year: number;
    btc_mined: number;
    revenue_usd: number;
    electricity_cost_usd: number;
    profit_usd: number;
    difficulty: number;
    btc_price_usd: number;
  }>;
  cumulative_metrics: {
    total_btc_mined: number;
    total_revenue_usd: number;
    total_costs_usd: number;
    total_profit_usd: number;
    roi_percent: number;
    payback_period_months: number;
  };
}

export interface MonteCarloRequest {
  base_scenario: MiningProjectionRequest;
  variables: Array<{
    name: string;
    type: 'normal' | 'uniform' | 'triangular';
    parameters: Record<string, number>;
  }>;
  iterations: number;
  confidence_levels: number[]; // e.g., [0.1, 0.5, 0.9]
}

export interface MonteCarloResponse {
  scenarios_analyzed: number;
  confidence_intervals: Record<
    string,
    {
      metric: string;
      percentiles: Record<string, number>;
    }
  >;
  risk_metrics: {
    probability_of_loss: number;
    expected_value: number;
    value_at_risk: Record<string, number>;
    scenarios_profitable: number;
  };
  scenario_distribution: Array<{
    scenario_id: number;
    total_profit_usd: number;
    roi_percent: number;
    payback_period_months: number;
  }>;
}

export interface FinancialMetricsRequest {
  cash_flows: Array<{
    period: number;
    cash_flow: number;
    date: string;
  }>;
  initial_investment: number;
  discount_rate: number;
  terminal_value?: number;
}

export interface FinancialMetricsResponse {
  npv: number;
  irr: number;
  payback_period_years: number;
  discounted_payback_period_years: number;
  profitability_index: number;
  roi_percent: number;
  break_even_analysis: {
    break_even_period: number;
    break_even_cash_flow: number;
  };
}

// Data worker API types
export interface BitcoinPriceResponse {
  price_usd: number;
  market_cap_usd: number;
  volume_24h_usd: number;
  price_change_24h_percent: number;
  last_updated: string;
  source: string;
}

export interface BitcoinNetworkStatsResponse {
  network_hashrate_eh: number;
  difficulty: number;
  block_height: number;
  block_reward: number;
  next_halving_estimate: string;
  time_since_last_block_minutes: number;
  mempool_size: number;
  average_fee_usd: number;
  last_updated: string;
}

export interface WeatherDataRequest {
  latitude: number;
  longitude: number;
  start_date?: string;
  end_date?: string;
  data_types: ('temperature' | 'irradiance' | 'wind' | 'humidity')[];
}

export interface WeatherDataResponse {
  location: {
    latitude: number;
    longitude: number;
    timezone: string;
  };
  current_conditions: {
    temperature_c: number;
    humidity_percent: number;
    wind_speed_ms: number;
    cloud_cover_percent: number;
    ghi: number;
    dni: number;
    dhi: number;
  };
  forecast?: Array<{
    date: string;
    hour?: number;
    temperature_c: number;
    ghi: number;
    wind_speed_ms: number;
  }>;
  data_source: string;
  last_updated: string;
}

// Error types
export interface ValidationError {
  field: string;
  message: string;
  code: string;
  value?: unknown;
}

export interface APIError {
  code: string;
  message: string;
  details?: ValidationError[];
  context?: Record<string, unknown>;
  timestamp: string;
}
