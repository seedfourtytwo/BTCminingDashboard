# Project Structure - Solar Mining Calculator

## Table of Contents
- [Overview](#overview)
- [Directory Structure](#directory-structure)
- [Configuration Files](#configuration-files)
  - [TypeScript Configuration](#typescript-configuration)
  - [Build Tools](#build-tools)
  - [Cloudflare Workers](#cloudflare-workers)
- [Source Code Organization](#source-code-organization)
  - [Client Application](#client-application)
  - [Server Application](#server-application)
  - [Shared Code](#shared-code)
- [Documentation Structure](#documentation-structure)
- [Testing Structure](#testing-structure)
- [Deployment Configuration](#deployment-configuration)
- [Development Workflow](#development-workflow)

## Overview

This document provides an overview of the project structure and organization.

## Directory Structure

```
solar-mining-calculator/
├── README.md                           # Project overview and quick start
├── LICENSE                             # MIT License
├── CLAUDE.md                           # Development standards
├── docs/                               # Documentation directory
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
├── src/                                # Source code directory
├── ├── client/                         # React frontend application
├── │   ├── components/                 # React components
├── │   │   ├── ui/                     # Basic UI components
├── │   │   ├── forms/                  # Form components
├── │   │   ├── charts/                 # Data visualization components
├── │   │   └── layout/                 # Layout components
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
└── └── fixtures/                      # Test fixtures and mock data
```

## Configuration Files

### TypeScript Configuration
**Source**: TypeScript configuration files in project root

- **`tsconfig.json`**: Base configuration for all TypeScript files
- **`tsconfig.client.json`**: Client-specific configuration for React components
- **`tsconfig.server.json`**: Server-specific configuration for Cloudflare Workers

### Build Tools
**Source**: Build configuration files in project root

- **`vite.config.ts`**: Vite build tool configuration for client application
- **`vitest.config.ts`**: Vitest test runner configuration
- **`tailwind.config.js`**: Tailwind CSS framework configuration
- **`postcss.config.js`**: PostCSS processing configuration

### Cloudflare Workers
**Source**: Worker configuration files in project root

- **`wrangler.api.toml`**: API Worker configuration and bindings
- **`wrangler.calculations.toml`**: Calculation Worker configuration
- **`wrangler.data.toml`**: Data Worker configuration

## Source Code Organization

### Client Application
**Source**: [`src/client/`](../src/client/)

**Components**:
- **`components/ui/`**: Reusable UI components (buttons, inputs, etc.)
- **`components/forms/`**: Form components and validation
- **`components/charts/`**: Data visualization components
- **`components/layout/`**: Layout components (header, sidebar, etc.)

**Application Logic**:
- **`hooks/`**: Custom React hooks for state management
- **`pages/`**: Page-level components and routing
- **`services/`**: API client services and data fetching
- **`types/`**: Client-specific TypeScript type definitions
- **`utils/`**: Client-side utility functions

### Server Application
**Source**: [`src/server/`](../src/server/)

**API Worker**:
- **`api/handlers/`**: HTTP route handlers and request processing
- **`api/services/`**: Business logic and service layer
- **`api/models/`**: Data models and validation schemas
- **`api/utils/`**: API-specific utility functions

**Specialized Workers**:
- **`calculations/`**: Mathematical calculation engines
- **`data/`**: External data collection and processing

### Shared Code
**Source**: [`src/shared/`](../src/shared/)

**Common Resources**:
- **`types/`**: Shared TypeScript interfaces and types
- **`constants/`**: Application constants and configuration
- **`config/`**: Configuration management utilities
- **`monitoring/`**: Logging and monitoring utilities

## Documentation Structure
**Source**: [`docs/`](.)

**Core Documentation**:
- **`01-PROJECT-OVERVIEW.md`**: High-level project description
- **`02-DATABASE-SCHEMA.md`**: Database design and relationships
- **`03-API-SPECIFICATION.md`**: REST API endpoints and data models
- **`04-CALCULATION-ENGINES.md`**: Mathematical models and algorithms
- **`05-EQUIPMENT-SPECIFICATIONS.md`**: Equipment catalogs and standards

**Implementation Guides**:
- **`06-UI-DESIGN-PRINCIPLES.md`**: UI/UX design guidelines
- **`07-USER-INTERFACE.md`**: UI/UX design and workflows
- **`08-WORKER-ARCHITECTURE.md`**: Worker architecture documentation
- **`09-PROJECT-STRUCTURE.md`**: This file - project organization
- **`10-USER-FLOW.md`**: User journey and workflow mapping
- **`11-ERROR-HANDLING.md`**: Error handling strategy
- **`12-DEPLOYMENT-GUIDE.md`**: Setup and deployment instructions
- **`13-CI-CD-GUIDE.md`**: CI/CD pipeline and automation

## Testing Structure
**Source**: [`tests/`](../tests/)

**Test Organization**:
- **`setup.ts`**: Test environment configuration
- **`unit/`**: Unit tests for individual components and functions
- **`integration/`**: Integration tests for component interactions
- **`fixtures/`**: Test data and mock objects

**Testing Strategy**:
- **Unit Tests**: Test individual functions and components in isolation
- **Integration Tests**: Test component interactions and data flow
- **End-to-End Tests**: Test complete user workflows
- **Performance Tests**: Test application performance under load

## Deployment Configuration

### Environment Management
- **Development**: Local development environment with hot reloading
- **Staging**: Pre-production environment for testing
- **Production**: Live production environment

### Deployment Process
1. **Code Review**: Pull request review and approval
2. **Automated Testing**: Unit and integration test execution
3. **Build Process**: Compilation and bundling of application
4. **Deployment**: Automated deployment to target environment
5. **Verification**: Post-deployment testing and monitoring

### Infrastructure
- **Frontend**: Cloudflare Pages for static hosting
- **Backend**: Cloudflare Workers for serverless functions
- **Database**: Cloudflare D1 for data storage
- **CDN**: Cloudflare's global CDN for content delivery

## Development Workflow

### Local Development
**Source**: See [`package.json`](../package.json) for available scripts

**Development Commands**:
- **`npm run dev`**: Start development environment
- **`npm run build`**: Build for production
- **`npm run test`**: Run test suite
- **`npm run lint`**: Code quality checks

### Code Quality
- **ESLint**: JavaScript/TypeScript linting
- **Prettier**: Code formatting
- **TypeScript**: Static type checking
- **Git Hooks**: Pre-commit validation

### Version Control
- **Git Flow**: Feature branch workflow
- **Commit Messages**: Conventional commit format
- **Pull Requests**: Code review process
- **Release Tags**: Semantic versioning

---

**Document Status**: Current Plan v1.0  
**Last Updated**: 2025-08-17  
**Next Review**: After Phase 1 implementation