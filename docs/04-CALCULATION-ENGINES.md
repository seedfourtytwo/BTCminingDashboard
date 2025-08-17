# Calculation Engines - Solar Bitcoin Mining Calculator

## Table of Contents
- [Overview](#overview)
- [Solar Power Calculations](#solar-power-calculations)
  - [Basic Solar Production](#basic-solar-production)
  - [Advanced Solar Modeling](#advanced-solar-modeling)
  - [Environmental Factors](#environmental-factors)
- [Mining Performance Calculations](#mining-performance-calculations)
  - [Hashrate Calculations](#hashrate-calculations)
  - [Power Consumption](#power-consumption)
  - [Equipment Degradation](#equipment-degradation)
- [Financial Analysis](#financial-analysis)
  - [Revenue Calculations](#revenue-calculations)
  - [Cost Analysis](#cost-analysis)
  - [Profitability Metrics](#profitability-metrics)
- [Economic Models](#economic-models)
  - [ROI Calculations](#roi-calculations)
  - [Payback Period](#payback-period)
  - [NPV and IRR](#npv-and-irr)
- [Risk Analysis](#risk-analysis)
  - [Monte Carlo Simulations](#monte-carlo-simulations)
  - [Sensitivity Analysis](#sensitivity-analysis)
  - [Scenario Planning](#scenario-planning)
- [Implementation Details](#implementation-details)
- [Performance Optimization](#performance-optimization)

## Overview

The calculation engines provide mathematical modeling for solar Bitcoin mining operations. These engines handle solar power generation, mining performance, financial analysis, and risk assessment.

**Source**: Calculation engines are implemented in the server workers:
- [`src/server/calculations/`](../src/server/calculations/) - Main calculation worker
- [`src/server/calculations/engines/`](../src/server/calculations/engines/) - Engine implementations
- [`src/server/calculations/services/`](../src/server/calculations/services/) - Calculation services

## Solar Power Calculations

### Basic Solar Production

The solar generation engine uses established photovoltaic modeling principles to calculate energy production.

#### Solar Position Calculations
**Key Components**:
- **Solar Elevation**: Angle of sun above horizon (0-90°)
- **Solar Azimuth**: Compass direction of sun (0-360°)
- **Declination**: Sun's position relative to equator
- **Hour Angle**: Time-based sun position

**Calculation Method**: Simplified solar position model using latitude, longitude, date, and timezone

#### PV System Output Calculation
**Input Parameters**:
- **Irradiance**: Plane of array irradiance (W/m²)
- **Ambient Temperature**: Environmental temperature (°C)
- **Panel Specifications**: Rated power, temperature coefficient
- **System Configuration**: Quantity, tilt, azimuth

**Output Metrics**:
- **DC Power**: Direct current power output (W)
- **AC Power**: Alternating current power output (W)
- **System Efficiency**: Overall conversion efficiency (%)

**Calculation Steps**:
1. **Module Temperature**: Ambient + irradiance effect
2. **Temperature Correction**: Apply temperature coefficient
3. **DC Power**: STC-based power calculation
4. **System Losses**: Wiring, mismatch, soiling losses
5. **Inverter Conversion**: DC to AC conversion

### Advanced Solar Modeling

#### Environmental Factors
- **Temperature Effects**: Performance reduction with heat
- **Dust and Soiling**: Accumulation impact on output
- **Shading Analysis**: Partial shading calculations
- **Weather Patterns**: Cloud cover and seasonal variations

#### Degradation Modeling
- **First Year**: 2-3% initial degradation
- **Annual Rate**: 0.5-0.8% typical degradation
- **Linear Model**: Warranty-based degradation curve
- **Real-world Factors**: Environmental stress effects

### Environmental Factors

#### Temperature Impact
- **Temperature Coefficient**: -0.3% to -0.4% per °C
- **Performance Reduction**: 10-15% at high temperatures
- **Cooling Considerations**: Airflow and spacing requirements

#### Weather Integration
- **Real-time Data**: Current weather conditions
- **Forecast Integration**: Future weather predictions
- **Historical Patterns**: Seasonal performance analysis
- **Extreme Events**: Storm and weather impact modeling

## Mining Performance Calculations

### Hashrate Calculations

**Source**: Mining calculations are implemented in the calculation engines

#### Performance Metrics
- **Hashrate (TH/s)**: Mining speed in terahashes per second
- **Effective Hashrate**: Actual mining performance after degradation
- **Network Difficulty**: Current Bitcoin network difficulty
- **Block Reward**: Current Bitcoin block reward

#### Degradation Modeling
- **Annual Degradation**: 5-10% hashrate loss per year
- **Efficiency Decline**: 3-5% efficiency reduction annually
- **Failure Rate**: 10-15% annual failure probability
- **Age-based Calculations**: Performance based on equipment age

### Power Consumption

#### Energy Requirements
- **Rated Power**: Manufacturer specifications (W)
- **Actual Consumption**: Real-world power draw
- **Efficiency Factors**: Temperature and load effects
- **Cooling Requirements**: Additional power for thermal management

#### Power Optimization
- **Power Limiting**: Reduced power for efficiency
- **Temperature Control**: Optimal operating conditions
- **Load Balancing**: Distribution across multiple units
- **Peak Shaving**: Demand management strategies

### Equipment Degradation

#### Performance Degradation
- **Hashrate Loss**: Gradual reduction in mining speed
- **Efficiency Decline**: Increasing energy consumption
- **Reliability Issues**: Higher failure rates over time
- **Maintenance Impact**: Regular service requirements

#### Economic Impact
- **Revenue Reduction**: Declining mining output
- **Cost Increase**: Higher maintenance and replacement costs
- **Replacement Timing**: Optimal upgrade scheduling
- **Resale Value**: Declining equipment market value

## Financial Analysis

### Revenue Calculations

#### Bitcoin Mining Revenue
- **Daily BTC Earned**: Based on hashrate and network difficulty
- **USD Revenue**: BTC amount × current Bitcoin price
- **Revenue Projection**: Future revenue based on price scenarios
- **Network Effects**: Difficulty changes and halving events

#### Revenue Factors
- **Bitcoin Price**: Current and projected price scenarios
- **Network Difficulty**: Mining competition level
- **Block Reward**: Halving schedule and reward amounts
- **Pool Fees**: Mining pool commission rates

### Cost Analysis

#### Operational Costs
- **Electricity Costs**: Power consumption × electricity rate
- **Maintenance Costs**: Regular service and repairs
- **Cooling Costs**: Thermal management expenses
- **Internet Costs**: Network connectivity requirements

#### Capital Costs
- **Equipment Purchase**: Initial hardware investment
- **Installation Costs**: Setup and configuration expenses
- **Infrastructure**: Cooling, electrical, and networking
- **Permits and Compliance**: Regulatory requirements

### Profitability Metrics

#### Key Performance Indicators
- **Daily Profit**: Revenue minus daily costs
- **Profit Margin**: Profit as percentage of revenue
- **Cost per BTC**: Total cost to mine one Bitcoin
- **Break-even Price**: Minimum Bitcoin price for profitability

#### Financial Ratios
- **Gross Margin**: Revenue minus direct costs
- **Operating Margin**: Profit after operating expenses
- **Net Margin**: Final profit after all costs
- **Cash Flow**: Monthly net cash generation

## Economic Models

### ROI Calculations

#### Return on Investment
- **Total Investment**: All capital and setup costs
- **Annual Returns**: Projected yearly profit
- **ROI Percentage**: Annual return / total investment
- **Time to Break-even**: Months to recover investment

#### Investment Analysis
- **Capital Efficiency**: Return per dollar invested
- **Risk-adjusted Returns**: Returns considering volatility
- **Comparative Analysis**: ROI vs alternative investments
- **Sensitivity Analysis**: Impact of parameter changes

### Payback Period

#### Break-even Analysis
- **Simple Payback**: Time to recover initial investment
- **Discounted Payback**: Time considering time value of money
- **Cash Flow Analysis**: Monthly cash generation
- **Risk Factors**: Uncertainty in projections

#### Payback Factors
- **Equipment Costs**: Hardware investment amount
- **Operating Costs**: Ongoing expenses
- **Revenue Projections**: Expected mining income
- **Market Conditions**: Bitcoin price and difficulty trends

### NPV and IRR

#### Net Present Value
- **Cash Flow Projection**: Future income and expenses
- **Discount Rate**: Cost of capital or required return
- **Present Value**: Discounted future cash flows
- **NPV Decision**: Positive NPV indicates profitable investment

#### Internal Rate of Return
- **IRR Calculation**: Rate where NPV equals zero
- **Hurdle Rate**: Minimum acceptable return
- **Investment Decision**: IRR > hurdle rate indicates good investment
- **Risk Assessment**: Higher IRR indicates better risk-adjusted returns

## Risk Analysis

### Monte Carlo Simulations

#### Simulation Methodology
- **Parameter Variation**: Random sampling of input parameters
- **Scenario Generation**: Multiple possible outcomes
- **Probability Distribution**: Likelihood of different results
- **Confidence Intervals**: Range of likely outcomes

#### Risk Factors Modeled
- **Bitcoin Price Volatility**: Price fluctuation scenarios
- **Network Difficulty Changes**: Mining competition variations
- **Equipment Performance**: Degradation and failure scenarios
- **Operational Risks**: Maintenance and downtime factors

### Sensitivity Analysis

#### Parameter Sensitivity
- **Bitcoin Price**: Impact of price changes on profitability
- **Electricity Costs**: Effect of power rate variations
- **Equipment Performance**: Influence of degradation rates
- **Network Difficulty**: Impact of mining competition changes

#### Scenario Analysis
- **Optimistic Scenarios**: Best-case projections
- **Pessimistic Scenarios**: Worst-case projections
- **Base Case**: Most likely outcomes
- **Stress Testing**: Extreme condition analysis

### Scenario Planning

#### What-if Analysis
- **Price Scenarios**: Different Bitcoin price projections
- **Difficulty Scenarios**: Various network difficulty paths
- **Cost Scenarios**: Different operational cost structures
- **Technology Scenarios**: Equipment upgrade timing

#### Decision Support
- **Investment Timing**: Optimal deployment schedule
- **Equipment Selection**: Best hardware choices
- **Scaling Decisions**: When to expand operations
- **Exit Strategies**: When to sell or upgrade equipment

## Implementation Details

### Calculation Architecture
- **Modular Design**: Separate engines for different calculations
- **Service Integration**: API-based calculation services
- **Caching Strategy**: Performance optimization for repeated calculations
- **Error Handling**: Robust error management and validation

### Performance Optimization
- **Parallel Processing**: Concurrent calculation execution
- **Memory Management**: Efficient data handling
- **Caching Layers**: Result caching for performance
- **Load Balancing**: Distribution across multiple workers

### Data Integration
- **Real-time Data**: Live Bitcoin and weather data
- **Historical Data**: Past performance analysis
- **External APIs**: Third-party data sources
- **User Inputs**: Configuration and parameter settings

## Performance Optimization

### Calculation Speed
- **Target Performance**: Sub-second response for basic calculations
- **Complex Scenarios**: <5 seconds for Monte Carlo simulations
- **Caching Strategy**: Intelligent result caching
- **Parallel Processing**: Multi-threaded calculation execution

### Resource Management
- **Memory Usage**: Efficient data structures and algorithms
- **CPU Optimization**: Optimized mathematical operations
- **Network Efficiency**: Minimized API calls and data transfer
- **Storage Optimization**: Compressed data storage and retrieval

### Scalability
- **Horizontal Scaling**: Multiple calculation workers
- **Load Distribution**: Intelligent workload balancing
- **Resource Monitoring**: Performance tracking and optimization
- **Auto-scaling**: Dynamic resource allocation

---

**Document Status**: Current Plan v1.0  
**Last Updated**: 2025-08-17  
**Next Review**: After Phase 1 implementation