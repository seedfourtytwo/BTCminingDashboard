# Solar Bitcoin Mining Calculator

A comprehensive planning and projection tool for solar-powered Bitcoin mining operations with support for multiple renewable energy sources.

## Project Overview

This application enables Bitcoin miners to plan and optimize solar-powered mining operations by providing detailed projections, equipment management, and economic analysis tools. The system supports multiple power sources including solar panels, wind turbines, grid connections, and custom renewable sources.

## Key Features

### 🔋 Multi-Source Power Management
- **Solar Power**: Comprehensive PV system modeling with irradiance data
- **Wind Power**: Wind turbine integration with speed-based power curves
- **Grid Integration**: Time-of-use rates and net metering support
- **Custom Sources**: Flexible system for any renewable power source
- **Battery Storage**: Advanced energy storage modeling with degradation

### ⚡ Mining Equipment Management
- **Comprehensive Miner Database**: 100+ ASIC miner models with detailed specifications
- **Performance Degradation**: Realistic hashrate and efficiency decline modeling
- **Economic Analysis**: ROI calculations with equipment replacement planning
- **Power Optimization**: Dynamic power limiting and thermal management

### 📊 Advanced Projections
- **Multi-Scenario Analysis**: Compare different equipment and power source combinations
- **Monte Carlo Simulations**: Risk analysis with confidence intervals
- **Long-term Modeling**: 1-10 year projections with degradation factors
- **Real-time Adjustments**: Live parameter updates with instant recalculation

### 📈 Economic Intelligence
- **Profitability Analysis**: Detailed revenue vs. cost breakdown
- **Break-even Calculations**: ROI and payback period analysis
- **Sensitivity Analysis**: Impact assessment of key variables
- **Market Integration**: Live Bitcoin price and network difficulty data

## Technology Stack

- **Backend**: Cloudflare Workers with TypeScript
- **Database**: Cloudflare D1 (SQLite-based)
- **Frontend**: React with TypeScript
- **Build Tools**: Vite, ESLint, Prettier
- **Testing**: Vitest for unit tests
- **Deployment**: Cloudflare Workers & Pages

## Documentation Structure

```
docs/
├── 01-PROJECT-OVERVIEW.md          # High-level project description and goals
├── 02-DATABASE-SCHEMA.md           # Complete database design and relationships
├── 03-API-SPECIFICATION.md         # REST API endpoints and data models
├── 04-CALCULATION-ENGINES.md       # Mathematical models and algorithms
├── 05-EQUIPMENT-SPECIFICATIONS.md  # Equipment catalogs and standards
├── 06-USER-INTERFACE.md            # UI/UX design and workflows
├── 07-DEPLOYMENT-GUIDE.md          # Setup and deployment instructions
├── 08-ERROR-HANDLING.md            # Comprehensive error handling strategy
├── 09-UI-DESIGN-PRINCIPLES.md      # Modern UI/UX design guidelines and best practices
├── 10-WORKER-ARCHITECTURE.md       # Modular Cloudflare Workers architecture
├── 11-PROJECT-STRUCTURE.md         # Complete directory structure and configuration reference
└── CLAUDE.md                       # Development standards and practices
```

## Quick Start

1. **Project Overview**: Start with `docs/01-PROJECT-OVERVIEW.md`
2. **Project Structure**: Review `docs/11-PROJECT-STRUCTURE.md` for organization
3. **Database Design**: Understand `docs/02-DATABASE-SCHEMA.md`
4. **Worker Architecture**: Check `docs/10-WORKER-ARCHITECTURE.md`
5. **Development Setup**: Follow `docs/07-DEPLOYMENT-GUIDE.md`

## Project Status

🚧 **In Development** - Currently in documentation and planning phase

### Completed
- ✅ Comprehensive requirements analysis
- ✅ Database schema design
- ✅ API specification planning
- ✅ Calculation engine architecture

### In Progress
- 🔄 Documentation creation
- 🔄 Database implementation
- 🔄 API development
- 🔄 Frontend interface

### Planned
- 📋 Testing suite implementation
- 📋 Performance optimization
- 📋 Deployment and hosting setup

## Contributing

This project follows strict TypeScript practices and comprehensive testing requirements. See `CLAUDE.md` for detailed contribution guidelines.

## License

MIT License - See LICENSE file for details.