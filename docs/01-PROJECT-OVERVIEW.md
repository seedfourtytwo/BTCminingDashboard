# Project Overview - Solar Bitcoin Mining Calculator

## Table of Contents
- [Executive Summary](#executive-summary)
- [Problem Statement](#problem-statement)
- [Solution Approach](#solution-approach)
  - [Data Integration](#1-data-integration)
  - [Modeling Engines](#2-modeling-engines)
  - [Equipment Management](#3-equipment-management)
- [Core Features](#core-features)
  - [Equipment Catalog](#equipment-catalog)
  - [Projection Capabilities](#projection-capabilities)
  - [Data Sources](#data-sources)
- [Target Users](#target-users)
- [Success Metrics](#success-metrics)
- [Technical Architecture](#technical-architecture)
- [Implementation Phases](#implementation-phases)
- [Next Steps](#next-steps)

## Executive Summary

The Solar Bitcoin Mining Calculator is a planning and projection tool for Bitcoin miners optimizing operations with renewable energy sources. The system provides modeling of solar-powered mining operations with equipment management and economic projections.

## Problem Statement

Bitcoin mining operations face several challenges:

1. **Energy Costs**: Electricity represents 60-80% of operational costs
2. **Profitability Volatility**: Bitcoin price and network difficulty fluctuations
3. **Equipment Degradation**: Mining hardware performance degrades over time
4. **Renewable Integration**: Complex calculations for solar/wind optimization
5. **Planning Complexity**: Difficulty comparing scenarios and optimizing equipment

## Solution Approach

The application addresses these challenges through:

### 1. Data Integration
- **Bitcoin Network Data**: Live difficulty, hashrate, and price feeds
- **Environmental Data**: Solar irradiance, weather patterns
- **Equipment Specifications**: Miner, panel, and battery catalogs
- **Economic Parameters**: Electricity rates, interconnection costs

### 2. Modeling Engines
- **Solar Production**: PV system calculations with environmental factors
- **Mining Performance**: Hashrate projections with degradation curves
- **Economic Analysis**: ROI calculations with risk assessment
- **Multi-Source Optimization**: Optimal power source mix determination

### 3. Equipment Management
- **Mining Hardware**: ASIC miner models with degradation profiles
- **Power Sources**: Solar panels, wind turbines, grid, generators
- **Energy Storage**: Battery systems with cycle-based degradation
- **System Configuration**: Equipment combinations and layouts

## Core Features

### Equipment Catalog
**Source**: Equipment data is stored in the database schema

**Mining Equipment**:
- Performance specifications (hashrate, power, efficiency)
- Degradation models (annual decline rates, failure probabilities)
- Economic data (purchase price, warranty, lifespan)
- Environmental limits (temperature, humidity, altitude)

**Power Sources**:
- Solar panels (efficiency, degradation, temperature coefficients)
- Wind turbines (power curves, cut-in/cut-out speeds)
- Grid connection (rate structures, demand charges)
- Generators (fuel costs, emissions, maintenance)

**Storage Systems**:
- Battery specifications (capacity, charge/discharge rates)
- Degradation models (cycle life, calendar aging)
- Economic parameters (cost per kWh, warranty)
- Operating conditions (temperature limits, depth of discharge)

### Projection Capabilities
**Time Horizons**:
- Short-term (1-12 months): Daily/weekly granularity
- Medium-term (1-3 years): Monthly granularity
- Long-term (3-10 years): Quarterly/annual granularity

**Analysis Types**:
- Deterministic: Single-point projections
- Sensitivity: Parameter variation analysis
- Monte Carlo: Risk assessment with confidence intervals
- Optimization: Equipment selection and sizing

**Economic Models**:
- Revenue calculations (BTC mining rewards, price projections)
- Cost analysis (electricity, maintenance, equipment replacement)
- Profitability metrics (NPV, IRR, payback period)
- Risk assessment (VaR, worst-case scenarios)

### Data Sources
**Bitcoin Network**:
- Blockchain APIs: Difficulty, hashrate, block times
- Price feeds: Multiple exchanges with redundancy
- Pool statistics: Fee structures, payout methods
- Network analysis: Trend detection, prediction models

**Environmental**:
- Weather APIs: Solar irradiance, wind speeds, temperature
- Geographic data: Location-specific solar/wind resources
- Climate models: Seasonal patterns, extreme weather
- Satellite data: Cloud cover, atmospheric conditions

**Equipment**:
- Manufacturer APIs: Live pricing, availability
- Performance databases: Real-world efficiency data
- Technology analysis: Equipment trends, roadmaps
- User contributions: Community-driven specifications

## Target Users

### Primary Users
- **Bitcoin Miners**: Individual and small-scale mining operations
- **Mining Farm Operators**: Commercial mining facility managers
- **Renewable Energy Developers**: Solar/wind project developers
- **Investment Analysts**: Financial professionals evaluating mining investments

### Use Cases
1. **Greenfield Planning**: New mining operation setup and optimization
2. **Expansion Analysis**: Adding capacity to existing operations
3. **Equipment Upgrades**: Timing and selection of new mining hardware
4. **Financial Planning**: ROI analysis and investment decision support
5. **Risk Management**: Scenario planning and sensitivity analysis

## Success Metrics

### Technical Performance
- **Calculation Speed**: Sub-second response for scenario modifications
- **Data Accuracy**: <5% variance from real-world performance
- **System Reliability**: 99.9% uptime for critical calculations
- **Scalability**: Support for 1000+ concurrent users

### User Experience
- **Learning Curve**: New users productive within 30 minutes
- **Feature Coverage**: 95% of planning scenarios supported
- **Data Export**: Multiple formats (PDF, CSV, JSON)
- **Mobile Access**: Responsive design for tablet/desktop use

### Business Impact
- **Decision Support**: Measurable improvement in investment decisions
- **Cost Optimization**: Average 10-15% improvement in operational efficiency
- **Risk Reduction**: Better scenario planning and contingency preparation
- **User Adoption**: 1000+ active users within first year

## Technical Architecture

### System Components
**Frontend (React/TypeScript)**:
- Dashboard: Real-time metrics and projections
- Equipment Manager: Catalog and configuration tools
- Scenario Planner: Multi-scenario comparison
- Data Explorer: Historical analysis and trends
- Settings: System configuration and preferences

**Backend (Cloudflare Workers)**:
- API Layer: RESTful endpoints for all operations
- Calculation Engines: Solar, mining, economic models
- Data Collectors: Automated external data ingestion
- Cron Jobs: Scheduled updates and maintenance
- Database Layer: Cloudflare D1 integration

**Database (Cloudflare D1)**:
- Core Foundation: User management and equipment specifications
- System Configuration: User-defined setups with JSON flexibility
- External Data: Bitcoin and environmental data with API management
- Projections & Scenarios: Scenario-based analysis and results
- Historical Data: Equipment value tracking over time
- Error Handling: Application error logging and debugging

### Data Flow
**Source**: See [`docs/08-WORKER-ARCHITECTURE.md`](08-WORKER-ARCHITECTURE.md) for detailed architecture

```
External APIs → Workers Cron Jobs → D1 Database → API Endpoints → React Frontend
                      ↓                           ↓
              Calculation Engines ←→ System Configurations
                      ↓
              Projection Results → Frontend Visualization
                      ↓
              Error Logging → Debugging & Monitoring
```

## Implementation Phases

### Phase 1: Foundation (Weeks 1-2)
- Database migrations (6 logical migrations)
- Core API structure
- External data integration
- Basic calculation engines
- Frontend foundation

### Phase 2: Core Features (Weeks 3-4)
- Equipment catalog management
- Solar production modeling
- Mining performance calculations
- Basic economic analysis
- User interface development

### Phase 3: Advanced Features (Weeks 5-6)
- Multi-scenario planning
- Risk analysis and Monte Carlo simulations
- Advanced economic modeling
- Data visualization and reporting
- Performance optimization

### Phase 4: Production Deployment (Weeks 7-8)
- Production environment setup
- Performance testing and optimization
- Security hardening
- Documentation completion
- User acceptance testing

## Next Steps

### Immediate Priorities
1. **Database Implementation**: Complete all migration scripts
2. **API Development**: Implement core endpoints
3. **Calculation Engines**: Build solar and mining models
4. **Frontend Foundation**: Create basic user interface

### Technical Considerations
- **Performance Optimization**: Ensure sub-second calculation times
- **Data Accuracy**: Validate models against real-world data
- **Scalability**: Design for 1000+ concurrent users
- **Security**: Implement proper authentication and authorization

### Future Enhancements
- **Additional Energy Sources**: Wind, hydro, geothermal integration
- **Advanced Analytics**: Machine learning for price prediction
- **Mobile Applications**: Native iOS and Android apps
- **API Ecosystem**: Third-party integrations and plugins

---

**Document Status**: Current Plan v1.0  
**Last Updated**: 2025-08-17  
**Next Review**: After Phase 1 implementation