# Solar Bitcoin Mining Calculator

A planning and projection tool for solar-powered Bitcoin mining operations.

## Project Overview

This application enables Bitcoin miners to plan and optimize solar-powered mining operations by providing projections, equipment management, and economic analysis tools. The system supports solar power modeling with location-specific environmental data.

## Current Status

🚧 **Development in Progress** - This is a personal project in early development.

### What's Implemented
- ✅ Project structure and architecture
- ✅ Database schema with 6 migrations
- ✅ API worker structure
- ✅ Calculation worker structure
- ✅ Data worker structure
- ✅ Documentation suite (13 files)
- ✅ Landing page with feature overview

### What's Coming Next
- 🔄 Equipment selection interface
- 🔄 Solar power modeling calculations
- 🔄 Mining profitability projections
- 🔄 Financial analysis

## Key Features

### Solar Power Modeling
- Location-specific solar resource data
- PV system calculations with environmental factors
- Degradation modeling over time

### Mining Equipment Management
- ASIC miner specifications and performance data
- Realistic degradation curves
- Power consumption optimization

### Economic Analysis
- ROI calculations with equipment costs
- Break-even analysis
- Financial metrics (NPV, IRR, payback period)

## Technology Stack

- **Frontend**: React with TypeScript
- **Backend**: Cloudflare Workers
- **Database**: Cloudflare D1 (SQLite-based)
- **Styling**: Tailwind CSS
- **Build Tool**: Vite

## Project Structure

```
src/
├── client/                 # React frontend
│   ├── components/        # UI components (ui/, forms/, charts/, layout/)
│   ├── hooks/             # Custom React hooks
│   ├── pages/             # Page components
│   ├── services/          # API services
│   └── types/             # TypeScript types
├── server/                # Cloudflare Workers backend
│   ├── api/               # API Worker (port 8787)
│   ├── calculations/      # Calculation Worker (port 8788)
│   ├── data/              # Data Worker (port 8789)
│   └── shared/            # Database, errors, middleware
└── shared/                # Common types and utilities
```

## Development

### Prerequisites
- Node.js 18+
- Wrangler CLI
- Cloudflare account

### Setup
1. Clone the repository
2. Install dependencies: `npm install`
3. Configure Wrangler: `wrangler login`
4. Set up database: `npm run db:migrate`

### Development Commands
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run test` - Run tests
- `npm run deploy` - Deploy to Cloudflare

## Database Schema

The database includes 18+ tables across 6 migrations:

- **Core Foundation**: Users, locations, equipment models
- **System Configuration**: User system setups and configurations
- **External Data**: Bitcoin network, price, and environmental data
- **Projections**: Scenario analysis and calculation results
- **Historical Data**: Equipment value tracking over time
- **Error Handling**: Application error logging and debugging

## API Endpoints

### Health Checks
- `GET /health` - API worker health
- `GET /calculate/health` - Calculation worker health
- `GET /data/health` - Data worker health

### API Routes
- `/api/v1/equipment` - Equipment management
- `/api/v1/projections` - Projection calculations
- `/api/v1/system-configs` - System configurations
- `/api/v1/locations` - Location data
- `/api/v1/bitcoin` - Bitcoin network data
- `/api/v1/environmental` - Environmental data

## Documentation

Complete documentation is available in the `docs/` directory:

- **01-PROJECT-OVERVIEW.md** - High-level project understanding
- **02-DATABASE-SCHEMA.md** - Database design and relationships
- **03-API-SPECIFICATION.md** - API endpoints and data models
- **04-CALCULATION-ENGINES.md** - Mathematical models and algorithms
- **05-EQUIPMENT-SPECIFICATIONS.md** - Equipment catalogs and standards
- **06-UI-DESIGN-PRINCIPLES.md** - UI/UX design guidelines
- **07-USER-INTERFACE.md** - Interface specifications and components
- **08-WORKER-ARCHITECTURE.md** - System architecture documentation
- **09-PROJECT-STRUCTURE.md** - Code organization and file structure
- **10-USER-FLOW.md** - User experience and workflow mapping
- **11-ERROR-HANDLING.md** - Error management strategy
- **12-DEPLOYMENT-GUIDE.md** - Manual deployment instructions
- **13-CI-CD-GUIDE.md** - Automated CI/CD pipeline setup

## Contributing

This is a personal project for learning and experimentation. The focus is on building a practical tool for solar Bitcoin mining analysis.

## License

MIT License - see LICENSE file for details.