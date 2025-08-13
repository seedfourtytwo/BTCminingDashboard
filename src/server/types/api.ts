/**
 * API request/response type definitions
 * Enhanced with real-time data pipeline and advanced mining calculator features
 * Based on research of leading Bitcoin mining profitability calculators
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

// Enhanced API types for advanced features (documentation for future implementation)

// Real-time data pipeline types
export interface RealtimeDataSubscription {
  data_types: ('bitcoin_price' | 'network_stats' | 'weather' | 'mining_pools')[];
  update_frequency: 'immediate' | 'minute' | '5minute' | 'hour';
  location_filters?: {
    latitude: number;
    longitude: number;
    radius_km?: number;
  };
}

export interface RealtimeDataEvent {
  event_type: string;
  timestamp: string;
  data: Record<string, unknown>;
  data_source: string;
  quality_score: number;
}

// Hardware comparison and template types
export interface HardwareComparisonRequest {
  miner_ids?: string[];
  panel_ids?: string[];
  comparison_metrics: ('efficiency' | 'roi' | 'payback' | 'hashrate_per_dollar')[];
  location?: {
    latitude: number;
    longitude: number;
  };
  electricity_cost?: number;
  btc_price_assumption?: number;
}

export interface HardwareComparisonResponse {
  comparison_matrix: Record<string, Record<string, number>>;
  rankings: Array<{
    equipment_id: string;
    equipment_name: string;
    rank: number;
    score: number;
    strengths: string[];
    weaknesses: string[];
  }>;
  recommendation: {
    best_overall: string;
    best_efficiency: string;
    best_value: string;
    best_beginner: string;
  };
}

// Template and configuration wizard types
export interface ConfigurationWizardStep {
  step_id: string;
  step_name: string;
  step_description: string;
  input_fields: Array<{
    field_name: string;
    field_type: 'text' | 'number' | 'select' | 'multiselect' | 'location' | 'slider';
    required: boolean;
    validation_rules?: Record<string, unknown>;
    options?: Array<{ value: string; label: string }>;
    help_text?: string;
  }>;
  next_step_logic?: Record<string, string>; // conditional navigation
}

export interface ConfigurationTemplateRequest {
  template_category: 'beginner' | 'intermediate' | 'advanced' | 'commercial';
  budget_range?: {
    min_usd: number;
    max_usd: number;
  };
  target_hashrate?: number;
  location?: {
    latitude: number;
    longitude: number;
  };
  risk_tolerance: 'low' | 'medium' | 'high';
}

// Risk analysis and Monte Carlo simulation types
export interface RiskAnalysisRequest {
  system_config_id: string;
  analysis_type: 'monte_carlo' | 'sensitivity' | 'scenario' | 'stress_test';
  parameters: {
    simulation_runs?: number;
    confidence_levels?: number[];
    variable_correlations?: Record<string, Record<string, number>>;
    stress_scenarios?: Array<{
      name: string;
      btc_price_change: number;
      difficulty_change: number;
      electricity_cost_change: number;
    }>;
  };
}

export interface RiskAnalysisResponse {
  analysis_type: string;
  total_scenarios: number;
  risk_metrics: {
    probability_of_loss: number;
    value_at_risk_95: number;
    expected_return: number;
    return_volatility: number;
    sharpe_ratio?: number;
  };
  scenario_results: Array<{
    scenario_name: string;
    probability: number;
    total_profit_usd: number;
    roi_percent: number;
    break_even_months: number;
  }>;
  sensitivity_analysis?: Record<
    string,
    {
      variable_name: string;
      impact_on_roi: number;
      correlation_coefficient: number;
    }
  >;
}

// Optimization and recommendation types
export interface OptimizationRequest {
  objective: 'maximize_roi' | 'minimize_payback' | 'maximize_hashrate' | 'minimize_risk';
  constraints: {
    max_budget_usd?: number;
    max_power_consumption_kw?: number;
    max_space_m2?: number;
    min_roi_percent?: number;
    max_payback_years?: number;
  };
  location: {
    latitude: number;
    longitude: number;
  };
  preferences?: {
    prefer_newer_equipment?: boolean;
    prefer_established_manufacturers?: boolean;
    include_experimental_tech?: boolean;
  };
}

export interface OptimizationResponse {
  optimal_configuration: {
    miners: Array<{
      miner_id: string;
      quantity: number;
      total_cost_usd: number;
      total_hashrate_th: number;
    }>;
    solar_panels: Array<{
      panel_id: string;
      quantity: number;
      total_cost_usd: number;
      total_power_kw: number;
    }>;
    total_investment_usd: number;
    expected_roi_percent: number;
    payback_period_years: number;
  };
  alternative_configurations: Array<{
    configuration_name: string;
    trade_offs: string;
    performance_comparison: Record<string, number>;
  }>;
  optimization_metadata: {
    algorithm_used: string;
    computation_time_ms: number;
    confidence_score: number;
    iterations_performed: number;
  };
}

// Export and reporting types
export interface ReportGenerationRequest {
  system_config_id: string;
  projection_id?: string;
  report_type: 'financial_summary' | 'technical_specs' | 'risk_analysis' | 'comprehensive';
  format: 'pdf' | 'xlsx' | 'csv' | 'json';
  include_charts: boolean;
  custom_branding?: {
    logo_url?: string;
    company_name?: string;
    contact_info?: string;
  };
}

export interface ReportGenerationResponse {
  report_id: string;
  download_url: string;
  expires_at: string;
  file_size_bytes: number;
  generation_time_ms: number;
}

// Mining pool integration types
export interface MiningPoolAnalysisRequest {
  hashrate_th: number;
  location?: {
    latitude: number;
    longitude: number;
  };
  preferences?: {
    payout_frequency?: 'immediate' | 'daily' | 'weekly';
    min_payout_btc?: number;
    prefer_low_variance?: boolean;
  };
}

export interface MiningPoolAnalysisResponse {
  recommended_pools: Array<{
    pool_name: string;
    pool_url: string;
    fee_percentage: number;
    expected_payout_variance: number;
    estimated_latency_ms: number;
    payout_frequency: string;
    pros: string[];
    cons: string[];
    suitability_score: number;
  }>;
  pool_comparison_matrix: Record<string, Record<string, number | string>>;
}

// Enhanced weather and environmental data types
export interface EnvironmentalImpactRequest {
  system_config_id: string;
  analysis_scope: 'solar_performance' | 'mining_efficiency' | 'combined';
  location: {
    latitude: number;
    longitude: number;
  };
  time_horizon_years: number;
}

export interface EnvironmentalImpactResponse {
  solar_impact_factors: {
    soiling_losses_percent: number;
    temperature_derating_percent: number;
    weather_variability_impact: number;
    seasonal_performance_variation: Record<string, number>;
  };
  mining_impact_factors: {
    temperature_efficiency_impact: number;
    cooling_cost_increase_percent: number;
    equipment_lifespan_impact_years: number;
  };
  mitigation_recommendations: Array<{
    issue: string;
    solution: string;
    estimated_cost_usd: number;
    expected_benefit: string;
  }>;
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
