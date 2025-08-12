# Project Structure - Solar Mining Calculator

## Overview

This document provides a complete overview of the project structure after consistency improvements and organization.

## Directory Structure

```
solar-mining-calculator/
├── README.md                           # Project overview and quick start
├── LICENSE                             # MIT License
├── CLAUDE.md                           # Development standards and best practices
├── docs/
│   ├── 11-PROJECT-STRUCTURE.md          # This file - project organization
├── package.json                        # Dependencies and scripts
├── .gitignore                          # Git ignore patterns
│
├── Configuration Files
├── ├── tsconfig.json                   # Base TypeScript configuration
├── ├── tsconfig.client.json            # Client-specific TypeScript config
├── ├── tsconfig.server.json            # Server-specific TypeScript config
├── ├── vite.config.ts                  # Vite build configuration
├── ├── vitest.config.ts                # Vitest test configuration
├── ├── tailwind.config.js              # Tailwind CSS configuration
├── ├── postcss.config.js               # PostCSS configuration
├── ├── .eslintrc.json                  # ESLint configuration
├── └── .prettierrc                     # Prettier formatting configuration
│
├── Cloudflare Workers Configuration
├── ├── wrangler.api.toml               # API Worker configuration
├── ├── wrangler.calculations.toml      # Calculation Worker configuration
├── └── wrangler.data.toml              # Data Worker configuration
│
├── docs/                               # Documentation directory
├── ├── 01-PROJECT-OVERVIEW.md          # High-level project description
├── ├── 02-DATABASE-SCHEMA.md           # Database design and relationships
├── ├── 03-API-SPECIFICATION.md         # REST API endpoints and data models
├── ├── 04-CALCULATION-ENGINES.md       # Mathematical models and algorithms
├── ├── 05-EQUIPMENT-SPECIFICATIONS.md  # Equipment catalogs and standards
├── ├── 06-USER-INTERFACE.md            # UI/UX design and workflows
├── ├── 07-DEPLOYMENT-GUIDE.md          # Setup and deployment instructions
├── ├── 08-ERROR-HANDLING.md            # Error handling strategy
├── ├── 09-UI-DESIGN-PRINCIPLES.md      # UI/UX design guidelines
├── └── 10-WORKER-ARCHITECTURE.md       # Worker architecture documentation
│
├── src/                                # Source code directory
├── ├── client/                         # React frontend application
├── │   ├── components/                 # React components
├── │   │   ├── ui/                     # Basic UI components (Button, Input, etc.)
├── │   │   ├── forms/                  # Form components
├── │   │   ├── charts/                 # Data visualization components
├── │   │   └── layout/                 # Layout components (Header, Sidebar, etc.)
├── │   ├── hooks/                      # Custom React hooks
├── │   ├── pages/                      # Page-level components
├── │   ├── services/                   # API client services
├── │   ├── types/                      # Client-specific TypeScript types
├── │   └── utils/                      # Client-side utility functions
├── │
├── ├── server/                         # Cloudflare Workers backend
├── │   ├── api/                        # Main API Worker
├── │   │   ├── handlers/               # Route handlers
├── │   │   ├── services/               # Business logic services
├── │   │   ├── models/                 # Data models and schemas
├── │   │   ├── migrations/             # Database migrations
├── │   │   │   └── 0001_initial_schema.sql
├── │   │   └── utils/                  # API-specific utilities
├── │   ├── calculations/               # Calculation Worker
├── │   └── data/                       # Data Worker
├── │
├── └── shared/                         # Shared code between client and server
├──     ├── types/                      # Common TypeScript interfaces
├──     ├── constants/                  # Shared constants
├──     ├── config/                     # Configuration utilities
├──     └── monitoring/                 # Monitoring and telemetry
│
├── tests/                              # Test files
├── ├── setup.ts                       # Test setup configuration
├── ├── unit/                          # Unit tests
├── ├── integration/                   # Integration tests
├── └── fixtures/                      # Test fixtures and mock data
│
└── .github/                           # GitHub configuration
    ├── workflows/                     # GitHub Actions workflows (to be created)
    └── ISSUE_TEMPLATE/                # Issue templates
        ├── bug_report.md              # Bug report template
        └── feature_request.md         # Feature request template
```

## Configuration Files Summary

### TypeScript Configuration
- **`tsconfig.json`**: Base configuration with strict mode enabled
- **`tsconfig.client.json`**: Client-specific settings for React/DOM
- **`tsconfig.server.json`**: Server-specific settings for Cloudflare Workers

### Build and Development Tools
- **`vite.config.ts`**: Frontend build configuration with path aliases
- **`vitest.config.ts`**: Test configuration with coverage settings
- **`tailwind.config.js`**: UI styling with custom color themes
- **`postcss.config.js`**: CSS processing configuration

### Code Quality Tools
- **`.eslintrc.json`**: Linting rules for TypeScript and React
- **`.prettierrc`**: Code formatting configuration

### Cloudflare Workers
- **`wrangler.api.toml`**: API Worker (port 8787)
- **`wrangler.calculations.toml`**: Calculation Worker (port 8788)
- **`wrangler.data.toml`**: Data Worker (port 8789)

## NPM Scripts

### Development Scripts
```bash
npm run dev                    # Start all services (client + all workers)
npm run dev:client            # Start frontend only (port 3000)
npm run dev:api               # Start API Worker only (port 8787)
npm run dev:calculations      # Start Calculation Worker only (port 8788)
npm run dev:data              # Start Data Worker only (port 8789)
```

### Build Scripts
```bash
npm run build                 # Build all components
npm run build:client          # Build frontend only
npm run build:workers         # Build all workers
npm run build:api             # Build API Worker only
npm run build:calculations    # Build Calculation Worker only
npm run build:data            # Build Data Worker only
```

### Test Scripts
```bash
npm run test                  # Run tests in watch mode
npm run test:ci               # Run tests with coverage (CI mode)
npm run test:coverage         # Run tests with verbose coverage
npm run test:unit             # Run unit tests only
npm run test:integration      # Run integration tests only
npm run test:smoke            # Run smoke tests
```

### Code Quality Scripts
```bash
npm run lint                  # Run ESLint
npm run lint:fix              # Fix ESLint issues automatically
npm run lint:ci               # Run ESLint with JUnit output for CI
npm run format                # Format code with Prettier
npm run format:check          # Check code formatting
npm run type-check            # Run TypeScript compiler checks
```

### Database Scripts
```bash
npm run db:migrate            # Run database migrations (development)
npm run db:migrate:production # Run database migrations (production)
npm run db:seed               # Seed database with sample data
npm run db:reset              # Reset and reseed database
```

### Deployment Scripts
```bash
npm run deploy               # Deploy all workers to production
npm run deploy:dev           # Deploy all workers to development
npm run deploy:api           # Deploy API Worker to production
npm run deploy:calculations  # Deploy Calculation Worker to production
npm run deploy:data          # Deploy Data Worker to production
npm run pages:deploy         # Deploy frontend to Cloudflare Pages
```

### Monitoring Scripts
```bash
npm run logs:api             # View API Worker logs
npm run logs:calculations    # View Calculation Worker logs
npm run logs:data            # View Data Worker logs
```

## Architecture Overview

### Modular Worker Design
- **API Worker**: Handles UI interactions, CRUD operations, routing
- **Calculation Worker**: Performs heavy computational tasks and projections
- **Data Worker**: Manages external API calls, caching, and scheduled jobs

### Benefits
- **Independent Scaling**: Each worker scales based on its specific workload
- **Isolated Failures**: Issues in one worker don't affect others
- **Optimized Performance**: Different CPU limits and resources per worker type
- **Easy Maintenance**: Clear separation of concerns and responsibilities

## Development Workflow

### 1. Initial Setup
```bash
git clone <repository-url>
cd solar-mining-calculator
npm install
```

### 2. Environment Configuration
```bash
# Copy environment example and configure
cp .env.example .env.local

# Set up Cloudflare API credentials
wrangler auth login
```

### 3. Database Setup
```bash
# Create databases
wrangler d1 create solar-mining-db-dev
wrangler d1 create solar-mining-db

# Run migrations
npm run db:migrate
npm run db:seed
```

### 4. Development
```bash
# Start all services
npm run dev

# Or start services individually as needed
npm run dev:client
npm run dev:api
```

### 5. Testing
```bash
# Run tests
npm run test

# Check code quality
npm run lint
npm run type-check
npm run format:check
```

### 6. Deployment
```bash
# Build and deploy
npm run build
npm run deploy
```

## Naming Conventions

### Files and Directories
- **Configuration files**: kebab-case (`vite.config.ts`)
- **Component files**: PascalCase (`EquipmentCard.tsx`)
- **Utility files**: camelCase (`calculateProjections.ts`)
- **Constant files**: SCREAMING_SNAKE_CASE (`API_ENDPOINTS.ts`)
- **Documentation files**: Numbered + SCREAMING_SNAKE_CASE (`01-PROJECT-OVERVIEW.md`)

### Workers and Services
- **API Worker**: `solar-mining-api` / `solar-mining-api-dev`
- **Calculation Worker**: `solar-mining-calculations` / `solar-mining-calculations-dev`
- **Data Worker**: `solar-mining-data` / `solar-mining-data-dev`

### Database Naming
- **Development**: `solar-mining-db-dev`
- **Production**: `solar-mining-db`

## Path Aliases

The following path aliases are configured for imports:

```typescript
import { Component } from '@/components/ui/Component';     // src/client/components/ui/Component
import { useHook } from '@/hooks/useHook';                // src/client/hooks/useHook
import { service } from '@/services/service';             // src/client/services/service
import { Type } from '@/types/Type';                      // src/shared/types/Type
import { util } from '@/utils/util';                      // src/client/utils/util
```

## Next Steps

With this organized structure in place, the project is ready for:

1. ✅ **Consistent Configuration**: All files follow naming conventions
2. ✅ **Modular Architecture**: Clear separation between workers
3. ✅ **Development Workflow**: Complete tooling setup
4. 🔄 **Frontend Implementation**: Ready to build React components
5. 🔄 **Worker Implementation**: Ready to implement business logic
6. 🔄 **Testing Setup**: Ready for comprehensive testing
7. 🔄 **CI/CD Pipeline**: Ready for automated deployment

This structure provides a solid foundation for scalable development while maintaining simplicity for solo work.