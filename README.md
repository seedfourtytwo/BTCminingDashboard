# Solar Bitcoin Mining Calculator

A comprehensive planning and projection tool for solar-powered Bitcoin mining operations.

## Project Overview

This application enables Bitcoin miners to plan and optimize solar-powered mining operations by providing detailed projections, equipment management, and economic analysis tools. The system supports solar power modeling with location-specific environmental data.

## Current Status

🚧 **Development in Progress** - This is a personal project in early development.

### What's Implemented
- ✅ Basic project structure and architecture
- ✅ Simplified database schema
- ✅ API worker placeholders
- ✅ Calculation worker placeholders
- ✅ Data worker placeholders
- ✅ Landing page with feature overview

### What's Coming Next
- 🔄 Equipment selection interface
- 🔄 Solar power modeling calculations
- 🔄 Mining profitability projections
- 🔄 Basic financial analysis

## Key Features (Planned)

### 🌞 Solar Power Modeling
- Location-specific solar resource data
- PV system calculations with environmental factors
- Degradation modeling over time

### ⚡ Mining Equipment Management
- ASIC miner specifications and performance data
- Realistic degradation curves
- Power consumption optimization

### 💰 Economic Analysis
- ROI calculations with equipment costs
- Break-even analysis
- Basic financial metrics (NPV, IRR, payback period)

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
│   ├── App.tsx            # Main landing page
│   ├── components/        # React components (empty - to be built)
│   ├── pages/            # Page components (empty - to be built)
│   ├── services/         # API services (empty - to be built)
│   └── types/            # TypeScript types (empty - to be built)
├── server/               # Cloudflare Workers backend
│   ├── api/              # Main API worker
│   ├── calculations/     # Calculation worker
│   ├── data/             # Data collection worker
│   └── shared/           # Shared utilities and database
└── shared/               # Shared types and utilities
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
4. Set up database: `wrangler d1 execute DB --file=src/server/shared/database/migrations/0001_initial_schema.sql`

### Development Commands
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run deploy` - Deploy to Cloudflare

## Database Schema

The simplified database includes:

- **locations** - Geographic data for solar calculations
- **miner_models** - ASIC miner specifications
- **solar_panel_models** - Solar panel specifications
- **storage_models** - Battery storage specifications
- **bitcoin_network_data** - Current Bitcoin network stats
- **bitcoin_price_data** - Current Bitcoin price data
- **environmental_data** - Weather and solar resource data
- **system_configs** - User system configurations
- **projection_results** - Calculated projections

## API Endpoints

### Health Checks
- `GET /health` - API worker health
- `GET /calculate/health` - Calculation worker health
- `GET /data/health` - Data worker health

### API Routes (Coming Soon)
- `/api/v1/equipment` - Equipment management
- `/api/v1/projections` - Projection calculations
- `/api/v1/system-configs` - System configurations
- `/api/v1/locations` - Location data
- `/api/v1/bitcoin` - Bitcoin network data
- `/api/v1/environmental` - Environmental data

## Contributing

This is a personal project for learning and experimentation. The focus is on building a practical tool for solar Bitcoin mining analysis.

## License

MIT License - see LICENSE file for details.