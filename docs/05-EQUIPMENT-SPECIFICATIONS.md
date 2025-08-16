# Equipment Specifications - Solar Bitcoin Mining Calculator

## Overview

This document defines the equipment specifications and standards used in the Solar Bitcoin Mining Calculator. The system supports essential equipment types with core technical specifications, performance characteristics, and economic parameters.

## Equipment Categories

```
Equipment Hierarchy:
├── Power Generation Equipment
│   └── Solar Panels (Photovoltaic Systems)
├── Energy Storage Equipment
│   └── Battery Storage Systems
├── Mining Equipment
│   └── SHA-256 ASIC Miners
└── System Components
    └── Basic Inverters (DC/AC Conversion)
```

## 1. SOLAR PANEL SPECIFICATIONS

### 1.1 Standard Solar Panel Models

The system includes specifications for current solar panel models from major manufacturers.

#### Tier 1 Manufacturers (Premium)
```json
{
  "manufacturers": [
    "SunPower", "Panasonic", "Canadian Solar", "Jinko Solar",
    "Trina Solar", "LG Solar", "REC Solar", "Hanwha Q CELLS"
  ],
  "typical_specs": {
    "power_range_w": [300, 500],
    "efficiency_range": [18, 22.5],
    "warranty_years": [20, 25],
    "degradation_rate_annual": [0.25, 0.60]
  }
}
```

#### Example: High-Efficiency Monocrystalline Panel
```json
{
  "id": 1,
  "manufacturer": "SunPower",
  "model_name": "Maxeon 3 400W",
  "technology": "Monocrystalline",
  "specifications": {
    "rated_power_w": 400,
    "efficiency_percent": 22.2,
    "temperature_coefficient": -0.29,
    "degradation_rate_annual": 0.25,
    "voltage_mpp": 67.8,
    "current_mpp": 5.90
  },
  "physical": {
    "length_mm": 1690,
    "width_mm": 1046,
    "thickness_mm": 40,
    "weight_kg": 20.6
  },
  "economic": {
    "cost_per_unit": 280.00,
    "cost_per_watt": 0.70,
    "warranty_power": 25,
    "warranty_product": 25
  }
}
```

#### Example: Cost-Effective Polycrystalline Panel
```json
{
  "id": 2,
  "manufacturer": "Canadian Solar",
  "model_name": "CS3W-400P",
  "technology": "Polycrystalline",
  "specifications": {
    "rated_power_w": 400,
    "efficiency_percent": 20.5,
    "temperature_coefficient": -0.38,
    "degradation_rate_annual": 0.50,
    "voltage_mpp": 40.1,
    "current_mpp": 9.98
  },
  "physical": {
    "length_mm": 2000,
    "width_mm": 1000,
    "thickness_mm": 40,
    "weight_kg": 22.5
  },
  "economic": {
    "cost_per_unit": 200.00,
    "cost_per_watt": 0.50,
    "warranty_power": 25,
    "warranty_product": 12
  }
}
```

## 2. BITCOIN MINER SPECIFICATIONS

### 2.1 Current Generation ASIC Miners (2024)

#### High Efficiency Models
```json
{
  "id": 1,
  "manufacturer": "Bitmain",
  "model_name": "Antminer S19 Pro",
  "generation": "7nm",
  "release_date": "2021-03-15",
  "performance": {
    "hashrate_th": 110.0,
    "power_consumption_w": 3250,
    "efficiency_j_th": 29.5
  },
  "degradation_model": {
    "hashrate_degradation_annual": 0.05,
    "efficiency_degradation_annual": 0.03,
    "failure_rate_annual": 0.10
  },
  "environmental": {
    "operating_temp_min": 5,
    "operating_temp_max": 40,
    "humidity_max": 85
  },
  "physical": {
    "dimensions_l_mm": 400,
    "dimensions_w_mm": 195,
    "dimensions_h_mm": 290,
    "weight_kg": 13.2
  },
  "economic": {
    "current_price_usd": 3500.00,
    "warranty_months": 36,
    "expected_lifespan_years": 5
  },
  "power_requirements": {
    "voltage_v": 220,
    "power_connection": "C19 IEC Connector"
  }
}
```

#### Mid-Range Models
```json
{
  "id": 2,
  "manufacturer": "MicroBT",
  "model_name": "WhatsMiner M30S++",
  "generation": "8nm",
  "performance": {
    "hashrate_th": 112.0,
    "power_consumption_w": 3472,
    "efficiency_j_th": 31.0
  },
  "economic": {
    "current_price_usd": 2500.00,
    "value_proposition": "Good balance of price and performance"
  }
}
```

#### Budget Models
```json
{
  "id": 3,
  "manufacturer": "Canaan",
  "model_name": "AvalonMiner 1246",
  "generation": "7nm",
  "performance": {
    "hashrate_th": 90.0,
    "power_consumption_w": 3420,
    "efficiency_j_th": 38.0
  },
  "economic": {
    "current_price_usd": 1800.00,
    "value_proposition": "Low upfront cost, suitable for low electricity rates"
  }
}
```

## 3. ENERGY STORAGE SPECIFICATIONS

### 3.1 Lithium-ion Battery Systems

#### Tesla Powerwall (Residential Scale)
```json
{
  "id": 1,
  "manufacturer": "Tesla",
  "model_name": "Powerwall 2",
  "technology": "Li-ion NMC",
  "specifications": {
    "capacity_kwh": 13.5,
    "usable_capacity_kwh": 13.5,
    "max_charge_rate_kw": 5.0,
    "max_discharge_rate_kw": 5.0,
    "round_trip_efficiency": 0.90,
    "operating_temp_min": -20,
    "operating_temp_max": 50
  },
  "degradation_model": {
    "cycle_life": 6000,
    "calendar_degradation_annual": 0.02
  },
  "economic": {
    "cost_per_unit": 11500,
    "cost_per_kwh": 852,
    "installation_cost": 2000,
    "warranty_years": 10
  },
  "integration": {
    "inverter_included": true,
    "monitoring_system": "Tesla app"
  }
}
```

#### Commercial LiFePO4 System
```json
{
  "id": 2,
  "manufacturer": "BYD",
  "model_name": "B-Box Pro 13.8",
  "technology": "LiFePO4",
  "specifications": {
    "capacity_kwh": 13.8,
    "usable_capacity_kwh": 13.1,
    "max_charge_rate_kw": 8.2,
    "max_discharge_rate_kw": 8.2,
    "round_trip_efficiency": 0.92,
    "depth_of_discharge_max": 0.95
  },
  "degradation_model": {
    "cycle_life": 10000,
    "calendar_degradation_annual": 0.015
  },
  "features": [
    "Longer cycle life than Li-ion",
    "Better thermal stability",
    "Lower fire risk",
    "More stable voltage curve"
  ],
  "economic": {
    "cost_per_kwh": 450,
    "expected_lifespan_years": 15,
    "maintenance_requirements": "Minimal"
  }
}
```

## 4. SYSTEM INTEGRATION COMPONENTS

### 4.1 Basic Inverters

#### String Inverters (Residential/Small Commercial)
```json
{
  "type": "String Inverter",
  "power_ranges": [3, 5, 6, 8, 10, 12, 15, 20, 25, 30],
  "efficiency_range": [95, 98.5],
  "features": [
    "MPPT tracking (1-4 strings)",
    "Grid-tie capability",
    "Monitoring integration",
    "Rapid shutdown compliance"
  ],
  "typical_specs": {
    "efficiency_peak": 0.975,
    "efficiency_weighted": 0.965,
    "power_factor": 1.0,
    "thd_current": 0.03
  }
}
```

## 5. EQUIPMENT SELECTION GUIDELINES

### 5.1 Solar System Sizing

#### Basic Sizing Methodology
```json
{
  "sizing_steps": [
    {
      "step": 1,
      "description": "Calculate daily energy requirements",
      "formula": "Daily mining consumption (kWh) + facility load (kWh)"
    },
    {
      "step": 2,
      "description": "Determine solar resource",
      "inputs": ["Peak sun hours", "Seasonal variation", "Weather patterns"]
    },
    {
      "step": 3,
      "description": "Calculate required solar capacity",
      "formula": "Daily energy need / (Peak sun hours × System efficiency)"
    },
    {
      "step": 4,
      "description": "Select appropriate equipment",
      "considerations": ["Budget", "Space constraints", "Aesthetic requirements"]
    }
  ]
}
```

### 5.2 Equipment Compatibility Matrix

#### Solar Panel + Inverter Compatibility
```json
{
  "compatibility_factors": {
    "voltage_matching": {
      "inverter_mppt_range": "Must encompass panel string voltage range",
      "max_system_voltage": "Panel Voc × string size < inverter max voltage"
    },
    "power_sizing": {
      "dc_ac_ratio": "Typical range 1.15-1.35",
      "inverter_sizing": "100-135% of panel nameplate capacity"
    },
    "environmental": {
      "temperature_derating": "Consider local temperature extremes",
      "altitude_derating": "Required above 1000m elevation"
    }
  }
}
```

## 6. COST MODELS AND ECONOMIC ANALYSIS

### 6.1 Equipment Cost Trends

#### Historical Cost Trends (2019-2024)
```json
{
  "solar_panels": {
    "2019_cost_per_watt": 0.68,
    "2024_cost_per_watt": 0.45,
    "annual_decline_rate": 0.08,
    "technology_improvement": "Efficiency gains 2-3% annually"
  },
  "bitcoin_miners": {
    "2019_cost_per_th": 65,
    "2024_cost_per_th": 28,
    "annual_decline_rate": 0.15,
    "performance_improvement": "Efficiency gains 15-20% annually"
  },
  "batteries": {
    "2019_cost_per_kwh": 650,
    "2024_cost_per_kwh": 420,
    "annual_decline_rate": 0.12,
    "technology_drivers": ["Manufacturing scale", "Chemistry improvements"]
  }
}
```

### 6.2 Total Cost of Ownership Models

#### Solar System TCO Components
```json
{
  "capex_components": [
    {"component": "Solar panels", "percent_of_total": 40},
    {"component": "Inverters", "percent_of_total": 15},
    {"component": "Mounting system", "percent_of_total": 12},
    {"component": "Electrical components", "percent_of_total": 8},
    {"component": "Installation labor", "percent_of_total": 15},
    {"component": "Permits and inspection", "percent_of_total": 5},
    {"component": "System design", "percent_of_total": 3},
    {"component": "Contingency", "percent_of_total": 2}
  ],
  "opex_components": [
    {"component": "O&M contracts", "annual_cost_per_kw": 15},
    {"component": "Insurance", "percent_of_capex": 0.5},
    {"component": "Performance monitoring", "annual_cost": 500},
    {"component": "Inverter replacement", "cost_at_year": [12, 2500]}
  ]
}
```

## 7. PERFORMANCE BENCHMARKS

### 7.1 Industry Performance Standards

#### Solar System Performance Ratios
```json
{
  "performance_benchmarks": {
    "excellent": {
      "performance_ratio": ">0.85",
      "capacity_factor": ">0.20",
      "degradation_rate": "<0.4%/year"
    },
    "good": {
      "performance_ratio": "0.80-0.85",
      "capacity_factor": "0.17-0.20",
      "degradation_rate": "0.4-0.6%/year"
    },
    "poor": {
      "performance_ratio": "<0.75",
      "capacity_factor": "<0.15",
      "degradation_rate": ">0.8%/year"
    }
  }
}
```

#### Mining Equipment Efficiency Standards
```json
{
  "efficiency_tiers": {
    "cutting_edge": {
      "efficiency_j_th": "<25",
      "examples": ["Antminer S19 XP", "WhatsMiner M50S"]
    },
    "current_generation": {
      "efficiency_j_th": "25-35",
      "examples": ["Antminer S19 Pro", "WhatsMiner M30S++"]
    },
    "previous_generation": {
      "efficiency_j_th": "35-50",
      "examples": ["Antminer S17", "WhatsMiner M20S"]
    },
    "obsolete": {
      "efficiency_j_th": ">50",
      "recommendation": "Not economically viable in most locations"
    }
  }
}
```

---

## Future Implementation

### Advanced Equipment Features (Planned for Later Phases)

#### Advanced Solar Technologies
- Bifacial solar panels
- Building-integrated photovoltaics (BIPV)
- Solar tracking systems
- Concentrated solar power

#### Wind Power Integration
- Small wind turbines
- Hybrid solar-wind systems
- Wind resource assessment
- Micro-hydroelectric systems

#### Advanced Mining Equipment
- Immersion cooling systems
- Liquid cooling solutions
- Advanced thermal management
- Power optimization features

#### Enhanced Storage Systems
- Flow batteries
- Compressed air storage
- Hydrogen storage systems
- Advanced battery chemistries

#### Smart Grid Integration
- Demand response systems
- Grid services participation
- Advanced monitoring systems
- Predictive maintenance

#### Equipment Performance Tracking
- Real-time performance monitoring
- Predictive failure analysis
- Performance optimization algorithms
- Automated maintenance scheduling

---

**Document Status**: Current Plan v1.0  
**Last Updated**: 2024-12-19  
**Next Review**: After Phase 1 implementation