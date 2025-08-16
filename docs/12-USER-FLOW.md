# User Flow - Solar Bitcoin Mining Calculator

## Overview

This document outlines the complete user workflow for the Solar Bitcoin Mining Calculator, from hardware inventory management to scenario-based projections and comparisons.

## Core Workflow

### 1. Hardware Inventory Management
**Goal**: Build and maintain a personal equipment inventory

#### 1.1 Add Equipment to Inventory
- **Miners**: Add ASIC miners (Antminer S19, S21, etc.)
  - Enter manufacturer, model, specifications
  - Add purchase date, price, warranty info
  - Set user-friendly nickname (e.g., "Main Miner", "Backup S19")
  - Configure depreciation settings

- **Solar Panels**: Add solar panel models
  - Enter manufacturer, model, specifications
  - Add installation date, purchase price
  - Set user-friendly nickname (e.g., "Main Array", "Backup Panels")

- **Storage Systems**: Add battery storage
  - Enter manufacturer, model, capacity
  - Add installation date, purchase price
  - Set user-friendly nickname (e.g., "Battery Bank 1")

- **Inverters**: Add solar inverters
  - Enter manufacturer, model, specifications
  - Add installation date, purchase price
  - Set user-friendly nickname (e.g., "Main Inverter")

#### 1.2 Manage Equipment Inventory
- **Edit Equipment**: Update specifications, prices, notes
- **Remove Equipment**: Archive or delete unused equipment
- **View Inventory**: See all equipment with current values
- **Track Depreciation**: Monitor equipment value over time

### 2. System Configuration
**Goal**: Create mining system setups using inventory equipment

#### 2.1 Create New System Configuration
- **Select Location**: Choose geographic location for solar calculations
- **Select Equipment from Inventory**:
  - Choose miners (quantity, configuration)
  - Choose solar panels (quantity, orientation)
  - Choose storage systems (if any)
  - Choose inverters
- **Configure Economic Parameters**:
  - Set electricity rate
  - Set net metering rate (if applicable)
- **Configure Mining Mode**:
  - Solar-only (no grid connection)
  - Grid-assisted (backup power)
  - Hybrid (battery + grid)
- **Set Mining Schedule** (for battery-free setups):
  - Auto-calculate based on solar generation
  - Manual schedule override

#### 2.2 System Configuration Examples
```
System: "Main Solar Mining Setup"
├── Location: Phoenix, AZ
├── Equipment:
│   ├── 2x Antminer S19 Pro (from inventory)
│   ├── 20x 400W Solar Panels (from inventory)
│   ├── 1x 10kWh Battery Bank (from inventory)
│   └── 1x 8kW Solar Inverter (from inventory)
├── Mode: Solar-only (no grid)
└── Auto-calculate mining hours
```

### 3. Baseline Scenario Generation
**Goal**: Create reference projection using current market conditions

#### 3.1 Automatic Baseline Creation
When a system configuration is created, the system automatically:
- **Fetches Live Data**:
  - Current Bitcoin price (CoinGecko API)
  - Current network difficulty (Blockchain API)
  - Current weather conditions (OpenWeatherMap API)
  - Solar irradiance data (NREL API)
- **Calculates Baseline Projection**:
  - Solar generation based on location and weather
  - Mining performance based on equipment specs
  - Financial projections using current market data
- **Stores as "Current Market" Scenario**:
  - Marked as baseline scenario
  - Uses live API data (no user overrides)
  - Serves as reference point for comparisons

#### 3.2 Baseline Scenario Example
```
Scenario: "Current Market" (Auto-generated)
├── Bitcoin Price: $44,500 (live from API)
├── Network Difficulty: 906,665,024,955,65 (live from API)
├── Hashprice: $0.12/TH/day (calculated)
├── Electricity Rate: $0.12/kWh (from system config)
├── Weather: Current conditions (live from API)
└── Results: 15.2% ROI, 6.6 month payback
```

### 4. Custom Scenario Creation
**Goal**: Create "what-if" scenarios for different market conditions

#### 4.1 Create Custom Scenarios
Users can create unlimited custom scenarios using the same hardware but different parameters:

- **Scenario Templates**:
  - Bear Market (BTC $30k, +20% difficulty)
  - Bull Market (BTC $80k, -20% difficulty)
  - High Electricity Costs (+50% rates)
  - Equipment Degradation (+25% degradation)
  - Weather Impact (cloudy summer, -15% solar)

- **Custom Parameter Overrides**:
  - Bitcoin price (any value)
  - Network difficulty multiplier
  - Electricity rates
  - Weather impact multipliers
  - Equipment performance adjustments

#### 4.2 Custom Scenario Examples
```
Scenario 1: "Bear Market"
├── Bitcoin Price: $30,000 (user override)
├── Difficulty: +20% (user override)
├── Electricity: $0.15/kWh (user override)
└── Results: 5.4% ROI, 18.5 month payback

Scenario 2: "Bull Market"
├── Bitcoin Price: $80,000 (user override)
├── Difficulty: -20% (user override)
├── Electricity: $0.10/kWh (user override)
└── Results: 34.8% ROI, 2.9 month payback

Scenario 3: "High Electricity"
├── Bitcoin Price: $44,500 (keep current)
├── Difficulty: 1.0x (keep current)
├── Electricity: $0.25/kWh (user override)
└── Results: 8.1% ROI, 12.3 month payback
```

### 5. Scenario Comparison
**Goal**: Compare all scenarios side-by-side for decision making

#### 5.1 Comparison Table
All scenarios for a system are displayed in a comparison table:

| Scenario | BTC Price | Difficulty | Elec Rate | ROI | Payback | Monthly Profit |
|----------|-----------|------------|-----------|-----|---------|----------------|
| Current Market | $44,500 | 1.0x | $0.12 | 15.2% | 6.6 mo | $850 |
| Bear Market | $30,000 | 1.2x | $0.15 | 5.4% | 18.5 mo | $300 |
| Bull Market | $80,000 | 0.8x | $0.10 | 34.8% | 2.9 mo | $1,950 |
| High Electricity | $44,500 | 1.0x | $0.25 | 8.1% | 12.3 mo | $450 |

#### 5.2 Comparison Features
- **Side-by-side metrics**: ROI, payback, monthly profit
- **Visual charts**: Bar charts, line graphs
- **Risk analysis**: Best case, worst case, expected case
- **Sensitivity analysis**: Impact of parameter changes
- **Export capabilities**: PDF reports, CSV data

## User Interface Flow

### Main Navigation
```
Dashboard
├── Inventory (Manage Equipment)
├── Systems (Create/Manage Configurations)
├── Scenarios (Create/Compare Projections)
└── Reports (Export/Share Results)
```

### Inventory Management Flow
```
Inventory Tab
├── Add Equipment
│   ├── Select Equipment Type (Miner/Solar/Storage/Inverter)
│   ├── Enter Specifications
│   ├── Set User Nickname
│   └── Save to Inventory
├── Edit Equipment
│   ├── Select Equipment
│   ├── Update Details
│   └── Save Changes
└── View Inventory
    ├── Equipment List
    ├── Current Values
    └── Depreciation Tracking
```

### System Configuration Flow
```
Systems Tab
├── Create New System
│   ├── Select Location
│   ├── Choose Equipment from Inventory
│   ├── Configure Economic Parameters
│   ├── Set Mining Mode
│   └── Save System Configuration
├── Edit System
│   ├── Modify Equipment Selection
│   ├── Update Parameters
│   └── Save Changes
└── View Systems
    ├── System List
    ├── Equipment Summary
    └── Quick Actions
```

### Scenario Management Flow
```
Scenarios Tab
├── View Baseline (Auto-generated)
│   ├── Current Market Conditions
│   ├── Live Data Sources
│   └── Baseline Results
├── Create Custom Scenario
│   ├── Select Template (Bear/Bull/Custom)
│   ├── Adjust Parameters
│   ├── Preview Changes
│   └── Save Scenario
├── Compare Scenarios
│   ├── Select Scenarios to Compare
│   ├── View Comparison Table
│   ├── Generate Charts
│   └── Export Results
└── Manage Scenarios
    ├── Edit Parameters
    ├── Duplicate Scenarios
    ├── Delete Scenarios
    └── Archive Old Scenarios
```

## Data Flow

### Equipment Inventory
```
User Input → Equipment Tables → Inventory Management
├── miner_models (with user fields)
├── solar_panel_models (with user fields)
├── storage_models (with user fields)
└── inverter_models (with user fields)
```

### System Configuration
```
Inventory + User Selection → System Configuration
├── system_configs (hardware selection)
├── locations (geographic data)
└── Economic parameters
```

### Scenario Management
```
System Config + Parameters → Scenarios → Results
├── projection_scenarios (user parameters)
├── External APIs (live data)
└── projection_results (calculated outcomes)
```

### External Data Integration
```
API Data → Environmental/Bitcoin Tables → Calculations
├── monthly_solar_data (NREL API)
├── daily_forecast_data (OpenWeatherMap API)
├── bitcoin_network_data (Blockchain APIs)
└── bitcoin_price_data (CoinGecko API)
```

## Key Benefits

### 1. Flexible Hardware Management
- **Reusable Equipment**: Same equipment in multiple systems
- **User-Friendly**: Nicknames and personal notes
- **Value Tracking**: Depreciation and resale value
- **Easy Updates**: Edit specifications anytime

### 2. Powerful Scenario Analysis
- **Unlimited Scenarios**: Create as many "what-if" scenarios as needed
- **Parameter Flexibility**: Override any market or environmental parameter
- **Template System**: Quick creation of common scenarios
- **Real-time Comparison**: Side-by-side analysis of all scenarios

### 3. Comprehensive Projections
- **Live Data Integration**: Current market conditions
- **Environmental Factors**: Weather impact on solar generation
- **Equipment Performance**: Realistic degradation modeling
- **Financial Analysis**: ROI, payback, cash flow projections

### 4. User Experience
- **Intuitive Flow**: Logical progression from inventory to results
- **Visual Comparisons**: Charts and tables for easy analysis
- **Export Capabilities**: Share results and reports
- **Mobile Friendly**: Access from any device

## Success Metrics

### User Engagement
- **Equipment Inventory**: Number of equipment items per user
- **System Configurations**: Number of systems created
- **Custom Scenarios**: Number of scenarios per system
- **Comparison Usage**: Frequency of scenario comparisons

### Business Value
- **Decision Support**: Users making informed investment decisions
- **Risk Assessment**: Understanding of different market scenarios
- **Equipment Optimization**: Better equipment selection and sizing
- **Financial Planning**: Accurate ROI and payback projections

### Technical Performance
- **Calculation Speed**: Projections complete in <5 seconds
- **Data Accuracy**: Live data integration working reliably
- **User Interface**: Intuitive and responsive design
- **Data Integrity**: Consistent and reliable calculations
