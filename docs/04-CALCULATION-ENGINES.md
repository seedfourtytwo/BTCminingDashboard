# Calculation Engines - Solar Bitcoin Mining Calculator (Simplified)

## Overview

The calculation engines form the core mathematical foundation of the Solar Bitcoin Mining Calculator. These engines model the interactions between solar energy generation, Bitcoin mining economics, and equipment degradation to provide accurate projections.

## Engine Architecture

```
Calculation Engine Stack:
├── Solar Generation Engine      → Models PV system power output
├── Mining Performance Engine    → Models Bitcoin mining operations
├── Equipment Degradation Engine → Models performance decline over time
└── Economic Analysis Engine     → Models financial performance
```

## 1. Solar Generation Engine

### 1.1 Core Solar Calculations

The solar generation engine uses established photovoltaic modeling principles.

#### Solar Position Calculations
```typescript
interface SolarPosition {
  elevation: number;    // Solar elevation angle (degrees)
  azimuth: number;     // Solar azimuth angle (degrees)
  zenith: number;      // Solar zenith angle (degrees)
}

function calculateSolarPosition(
  latitude: number,
  longitude: number, 
  date: Date,
  timezone: string
): SolarPosition {
  // Basic solar position calculation
  const dayOfYear = getDayOfYear(date);
  const declination = calculateSolarDeclination(dayOfYear);
  const hourAngle = calculateHourAngle(date, longitude, timezone);
  
  const elevation = Math.asin(
    Math.sin(latitude * Math.PI/180) * Math.sin(declination) +
    Math.cos(latitude * Math.PI/180) * Math.cos(declination) * Math.cos(hourAngle)
  ) * 180/Math.PI;
  
  return { elevation, azimuth: 0, zenith: 90 - elevation };
}
```

#### PV System Output Calculation
```typescript
interface PVSystemOutput {
  dcPower: number;      // DC power output (W)
  acPower: number;      // AC power output (W)
  efficiency: number;   // System efficiency (%)
}

function calculatePVOutput(
  irradiance: number,           // Plane of array irradiance (W/m²)
  ambientTemp: number,          // Ambient temperature (°C)
  panelSpecs: SolarPanelModel,
  systemConfig: PVSystemConfig
): PVSystemOutput {
  // Calculate module temperature
  const moduleTemp = ambientTemp + (irradiance / 1000) * 25; // Simple temperature model
  
  // Temperature coefficient effect
  const tempCoeff = panelSpecs.temperature_coefficient / 100;
  const tempEffect = 1 + tempCoeff * (moduleTemp - 25);
  
  // DC power calculation
  const stcIrradiance = 1000; // Standard Test Conditions irradiance (W/m²)
  const dcPower = panelSpecs.rated_power_w * 
                  (irradiance / stcIrradiance) * 
                  tempEffect * 
                  systemConfig.quantity;
  
  // Apply system losses (simplified)
  const systemLosses = 0.85; // 15% system losses
  const dcPowerAfterLosses = dcPower * systemLosses;
  
  // Inverter conversion
  const inverterEfficiency = 0.95; // 95% inverter efficiency
  const acPower = dcPowerAfterLosses * inverterEfficiency;
  
  return {
    dcPower: dcPowerAfterLosses,
    acPower: acPower,
    efficiency: (acPower / (irradiance * systemConfig.quantity * 2)) * 100 // Approximate panel area
  };
}
```

## 2. Mining Performance Engine

### 2.1 Bitcoin Mining Calculations

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

## 3. Equipment Degradation Engine

### 3.1 Miner Degradation Modeling

```typescript
interface DegradationFactors {
  hashrate_retention: number;   // Fraction of original hashrate (0-1)
  power_retention: number;      // Power consumption multiplier
  efficiency_retention: number; // Efficiency retention factor
}

function calculateMinerDegradation(
  minerSpecs: MinerModel,
  ageMonths: number
): DegradationFactors {
  // Simple linear degradation model
  const ageYears = ageMonths / 12;
  
  const hashrate_retention = Math.max(0.1, 
    1 - (minerSpecs.hashrate_degradation_annual * ageYears)
  );
  
  const efficiency_retention = Math.max(0.1,
    1 - (minerSpecs.efficiency_degradation_annual * ageYears)
  );
  
  // Power consumption typically increases slightly as efficiency degrades
  const power_retention = 1 / efficiency_retention;
  
  return {
    hashrate_retention: Math.max(0.1, hashrate_retention),
    power_retention: Math.min(1.5, power_retention),
    efficiency_retention
  };
}
```

### 3.2 Solar Panel Degradation

```typescript
function calculateSolarPanelDegradation(
  panelSpecs: SolarPanelModel,
  ageYears: number
): number {
  // Linear degradation model (most common for solar panels)
  const baseDegradationRate = panelSpecs.degradation_rate_annual / 100;
  const retentionFactor = Math.pow(1 - baseDegradationRate, ageYears);
  
  return Math.max(0.7, retentionFactor); // Minimum 70% retention
}
```

## 4. Economic Analysis Engine

### 4.1 Financial Calculations

```typescript
interface FinancialAnalysis {
  initial_investment: number;   // Total upfront cost
  annual_cash_flows: number[];  // Year-by-year cash flows
  npv: number;                 // Net Present Value
  irr: number;                 // Internal Rate of Return
  payback_period: number;      // Simple payback period (years)
  roi_percent: number;         // Return on Investment percentage
}

function calculateFinancialMetrics(
  systemConfig: SystemConfiguration,
  projectionResults: ProjectionResult[],
  discountRate: number = 0.08
): FinancialAnalysis {
  // Calculate initial investment
  const equipmentCosts = calculateEquipmentCosts(systemConfig);
  const installationCosts = equipmentCosts * 0.15; // 15% installation cost
  const initial_investment = equipmentCosts + installationCosts;
  
  // Group projection results by year
  const annual_cash_flows = groupCashFlowsByYear(projectionResults);
  
  // Calculate NPV
  const npv = calculateNPV(initial_investment, annual_cash_flows, discountRate);
  
  // Calculate IRR using iterative method
  const irr = calculateIRR(initial_investment, annual_cash_flows);
  
  // Calculate payback period
  const payback_period = calculatePaybackPeriod(initial_investment, annual_cash_flows);
  
  const total_cash_flows = annual_cash_flows.reduce((sum, cf) => sum + cf, 0);
  const roi_percent = ((total_cash_flows - initial_investment) / initial_investment) * 100;
  
  return {
    initial_investment,
    annual_cash_flows,
    npv,
    irr,
    payback_period,
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
  // Simple IRR calculation using Newton-Raphson method
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
  
  return rate;
}
```

## 5. Performance Optimization

### 5.1 Calculation Caching

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
      start_date: scenario.projection_start_date,
      end_date: scenario.projection_end_date
    });
  }
}
```

---

**Document Status**: Simplified v1.0  
**Last Updated**: 2024-12-19  
**Next Review**: After Phase 1 implementation