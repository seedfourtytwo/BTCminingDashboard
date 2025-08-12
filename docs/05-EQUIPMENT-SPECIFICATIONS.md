# Equipment Specifications - Solar Bitcoin Mining Calculator

## Overview

This document defines the comprehensive equipment specifications and standards used in the Solar Bitcoin Mining Calculator. The system supports a wide range of equipment types with detailed technical specifications, performance characteristics, and economic parameters.

## Equipment Categories

```
Equipment Hierarchy:
├── Power Generation Equipment
│   ├── Solar Panels (Photovoltaic Systems)
│   ├── Wind Turbines (Small-scale & Micro)
│   ├── Micro-Hydroelectric Generators
│   ├── Grid Connections (Utility Power)
│   └── Custom Power Sources (User-defined)
├── Energy Storage Equipment
│   ├── Lithium-ion Battery Systems
│   ├── LiFePO4 Battery Systems
│   ├── Lead-acid Battery Systems
│   └── Alternative Storage Technologies
├── Mining Equipment
│   ├── SHA-256 ASIC Miners
│   ├── Cooling Systems
│   └── Power Distribution Units
└── System Components
    ├── Inverters (DC/AC Conversion)
    ├── Charge Controllers (Solar/Wind)
    ├── Monitoring Equipment
    └── Safety & Protection Systems
```

## 1. SOLAR PANEL SPECIFICATIONS

### 1.1 Standard Solar Panel Models

The system includes comprehensive specifications for current and historical solar panel models from major manufacturers.

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
  "id": 15,
  "manufacturer": "SunPower",
  "model_name": "Maxeon 3 400W",
  "technology": "Monocrystalline",
  "specifications": {
    "rated_power_w": 400,
    "efficiency_percent": 22.2,
    "temperature_coefficient": -0.29,
    "degradation_rate_annual": 0.25,
    "voltage_mpp": 67.8,
    "current_mpp": 5.90,
    "voltage_oc": 78.2,
    "current_sc": 6.46,
    "max_system_voltage": 1500,
    "fire_rating": "Class A",
    "wind_load": 2400,
    "snow_load": 5400
  },
  "physical": {
    "length_mm": 1690,
    "width_mm": 1046,
    "thickness_mm": 40,
    "weight_kg": 20.6,
    "frame_material": "Anodized Aluminum",
    "glass_type": "Anti-reflective Tempered Glass"
  },
  "economic": {
    "cost_per_unit": 280.00,
    "cost_per_watt": 0.70,
    "availability": "In Stock",
    "warranty_power": 25,
    "warranty_product": 25
  },
  "certifications": ["IEC 61215", "IEC 61730", "UL 1703", "CEC Listed"]
}
```

#### Example: Cost-Effective Polycrystalline Panel
```json
{
  "id": 16,
  "manufacturer": "Canadian Solar",
  "model_name": "CS3W-400P",
  "technology": "Polycrystalline",
  "specifications": {
    "rated_power_w": 400,
    "efficiency_percent": 20.5,
    "temperature_coefficient": -0.38,
    "degradation_rate_annual": 0.50,
    "voltage_mpp": 40.1,
    "current_mpp": 9.98,
    "voltage_oc": 48.4,
    "current_sc": 10.58
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

### 1.2 Specialized Solar Technologies

#### Bifacial Solar Panels
```json
{
  "technology_type": "Bifacial Monocrystalline",
  "bifacial_factor": 0.70,
  "additional_yield": 0.15,
  "mounting_requirements": "Elevated mounting for rear-side illumination",
  "cost_premium": 0.15
}
```

#### Building-Integrated Photovoltaics (BIPV)
```json
{
  "technology_type": "BIPV Roof Tiles",
  "integration_factor": "Replaces traditional roofing material",
  "installation_complexity": "High",
  "aesthetic_rating": "Excellent",
  "cost_premium": 2.5
}
```

## 2. WIND TURBINE SPECIFICATIONS

### 2.1 Small Wind Turbines (Under 100kW)

#### Horizontal Axis Wind Turbines
```json
{
  "id": 3,
  "manufacturer": "Bergey",
  "model_name": "Excel 10",
  "technology": "Horizontal Axis",
  "specifications": {
    "rated_power_w": 10000,
    "cut_in_speed_ms": 2.5,
    "rated_speed_ms": 11.0,
    "cut_out_speed_ms": 20.0,
    "rotor_diameter_m": 7.0,
    "swept_area_m2": 38.5,
    "power_curve": [
      {"wind_speed": 2.5, "power": 0},
      {"wind_speed": 5.0, "power": 500},
      {"wind_speed": 7.5, "power": 2500},
      {"wind_speed": 10.0, "power": 7500},
      {"wind_speed": 11.0, "power": 10000},
      {"wind_speed": 15.0, "power": 10000},
      {"wind_speed": 20.0, "power": 0}
    ]
  },
  "physical": {
    "hub_height_options": [18, 24, 30, 37],
    "weight_turbine_kg": 545,
    "weight_tower_kg": 1500,
    "foundation_requirements": "Concrete pad 3m x 3m x 1.5m deep"
  },
  "economic": {
    "cost_turbine": 45000,
    "cost_tower": 15000,
    "cost_installation": 25000,
    "warranty_years": 5,
    "expected_lifespan": 20
  }
}
```

#### Vertical Axis Wind Turbines
```json
{
  "id": 4,
  "manufacturer": "Urban Green Energy",
  "model_name": "VisionAIR3",
  "technology": "Vertical Axis (Helical)",
  "specifications": {
    "rated_power_w": 3200,
    "cut_in_speed_ms": 2.0,
    "rated_speed_ms": 11.0,
    "height_m": 2.7,
    "diameter_m": 1.8,
    "noise_level_db": 38,
    "turbulence_tolerance": "High"
  },
  "advantages": [
    "Low noise operation",
    "Handles turbulent wind well",
    "Compact installation footprint",
    "No wind direction tracking needed"
  ],
  "economic": {
    "cost_per_unit": 18000,
    "installation_cost": 5000,
    "maintenance_cost_annual": 500
  }
}
```

### 2.2 Wind Resource Assessment

#### Wind Speed Classifications
```json
{
  "wind_classes": {
    "Class_1": {
      "avg_wind_speed_ms": 4.5,
      "avg_power_density": 200,
      "suitability": "Poor - Not recommended"
    },
    "Class_2": {
      "avg_wind_speed_ms": 5.5,
      "avg_power_density": 300,
      "suitability": "Marginal - Small turbines only"
    },
    "Class_3": {
      "avg_wind_speed_ms": 6.5,
      "avg_power_density": 400,
      "suitability": "Fair - Good for small turbines"
    },
    "Class_4": {
      "avg_wind_speed_ms": 7.5,
      "avg_power_density": 500,
      "suitability": "Good - Suitable for most turbines"
    },
    "Class_5": {
      "avg_wind_speed_ms": 8.5,
      "avg_power_density": 600,
      "suitability": "Excellent - Optimal for all turbines"
    }
  }
}
```

## 3. BITCOIN MINER SPECIFICATIONS

### 3.1 Current Generation ASIC Miners (2024)

#### Flagship Models - High Efficiency
```json
{
  "id": 8,
  "manufacturer": "Bitmain",
  "model_name": "Antminer S19 XP",
  "generation": "7nm",
  "release_date": "2022-07-15",
  "performance": {
    "hashrate_th": 140.0,
    "power_consumption_w": 3010,
    "efficiency_j_th": 21.5
  },
  "degradation_model": {
    "hashrate_degradation_annual": 0.04,
    "efficiency_degradation_annual": 0.025,
    "failure_rate_annual": 0.08,
    "performance_curve": {
      "months": [0, 6, 12, 18, 24, 30, 36, 42, 48],
      "hashrate_retention": [1.00, 0.98, 0.96, 0.94, 0.92, 0.90, 0.88, 0.86, 0.84],
      "efficiency_retention": [1.00, 0.99, 0.98, 0.97, 0.95, 0.94, 0.92, 0.90, 0.88]
    }
  },
  "environmental": {
    "operating_temp_min": 5,
    "operating_temp_max": 45,
    "humidity_max": 85,
    "altitude_max": 2000,
    "noise_level_db": 75
  },
  "physical": {
    "dimensions_l_mm": 400,
    "dimensions_w_mm": 195,
    "dimensions_h_mm": 290,
    "weight_kg": 14.5,
    "cooling_type": "Dual Fan Air Cooling"
  },
  "economic": {
    "msrp_usd": 6000,
    "current_price_usd": 3800,
    "warranty_months": 36,
    "expected_lifespan_years": 5,
    "resale_value_curve": [1.0, 0.7, 0.5, 0.3, 0.15, 0.05]
  },
  "power_requirements": {
    "voltage_v": 220,
    "power_connection": "C19 IEC Connector",
    "power_factor": 0.93,
    "startup_current_a": 25,
    "power_efficiency_curve": [
      {"load_percent": 50, "efficiency": 0.91},
      {"load_percent": 75, "efficiency": 0.93},
      {"load_percent": 100, "efficiency": 0.93}
    ]
  }
}
```

#### Mid-Range Models - Balanced Performance
```json
{
  "id": 9,
  "manufacturer": "MicroBT",
  "model_name": "WhatsMiner M30S++",
  "generation": "8nm",
  "performance": {
    "hashrate_th": 112.0,
    "power_consumption_w": 3472,
    "efficiency_j_th": 31.0
  },
  "economic": {
    "current_price_usd": 2500,
    "value_proposition": "Good balance of price and performance"
  }
}
```

#### Budget Models - High Volume Operations
```json
{
  "id": 10,
  "manufacturer": "Canaan",
  "model_name": "AvalonMiner 1246",
  "generation": "7nm",
  "performance": {
    "hashrate_th": 90.0,
    "power_consumption_w": 3420,
    "efficiency_j_th": 38.0
  },
  "economic": {
    "current_price_usd": 1800,
    "value_proposition": "Low upfront cost, suitable for low electricity rates"
  }
}
```

### 3.2 Immersion Cooling Miners

```json
{
  "cooling_technology": "Immersion Cooling",
  "cooling_fluid": "Dielectric Fluid (3M Novec or equivalent)",
  "advantages": [
    "Higher power density (up to 50kW/rack)",
    "Improved efficiency (+3-5%)",
    "Reduced noise (<40dB)",
    "Better thermal management",
    "Extended equipment lifespan"
  ],
  "infrastructure_requirements": {
    "cooling_infrastructure": "Immersion tanks with heat exchangers",
    "facility_modifications": "Reinforced flooring, spill containment",
    "maintenance_complexity": "Specialized technician training required"
  },
  "cost_implications": {
    "infrastructure_cost_premium": 2.0,
    "operational_savings_annual": 0.15,
    "maintenance_cost_reduction": 0.25
  }
}
```

### 3.3 Mining Performance Optimization

#### Power Limiting and Overclocking
```json
{
  "power_management": {
    "power_limiting": {
      "range_percent": [70, 100],
      "efficiency_impact": "Linear improvement at lower power",
      "hashrate_impact": "Near-linear reduction",
      "longevity_impact": "Improved at <90% power"
    },
    "overclocking": {
      "range_percent": [100, 120],
      "efficiency_impact": "Degraded beyond 110%",
      "failure_risk": "Exponentially increased beyond 115%",
      "warranty_impact": "Voided if detected"
    }
  }
}
```

#### Thermal Management
```json
{
  "thermal_optimization": {
    "optimal_intake_temp": 25,
    "max_safe_temp": 85,
    "thermal_throttling_start": 75,
    "cooling_strategies": [
      "Ambient air cooling",
      "Evaporative cooling",
      "Immersion cooling",
      "Liquid cooling"
    ]
  }
}
```

## 4. ENERGY STORAGE SPECIFICATIONS

### 4.1 Lithium-ion Battery Systems

#### Tesla Powerwall (Residential Scale)
```json
{
  "id": 2,
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
    "calendar_degradation_annual": 0.02,
    "capacity_retention_curve": {
      "cycles": [0, 1000, 2000, 3000, 4000, 5000, 6000],
      "capacity_retention": [1.00, 0.95, 0.92, 0.88, 0.85, 0.82, 0.80]
    }
  },
  "economic": {
    "cost_per_unit": 11500,
    "cost_per_kwh": 852,
    "installation_cost": 2000,
    "warranty_years": 10,
    "warranty_cycles": 37800
  },
  "integration": {
    "inverter_included": true,
    "monitoring_system": "Tesla app",
    "grid_services": ["Load shifting", "Backup power", "Grid stabilization"]
  }
}
```

#### Commercial LiFePO4 System
```json
{
  "id": 3,
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
    "calendar_degradation_annual": 0.015,
    "temperature_acceleration": {
      "base_temp": 25,
      "degradation_doubling_temp": 10
    }
  },
  "advantages": [
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

### 4.2 Battery Management and Safety

#### Battery Management System (BMS) Requirements
```json
{
  "bms_features": {
    "cell_monitoring": "Individual cell voltage and temperature",
    "balancing": "Active or passive cell balancing",
    "protection": "Overcurrent, overvoltage, thermal protection",
    "communication": "CAN bus, Modbus, or proprietary protocols",
    "safety_systems": "Emergency disconnect, fire suppression integration"
  },
  "safety_standards": [
    "UL 9540 (Energy Storage Systems)",
    "IEC 62933 (Electrical Energy Storage Systems)",
    "NFPA 855 (Energy Storage Systems)",
    "UL 1973 (Batteries for Use in Stationary Applications)"
  ]
}
```

## 5. SYSTEM INTEGRATION COMPONENTS

### 5.1 Inverters and Power Electronics

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

#### Power Optimizers
```json
{
  "type": "Power Optimizer",
  "application": "Module-level power electronics",
  "benefits": [
    "Individual panel MPPT",
    "Shade mitigation",
    "Module-level monitoring",
    "Enhanced safety (module-level shutdown)"
  ],
  "cost_impact": {
    "equipment_cost_increase": 0.15,
    "performance_gain": 0.08,
    "monitoring_value": "High"
  }
}
```

### 5.2 Monitoring and Control Systems

#### Production Monitoring
```json
{
  "monitoring_levels": {
    "system_level": {
      "metrics": ["Total power", "Energy production", "System efficiency"],
      "update_frequency": "Real-time (1-5 minutes)"
    },
    "string_level": {
      "metrics": ["String current", "String voltage", "String power"],
      "diagnostic_value": "Medium"
    },
    "module_level": {
      "metrics": ["Individual panel performance", "Hot spot detection"],
      "diagnostic_value": "High",
      "cost_premium": "Significant"
    }
  }
}
```

## 6. EQUIPMENT SELECTION GUIDELINES

### 6.1 Solar System Sizing

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

### 6.2 Equipment Compatibility Matrix

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

## 7. COST MODELS AND ECONOMIC ANALYSIS

### 7.1 Equipment Cost Trends

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

### 7.2 Total Cost of Ownership Models

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

## 8. PERFORMANCE BENCHMARKS

### 8.1 Industry Performance Standards

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
      "recommendation": "Not economically viable in most markets"
    }
  }
}
```

---

**Document Status**: Draft v1.0  
**Last Updated**: 2024-08-11  
**Next Review**: After user interface documentation