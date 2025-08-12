# Development Standards and Best Practices

This document serves as the primary development guide for the Solar Bitcoin Mining Calculator project. It establishes coding standards, architectural patterns, and development workflows to ensure maintainable, scalable, and high-quality code.

## Table of Contents

1. [Project Architecture](#project-architecture)
2. [TypeScript Standards](#typescript-standards)
3. [React Development Patterns](#react-development-patterns)
4. [Cloudflare Workers Best Practices](#cloudflare-workers-best-practices)
5. [Database Design with D1](#database-design-with-d1)
6. [Build System with Vite](#build-system-with-vite)
7. [Code Organization](#code-organization)
8. [Testing Standards](#testing-standards)
9. [Error Handling](#error-handling)
10. [Performance Guidelines](#performance-guidelines)
11. [Development Workflow](#development-workflow)
12. [Deployment and CI/CD](#deployment-and-cicd)

## Project Architecture

### Monorepo Structure
```
src/
├── client/           # React frontend application
│   ├── components/   # Reusable UI components
│   ├── hooks/        # Custom React hooks
│   ├── pages/        # Page-level components
│   ├── services/     # API client logic
│   ├── types/        # TypeScript type definitions
│   └── utils/        # Client-side utilities
├── server/           # Cloudflare Workers backend
│   ├── handlers/     # Route handlers
│   ├── services/     # Business logic services
│   ├── models/       # Data models and schemas
│   ├── migrations/   # Database migrations
│   └── utils/        # Server-side utilities
├── shared/           # Shared types and utilities
│   ├── types/        # Common TypeScript interfaces
│   └── constants/    # Shared constants
└── tests/            # Test files
    ├── unit/         # Unit tests
    ├── integration/  # Integration tests
    └── fixtures/     # Test fixtures
```

### Environment Configuration
- **Development**: Local D1 database, hot module replacement
- **Staging**: Preview D1 database, staging Workers deployment
- **Production**: Production D1 database, production Workers deployment

## TypeScript Standards

### Configuration Requirements

#### Strict Mode (Required)
```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true
  }
}
```

#### Module Resolution
```json
{
  "compilerOptions": {
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "isolatedModules": true
  }
}
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

#### Table Structure
```sql
-- ✅ Good: Normalized schema with proper constraints
CREATE TABLE miners (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  manufacturer TEXT NOT NULL,
  hashrate_th REAL NOT NULL CHECK (hashrate_th > 0),
  power_consumption_w INTEGER NOT NULL CHECK (power_consumption_w > 0),
  efficiency_j_th REAL NOT NULL CHECK (efficiency_j_th > 0),
  release_date DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE projections (
  id TEXT PRIMARY KEY,
  user_id TEXT,
  miner_id TEXT NOT NULL,
  solar_config TEXT NOT NULL, -- JSON
  projection_config TEXT NOT NULL, -- JSON
  results TEXT NOT NULL, -- JSON
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (miner_id) REFERENCES miners(id)
);

CREATE INDEX idx_projections_user_created ON projections(user_id, created_at DESC);
CREATE INDEX idx_miners_efficiency ON miners(efficiency_j_th);
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

## Build System with Vite

### Configuration

#### Base Configuration
```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

export default defineConfig({
  plugins: [react()],
  
  // TypeScript configuration
  esbuild: {
    target: 'es2022'
  },
  
  // Path resolution
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
      '@shared': resolve(__dirname, 'src/shared'),
      '@components': resolve(__dirname, 'src/client/components'),
      '@hooks': resolve(__dirname, 'src/client/hooks'),
      '@services': resolve(__dirname, 'src/client/services')
    }
  },
  
  // Development server
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8787',
        changeOrigin: true
      }
    }
  },

  // Build configuration
  build: {
    target: 'es2022',
    sourcemap: true,
    rollupOptions: {
      output: {
        manualChunks: {
          vendor: ['react', 'react-dom'],
          utils: ['date-fns', 'zod']
        }
      }
    }
  },

  // Optimization
  optimizeDeps: {
    include: ['react', 'react-dom', 'date-fns'],
    esbuildOptions: {
      target: 'es2022'
    }
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

### Development Commands

```bash
# Development
npm run dev          # Start development servers
npm run dev:client   # Start client only
npm run dev:server   # Start server only

# Building
npm run build        # Build both client and server
npm run build:client # Build client only
npm run build:server # Build server only

# Testing
npm run test         # Run all tests
npm run test:unit    # Run unit tests only
npm run test:integration # Run integration tests
npm run test:coverage    # Generate coverage report

# Quality Assurance
npm run lint         # Run ESLint
npm run lint:fix     # Fix ESLint issues
npm run type-check   # Run TypeScript compiler
npm run format       # Format with Prettier

# Database
npm run db:migrate   # Run database migrations
npm run db:seed      # Seed database with sample data
npm run db:reset     # Reset and reseed database
```

## Deployment and CI/CD

> **Educational Note**: This section covers modern deployment practices using GitHub Actions and Cloudflare's automated deployment system. Each step includes explanations to help you understand the concepts and implementation details.

### Overview

This project uses a modern CI/CD pipeline that automatically deploys your application whenever you push code to GitHub. Here's how it works:

1. **Code Push to GitHub** → Triggers GitHub Actions workflow
2. **GitHub Actions** → Runs tests, builds, and validates code
3. **Cloudflare Integration** → Automatically deploys to Cloudflare Workers and Pages
4. **Database Migrations** → Automatically applied to D1 database

### Repository Setup and GitHub Integration

#### Initial Repository Setup
```bash
# Initialize git repository (if not already done)
git init

# Add all files to staging
git add .

# Create initial commit
git commit -m "feat: initial project setup with documentation

- Add comprehensive project documentation
- Setup TypeScript configuration
- Create database schema design
- Implement calculation engines architecture

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Add GitHub remote (replace with your repository URL)
git remote add origin https://github.com/yourusername/solar-mining-calculator.git

# Push to GitHub
git push -u origin main
```

**Educational Explanation**: Git is our version control system that tracks changes to your code. GitHub is a cloud platform that hosts your repository and provides collaboration tools. The `-u origin main` flag sets up tracking between your local main branch and the remote repository.

#### Repository Configuration

Create these essential files for proper GitHub integration:

##### `.github/ISSUE_TEMPLATE/bug_report.md`
```markdown
---
name: Bug report
about: Create a report to help us improve
title: '[BUG] '
labels: bug
assignees: ''
---

**Describe the bug**
A clear and concise description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
A clear and concise description of what you expected to happen.

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Environment:**
 - Browser [e.g. chrome, safari]
 - Version [e.g. 22]

**Additional context**
Add any other context about the problem here.
```

##### `.github/ISSUE_TEMPLATE/feature_request.md`
```markdown
---
name: Feature request
about: Suggest an idea for this project
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

**Is your feature request related to a problem? Please describe.**
A clear and concise description of what the problem is.

**Describe the solution you'd like**
A clear and concise description of what you want to happen.

**Describe alternatives you've considered**
A clear and concise description of any alternative solutions.

**Additional context**
Add any other context or screenshots about the feature request here.
```

**Educational Explanation**: Issue templates standardize how bugs and feature requests are reported, making it easier to understand and address problems. They're stored in the `.github` directory which GitHub automatically recognizes.

### GitHub Actions CI/CD Pipeline

#### Main Workflow Configuration

Create `.github/workflows/ci-cd.yml`:

```yaml
name: CI/CD Pipeline

# Trigger workflow on push to main branch and pull requests
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

# Define environment variables used across jobs
env:
  NODE_VERSION: '18'
  CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
  CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}

# Define jobs that run in parallel or sequence
jobs:
  # Job 1: Code Quality and Testing
  quality-check:
    name: Code Quality & Testing
    runs-on: ubuntu-latest
    
    steps:
      # Check out the repository code
      - name: Checkout code
        uses: actions/checkout@v4
        
      # Setup Node.js environment
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          
      # Install project dependencies
      - name: Install dependencies
        run: npm ci
        
      # Run TypeScript type checking
      - name: Type checking
        run: npm run type-check
        
      # Run ESLint for code quality
      - name: Lint code
        run: npm run lint
        
      # Run Prettier for code formatting
      - name: Check formatting
        run: npm run format:check
        
      # Run unit tests with coverage
      - name: Run tests
        run: npm run test:coverage
        
      # Upload test coverage results
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage/lcov.info
          fail_ci_if_error: true

  # Job 2: Build Application
  build:
    name: Build Application
    runs-on: ubuntu-latest
    needs: quality-check # Only run if quality checks pass
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      # Build the frontend application
      - name: Build frontend
        run: npm run build:client
        
      # Build the backend Workers
      - name: Build backend
        run: npm run build:server
        
      # Store build artifacts for deployment
      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build-files
          path: |
            dist/
            build/
          retention-days: 1

  # Job 3: Deploy to Staging (on pull requests)
  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    needs: [quality-check, build]
    if: github.event_name == 'pull_request'
    environment: staging
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      # Download build artifacts from build job
      - name: Download build artifacts
        uses: actions/download-artifact@v3
        with:
          name: build-files
          
      # Deploy to Cloudflare Workers (staging)
      - name: Deploy Workers to staging
        run: npx wrangler deploy --env staging
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          
      # Deploy to Cloudflare Pages (staging)
      - name: Deploy Pages to staging
        run: npx wrangler pages deploy dist --project-name solar-mining-calc-staging
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}

  # Job 4: Deploy to Production (on main branch)
  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: [quality-check, build]
    if: github.ref == 'refs/heads/main'
    environment: production
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Download build artifacts
        uses: actions/download-artifact@v3
        with:
          name: build-files
          
      # Run database migrations in production
      - name: Run database migrations
        run: npx wrangler d1 migrations apply solar-mining-db --env production
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          
      # Deploy to Cloudflare Workers (production)
      - name: Deploy Workers to production
        run: npx wrangler deploy --env production
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          
      # Deploy to Cloudflare Pages (production)
      - name: Deploy Pages to production
        run: npx wrangler pages deploy dist --project-name solar-mining-calculator
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          
      # Create GitHub release on successful deployment
      - name: Create Release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: v${{ github.run_number }}
          release_name: Release v${{ github.run_number }}
          body: |
            Automated release created by GitHub Actions
            
            Changes in this release:
            ${{ github.event.head_commit.message }}
          draft: false
          prerelease: false
```

**Educational Explanation**: This GitHub Actions workflow automates your entire deployment process. Here's what each part does:

- **Triggers**: The workflow runs on pushes to main and pull requests
- **Jobs**: Different tasks run in parallel or sequence (quality checks, building, deploying)
- **Environments**: Separate staging and production deployments for safety
- **Artifacts**: Build files are stored and shared between jobs
- **Secrets**: Sensitive information like API tokens are stored securely in GitHub

#### Additional Workflow for Dependency Updates

Create `.github/workflows/dependency-updates.yml`:

```yaml
name: Dependency Updates

on:
  schedule:
    # Run every Monday at 9 AM UTC
    - cron: '0 9 * * 1'
  workflow_dispatch: # Allow manual triggering

jobs:
  update-dependencies:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          
      # Check for outdated packages
      - name: Check for updates
        run: |
          npm outdated || true
          echo "UPDATES_AVAILABLE=$(npm outdated --json | jq 'length')" >> $GITHUB_ENV
          
      # Update dependencies if updates are available
      - name: Update dependencies
        if: env.UPDATES_AVAILABLE != '0'
        run: |
          npm update
          npm audit fix
          
      # Create pull request with updates
      - name: Create Pull Request
        if: env.UPDATES_AVAILABLE != '0'
        uses: peter-evans/create-pull-request@v5
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: 'chore: update dependencies'
          title: 'Automated Dependency Updates'
          body: |
            This PR contains automated dependency updates.
            
            Please review the changes and ensure all tests pass before merging.
            
            🤖 Generated automatically by GitHub Actions
          branch: dependency-updates
          delete-branch: true
```

**Educational Explanation**: This workflow automatically checks for dependency updates weekly and creates pull requests when updates are available. This helps keep your project secure and up-to-date.

### Cloudflare Integration Setup

#### Cloudflare Account Configuration

1. **Create Cloudflare Account**
   - Go to [cloudflare.com](https://cloudflare.com) and sign up
   - Navigate to the Cloudflare dashboard

2. **Get API Credentials**
   ```bash
   # Get your Account ID from the Cloudflare dashboard right sidebar
   # Get your API Token by going to "My Profile" > "API Tokens" > "Create Token"
   # Use the "Custom token" template with these permissions:
   # - Account: Cloudflare Workers:Edit
   # - Zone: Zone Settings:Read, Zone:Read
   # - Account: Account Settings:Read
   ```

3. **Add Secrets to GitHub**
   - Go to your GitHub repository
   - Navigate to Settings > Secrets and variables > Actions
   - Add these repository secrets:
     - `CLOUDFLARE_API_TOKEN`: Your Cloudflare API token
     - `CLOUDFLARE_ACCOUNT_ID`: Your Cloudflare account ID

**Educational Explanation**: API tokens are secure ways to authenticate with external services. Storing them as GitHub secrets ensures they're encrypted and only accessible to your workflows.

#### Wrangler Configuration

Create `wrangler.toml` for Cloudflare Workers configuration:

```toml
# Wrangler configuration for Cloudflare Workers
name = "solar-mining-calculator"
main = "src/server/index.ts"
compatibility_date = "2024-01-01"

# Build configuration
[build]
command = "npm run build:server"

# Environment configurations
[env.staging]
name = "solar-mining-calculator-staging"
vars = { ENVIRONMENT = "staging" }

[env.production]
name = "solar-mining-calculator"
vars = { ENVIRONMENT = "production" }

# Database binding for D1
[[env.staging.d1_databases]]
binding = "DB"
database_name = "solar-mining-db-staging"
database_id = "your-staging-database-id"

[[env.production.d1_databases]]
binding = "DB"
database_name = "solar-mining-db"
database_id = "your-production-database-id"

# KV namespace for caching (optional)
[[env.production.kv_namespaces]]
binding = "CACHE"
id = "your-kv-namespace-id"

# Environment variables (add API keys here)
[env.production.vars]
BITCOIN_API_KEY = "your-api-key"
WEATHER_API_KEY = "your-weather-api-key"
```

**Educational Explanation**: Wrangler is Cloudflare's CLI tool that manages your Workers and related services. This configuration file tells Wrangler how to deploy your application and what resources to use.

#### Database Setup Commands

```bash
# Create D1 databases
npx wrangler d1 create solar-mining-db-staging
npx wrangler d1 create solar-mining-db

# Create database tables
npx wrangler d1 execute solar-mining-db-staging --file=src/server/migrations/001_initial_schema.sql
npx wrangler d1 execute solar-mining-db --file=src/server/migrations/001_initial_schema.sql

# List your databases
npx wrangler d1 list
```

**Educational Explanation**: D1 is Cloudflare's SQL database service built on SQLite. These commands create separate databases for staging and production environments, ensuring your test data doesn't affect your live application.

### Environment Management

#### Environment-Specific Configuration

Create `src/shared/config/environments.ts`:

```typescript
interface EnvironmentConfig {
  apiBaseUrl: string;
  databaseUrl: string;
  logLevel: 'debug' | 'info' | 'warn' | 'error';
  features: {
    enableAnalytics: boolean;
    enableDebugMode: boolean;
    enableExperimentalFeatures: boolean;
  };
}

const environments: Record<string, EnvironmentConfig> = {
  development: {
    apiBaseUrl: 'http://localhost:8787',
    databaseUrl: 'local',
    logLevel: 'debug',
    features: {
      enableAnalytics: false,
      enableDebugMode: true,
      enableExperimentalFeatures: true
    }
  },
  
  staging: {
    apiBaseUrl: 'https://solar-mining-calculator-staging.your-subdomain.workers.dev',
    databaseUrl: 'staging',
    logLevel: 'info',
    features: {
      enableAnalytics: true,
      enableDebugMode: true,
      enableExperimentalFeatures: true
    }
  },
  
  production: {
    apiBaseUrl: 'https://solar-mining-calculator.your-subdomain.workers.dev',
    databaseUrl: 'production',
    logLevel: 'warn',
    features: {
      enableAnalytics: true,
      enableDebugMode: false,
      enableExperimentalFeatures: false
    }
  }
};

export function getEnvironmentConfig(): EnvironmentConfig {
  const env = process.env.NODE_ENV || 'development';
  return environments[env] || environments.development;
}
```

**Educational Explanation**: Environment configuration allows your application to behave differently in development, staging, and production. For example, you might enable debug logging in development but disable it in production for security and performance.

### Automated Testing in CI/CD

#### Test Configuration for CI

Update `package.json` to include CI-specific test scripts:

```json
{
  "scripts": {
    "test": "vitest",
    "test:ci": "vitest run --coverage",
    "test:coverage": "vitest run --coverage --reporter=verbose",
    "test:unit": "vitest run src/**/*.test.ts",
    "test:integration": "vitest run tests/integration/**/*.test.ts",
    "format:check": "prettier --check \"src/**/*.{ts,tsx,js,jsx,json,md}\"",
    "format": "prettier --write \"src/**/*.{ts,tsx,js,jsx,json,md}\"",
    "lint:ci": "eslint src --ext .ts,.tsx --format=junit --output-file=eslint-report.xml"
  }
}
```

#### Quality Gates Configuration

Create `.github/branch-protection.json` (for reference):

```json
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "Code Quality & Testing",
      "Build Application"
    ]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": false
  },
  "restrictions": null
}
```

**Educational Explanation**: Quality gates ensure code quality by requiring tests to pass and code reviews before merging. This prevents broken code from reaching production.

### Monitoring and Observability

#### Application Performance Monitoring

Create `src/shared/monitoring/telemetry.ts`:

```typescript
interface TelemetryEvent {
  name: string;
  properties: Record<string, any>;
  timestamp: Date;
  environment: string;
}

export class TelemetryService {
  private events: TelemetryEvent[] = [];
  
  track(name: string, properties: Record<string, any> = {}) {
    const event: TelemetryEvent = {
      name,
      properties,
      timestamp: new Date(),
      environment: process.env.NODE_ENV || 'unknown'
    };
    
    this.events.push(event);
    
    // Send to monitoring service in production
    if (process.env.NODE_ENV === 'production') {
      this.sendToMonitoring(event);
    } else {
      console.log('Telemetry Event:', event);
    }
  }
  
  private async sendToMonitoring(event: TelemetryEvent) {
    // Implementation for sending to monitoring service
    // Could be Cloudflare Analytics, DataDog, etc.
  }
}

export const telemetry = new TelemetryService();
```

#### Error Tracking Integration

```typescript
// src/shared/monitoring/error-tracking.ts
export class ErrorTracker {
  static captureException(error: Error, context?: Record<string, any>) {
    const errorInfo = {
      message: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString(),
      context,
      environment: process.env.NODE_ENV
    };
    
    if (process.env.NODE_ENV === 'production') {
      // Send to error tracking service (Sentry, Bugsnag, etc.)
      console.error('Production Error:', errorInfo);
    } else {
      console.error('Development Error:', error);
    }
  }
}
```

**Educational Explanation**: Monitoring and error tracking help you understand how your application performs in production and quickly identify issues. This is crucial for maintaining a reliable service.

### Deployment Best Practices

#### Pre-deployment Checklist

Before deploying to production, ensure:

- [ ] All tests pass in CI/CD pipeline
- [ ] Code has been reviewed and approved
- [ ] Database migrations are tested and ready
- [ ] Environment variables are properly configured
- [ ] Monitoring and alerting are set up
- [ ] Rollback plan is documented
- [ ] Performance testing has been completed

#### Rolling Deployment Strategy

```yaml
# Example of blue-green deployment using Cloudflare
# This would be added to your GitHub Actions workflow

- name: Deploy with zero downtime
  run: |
    # Deploy to staging slot first
    npx wrangler deploy --env staging
    
    # Run smoke tests against staging
    npm run test:smoke:staging
    
    # If tests pass, deploy to production
    if [ $? -eq 0 ]; then
      npx wrangler deploy --env production
    else
      echo "Smoke tests failed, aborting deployment"
      exit 1
    fi
```

**Educational Explanation**: Rolling deployments minimize downtime by deploying to a staging environment first, testing it, and then promoting to production only if tests pass.

### Troubleshooting Common Issues

#### Common CI/CD Problems and Solutions

1. **Build Failures**
   ```bash
   # Check Node.js version compatibility
   node --version
   npm --version
   
   # Clear npm cache if dependencies fail
   npm cache clean --force
   rm -rf node_modules package-lock.json
   npm install
   ```

2. **Deployment Failures**
   ```bash
   # Check Wrangler authentication
   npx wrangler auth list
   
   # Verify environment configuration
   npx wrangler tail --env production
   
   # Check D1 database connectivity
   npx wrangler d1 info solar-mining-db
   ```

3. **Environment Variable Issues**
   ```bash
   # List current environment variables
   npx wrangler secret list
   
   # Set missing secrets
   npx wrangler secret put API_KEY
   ```

#### Debugging Deployment Issues

```typescript
// Add debug logging to your Workers
export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    console.log('Request received:', {
      url: request.url,
      method: request.method,
      headers: Object.fromEntries(request.headers),
      timestamp: new Date().toISOString()
    });
    
    try {
      // Your application logic
      return new Response('OK');
    } catch (error) {
      console.error('Worker error:', error);
      return new Response('Internal Server Error', { status: 500 });
    }
  }
};
```

**Educational Explanation**: Good logging and debugging practices help you quickly identify and resolve issues in production. Cloudflare provides real-time logs through `wrangler tail`.

This deployment and CI/CD setup provides a robust, automated pipeline that ensures code quality, handles deployments safely, and monitors your application in production. As you implement this system, you'll learn modern DevOps practices that are valuable for any web development project.

This development guide should be referenced for all code contributions and maintained as the project evolves. Regular updates ensure alignment with best practices and emerging patterns in the ecosystem.