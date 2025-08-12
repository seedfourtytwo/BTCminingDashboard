# Calculation Engines - Solar Bitcoin Mining Calculator

## Overview

The calculation engines form the core mathematical foundation of the Solar Bitcoin Mining Calculator. These engines model complex interactions between renewable energy generation, Bitcoin mining economics, equipment degradation, and market dynamics to provide accurate projections.

## Engine Architecture

```
Calculation Engine Stack:
├── Solar Generation Engine      → Models PV system power output
├── Wind Generation Engine       → Models wind turbine power output  
├── Mining Performance Engine    → Models Bitcoin mining operations
├── Equipment Degradation Engine → Models performance decline over time
├── Economic Analysis Engine     → Models financial performance
├── Monte Carlo Engine          → Performs risk analysis simulations
└── Optimization Engine         → Finds optimal configurations
```

## 1. Solar Generation Engine

### 1.1 Core Solar Calculations

The solar generation engine uses established photovoltaic modeling principles similar to PVLIB and NREL methodologies.

#### Solar Position Calculations
```typescript
interface SolarPosition {
  elevation: number;    // Solar elevation angle (degrees)
  azimuth: number;     // Solar azimuth angle (degrees)
  zenith: number;      // Solar zenith angle (degrees)
  equation_of_time: number; // Equation of time correction (minutes)
}

function calculateSolarPosition(
  latitude: number,
  longitude: number, 
  date: Date,
  timezone: string
): SolarPosition {
  // Implementation based on NREL Solar Position Algorithm (SPA)
  const dayOfYear = getDayOfYear(date);
  const declination = calculateSolarDeclination(dayOfYear);
  const hourAngle = calculateHourAngle(date, longitude, timezone);
  
  const elevation = Math.asin(
    Math.sin(latitude * Math.PI/180) * Math.sin(declination) +
    Math.cos(latitude * Math.PI/180) * Math.cos(declination) * Math.cos(hourAngle)
  ) * 180/Math.PI;
  
  // Additional calculations for azimuth, zenith, etc.
  return { elevation, azimuth, zenith, equation_of_time };
}
```

#### Irradiance Calculations
```typescript
interface IrradianceComponents {
  ghi: number;  // Global Horizontal Irradiance (W/m²)
  dni: number;  // Direct Normal Irradiance (W/m²)
  dhi: number;  // Diffuse Horizontal Irradiance (W/m²)
  poa: number;  // Plane of Array Irradiance (W/m²)
}

function calculatePlaneOfArrayIrradiance(
  ghi: number,
  dni: number,
  dhi: number,
  solarPosition: SolarPosition,
  panelTilt: number,
  panelAzimuth: number
): number {
  // Transposition model for converting horizontal to tilted plane irradiance
  const incidenceAngle = calculateIncidenceAngle(
    solarPosition.elevation,
    solarPosition.azimuth,
    panelTilt,
    panelAzimuth
  );
  
  // Direct component
  const directComponent = dni * Math.cos(incidenceAngle * Math.PI/180);
  
  // Diffuse component (isotropic sky model)
  const diffuseComponent = dhi * (1 + Math.cos(panelTilt * Math.PI/180)) / 2;
  
  // Ground reflection component
  const albedo = 0.2; // Typical ground albedo
  const groundComponent = ghi * albedo * (1 - Math.cos(panelTilt * Math.PI/180)) / 2;
  
  return Math.max(0, directComponent + diffuseComponent + groundComponent);
}
```

#### PV System Output Calculation
```typescript
interface PVSystemOutput {
  dcPower: number;      // DC power output (W)
  acPower: number;      // AC power output (W)
  efficiency: number;   // System efficiency (%)
  temperature: number;  // Module temperature (°C)
}

function calculatePVOutput(
  irradiance: number,           // Plane of array irradiance (W/m²)
  ambientTemp: number,          // Ambient temperature (°C)
  windSpeed: number,            // Wind speed (m/s)
  panelSpecs: SolarPanelModel,
  systemConfig: PVSystemConfig
): PVSystemOutput {
  // Calculate module temperature
  const moduleTemp = calculateModuleTemperature(ambientTemp, irradiance, windSpeed);
  
  // Temperature coefficient effect
  const tempCoeff = panelSpecs.temperature_coefficient / 100; // Convert from %/°C
  const tempEffect = 1 + tempCoeff * (moduleTemp - 25); // 25°C is STC
  
  // DC power calculation
  const stcIrradiance = 1000; // Standard Test Conditions irradiance (W/m²)
  const dcPower = panelSpecs.rated_power_w * 
                  (irradiance / stcIrradiance) * 
                  tempEffect * 
                  systemConfig.quantity;
  
  // Apply system losses
  const dcPowerAfterLosses = dcPower * calculateSystemLosses(systemConfig);
  
  // Inverter conversion
  const acPower = dcPowerAfterLosses * systemConfig.inverter_efficiency;
  
  return {
    dcPower: dcPowerAfterLosses,
    acPower: acPower,
    efficiency: (acPower / (irradiance * panelSpecs.panel_area_m2 * systemConfig.quantity)) * 100,
    temperature: moduleTemp
  };
}
```

#### System Losses Model
```typescript
interface SystemLosses {
  soiling: number;        // Dust and dirt losses (%)
  shading: number;        // Shading losses (%)
  mismatch: number;       // Module mismatch losses (%)
  wiring: number;         // DC wiring losses (%)
  connections: number;    // Connection losses (%)
  lid: number;           // Light-induced degradation (%)
  nameplate: number;     // Nameplate rating tolerance (%)
  age: number;           // Age-related degradation (%)
}

function calculateSystemLosses(config: PVSystemConfig, ageYears: number = 0): number {
  const losses: SystemLosses = {
    soiling: 0.02,        // 2% typical soiling loss
    shading: config.shading_factor || 0.01,
    mismatch: 0.02,       // 2% module mismatch
    wiring: 0.02,         // 2% DC wiring losses
    connections: 0.005,   // 0.5% connection losses
    lid: 0.015,           // 1.5% light-induced degradation
    nameplate: 0.01,      // 1% nameplate tolerance
    age: ageYears * (config.degradation_rate_annual || 0.005) // Annual degradation
  };
  
  // Compound losses (each loss reduces remaining power)
  let remainingPower = 1.0;
  Object.values(losses).forEach(loss => {
    remainingPower *= (1 - loss);
  });
  
  return remainingPower;
}
```

### 1.2 Advanced Solar Modeling

#### Shading Analysis
```typescript
function calculateShadingLosses(
  solarPosition: SolarPosition,
  systemLayout: PVSystemLayout,
  surroundingObstacles: Obstacle[]
): number {
  // Ray-tracing algorithm for shading analysis
  let shadedArea = 0;
  let totalArea = systemLayout.total_area_m2;
  
  for (const panel of systemLayout.panels) {
    for (const obstacle of surroundingObstacles) {
      const shadowLength = calculateShadowLength(
        obstacle.height,
        solarPosition.elevation
      );
      
      const shadowArea = calculateShadowOverlap(
        panel.position,
        panel.area,
        obstacle.position,
        shadowLength,
        solarPosition.azimuth
      );
      
      shadedArea += shadowArea;
    }
  }
  
  return Math.min(shadedArea / totalArea, 1.0);
}
```

## 2. Wind Generation Engine

### 2.1 Wind Power Calculations

```typescript
interface WindTurbineOutput {
  power: number;        // Power output (W)
  capacity_factor: number; // Capacity factor (%)
  wind_speed_hub: number;  // Wind speed at hub height (m/s)
}

function calculateWindPower(
  windSpeedGround: number,    // Wind speed at measurement height (m/s)
  measurementHeight: number,  // Height of wind measurement (m)
  turbineSpecs: WindTurbineModel,
  turbineConfig: WindTurbineConfig
): WindTurbineOutput {
  // Wind speed extrapolation to hub height using power law
  const alpha = 0.143; // Power law exponent (typical for open terrain)
  const windSpeedHub = windSpeedGround * 
    Math.pow(turbineConfig.hub_height / measurementHeight, alpha);
  
  // Power calculation based on power curve
  const power = interpolatePowerCurve(windSpeedHub, turbineSpecs.power_curve);
  
  // Apply wake effects for multiple turbines
  const wakeEffect = calculateWakeEffect(
    turbineConfig.quantity,
    turbineConfig.spacing_factor || 5.0,
    windSpeedHub
  );
  
  const totalPower = power * turbineConfig.quantity * (1 - wakeEffect);
  
  return {
    power: totalPower,
    capacity_factor: totalPower / (turbineSpecs.rated_power_w * turbineConfig.quantity),
    wind_speed_hub: windSpeedHub
  };
}

function interpolatePowerCurve(windSpeed: number, powerCurve: PowerCurvePoint[]): number {
  // Handle cut-in and cut-out speeds
  if (windSpeed < powerCurve[0].wind_speed) return 0;
  if (windSpeed > powerCurve[powerCurve.length - 1].wind_speed) return 0;
  
  // Linear interpolation between power curve points
  for (let i = 0; i < powerCurve.length - 1; i++) {
    const p1 = powerCurve[i];
    const p2 = powerCurve[i + 1];
    
    if (windSpeed >= p1.wind_speed && windSpeed <= p2.wind_speed) {
      const ratio = (windSpeed - p1.wind_speed) / (p2.wind_speed - p1.wind_speed);
      return p1.power + ratio * (p2.power - p1.power);
    }
  }
  
  return 0;
}
```

## 3. Mining Performance Engine

### 3.1 Bitcoin Mining Calculations

```typescript
interface MiningPerformance {
  daily_btc_earned: number;     // BTC earned per day
  daily_revenue_usd: number;    // Revenue in USD per day
  effective_hashrate: number;   // Hashrate after degradation
  power_consumption: number;    // Actual power consumption (W)
  efficiency: number;           // Current efficiency (J/TH)
}

function calculateMiningPerformance(
  minerSpecs: MinerModel,
  minerConfig: MinerConfiguration,
  networkStats: BitcoinNetworkStats,
  ageMonths: number = 0
): MiningPerformance {
  // Apply degradation based on age
  const degradationFactor = calculateMinerDegradation(minerSpecs, ageMonths);
  
  const effective_hashrate = minerSpecs.hashrate_th * 
    degradationFactor.hashrate_retention * 
    minerConfig.quantity;
    
  const power_consumption = minerSpecs.power_consumption_w * 
    degradationFactor.power_retention * 
    minerConfig.quantity;
  
  // Calculate daily BTC earnings
  const daily_btc_earned = calculateDailyBTCEarnings(
    effective_hashrate,
    networkStats.network_hashrate,
    networkStats.block_reward,
    networkStats.avg_block_time
  );
  
  const daily_revenue_usd = daily_btc_earned * networkStats.btc_price_usd;
  
  return {
    daily_btc_earned,
    daily_revenue_usd,
    effective_hashrate,
    power_consumption,
    efficiency: (power_consumption / effective_hashrate)
  };
}

function calculateDailyBTCEarnings(
  minerHashrate: number,      // TH/s
  networkHashrate: number,    // EH/s (need to convert)
  blockReward: number,        // BTC per block
  avgBlockTime: number        // seconds
): number {
  const networkHashrateTH = networkHashrate * 1e6; // Convert EH/s to TH/s
  const minerShareOfNetwork = minerHashrate / networkHashrateTH;
  
  const blocksPerDay = (24 * 60 * 60) / avgBlockTime;
  const dailyNetworkReward = blocksPerDay * blockReward;
  
  return dailyNetworkReward * minerShareOfNetwork;
}
```

### 3.2 Network Difficulty Projection

```typescript
interface DifficultyProjection {
  future_difficulty: number[];
  adjustment_dates: Date[];
  growth_rate_annual: number;
}

function projectNetworkDifficulty(
  currentDifficulty: number,
  historicalData: BitcoinNetworkHistory[],
  projectionYears: number,
  growthModel: DifficultyGrowthModel
): DifficultyProjection {
  const adjustmentInterval = 2016; // blocks
  const targetBlockTime = 600; // seconds (10 minutes)
  
  switch (growthModel.type) {
    case 'exponential':
      return projectExponentialGrowth(
        currentDifficulty,
        growthModel.annual_growth_rate,
        projectionYears
      );
      
    case 'sigmoid':
      return projectSigmoidGrowth(
        currentDifficulty,
        growthModel.saturation_point,
        growthModel.growth_rate,
        projectionYears
      );
      
    case 'regression':
      return projectRegressionBased(
        historicalData,
        projectionYears,
        growthModel.regression_features
      );
  }
}

function projectExponentialGrowth(
  initialDifficulty: number,
  annualGrowthRate: number,
  years: number
): DifficultyProjection {
  const adjustmentsPerYear = 26.07; // Approximately every 2 weeks
  const adjustmentGrowthRate = Math.pow(1 + annualGrowthRate, 1/adjustmentsPerYear) - 1;
  
  const totalAdjustments = Math.floor(years * adjustmentsPerYear);
  const future_difficulty: number[] = [];
  const adjustment_dates: Date[] = [];
  
  let currentDiff = initialDifficulty;
  let currentDate = new Date();
  
  for (let i = 0; i < totalAdjustments; i++) {
    currentDiff *= (1 + adjustmentGrowthRate);
    currentDate = new Date(currentDate.getTime() + 14 * 24 * 60 * 60 * 1000); // +14 days
    
    future_difficulty.push(currentDiff);
    adjustment_dates.push(new Date(currentDate));
  }
  
  return {
    future_difficulty,
    adjustment_dates,
    growth_rate_annual: annualGrowthRate
  };
}
```

## 4. Equipment Degradation Engine

### 4.1 Miner Degradation Modeling

```typescript
interface DegradationFactors {
  hashrate_retention: number;   // Fraction of original hashrate (0-1)
  power_retention: number;      // Power consumption multiplier
  efficiency_retention: number; // Efficiency retention factor
  failure_probability: number;  // Cumulative failure probability
}

function calculateMinerDegradation(
  minerSpecs: MinerModel,
  ageMonths: number,
  operatingConditions?: OperatingConditions
): DegradationFactors {
  // Base degradation from manufacturer specifications
  const annualHashrateDegradation = minerSpecs.hashrate_degradation_annual;
  const annualEfficiencyDegradation = minerSpecs.efficiency_degradation_annual;
  const annualFailureRate = minerSpecs.failure_rate_annual;
  
  // Time-based degradation
  const ageYears = ageMonths / 12;
  
  // Use performance curve if available, otherwise linear degradation
  let hashrate_retention: number;
  if (minerSpecs.performance_curve) {
    hashrate_retention = interpolatePerformanceCurve(
      ageMonths,
      minerSpecs.performance_curve
    );
  } else {
    hashrate_retention = Math.pow(1 - annualHashrateDegradation, ageYears);
  }
  
  // Environmental factors affecting degradation
  const envFactor = calculateEnvironmentalDegradation(operatingConditions);
  hashrate_retention *= envFactor.hashrate_multiplier;
  
  // Power consumption typically increases slightly as efficiency degrades
  const efficiency_retention = Math.pow(1 - annualEfficiencyDegradation, ageYears);
  const power_retention = 1 / efficiency_retention;
  
  // Cumulative failure probability (Weibull distribution)
  const failure_probability = calculateFailureProbability(ageMonths, annualFailureRate);
  
  return {
    hashrate_retention: Math.max(0.1, hashrate_retention), // Minimum 10% performance
    power_retention: Math.min(1.5, power_retention),       // Maximum 50% power increase
    efficiency_retention,
    failure_probability
  };
}

function calculateEnvironmentalDegradation(
  conditions?: OperatingConditions
): EnvironmentalDegradationFactor {
  if (!conditions) {
    return { hashrate_multiplier: 1.0, life_multiplier: 1.0 };
  }
  
  let degradationMultiplier = 1.0;
  
  // Temperature effects
  const optimalTemp = 25; // °C
  const tempDeviation = Math.abs(conditions.avg_temperature - optimalTemp);
  if (tempDeviation > 10) {
    degradationMultiplier *= (1 - 0.02 * (tempDeviation - 10) / 10); // 2% per 10°C above optimal range
  }
  
  // Humidity effects
  if (conditions.avg_humidity > 80) {
    degradationMultiplier *= 0.98; // 2% degradation for high humidity
  }
  
  // Dust and altitude effects
  if (conditions.dust_level === 'high') {
    degradationMultiplier *= 0.95; // 5% degradation for dusty environments
  }
  
  return {
    hashrate_multiplier: degradationMultiplier,
    life_multiplier: degradationMultiplier
  };
}
```

### 4.2 Solar Panel Degradation

```typescript
function calculateSolarPanelDegradation(
  panelSpecs: SolarPanelModel,
  ageYears: number,
  environmentalFactors: SolarEnvironmentalFactors
): number {
  // Linear degradation model (most common for solar panels)
  const baseDegradationRate = panelSpecs.degradation_rate_annual / 100; // Convert from %
  
  // Environmental acceleration factors
  let accelerationFactor = 1.0;
  
  // High temperature acceleration
  if (environmentalFactors.avg_module_temperature > 60) {
    accelerationFactor *= 1.2; // 20% faster degradation
  }
  
  // UV exposure acceleration
  if (environmentalFactors.annual_uv_exposure > 2000) { // kWh/m²/year
    accelerationFactor *= 1.1; // 10% faster degradation
  }
  
  // Thermal cycling effects
  const dailyTempRange = environmentalFactors.max_temperature - environmentalFactors.min_temperature;
  if (dailyTempRange > 30) {
    accelerationFactor *= 1.15; // 15% faster degradation for high thermal cycling
  }
  
  const effectiveDegradationRate = baseDegradationRate * accelerationFactor;
  const retentionFactor = Math.pow(1 - effectiveDegradationRate, ageYears);
  
  return Math.max(0.7, retentionFactor); // Minimum 70% retention after extreme degradation
}
```

## 5. Economic Analysis Engine

### 5.1 Financial Calculations

```typescript
interface FinancialAnalysis {
  initial_investment: number;   // Total upfront cost
  annual_cash_flows: number[];  // Year-by-year cash flows
  npv: number;                 // Net Present Value
  irr: number;                 // Internal Rate of Return
  payback_period: number;      // Simple payback period (years)
  discounted_payback: number;  // Discounted payback period (years)
  roi_percent: number;         // Return on Investment percentage
}

function calculateFinancialMetrics(
  systemConfig: SystemConfiguration,
  projectionResults: ProjectionResult[],
  discountRate: number = 0.08
): FinancialAnalysis {
  // Calculate initial investment
  const equipmentCosts = calculateEquipmentCosts(systemConfig);
  const installationCosts = calculateInstallationCosts(systemConfig);
  const initial_investment = equipmentCosts + installationCosts;
  
  // Group projection results by year
  const annual_cash_flows = groupCashFlowsByYear(projectionResults);
  
  // Calculate NPV
  const npv = calculateNPV(initial_investment, annual_cash_flows, discountRate);
  
  // Calculate IRR using iterative method
  const irr = calculateIRR(initial_investment, annual_cash_flows);
  
  // Calculate payback periods
  const payback_period = calculatePaybackPeriod(initial_investment, annual_cash_flows);
  const discounted_payback = calculateDiscountedPaybackPeriod(
    initial_investment,
    annual_cash_flows,
    discountRate
  );
  
  const total_cash_flows = annual_cash_flows.reduce((sum, cf) => sum + cf, 0);
  const roi_percent = ((total_cash_flows - initial_investment) / initial_investment) * 100;
  
  return {
    initial_investment,
    annual_cash_flows,
    npv,
    irr,
    payback_period,
    discounted_payback,
    roi_percent
  };
}

function calculateNPV(
  initialInvestment: number,
  cashFlows: number[],
  discountRate: number
): number {
  let npv = -initialInvestment;
  
  cashFlows.forEach((cashFlow, year) => {
    npv += cashFlow / Math.pow(1 + discountRate, year + 1);
  });
  
  return npv;
}

function calculateIRR(
  initialInvestment: number,
  cashFlows: number[],
  precision: number = 0.0001
): number {
  // Newton-Raphson method for IRR calculation
  let rate = 0.1; // Initial guess: 10%
  let iteration = 0;
  const maxIterations = 100;
  
  while (iteration < maxIterations) {
    const npv = calculateNPV(initialInvestment, cashFlows, rate);
    const derivative = calculateNPVDerivative(initialInvestment, cashFlows, rate);
    
    if (Math.abs(npv) < precision) {
      return rate;
    }
    
    rate = rate - npv / derivative;
    iteration++;
  }
  
  return rate; // Return best estimate if convergence not achieved
}
```

### 5.2 Sensitivity Analysis

```typescript
interface SensitivityResult {
  parameter: string;
  base_value: number;
  variation_percent: number;
  npv_impact: number;
  roi_impact: number;
}

function performSensitivityAnalysis(
  baseScenario: ProjectionScenario,
  sensitivityParameters: SensitivityParameter[]
): SensitivityResult[] {
  const baseMetrics = calculateFinancialMetrics(baseScenario);
  const results: SensitivityResult[] = [];
  
  for (const param of sensitivityParameters) {
    for (const variation of [-20, -10, 10, 20]) { // ±20%, ±10%
      const modifiedScenario = applyParameterVariation(baseScenario, param, variation);
      const modifiedMetrics = calculateFinancialMetrics(modifiedScenario);
      
      results.push({
        parameter: param.name,
        base_value: param.base_value,
        variation_percent: variation,
        npv_impact: ((modifiedMetrics.npv - baseMetrics.npv) / baseMetrics.npv) * 100,
        roi_impact: modifiedMetrics.roi_percent - baseMetrics.roi_percent
      });
    }
  }
  
  return results;
}
```

## 6. Monte Carlo Engine

### 6.1 Stochastic Modeling

```typescript
interface MonteCarloParameters {
  btc_price_volatility: number;
  difficulty_variance: number;
  weather_variance: number;
  equipment_failure_variance: number;
  simulation_runs: number;
}

function runMonteCarloSimulation(
  baseScenario: ProjectionScenario,
  mcParams: MonteCarloParameters
): MonteCarloResults {
  const results: SimulationRun[] = [];
  
  for (let run = 1; run <= mcParams.simulation_runs; run++) {
    // Generate random variables for this simulation run
    const randomFactors = generateRandomFactors(mcParams);
    
    // Apply random variations to base scenario
    const stochasticScenario = applyStochasticVariations(baseScenario, randomFactors);
    
    // Calculate projection for this run
    const runResults = calculateProjectionResults(stochasticScenario);
    const runMetrics = calculateFinancialMetrics(stochasticScenario, runResults);
    
    results.push({
      run_number: run,
      total_btc_mined: runResults.reduce((sum, r) => sum + r.btc_mined, 0),
      net_profit_usd: runMetrics.annual_cash_flows.reduce((sum, cf) => sum + cf, 0),
      roi_percent: runMetrics.roi_percent,
      payback_years: runMetrics.payback_period
    });
  }
  
  return analyzeMonteCarloResults(results);
}

function generateRandomFactors(params: MonteCarloParameters): RandomFactors {
  return {
    btc_price_multipliers: generateCorrelatedRandomWalk(
      1.0,                           // Starting value
      params.btc_price_volatility,   // Annual volatility
      365                           // Daily steps
    ),
    difficulty_multipliers: generateRandomWalk(
      1.0,
      params.difficulty_variance,
      26 // Bi-weekly difficulty adjustments
    ),
    weather_multipliers: generateSeasonalRandomVariation(
      params.weather_variance,
      365
    ),
    equipment_failures: generateEquipmentFailureEvents(
      params.equipment_failure_variance
    )
  };
}

function analyzeMonteCarloResults(results: SimulationRun[]): MonteCarloResults {
  const sortedROI = results.map(r => r.roi_percent).sort((a, b) => a - b);
  const sortedProfit = results.map(r => r.net_profit_usd).sort((a, b) => a - b);
  
  return {
    summary_statistics: {
      mean_roi: calculateMean(sortedROI),
      median_roi: calculatePercentile(sortedROI, 50),
      std_dev_roi: calculateStandardDeviation(sortedROI),
      mean_profit: calculateMean(sortedProfit),
      median_profit: calculatePercentile(sortedProfit, 50)
    },
    confidence_intervals: {
      roi_ci_5: calculatePercentile(sortedROI, 5),
      roi_ci_25: calculatePercentile(sortedROI, 25),
      roi_ci_75: calculatePercentile(sortedROI, 75),
      roi_ci_95: calculatePercentile(sortedROI, 95),
      profit_ci_5: calculatePercentile(sortedProfit, 5),
      profit_ci_25: calculatePercentile(sortedProfit, 25),
      profit_ci_75: calculatePercentile(sortedProfit, 75),
      profit_ci_95: calculatePercentile(sortedProfit, 95)
    },
    risk_metrics: {
      probability_of_loss: results.filter(r => r.net_profit_usd < 0).length / results.length,
      var_5_percent: calculatePercentile(sortedProfit, 5),
      expected_shortfall: calculateExpectedShortfall(sortedProfit, 0.05)
    }
  };
}
```

## 7. Performance Optimization

### 7.1 Calculation Caching

```typescript
class CalculationCache {
  private cache = new Map<string, CacheEntry>();
  private readonly TTL = 3600000; // 1 hour
  
  getCachedResult<T>(key: string): T | null {
    const entry = this.cache.get(key);
    if (!entry || Date.now() - entry.timestamp > this.TTL) {
      this.cache.delete(key);
      return null;
    }
    return entry.data as T;
  }
  
  setCachedResult<T>(key: string, data: T): void {
    this.cache.set(key, {
      data,
      timestamp: Date.now()
    });
  }
  
  generateCacheKey(scenario: ProjectionScenario): string {
    // Create deterministic cache key from scenario parameters
    return JSON.stringify({
      config_id: scenario.system_config_id,
      btc_model: scenario.btc_price_model,
      difficulty_model: scenario.difficulty_model,
      start_date: scenario.projection_start_date,
      end_date: scenario.projection_end_date
    });
  }
}
```

### 7.2 Parallel Calculation Processing

```typescript
async function calculateProjectionsParallel(
  scenarios: ProjectionScenario[]
): Promise<ProjectionResult[]> {
  const workerPool = createWorkerPool(4); // 4 parallel workers
  
  const tasks = scenarios.map(scenario => ({
    type: 'projection_calculation',
    data: scenario
  }));
  
  const results = await Promise.all(
    tasks.map(task => workerPool.execute(task))
  );
  
  return results;
}
```

---

**Document Status**: Draft v1.0  
**Last Updated**: 2024-08-11  
**Next Review**: After equipment specifications documentation