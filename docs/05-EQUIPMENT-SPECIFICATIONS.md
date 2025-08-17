# Equipment Specifications - Solar Bitcoin Mining Calculator

## Table of Contents
- [Overview](#overview)
- [Equipment Categories](#equipment-categories)
- [Solar Panel Specifications](#1-solar-panel-specifications)
  - [Standard Solar Panel Models](#11-standard-solar-panel-models)
  - [Performance Characteristics](#12-performance-characteristics)
  - [Environmental Factors](#13-environmental-factors)
- [Mining Equipment Specifications](#2-mining-equipment-specifications)
  - [ASIC Miner Models](#21-asic-miner-models)
  - [Performance Metrics](#22-performance-metrics)
  - [Degradation Models](#23-degradation-models)
- [Energy Storage Specifications](#3-energy-storage-specifications)
  - [Battery Storage Systems](#31-battery-storage-systems)
  - [Performance Characteristics](#32-performance-characteristics)
  - [Economic Parameters](#33-economic-parameters)
- [System Components](#4-system-components)
  - [Inverter Specifications](#41-inverter-specifications)
  - [Balance of System](#42-balance-of-system)
- [Equipment Standards](#equipment-standards)
- [Data Sources](#data-sources)
- [Maintenance and Updates](#maintenance-and-updates)

## Overview

This document defines the equipment specifications and standards used in the Solar Bitcoin Mining Calculator. The system supports essential equipment types with core technical specifications, performance characteristics, and economic parameters.

**Source**: Equipment data is stored in the database schema and seeded from [`src/server/shared/database/migrations/seed.sql`](../src/server/shared/database/migrations/seed.sql)

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
**Manufacturers**: SunPower, Panasonic, Canadian Solar, Jinko Solar, Trina Solar, LG Solar, REC Solar, Hanwha Q CELLS

**Typical Specifications**:
- **Power Range**: 300-500W
- **Efficiency Range**: 18-22.5%
- **Warranty**: 20-25 years
- **Degradation Rate**: 0.25-0.60% annually

#### Technology Types
- **Monocrystalline**: Highest efficiency (20-22.5%), premium cost
- **Polycrystalline**: Good efficiency (18-20%), cost-effective
- **Thin Film**: Lower efficiency (10-15%), flexible applications

#### Key Performance Metrics
- **Rated Power (W)**: Standard test conditions output
- **Efficiency (%)**: Power output per unit area
- **Temperature Coefficient**: Performance change with temperature
- **Degradation Rate**: Annual power loss percentage

### 1.2 Performance Characteristics

#### Efficiency Factors
- **Cell Technology**: Monocrystalline vs polycrystalline
- **Temperature Impact**: Performance decreases with heat
- **Age Degradation**: Gradual efficiency loss over time
- **Dust/Shading**: Real-world performance factors

#### Environmental Considerations
- **Operating Temperature**: -40°C to +85°C typical
- **Humidity**: 0-100% non-condensing
- **Wind Load**: 2400 Pa typical rating
- **Snow Load**: 5400 Pa typical rating

### 1.3 Environmental Factors

#### Temperature Effects
- **Temperature Coefficient**: -0.3% to -0.4% per °C typical
- **Performance Impact**: 10-15% reduction at high temperatures
- **Cooling Considerations**: Airflow and spacing requirements

#### Degradation Modeling
- **First Year**: 2-3% initial degradation
- **Annual Rate**: 0.5-0.8% typical
- **Warranty**: 25-year linear degradation guarantee

## 2. MINING EQUIPMENT SPECIFICATIONS

### 2.1 Current Generation ASIC Miners

**Source**: Miner specifications are stored in the database and can be updated via the API

#### High Efficiency Models (2024)
**Manufacturers**: Bitmain, MicroBT, Canaan, Innosilicon

**Performance Range**:
- **Hashrate**: 100-200 TH/s
- **Power Consumption**: 3000-4000W
- **Efficiency**: 20-30 J/TH
- **Price Range**: $2000-5000

#### Key Performance Metrics
- **Hashrate (TH/s)**: Mining speed in terahashes per second
- **Power Consumption (W)**: Electrical power draw
- **Efficiency (J/TH)**: Energy efficiency ratio
- **Noise Level**: Acoustic output in dB

### 2.2 Performance Metrics

#### Efficiency Calculations
- **J/TH Ratio**: Lower is better (more efficient)
- **Power Density**: Watts per unit volume
- **Heat Output**: Thermal management requirements
- **Reliability**: Mean time between failures

#### Environmental Requirements
- **Operating Temperature**: 5-40°C optimal
- **Humidity**: 10-90% non-condensing
- **Altitude**: Up to 3000m typical
- **Cooling**: Air or liquid cooling options

### 2.3 Degradation Models

#### Performance Degradation
- **Hashrate Loss**: 5-10% annually typical
- **Efficiency Decline**: 3-5% annually
- **Failure Rate**: 10-15% annual failure probability
- **Lifespan**: 3-5 years typical

#### Economic Factors
- **Depreciation**: 25-30% annually
- **Resale Value**: Declines with age and technology
- **Maintenance Costs**: Regular cleaning and repairs
- **Replacement Cycle**: Every 2-3 years optimal

## 3. ENERGY STORAGE SPECIFICATIONS

### 3.1 Battery Storage Systems

**Source**: Storage system data is managed through the database schema

#### Technology Types
- **Li-ion**: High energy density, good cycle life
- **LiFePO4**: Long cycle life, thermal stability
- **Lead Acid**: Low cost, limited cycle life
- **Flow Batteries**: Scalable, long duration

#### Key Specifications
- **Capacity (kWh)**: Total energy storage
- **Usable Capacity**: Available energy (typically 80-90%)
- **Power Rating (kW)**: Maximum charge/discharge rate
- **Cycle Life**: Number of charge/discharge cycles

### 3.2 Performance Characteristics

#### Efficiency Metrics
- **Round-trip Efficiency**: 85-95% typical
- **Charge Rate**: 0.5C to 2C typical
- **Discharge Rate**: 0.5C to 2C typical
- **Self-discharge**: 2-5% monthly

#### Degradation Factors
- **Cycle Degradation**: Capacity loss per cycle
- **Calendar Degradation**: Time-based capacity loss
- **Temperature Effects**: Performance at different temperatures
- **Depth of Discharge**: Impact of discharge level

### 3.3 Economic Parameters

#### Cost Considerations
- **Cost per kWh**: $300-800 typical
- **Installation Cost**: 20-30% of battery cost
- **Maintenance**: Minimal ongoing costs
- **Warranty**: 10-15 years typical

#### Financial Analysis
- **ROI Calculation**: Based on electricity arbitrage
- **Payback Period**: 5-10 years typical
- **Lifespan Value**: Total energy throughput
- **Replacement Cost**: End-of-life considerations

## 4. SYSTEM COMPONENTS

### 4.1 Inverter Specifications

**Source**: Inverter data is stored in the database schema

#### Types and Applications
- **String Inverters**: Traditional solar installations
- **Microinverters**: Panel-level optimization
- **Hybrid Inverters**: Solar + battery integration
- **Grid-tie Inverters**: Utility interconnection

#### Key Specifications
- **Power Rating (W)**: Maximum output capacity
- **Efficiency**: 95-99% typical
- **MPPT Trackers**: Maximum power point tracking
- **Grid Compatibility**: Voltage and frequency ranges

### 4.2 Balance of System

#### Electrical Components
- **Wiring**: DC and AC cabling requirements
- **Disconnects**: Safety and maintenance switches
- **Grounding**: Electrical safety systems
- **Monitoring**: Performance tracking equipment

#### Structural Components
- **Mounting Systems**: Panel and equipment mounting
- **Racking**: Support structures and foundations
- **Weather Protection**: Enclosures and covers
- **Access Systems**: Maintenance and inspection access

## Equipment Standards

### Industry Standards
- **IEC Standards**: International electrical standards
- **UL Certification**: Safety certification for US market
- **CE Marking**: European compliance
- **ISO Standards**: Quality management systems

### Quality Assurance
- **Manufacturer Warranties**: Equipment guarantees
- **Performance Testing**: Independent verification
- **Installation Standards**: Professional installation requirements
- **Maintenance Protocols**: Regular service requirements

## Data Sources

### Equipment Databases
- **Manufacturer Catalogs**: Official specifications
- **Industry Databases**: Third-party equipment data
- **User Contributions**: Community-driven specifications
- **Market Research**: Current pricing and availability

### Update Mechanisms
- **API Integration**: Automated data updates
- **Manual Updates**: User-driven specification changes
- **Market Monitoring**: Price and availability tracking
- **Technology Tracking**: New product releases

## Maintenance and Updates

### Data Maintenance
- **Regular Updates**: Quarterly specification reviews
- **Price Updates**: Monthly pricing adjustments
- **Technology Tracking**: New product monitoring
- **User Feedback**: Community input integration

### Quality Control
- **Data Validation**: Specification accuracy verification
- **Source Verification**: Manufacturer data confirmation
- **Performance Testing**: Real-world validation
- **User Reviews**: Community feedback integration

---

**Document Status**: Current Plan v1.0  
**Last Updated**: 2025-08-17  
**Next Review**: After Phase 1 implementation