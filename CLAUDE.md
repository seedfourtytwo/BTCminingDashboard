# Development Standards and Best Practices

This document serves as the primary development guide for the Solar Bitcoin Mining Calculator project. It establishes coding standards, architectural patterns, and development workflows to ensure maintainable, scalable, and high-quality code.

## Table of Contents

1. [Project Architecture](#project-architecture)
2. [Current Implementation Status](#current-implementation-status)
3. [TypeScript Standards](#typescript-standards)
4. [React Development Patterns](#react-development-patterns)
5. [Cloudflare Workers Best Practices](#cloudflare-workers-best-practices)
6. [Database Design with D1](#database-design-with-d1)
7. [Build System with Vite](#build-system-with-vite)
8. [Code Organization](#code-organization)
9. [Testing Standards](#testing-standards)
10. [Error Handling](#error-handling)
11. [Performance Guidelines](#performance-guidelines)
12. [Development Workflow](#development-workflow)
13. [Future Roadmap](#future-roadmap)

## Project Architecture

### Actual Project Structure (Current)
```
src/
├── client/                    # React frontend application
│   ├── components/            # React components
│   │   ├── ui/                # Basic UI components
│   │   ├── forms/             # Form components  
│   │   ├── charts/            # Data visualization
│   │   └── layout/            # Layout components
│   ├── hooks/                 # Custom React hooks
│   ├── pages/                 # Page-level components
│   ├── services/              # API client services
│   ├── types/                 # Client-specific types
│   └── utils/                 # Client-side utilities
├── server/                    # Cloudflare Workers backend (3-worker architecture)
│   ├── api/                   # Main API Worker (port 8787)
│   │   ├── handlers/          # Route handlers
│   │   ├── services/          # Business logic
│   │   ├── models/            # Data models
│   │   └── utils/             # API utilities
│   ├── calculations/          # Calculation Worker (port 8788)
│   │   ├── engines/           # Calculation engines
│   │   ├── services/          # Calculation services
│   │   └── utils/             # Calculation utilities
│   ├── data/                  # Data Worker (port 8789)
│   │   ├── providers/         # External API integrations
│   │   ├── cache/             # Data caching
│   │   ├── schedulers/        # Scheduled jobs
│   │   └── utils/             # Data utilities
│   ├── shared/                # Shared server code
│   │   ├── database/          # Database layer
│   │   │   ├── migrations/    # SQL migrations
│   │   │   └── repository-base.ts
│   │   ├── errors/            # Error classes
│   │   ├── middleware/        # Shared middleware
│   │   ├── utils/             # Shared utilities
│   │   └── validation/        # Data validation
│   └── types/                 # Server-wide types
└── shared/                    # Code shared between client and server
    ├── types/                 # Common TypeScript interfaces
    ├── constants/             # Shared constants
    ├── config/                # Configuration utilities
    └── monitoring/            # Telemetry and monitoring
```

### Multi-Worker Architecture Benefits
- **API Worker** (`wrangler.api.toml`): Handles UI interactions, CRUD operations, routing
- **Calculation Worker** (`wrangler.calculations.toml`): Performs heavy computational tasks and projections  
- **Data Worker** (`wrangler.data.toml`): Manages external API calls, caching, and scheduled jobs
- **Independent Scaling**: Each worker scales based on its specific workload
- **Isolated Failures**: Issues in one worker don't affect others
- **Optimized Performance**: Different CPU limits and resources per worker type

### Environment Configuration  
- **Development**: Local D1 database (`solar-mining-db-dev`), hot module replacement
- **Production**: Production D1 database (`solar-mining-db`), production Workers deployment

## Current Implementation Status

### ✅ Completed Components
- **Project Structure**: Organized 3-worker architecture with proper separation of concerns
- **TypeScript Configuration**: Strict mode enabled with comprehensive type checking  
- **Build System**: Vite configured with path aliases, code splitting, and optimization
- **Testing Setup**: Vitest configured with coverage reporting and test utilities
- **Database Schema**: Comprehensive schema with 8 core tables (miners, solar panels, storage, locations, etc.)
- **Development Workflow**: Complete npm scripts for all development tasks
- **Code Quality**: ESLint, Prettier, and Husky pre-commit hooks configured
- **CI/CD Pipeline**: GitHub Actions workflow with quality checks, builds, and deployment
- **Documentation**: Complete project documentation in docs/ directory

### 🔄 In Progress (Phase 1: Foundation & Data)
- **Database Seeding**: Populating equipment data with real ASIC and solar panel specifications
- **Basic API Implementation**: Equipment endpoints and system configuration CRUD operations
- **External Data Integration**: Bitcoin price, network data, and weather API integration
- **Frontend Implementation**: React components and pages (basic structure exists)

### 📋 Planned Features
- **Real-time Data Integration**: Live Bitcoin network data, weather forecasting
- **Advanced Calculations**: Monte Carlo simulations, risk analysis, sensitivity testing
- **Hardware Optimization**: Equipment comparison and recommendation algorithms
- **User Experience Enhancements**: Configuration wizard, templates, export capabilities
- **Environmental Modeling**: Temperature coefficients, degradation factors, weather impact

## TypeScript Standards

### Current Configuration

The project uses strict TypeScript configuration with comprehensive type checking:

#### Strict Mode (Enabled)
```json
// tsconfig.json (actual configuration)
{
  "compilerOptions": {
    "target": "ES2022",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyProperties": true,
    "noImplicitAny": true,
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true
  }
}
```

#### Path Aliases (Configured)
```typescript
// Available path aliases
"@/*": ["src/*"]
"@/client/*": ["src/client/*"]  
"@/server/*": ["src/server/*"]
"@/shared/*": ["src/shared/*"]
"@/components/*": ["src/client/components/*"]
"@/hooks/*": ["src/client/hooks/*"]
"@/services/*": ["src/client/services/*"]
"@/utils/*": ["src/client/utils/*"]
"@/types/*": ["src/shared/types/*"]
```

### Type Definition Patterns

#### Interface Design
- Use `interface` for object shapes that might be extended
- Use `type` for unions, intersections, and computed types
- Prefer composition over inheritance

```typescript
// ✅ Good: Composable interfaces
interface BaseEntity {
  id: string;
  createdAt: Date;
  updatedAt: Date;
}

interface MinerModel extends BaseEntity {
  name: string;
  hashrate: number;
  powerConsumption: number;
  efficiency: number;
}

// ✅ Good: Union types for state
type AsyncState<T> = 
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: string };
```

#### Generic Patterns
- Use descriptive generic names beyond `T`
- Constrain generics appropriately
- Leverage utility types for transformations

```typescript
// ✅ Good: Descriptive generic names
interface ApiResponse<TData> {
  success: boolean;
  data: TData;
  meta?: {
    pagination?: PaginationMeta;
  };
}

// ✅ Good: Generic constraints
interface Repository<TEntity extends BaseEntity> {
  findById(id: TEntity['id']): Promise<TEntity | null>;
  create(data: Omit<TEntity, keyof BaseEntity>): Promise<TEntity>;
  update(id: TEntity['id'], data: Partial<TEntity>): Promise<TEntity>;
}
```

### Type Safety Rules

#### Null Safety
- Use optional chaining (`?.`) for potentially undefined properties
- Prefer nullish coalescing (`??`) over logical OR (`||`)
- Use type guards for runtime type checking

```typescript
// ✅ Good: Safe property access
const minerName = equipment?.miner?.name ?? 'Unknown Miner';

// ✅ Good: Type guards
function isValidMinerData(data: unknown): data is MinerModel {
  return (
    typeof data === 'object' &&
    data !== null &&
    'name' in data &&
    'hashrate' in data &&
    typeof (data as any).hashrate === 'number'
  );
}
```

#### Error Handling Types
```typescript
// ✅ Good: Result pattern for error handling
type Result<T, E = Error> = 
  | { success: true; data: T }
  | { success: false; error: E };

// ✅ Good: Discriminated unions for API responses
type ProjectionResult = 
  | { type: 'success'; projections: Projection[]; metadata: ProjectionMeta }
  | { type: 'validation_error'; errors: ValidationError[] }
  | { type: 'calculation_error'; message: string; code: string };
```

## React Development Patterns

### Current Component Structure

The project uses a organized component architecture with clear separation of concerns:

```
src/client/components/
├── ui/           # Basic UI components (Button, Input, Card, etc.)
├── forms/        # Form components and form logic
├── charts/       # Data visualization components
└── layout/       # Layout components (Header, Sidebar, etc.)
```

### Planned User Experience Components

#### Configuration Wizard (Future)
- Step-by-step setup process for complex mining configurations
- Location & climate data integration
- Equipment selection and comparison
- Financial settings and optimization

#### Hardware Comparison (Future)  
- Side-by-side equipment comparison tables
- Performance charts and visualizations
- Equipment recommendation algorithms
- Real-time pricing integration

#### Export and Reporting (Future)
- PDF report generation
- Excel workbook exports
- CSV data exports
- Shareable calculation results

### Component Architecture

#### Functional Components Only
- Use functional components exclusively
- Leverage hooks for state and side effects
- Keep components focused on single responsibilities

```typescript
// ✅ Good: Focused functional component
interface EquipmentCardProps {
  equipment: MinerModel;
  onSelect: (equipment: MinerModel) => void;
  isSelected: boolean;
}

export function EquipmentCard({ equipment, onSelect, isSelected }: EquipmentCardProps) {
  const handleClick = useCallback(() => {
    onSelect(equipment);
  }, [equipment, onSelect]);

  return (
    <div 
      className={`card ${isSelected ? 'selected' : ''}`}
      onClick={handleClick}
    >
      <h3>{equipment.name}</h3>
      <p>Hashrate: {equipment.hashrate} TH/s</p>
      <p>Power: {equipment.powerConsumption}W</p>
    </div>
  );
}
```

#### Custom Hooks Patterns

##### Data Fetching Hooks
```typescript
// ✅ Good: Reusable data fetching hook
function useEquipmentData() {
  const [state, setState] = useState<AsyncState<MinerModel[]>>({ status: 'idle' });

  const fetchEquipment = useCallback(async () => {
    setState({ status: 'loading' });
    try {
      const response = await api.get<MinerModel[]>('/equipment');
      setState({ status: 'success', data: response.data });
    } catch (error) {
      setState({ 
        status: 'error', 
        error: error instanceof Error ? error.message : 'Unknown error' 
      });
    }
  }, []);

  useEffect(() => {
    fetchEquipment();
  }, [fetchEquipment]);

  return { ...state, refetch: fetchEquipment };
}
```

##### State Management Hooks
```typescript
// ✅ Good: Custom state management hook
function useProjectionCalculator() {
  const [config, setConfig] = useState<ProjectionConfig>();
  const [results, setResults] = useState<ProjectionResult[]>([]);
  const [isCalculating, setIsCalculating] = useState(false);

  const calculate = useCallback(async (newConfig: ProjectionConfig) => {
    if (isCalculating) return;

    setIsCalculating(true);
    setConfig(newConfig);
    
    try {
      const projections = await calculateProjections(newConfig);
      setResults(projections);
    } catch (error) {
      console.error('Calculation failed:', error);
      setResults([]);
    } finally {
      setIsCalculating(false);
    }
  }, [isCalculating]);

  return {
    config,
    results,
    isCalculating,
    calculate
  };
}
```

#### Component Composition Patterns

##### Compound Components
```typescript
// ✅ Good: Compound component pattern
export function ProjectionCard({ children, ...props }: ProjectionCardProps) {
  return <div className="projection-card" {...props}>{children}</div>;
}

ProjectionCard.Header = function Header({ title, subtitle }: HeaderProps) {
  return (
    <div className="projection-card-header">
      <h3>{title}</h3>
      {subtitle && <p>{subtitle}</p>}
    </div>
  );
};

ProjectionCard.Body = function Body({ children }: BodyProps) {
  return <div className="projection-card-body">{children}</div>;
};

ProjectionCard.Footer = function Footer({ children }: FooterProps) {
  return <div className="projection-card-footer">{children}</div>;
};
```

### Performance Optimization

#### Memoization Rules
- Use `useMemo` for expensive calculations only
- Use `useCallback` for functions passed to child components
- Use `React.memo` for components that re-render frequently

```typescript
// ✅ Good: Appropriate use of memoization
const ProjectionChart = React.memo(function ProjectionChart({ data, options }: Props) {
  const chartData = useMemo(() => {
    // Expensive transformation
    return transformDataForChart(data);
  }, [data]);

  const handleDataPointClick = useCallback((point: DataPoint) => {
    onDataPointClick?.(point);
  }, [onDataPointClick]);

  return <Chart data={chartData} onPointClick={handleDataPointClick} />;
});
```

## Cloudflare Workers Best Practices

### Worker Architecture

#### Handler Organization
```typescript
// ✅ Good: Modular handler structure
interface Env {
  DB: D1Database;
  API_KEY: string;
}

export default {
  async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
    const url = new URL(request.url);
    const method = request.method;
    
    try {
      // Route handling
      if (url.pathname.startsWith('/api/equipment')) {
        return handleEquipmentRoutes(request, env, ctx);
      }
      
      if (url.pathname.startsWith('/api/projections')) {
        return handleProjectionRoutes(request, env, ctx);
      }

      return new Response('Not found', { status: 404 });
    } catch (error) {
      return handleError(error);
    }
  },
} satisfies ExportedHandler<Env>;
```

#### Request Validation
```typescript
// ✅ Good: Request validation with Zod
import { z } from 'zod';

const ProjectionConfigSchema = z.object({
  equipmentId: z.string(),
  solarConfig: z.object({
    panelCount: z.number().min(1),
    panelWatts: z.number().min(1),
    systemVoltage: z.number().min(12)
  }),
  projectionYears: z.number().min(1).max(10)
});

async function handleCreateProjection(request: Request, env: Env) {
  const body = await request.json();
  
  const result = ProjectionConfigSchema.safeParse(body);
  if (!result.success) {
    return Response.json({ 
      error: 'Validation failed', 
      details: result.error.issues 
    }, { status: 400 });
  }

  const projection = await createProjection(result.data, env.DB);
  return Response.json(projection);
}
```

#### Error Handling Pattern
```typescript
// ✅ Good: Centralized error handling
function handleError(error: unknown): Response {
  console.error('Worker error:', error);

  if (error instanceof ValidationError) {
    return Response.json({
      error: 'Validation Error',
      message: error.message,
      details: error.details
    }, { status: 400 });
  }

  if (error instanceof DatabaseError) {
    return Response.json({
      error: 'Database Error',
      message: 'Internal database error occurred'
    }, { status: 500 });
  }

  return Response.json({
    error: 'Internal Server Error',
    message: 'An unexpected error occurred'
  }, { status: 500 });
}
```

### Performance Optimization

#### Connection Reuse
```typescript
// ✅ Good: Reuse database connections
class DatabaseService {
  private constructor(private db: D1Database) {}

  static create(db: D1Database): DatabaseService {
    return new DatabaseService(db);
  }

  async findEquipment(): Promise<MinerModel[]> {
    const { results } = await this.db
      .prepare('SELECT * FROM equipment ORDER BY name')
      .all();
    return results as MinerModel[];
  }

  async createProjection(data: ProjectionData): Promise<Projection> {
    const stmt = this.db.prepare(`
      INSERT INTO projections (config, results, created_at)
      VALUES (?1, ?2, ?3)
      RETURNING *
    `);
    
    const result = await stmt
      .bind(JSON.stringify(data.config), JSON.stringify(data.results), new Date().toISOString())
      .first();
    
    return result as Projection;
  }
}
```

## Database Design with D1

### Schema Design Principles

#### Current Database Schema (Implemented)
```sql
-- Core tables in the current database schema
-- Complete schema is in src/server/shared/database/migrations/0001_initial_schema.sql

-- Equipment specifications
CREATE TABLE miner_models (
  id INTEGER PRIMARY KEY,
  manufacturer VARCHAR(50) NOT NULL,
  model_name VARCHAR(100) NOT NULL,
  hashrate_th REAL NOT NULL,
  power_consumption_w INTEGER NOT NULL,
  efficiency_j_th REAL NOT NULL,
  -- Degradation and environmental factors
  hashrate_degradation_annual REAL DEFAULT 0.05,
  operating_temp_min INTEGER,
  operating_temp_max INTEGER,
  current_price_usd REAL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE solar_panel_models (
  id INTEGER PRIMARY KEY,
  manufacturer VARCHAR(50) NOT NULL,
  model_name VARCHAR(100) NOT NULL,
  rated_power_w INTEGER NOT NULL,
  efficiency_percent REAL NOT NULL,
  temperature_coefficient REAL NOT NULL,
  degradation_rate_annual REAL DEFAULT 0.5,
  cost_per_watt REAL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- System configurations and projections
CREATE TABLE system_configs (
  id INTEGER PRIMARY KEY,
  config_name VARCHAR(100) NOT NULL,
  location_id INTEGER NOT NULL,
  solar_panels JSON NOT NULL,
  miners JSON NOT NULL,
  electricity_rate_usd_kwh REAL NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Market and environmental data tables
CREATE TABLE bitcoin_price_data (
  id INTEGER PRIMARY KEY,
  recorded_date DATE NOT NULL,
  price_usd REAL NOT NULL,
  data_source VARCHAR(50) NOT NULL
);

-- Complete schema includes 8 tables total
-- See migration file for full table definitions
```

#### Query Patterns
```typescript
// ✅ Good: Prepared statements with proper error handling
export class EquipmentRepository {
  constructor(private db: D1Database) {}

  async findById(id: string): Promise<MinerModel | null> {
    try {
      const result = await this.db
        .prepare('SELECT * FROM miners WHERE id = ?')
        .bind(id)
        .first();
      
      return result as MinerModel | null;
    } catch (error) {
      throw new DatabaseError(`Failed to find miner ${id}`, { cause: error });
    }
  }

  async findMostEfficient(limit = 10): Promise<MinerModel[]> {
    try {
      const { results } = await this.db
        .prepare('SELECT * FROM miners ORDER BY efficiency_j_th ASC LIMIT ?')
        .bind(limit)
        .all();
      
      return results as MinerModel[];
    } catch (error) {
      throw new DatabaseError('Failed to find efficient miners', { cause: error });
    }
  }

  async create(data: CreateMinerData): Promise<MinerModel> {
    try {
      const id = generateId();
      const now = new Date().toISOString();
      
      const result = await this.db
        .prepare(`
          INSERT INTO miners (id, name, manufacturer, hashrate_th, power_consumption_w, efficiency_j_th, created_at, updated_at)
          VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)
          RETURNING *
        `)
        .bind(id, data.name, data.manufacturer, data.hashrate, data.powerConsumption, data.efficiency, now, now)
        .first();
      
      return result as MinerModel;
    } catch (error) {
      throw new DatabaseError('Failed to create miner', { cause: error });
    }
  }
}
```

#### Migration Strategy
```typescript
// ✅ Good: Version-controlled migrations
export interface Migration {
  version: number;
  name: string;
  up: (db: D1Database) => Promise<void>;
  down: (db: D1Database) => Promise<void>;
}

const migrations: Migration[] = [
  {
    version: 1,
    name: 'create_miners_table',
    async up(db) {
      await db.exec(`
        CREATE TABLE miners (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          hashrate_th REAL NOT NULL,
          power_consumption_w INTEGER NOT NULL,
          created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
      `);
    },
    async down(db) {
      await db.exec('DROP TABLE miners');
    }
  }
];

export async function runMigrations(db: D1Database) {
  // Create migrations table if not exists
  await db.exec(`
    CREATE TABLE IF NOT EXISTS migrations (
      version INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      executed_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);

  // Get current version
  const current = await db.prepare('SELECT MAX(version) as version FROM migrations').first();
  const currentVersion = (current?.version as number) || 0;

  // Run pending migrations
  for (const migration of migrations) {
    if (migration.version > currentVersion) {
      await migration.up(db);
      await db.prepare('INSERT INTO migrations (version, name) VALUES (?, ?)')
        .bind(migration.version, migration.name)
        .run();
    }
  }
}
```

## Calculation Engine Architecture (Planned)

### Current Calculation Structure
The project is structured to support advanced calculations in the dedicated Calculation Worker:

```
src/server/calculations/
├── engines/          # Mathematical calculation engines
├── services/         # Calculation business logic
├── utils/           # Calculation utilities
└── index.ts         # Calculation Worker entry point
```

### Planned Calculation Features

#### Phase 2: Basic Calculations (Next)
- **Solar power output**: PV system modeling with irradiance data
- **Mining hashrate**: Effective hashrate with environmental factors
- **Financial projections**: ROI, payback period, operating costs
- **Performance degradation**: Equipment aging and efficiency decline

#### Phase 3: Advanced Analytics (Future)
- **Monte Carlo simulations**: Risk analysis with confidence intervals
- **Sensitivity analysis**: Parameter impact assessment
- **Hardware optimization**: Multi-objective equipment selection
- **Environmental modeling**: Temperature and weather impact

### Basic Calculation Types

#### Solar Energy Calculations (Implementation Ready)
```typescript
interface SolarCalculationConfig {
  panels: {
    count: number;
    watts_per_panel: number;
    efficiency: number;
    degradation_rate: number;
  };
  location: {
    latitude: number;
    longitude: number;
    irradiance_data: number[];
  };
  environmental: {
    temperature_coefficient: number;
    soiling_losses: number;
    system_losses: number;
  };
}
```

#### Mining Performance Calculations (Implementation Ready)
```typescript
interface MiningCalculationConfig {
  equipment: {
    hashrate_th: number;
    power_consumption_w: number;
    efficiency_j_th: number;
    degradation_rate: number;
  };
  network: {
    difficulty: number;
    block_reward: number;
    btc_price_usd: number;
  };
  costs: {
    electricity_rate_kwh: number;
    maintenance_costs: number;
  };
}
```

#### Financial Analysis (Implementation Ready)
```typescript
interface FinancialProjection {
  initial_investment: number;
  monthly_revenue: number[];
  monthly_costs: number[];
  net_present_value: number;
  internal_rate_of_return: number;
  payback_period_months: number;
  total_roi_percent: number;
}
```

## Build System with Vite

### Current Configuration

#### Production Vite Configuration
```typescript
// vite.config.ts (actual current configuration)
export default defineConfig({
  plugins: [react()],
  
  esbuild: { target: 'es2022' },
  
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
      '@/client': resolve(__dirname, 'src/client'),
      '@/server': resolve(__dirname, 'src/server'),
      '@/shared': resolve(__dirname, 'src/shared'),
      '@/components': resolve(__dirname, 'src/client/components'),
      '@/hooks': resolve(__dirname, 'src/client/hooks'),
      '@/services': resolve(__dirname, 'src/client/services'),
      '@/utils': resolve(__dirname, 'src/client/utils'),
      '@/types': resolve(__dirname, 'src/shared/types')
    }
  },
  
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8787',
        changeOrigin: true
      }
    }
  },

  build: {
    target: 'es2022',
    outDir: 'dist',
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          router: ['react-router-dom'],
          utils: ['date-fns', 'zod', 'clsx']
        }
      }
    }
  },

  optimizeDeps: {
    include: ['react', 'react-dom', 'react-router-dom', 'date-fns'],
    esbuildOptions: { target: 'es2022' }
  }
});
```

#### Environment-Specific Builds
```typescript
// vite.config.production.ts
export default defineConfig({
  ...baseConfig,
  build: {
    ...baseConfig.build,
    minify: 'esbuild',
    cssMinify: true,
    reportCompressedSize: false, // Faster builds
    chunkSizeWarningLimit: 1000
  },
  define: {
    __DEV__: false,
    __PROD__: true
  }
});
```

### Performance Optimization

#### Code Splitting
```typescript
// ✅ Good: Route-based code splitting
const EquipmentPage = lazy(() => import('@/pages/EquipmentPage'));
const ProjectionsPage = lazy(() => import('@/pages/ProjectionsPage'));
const AnalyticsPage = lazy(() => import('@/pages/AnalyticsPage'));

function App() {
  return (
    <Router>
      <Suspense fallback={<PageLoader />}>
        <Routes>
          <Route path="/equipment" element={<EquipmentPage />} />
          <Route path="/projections" element={<ProjectionsPage />} />
          <Route path="/analytics" element={<AnalyticsPage />} />
        </Routes>
      </Suspense>
    </Router>
  );
}
```

## Code Organization

### File Naming Conventions

#### Files and Directories
- Use kebab-case for file names: `equipment-card.tsx`
- Use PascalCase for component files: `EquipmentCard.tsx`
- Use camelCase for utility files: `calculateProjections.ts`
- Use SCREAMING_SNAKE_CASE for constants: `API_ENDPOINTS.ts`

#### Component Organization
```
components/
├── ui/                    # Basic UI components
│   ├── Button.tsx
│   ├── Input.tsx
│   └── Card.tsx
├── forms/                 # Form components
│   ├── EquipmentForm.tsx
│   └── ProjectionForm.tsx
├── charts/                # Visualization components
│   ├── ProjectionChart.tsx
│   └── EfficiencyChart.tsx
└── layout/                # Layout components
    ├── Header.tsx
    ├── Sidebar.tsx
    └── PageLayout.tsx
```

### Module Export Patterns

#### Named Exports (Preferred)
```typescript
// ✅ Good: Named exports for better tree-shaking
export function calculateProjections(config: ProjectionConfig): Promise<Projection[]> {
  // Implementation
}

export function validateEquipment(equipment: MinerModel): boolean {
  // Implementation
}

export const PROJECTION_DEFAULTS = {
  years: 5,
  degradationRate: 0.005
} as const;
```

#### Barrel Exports
```typescript
// index.ts - Barrel export file
export { calculateProjections, validateEquipment } from './calculations';
export { PROJECTION_DEFAULTS } from './constants';
export type { ProjectionConfig, Projection } from './types';
```

### Import Organization
```typescript
// ✅ Good: Organized imports
// 1. Node modules
import React, { useState, useCallback, useMemo } from 'react';
import { z } from 'zod';

// 2. Internal modules (absolute imports)
import { EquipmentCard } from '@components/equipment/EquipmentCard';
import { useEquipmentData } from '@hooks/useEquipmentData';
import { calculateProjections } from '@services/calculations';

// 3. Relative imports
import './EquipmentList.css';

// 4. Type-only imports (separate)
import type { MinerModel, ProjectionConfig } from '@shared/types';
```

## Testing Standards

### Unit Testing with Vitest

#### Component Testing
```typescript
// ✅ Good: Comprehensive component test
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { vi } from 'vitest';
import { EquipmentCard } from './EquipmentCard';
import type { MinerModel } from '@shared/types';

const mockMiner: MinerModel = {
  id: 'test-1',
  name: 'Test Miner S19',
  manufacturer: 'Bitmain',
  hashrate: 110,
  powerConsumption: 3250,
  efficiency: 29.5,
  createdAt: new Date(),
  updatedAt: new Date()
};

describe('EquipmentCard', () => {
  const mockOnSelect = vi.fn();

  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('displays miner information correctly', () => {
    render(<EquipmentCard equipment={mockMiner} onSelect={mockOnSelect} isSelected={false} />);
    
    expect(screen.getByText('Test Miner S19')).toBeInTheDocument();
    expect(screen.getByText(/110 TH\/s/)).toBeInTheDocument();
    expect(screen.getByText(/3250W/)).toBeInTheDocument();
  });

  it('calls onSelect when clicked', async () => {
    render(<EquipmentCard equipment={mockMiner} onSelect={mockOnSelect} isSelected={false} />);
    
    fireEvent.click(screen.getByRole('button'));
    
    await waitFor(() => {
      expect(mockOnSelect).toHaveBeenCalledWith(mockMiner);
    });
  });

  it('applies selected styling when selected', () => {
    render(<EquipmentCard equipment={mockMiner} onSelect={mockOnSelect} isSelected={true} />);
    
    expect(screen.getByRole('button')).toHaveClass('selected');
  });
});
```

#### Service Testing
```typescript
// ✅ Good: Service layer testing
import { describe, it, expect, beforeEach, vi } from 'vitest';
import { EquipmentService } from './EquipmentService';
import type { D1Database } from '@cloudflare/workers-types';

// Mock D1 database
const mockDB = {
  prepare: vi.fn(),
  exec: vi.fn()
} as unknown as D1Database;

describe('EquipmentService', () => {
  let service: EquipmentService;

  beforeEach(() => {
    vi.clearAllMocks();
    service = new EquipmentService(mockDB);
  });

  describe('findById', () => {
    it('returns miner when found', async () => {
      const mockResult = { id: '1', name: 'Test Miner' };
      const mockStatement = {
        bind: vi.fn().mockReturnThis(),
        first: vi.fn().mockResolvedValue(mockResult)
      };
      
      (mockDB.prepare as any).mockReturnValue(mockStatement);

      const result = await service.findById('1');

      expect(mockDB.prepare).toHaveBeenCalledWith('SELECT * FROM miners WHERE id = ?');
      expect(mockStatement.bind).toHaveBeenCalledWith('1');
      expect(result).toEqual(mockResult);
    });

    it('returns null when not found', async () => {
      const mockStatement = {
        bind: vi.fn().mockReturnThis(),
        first: vi.fn().mockResolvedValue(null)
      };
      
      (mockDB.prepare as any).mockReturnValue(mockStatement);

      const result = await service.findById('nonexistent');

      expect(result).toBeNull();
    });
  });
});
```

### Integration Testing
```typescript
// ✅ Good: Integration test with real Worker
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { unstable_dev } from 'wrangler';
import type { UnstableDevWorker } from 'wrangler';

describe('Equipment API', () => {
  let worker: UnstableDevWorker;

  beforeAll(async () => {
    worker = await unstable_dev('src/server/index.ts', {
      experimental: { disableExperimentalWarning: true }
    });
  });

  afterAll(async () => {
    await worker.stop();
  });

  it('GET /api/equipment returns equipment list', async () => {
    const response = await worker.fetch('/api/equipment');
    const data = await response.json();

    expect(response.status).toBe(200);
    expect(Array.isArray(data)).toBe(true);
    expect(data).toHaveLength.greaterThan(0);
  });

  it('POST /api/equipment creates new equipment', async () => {
    const newEquipment = {
      name: 'Test Miner',
      manufacturer: 'Test Corp',
      hashrate: 100,
      powerConsumption: 3000,
      efficiency: 30
    };

    const response = await worker.fetch('/api/equipment', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(newEquipment)
    });

    expect(response.status).toBe(201);
    
    const created = await response.json();
    expect(created).toMatchObject(newEquipment);
    expect(created.id).toBeDefined();
  });
});
```

## Error Handling

### Error Classes
```typescript
// ✅ Good: Custom error hierarchy
export abstract class AppError extends Error {
  abstract readonly code: string;
  abstract readonly statusCode: number;
  
  constructor(
    message: string,
    public readonly context?: Record<string, unknown>
  ) {
    super(message);
    this.name = this.constructor.name;
  }
}

export class ValidationError extends AppError {
  readonly code = 'VALIDATION_ERROR';
  readonly statusCode = 400;
  
  constructor(
    message: string,
    public readonly field: string,
    public readonly value: unknown,
    context?: Record<string, unknown>
  ) {
    super(message, context);
  }
}

export class DatabaseError extends AppError {
  readonly code = 'DATABASE_ERROR';
  readonly statusCode = 500;
}

export class CalculationError extends AppError {
  readonly code = 'CALCULATION_ERROR';
  readonly statusCode = 422;
}
```

### Error Boundaries (React)
```typescript
// ✅ Good: Error boundary component
interface ErrorBoundaryState {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<PropsWithChildren, ErrorBoundaryState> {
  constructor(props: PropsWithChildren) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: ErrorInfo) {
    console.error('Error boundary caught error:', error, errorInfo);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div className="error-boundary">
          <h2>Something went wrong</h2>
          <details>
            <summary>Error details</summary>
            <pre>{this.state.error?.stack}</pre>
          </details>
          <button onClick={() => this.setState({ hasError: false, error: null })}>
            Try again
          </button>
        </div>
      );
    }

    return this.props.children;
  }
}
```

## Performance Guidelines

### React Performance

#### Avoid Unnecessary Re-renders
```typescript
// ✅ Good: Memoized component with stable references
interface ProjectionListProps {
  projections: Projection[];
  onProjectionSelect: (projection: Projection) => void;
}

export const ProjectionList = React.memo(function ProjectionList({ 
  projections, 
  onProjectionSelect 
}: ProjectionListProps) {
  // Stable callback reference
  const handleSelect = useCallback((projection: Projection) => {
    onProjectionSelect(projection);
  }, [onProjectionSelect]);

  // Memoize expensive calculations
  const sortedProjections = useMemo(() => {
    return [...projections].sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
  }, [projections]);

  return (
    <div>
      {sortedProjections.map(projection => (
        <ProjectionCard 
          key={projection.id} 
          projection={projection}
          onSelect={handleSelect}
        />
      ))}
    </div>
  );
});
```

#### Virtual Scrolling for Large Lists
```typescript
// ✅ Good: Virtual scrolling implementation
import { FixedSizeList as List } from 'react-window';

interface VirtualizedListProps {
  items: MinerModel[];
  onItemSelect: (item: MinerModel) => void;
}

export function VirtualizedEquipmentList({ items, onItemSelect }: VirtualizedListProps) {
  const Row = useCallback(({ index, style }: ListChildComponentProps) => (
    <div style={style}>
      <EquipmentCard 
        equipment={items[index]}
        onSelect={onItemSelect}
        isSelected={false}
      />
    </div>
  ), [items, onItemSelect]);

  return (
    <List
      height={600}
      itemCount={items.length}
      itemSize={150}
      width="100%"
    >
      {Row}
    </List>
  );
}
```

### Database Performance

#### Query Optimization
```typescript
// ✅ Good: Optimized queries with pagination
export class ProjectionRepository {
  async findUserProjections(
    userId: string, 
    options: PaginationOptions = {}
  ): Promise<PaginatedResult<Projection>> {
    const { offset = 0, limit = 20, sortBy = 'created_at', sortOrder = 'DESC' } = options;
    
    // Use prepared statement with proper indexing
    const query = `
      SELECT p.*, m.name as miner_name
      FROM projections p
      JOIN miners m ON p.miner_id = m.id
      WHERE p.user_id = ?
      ORDER BY p.${sortBy} ${sortOrder}
      LIMIT ? OFFSET ?
    `;
    
    const [projections, total] = await Promise.all([
      this.db.prepare(query).bind(userId, limit, offset).all(),
      this.db.prepare('SELECT COUNT(*) as count FROM projections WHERE user_id = ?')
        .bind(userId).first()
    ]);

    return {
      data: projections.results as Projection[],
      total: (total as any).count,
      offset,
      limit,
      hasMore: offset + limit < (total as any).count
    };
  }
}
```

## Development Workflow

### Git Workflow

#### Branch Naming
- Feature branches: `feature/equipment-management`
- Bug fixes: `fix/calculation-error`
- Hotfixes: `hotfix/critical-security-patch`

#### Commit Messages
```
feat: add solar panel efficiency calculator

- Implement PV system modeling calculations
- Add degradation factor calculations
- Include temperature coefficient adjustments

Closes #123
```

#### Pre-commit Hooks
```json
// package.json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "pre-push": "npm run type-check && npm run test"
    }
  },
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{md,json}": [
      "prettier --write"
    ]
  }
}
```

### Code Review Checklist

#### Before Submitting PR
- [ ] All tests pass (`npm run test`)
- [ ] Type checking passes (`npm run type-check`)
- [ ] Linting passes (`npm run lint`)
- [ ] Code is properly formatted (`npm run format`)
- [ ] Documentation is updated
- [ ] Breaking changes are noted

#### Review Criteria
- [ ] Code follows established patterns
- [ ] Error handling is appropriate
- [ ] Performance considerations are addressed
- [ ] Security best practices are followed
- [ ] Tests provide adequate coverage
- [ ] Types are properly defined

### Development Commands (Current NPM Scripts)

```bash
# Development (Multi-Worker Architecture)
npm run dev                    # Start all services (client + all workers)
npm run dev:client             # Start frontend only (port 3000)
npm run dev:api                # Start API Worker only (port 8787)
npm run dev:calculations       # Start Calculation Worker only (port 8788)
npm run dev:data               # Start Data Worker only (port 8789)

# Building
npm run build                  # Build all components
npm run build:client           # Build frontend only
npm run build:workers          # Build all workers
npm run build:api              # Build API Worker only
npm run build:calculations     # Build Calculation Worker only
npm run build:data             # Build Data Worker only

# Testing
npm run test                   # Run tests in watch mode
npm run test:ci                # Run tests with coverage (CI mode)
npm run test:coverage          # Run tests with verbose coverage
npm run test:unit              # Run unit tests only
npm run test:integration       # Run integration tests only
npm run test:smoke             # Run smoke tests

# Code Quality
npm run lint                   # Run ESLint
npm run lint:fix               # Fix ESLint issues automatically
npm run lint:ci                # Run ESLint with JUnit output for CI
npm run format                 # Format code with Prettier
npm run format:check           # Check code formatting
npm run type-check             # Run TypeScript compiler checks

# Database Management
npm run db:migrate             # Run database migrations (development)
npm run db:migrate:production  # Run database migrations (production)
npm run db:seed                # Seed database with sample data
npm run db:reset               # Reset and reseed database

# Deployment
npm run deploy                 # Deploy all workers to production
npm run deploy:dev             # Deploy all workers to development
npm run deploy:api             # Deploy API Worker to production
npm run deploy:calculations    # Deploy Calculation Worker to production
npm run deploy:data            # Deploy Data Worker to production
npm run pages:deploy           # Deploy frontend to Cloudflare Pages

# Monitoring
npm run logs:api               # View API Worker logs
npm run logs:calculations      # View Calculation Worker logs
npm run logs:data              # View Data Worker logs
```

## Future Roadmap

### Phase 1: Core Implementation (Current Focus)
- ✅ Project architecture and configuration setup
- 🔄 Basic frontend components and pages
- 🔄 API endpoints and database integration
- 🔄 Basic mining profitability calculations
- 📋 Equipment database integration

### Phase 2: Advanced Features
- 📋 Real-time data integration (Bitcoin network, weather)
- 📋 Monte Carlo risk analysis
- 📋 Hardware optimization algorithms
- 📋 Advanced environmental modeling
- 📋 Configuration wizard and templates

### Phase 3: User Experience Enhancement
- 📋 Interactive charts and visualizations
- 📋 Export capabilities (PDF, Excel, CSV)
- 📋 Hardware comparison tools
- 📋 Real-time monitoring dashboard
- 📋 Mobile-responsive design optimization

### Phase 4: Enterprise Features
- 📋 Multi-user support and authentication
- 📋 Portfolio management for multiple projects
- 📋 Advanced reporting and analytics
- 📋 API access for third-party integrations
- 📋 White-label solutions

## Deployment Strategy

### Current CI/CD Pipeline (Implemented)

The project has a complete GitHub Actions workflow at `.github/workflows/ci-cd.yml` with the following pipeline:

#### Quality Checks Job
- **TypeScript type checking**: Ensures all types are valid
- **ESLint code quality**: Checks code standards and best practices
- **Prettier formatting**: Validates consistent code formatting
- **Test coverage**: Runs all tests with coverage reporting
- **Claude Code Analysis**: AI-powered code review on pull requests

#### Build Job
- **Client build**: Compiles React frontend for production
- **Worker build**: Validates all 3 Cloudflare Workers (dry-run)
- **Artifact storage**: Saves build outputs for deployment

#### Staging Deployment
- **Triggers**: Automatic on pull requests and non-main branches
- **Multi-worker deployment**: Deploys all 3 workers to development environment
- **Frontend deployment**: Deploys to Cloudflare Pages staging

#### Production Deployment
- **Triggers**: Automatic on main branch push (with approval)
- **Environment**: Production environment with URL: https://solar-mining-calculator.pages.dev
- **Multi-worker deployment**: Deploys all 3 workers to production
- **Frontend deployment**: Deploys to production Cloudflare Pages

### Manual Deployment (Alternative)
```bash
# Build and deploy all workers
npm run build
npm run deploy

# Deploy frontend to Cloudflare Pages
npm run pages:deploy
```

---

This development guide should be referenced for all code contributions and maintained as the project evolves. Regular updates ensure alignment with best practices and emerging patterns in the ecosystem.