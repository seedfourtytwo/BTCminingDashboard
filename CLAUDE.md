# Solar Bitcoin Mining Calculator - Development Guide

Development standards and architectural patterns for the Solar Bitcoin Mining Calculator project.

**Project Goal**: A planning and projection tool for Bitcoin miners optimizing operations with renewable energy sources, providing comprehensive modeling of solar-powered mining operations with detailed equipment management and economic projections.

## Table of Contents

1. [Project Architecture](#project-architecture)
2. [Development Workflow](#development-workflow)
3. [Code Standards](#code-standards)
4. [Database & API Patterns](#database--api-patterns)
5. [Testing & Quality](#testing--quality)
6. [Documentation Reference](#documentation-reference)
7. [AI Development Guidelines](#ai-development-guidelines)

## Project Architecture

### Multi-Worker Architecture
```
src/
├── client/                    # React frontend (Vite)
│   ├── components/            # UI components (ui/, forms/, charts/, layout/)
│   ├── hooks/                 # Custom React hooks
│   ├── pages/                 # Route components
│   └── services/              # API client
├── server/                    # Cloudflare Workers backend
│   ├── api/                   # API Worker (port 8787)
│   ├── calculations/          # Calculation Worker (port 8788)
│   ├── data/                  # Data Worker (port 8789)
│   └── shared/                # Database, errors, middleware
└── shared/                    # Common types & utilities
```

### Worker Responsibilities
- **API Worker**: CRUD operations, routing, authentication
- **Calculation Worker**: Mining projections, solar modeling, financial analysis
- **Data Worker**: External APIs, data caching, scheduled jobs

### Environment Setup
- **Development**: `solar-mining-db-dev`, ports 3000 (client), 8787-8789 (workers)
- **Production**: `solar-mining-db`, Cloudflare Pages deployment

### Implementation Status
- ✅ **Infrastructure**: TypeScript, Vite, Vitest, ESLint, CI/CD
- ✅ **Database**: 6-migration schema with 18+ tables, seeding completed
- ✅ **Documentation**: Complete documentation suite (13 files) with logical ordering
- 🔄 **Backend**: API structure in place, endpoints need implementation
- 🔄 **Frontend**: Basic component structure, needs full implementation
- 📋 **Features**: Real-time data, advanced calculations, optimization

### Current Priorities (Phase 1)
1. **API Implementation**: Basic CRUD operations for equipment and configurations
2. **Frontend Components**: Equipment browser, configuration forms, results display
3. **Basic Calculations**: Mining profitability and solar power output modeling
4. **Data Integration**: Bitcoin network data and equipment catalogs

## Development Workflow

### Commands
```bash
# Development
npm run dev                    # Start all services
npm run dev:client             # Frontend only (port 3000)
npm run dev:api                # API Worker (port 8787)
npm run dev:calculations       # Calculation Worker (port 8788)
npm run dev:data               # Data Worker (port 8789)

# Testing & Quality
npm run test                   # Run tests
npm run test:ci                # Tests with coverage
npm run type-check             # TypeScript checks
npm run lint                   # ESLint
npm run format                 # Prettier

# Database
npm run db:migrate             # Run all migrations (dev)
npm run db:seed                # Seed with data
npm run db:reset               # Reset and reseed

# Deployment
npm run deploy                 # Deploy all workers
npm run pages:deploy           # Deploy frontend
```

### Git Workflow
- **Branches**: `feature/`, `fix/`, `hotfix/`
- **Commits**: Follow conventional commits format
- **Pre-commit**: Husky configured, lint-staged ready (run `npm run prepare`)

## Code Standards

### TypeScript Configuration
- **Strict mode**: Enabled with comprehensive checks
- **Path aliases**: `@/client/*`, `@/server/*`, `@/shared/*`
- **ES2022 target**: Modern JavaScript features

### Essential Patterns

#### Type Safety
```typescript
// Use discriminated unions for API responses
type ApiResult<T> = 
  | { success: true; data: T }
  | { success: false; error: string };

// Type guards for runtime validation
function isValidMinerData(data: unknown): data is MinerModel {
  return typeof data === 'object' && data !== null && 'hashrate' in data;
}

// Safe property access
const name = equipment?.miner?.name ?? 'Unknown';
```

#### React Components
```typescript
// Functional components with TypeScript
interface EquipmentCardProps {
  equipment: MinerModel;
  onSelect: (equipment: MinerModel) => void;
  isSelected: boolean;
}

export function EquipmentCard({ equipment, onSelect, isSelected }: EquipmentCardProps) {
  const handleClick = useCallback(() => onSelect(equipment), [equipment, onSelect]);
  
  return (
    <div className={`card ${isSelected ? 'selected' : ''}`} onClick={handleClick}>
      <h3>{equipment.name}</h3>
      <p>Hashrate: {equipment.hashrate} TH/s</p>
    </div>
  );
}
```

#### Custom Hooks
```typescript
// Data fetching hook pattern
function useEquipmentData() {
  const [data, setData] = useState<MinerModel[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchData = useCallback(async () => {
    setLoading(true);
    try {
      const response = await api.get<MinerModel[]>('/equipment');
      setData(response.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { fetchData(); }, [fetchData]);
  return { data, loading, error, refetch: fetchData };
}
```

## Database & API Patterns

### Cloudflare Workers
```typescript
// Worker entry point pattern
interface Env {
  DB: D1Database;
  API_KEY: string;
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    
    try {
      if (url.pathname.startsWith('/api/equipment')) {
        return handleEquipmentRoutes(request, env);
      }
      return new Response('Not found', { status: 404 });
    } catch (error) {
      return handleError(error);
    }
  }
} satisfies ExportedHandler<Env>;

// Request validation with Zod
const ProjectionSchema = z.object({
  equipmentId: z.string(),
  solarConfig: z.object({
    panelCount: z.number().min(1),
    panelWatts: z.number().min(1)
  })
});

async function handleRequest(request: Request) {
  const body = await request.json();
  const result = ProjectionSchema.safeParse(body);
  
  if (!result.success) {
    return Response.json({ 
      error: 'Validation failed', 
      details: result.error.issues 
    }, { status: 400 });
  }
  
  return Response.json(await createProjection(result.data));
}
```

### Database Repository Pattern
```typescript
// Repository with prepared statements
export class EquipmentRepository {
  constructor(private db: D1Database) {}

  async findById(id: string): Promise<MinerModel | null> {
    const result = await this.db
      .prepare('SELECT * FROM miner_models WHERE id = ?')
      .bind(id)
      .first();
    return result as MinerModel | null;
  }

  async findMostEfficient(limit = 10): Promise<MinerModel[]> {
    const { results } = await this.db
      .prepare('SELECT * FROM miner_models ORDER BY efficiency_j_th ASC LIMIT ?')
      .bind(limit)
      .all();
    return results as MinerModel[];
  }

  async create(data: CreateMinerData): Promise<MinerModel> {
    const result = await this.db
      .prepare(`
        INSERT INTO miner_models (manufacturer, model_name, hashrate_th, power_consumption_w, efficiency_j_th)
        VALUES (?1, ?2, ?3, ?4, ?5)
        RETURNING *
      `)
      .bind(data.manufacturer, data.modelName, data.hashrate, data.powerConsumption, data.efficiency)
      .first();
    return result as MinerModel;
  }
}
```

### Error Handling
```typescript
// Custom error classes
export abstract class AppError extends Error {
  abstract readonly code: string;
  abstract readonly statusCode: number;
}

export class ValidationError extends AppError {
  readonly code = 'VALIDATION_ERROR';
  readonly statusCode = 400;
}

export class DatabaseError extends AppError {
  readonly code = 'DATABASE_ERROR';
  readonly statusCode = 500;
}

// Centralized error handler
function handleError(error: unknown): Response {
  if (error instanceof ValidationError) {
    return Response.json({
      error: 'Validation Error',
      message: error.message
    }, { status: 400 });
  }

  return Response.json({
    error: 'Internal Server Error',
    message: 'An unexpected error occurred'
  }, { status: 500 });
}
```

## Testing & Quality

### Test Structure
```typescript
// Component testing with Vitest + Testing Library
import { render, screen, fireEvent } from '@testing-library/react';
import { vi } from 'vitest';
import { EquipmentCard } from './EquipmentCard';

const mockMiner = {
  id: 'test-1',
  name: 'Test Miner S19',
  hashrate: 110,
  powerConsumption: 3250,
  efficiency: 29.5
};

describe('EquipmentCard', () => {
  const mockOnSelect = vi.fn();

  it('displays miner information correctly', () => {
    render(<EquipmentCard equipment={mockMiner} onSelect={mockOnSelect} isSelected={false} />);
    
    expect(screen.getByText('Test Miner S19')).toBeInTheDocument();
    expect(screen.getByText(/110 TH\/s/)).toBeInTheDocument();
  });

  it('calls onSelect when clicked', () => {
    render(<EquipmentCard equipment={mockMiner} onSelect={mockOnSelect} isSelected={false} />);
    
    fireEvent.click(screen.getByRole('button'));
    expect(mockOnSelect).toHaveBeenCalledWith(mockMiner);
  });
});
```

### Integration Testing
```typescript
// Worker integration tests
import { unstable_dev } from 'wrangler';

describe('Equipment API', () => {
  let worker: UnstableDevWorker;

  beforeAll(async () => {
    worker = await unstable_dev('src/server/api/index.ts');
  });

  afterAll(async () => {
    await worker.stop();
  });

  it('GET /api/equipment returns equipment list', async () => {
    const response = await worker.fetch('/api/equipment');
    const data = await response.json();

    expect(response.status).toBe(200);
    expect(Array.isArray(data)).toBe(true);
  });
});
```

### Code Quality Tools
- **ESLint**: TypeScript + React rules, strict enforcement
- **Prettier**: Consistent formatting across all files
- **Husky**: Pre-commit hooks with lint-staged
- **Vitest**: Testing with coverage reporting and jsdom
- **GitHub Actions**: Multi-stage CI/CD with quality gates

### Database Schema
- **6 migrations**: Core foundation through error handling (18+ tables total)
- **Equipment tables**: Miners, solar panels, battery storage, inverters
- **System tables**: Configurations, projections, locations, users
- **Market data**: Bitcoin prices, network difficulty, external sources
- **Error logging**: Comprehensive error tracking and analytics

## Documentation Reference

### Core Documentation (docs/)
- **01-PROJECT-OVERVIEW.md** - High-level project understanding
- **02-DATABASE-SCHEMA.md** - Database design and relationships
- **03-API-SPECIFICATION.md** - API endpoints and data models
- **04-CALCULATION-ENGINES.md** - Mathematical models and algorithms
- **05-EQUIPMENT-SPECIFICATIONS.md** - Equipment catalogs and standards

### Implementation Guides (docs/)
- **06-UI-DESIGN-PRINCIPLES.md** - UI/UX design guidelines
- **07-USER-INTERFACE.md** - Interface specifications and components
- **08-WORKER-ARCHITECTURE.md** - System architecture documentation
- **09-PROJECT-STRUCTURE.md** - Code organization and file structure
- **10-USER-FLOW.md** - User experience and workflow mapping
- **11-ERROR-HANDLING.md** - Error management strategy
- **12-DEPLOYMENT-GUIDE.md** - Manual deployment instructions
- **13-CI-CD-GUIDE.md** - Automated CI/CD pipeline setup

## AI Development Guidelines

### When Working on This Project:
1. **Reference numbered documentation** (docs/01-13) for detailed specifications
2. **Follow established patterns** shown in code examples above
3. **Use TypeScript strictly** with proper type safety
4. **Implement comprehensive error handling** using error patterns
5. **Write tests** for all new functionality
6. **Follow modular worker architecture** for backend development
7. **Use repository pattern** for database operations
8. **Maintain consistency** with existing code style

### Common Task References:
- **API endpoints**: Reference docs/03-API-SPECIFICATION.md
- **Database changes**: Reference docs/02-DATABASE-SCHEMA.md
- **UI components**: Reference docs/07-USER-INTERFACE.md
- **Calculations**: Reference docs/04-CALCULATION-ENGINES.md
- **Deployment**: Reference docs/12-DEPLOYMENT-GUIDE.md and docs/13-CI-CD-GUIDE.md