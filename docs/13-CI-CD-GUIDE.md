# CI/CD Guide: From Zero to Deployment

## Table of Contents
- [CI/CD Fundamentals](#cicd-fundamentals)
  - [What is CI/CD?](#what-is-cicd)
  - [Why CI/CD Matters](#why-cicd-matters)
  - [The Basic Flow](#the-basic-flow)
- [GitHub Actions Setup](#github-actions-setup)
  - [Core Concepts](#core-concepts)
  - [Basic Workflow Structure](#basic-workflow-structure)
  - [Key GitHub Actions Concepts](#key-github-actions-concepts)
- [Cloudflare Integration](#cloudflare-integration)
- [Environment Management](#environment-management)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Complete Example](#complete-example)

---

## CI/CD Fundamentals

### What is CI/CD?

**CI (Continuous Integration)** = Automatically test and build code when you push changes
**CD (Continuous Deployment)** = Automatically deploy code when tests pass

### Why CI/CD Matters

- **Catch bugs early** - Tests run automatically
- **Deploy faster** - No manual deployment steps
- **Reduce human error** - Automated processes
- **Confidence** - Know your code works before deploying

### The Basic Flow

```
Code Push → Tests → Build → Deploy → Verify
```

---

## GitHub Actions Setup

### Core Concepts

**Workflow**: A YAML file that defines your CI/CD process
**Job**: A group of steps that run on the same runner
**Step**: A single action (run command, use action, etc.)
**Runner**: The machine that executes your workflow

### Basic Workflow Structure

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

env:
  NODE_VERSION: '20'

jobs:
  quality-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run test

  build:
    runs-on: ubuntu-latest
    needs: quality-check
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      - run: npm ci
      - run: npm run build

  deploy:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    environment: production
    steps:
      - uses: actions/checkout@v4
      - run: npm run deploy
```

### Key GitHub Actions Concepts

**Triggers (`on`)**:
- `push`: Runs when code is pushed to specified branches
- `pull_request`: Runs when PR is created/updated
- `workflow_dispatch`: Manual trigger

**Conditions (`if`)**:
- `github.ref == 'refs/heads/main'`: Only run on main branch
- `needs.job-name.result == 'success'`: Only run if previous job succeeded

**Environments**:
- Separate deployment targets (staging, production)
- Can have protection rules and secrets
- Require approval for production deployments

---

## Cloudflare Integration

### Cloudflare Services Overview

**Cloudflare Workers**: Serverless functions (your backend API)
**Cloudflare Pages**: Static site hosting (your frontend)
**Cloudflare D1**: Serverless SQL database
**Cloudflare KV**: Key-value storage
**Cloudflare Queues**: Message queues for background processing

### Why Cloudflare for Small Projects

- **Free tier is generous** - Perfect for learning and small projects
- **Integrated ecosystem** - All services work together
- **Global CDN** - Fast worldwide
- **Simple deployment** - Push to Git, auto-deploy

### Cloudflare vs Other Platforms

| Feature | Cloudflare | Vercel | Netlify | AWS |
|---------|------------|--------|---------|-----|
| Free Tier | ✅ Generous | ✅ Good | ✅ Good | ❌ Limited |
| Learning Curve | 🟡 Medium | 🟢 Easy | 🟢 Easy | 🔴 Hard |
| Integration | 🟢 Excellent | 🟡 Good | 🟡 Good | 🟢 Excellent |
| Cost Scaling | 🟢 Predictable | 🟡 Can spike | 🟡 Can spike | 🔴 Complex |

---

## Environment Management

### GitHub Environments

**Purpose**: Separate deployment targets with different configurations

**Setup**:
1. Go to repository Settings → Environments
2. Create environments (e.g., `staging`, `production`)
3. Add environment-specific secrets and variables

**Example Structure**:
```
staging:
  - CLOUDFLARE_API_TOKEN
  - CLOUDFLARE_ACCOUNT_ID
  - API_BASE_URL: https://api-staging.example.com

production:
  - CLOUDFLARE_API_TOKEN
  - CLOUDFLARE_ACCOUNT_ID
  - API_BASE_URL: https://api.example.com
```

### Secrets vs Environment Variables

**Secrets** (encrypted):
- API keys
- Database passwords
- Private tokens

**Environment Variables** (plain text):
- Configuration URLs
- Feature flags
- Non-sensitive settings

### Branch Strategy

**Simple Strategy** (recommended for small projects):
```
main (production)
├── develop (staging)
    ├── feature/new-feature
    ├── bug/fix-issue
    └── docs/update-readme
```

**Workflow Triggers**:
- `push` to `main` → Deploy to production
- `push` to `develop` → Deploy to staging
- `pull_request` to `main` → Run tests only

---

## Best Practices

### 1. Start Simple, Add Complexity Later

**Don't do this** (trying to deploy everything at once):
```yaml
# ❌ Too complex for initial setup
jobs:
  - quality-check
  - security-scan
  - build
  - test-integration
  - test-e2e
  - deploy-staging
  - deploy-production
  - smoke-tests
  - performance-tests
```

**Do this** (minimal viable pipeline):
```yaml
# ✅ Start with basics
jobs:
  - quality-check
  - build
  - deploy
```

### 2. Use Dry-Runs for Validation

**Before deploying, validate your configuration**:
```bash
# Test Wrangler config without deploying
wrangler deploy --dry-run

# Test build process locally
npm run build
```

### 3. Disable Advanced Features Initially

**Cloudflare features to disable for initial deployment**:
- Analytics Engine (requires paid plan)
- CPU limits (not supported on free plan)
- Durable Objects (require migrations)
- Queues (need to be created separately)
- KV namespaces (need real IDs)

**Enable later when needed**:
```toml
# Start with this (simple)
# [limits]
# cpu_ms = 10000

# Add this later (advanced)
[limits]
cpu_ms = 10000
```

### 4. Use Meaningful Commit Messages

**Good commit messages**:
```
feat: add user authentication system
fix: resolve API timeout issues
docs: update deployment guide
refactor: simplify database queries
```

**Bad commit messages**:
```
fixed stuff
updated things
wip
```

### 5. Test Locally Before Pushing

**Local testing checklist**:
- [ ] `npm run lint` passes
- [ ] `npm run test` passes
- [ ] `npm run build` works
- [ ] `wrangler deploy --dry-run` succeeds

---

## Troubleshooting

### Common Issues and Solutions

**1. "You must use a real database in the database_id configuration"**
```toml
# ❌ Placeholder ID
database_id = "REPLACE_WITH_YOUR_DATABASE_ID"

# ✅ Real ID from Cloudflare
database_id = "your-actual-database-id"
```

**2. "CPU limits are not supported for the Free plan"**
```toml
# ❌ Remove this for free plan
[limits]
cpu_ms = 10000

# ✅ Comment out for free plan
# [limits]
# cpu_ms = 10000
```

**3. "Queue does not exist"**
```toml
# ❌ Remove until queue is created
[[env.production.queues.producers]]
binding = "MY_QUEUE"
queue = "my-queue"

# ✅ Comment out for now
# [[env.production.queues.producers]]
# binding = "MY_QUEUE"
# queue = "my-queue"
```

**4. "KV namespace is not valid"**
```toml
# ❌ Placeholder IDs
id = "my-kv-namespace-id"

# ✅ Comment out until real namespace is created
# id = "your-actual-kv-namespace-id"
```

### Debugging Workflows

**Enable debug logging**:
```yaml
env:
  ACTIONS_STEP_DEBUG: true
  ACTIONS_RUNNER_DEBUG: true
```

**Check workflow logs**:
1. Go to Actions tab in GitHub
2. Click on failed workflow
3. Click on failed job
4. Expand failed step
5. Look for error messages

---

## Complete Example

### Project Structure
```
my-project/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
├── src/
│   ├── client/          # Frontend code
│   └── server/          # Backend code
├── wrangler.api.toml    # API Worker config
├── wrangler.data.toml   # Data Worker config
├── package.json
└── README.md
```

### Complete CI/CD Workflow

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

env:
  NODE_VERSION: '20'

jobs:
  # Job 1: Quality Checks
  quality-check:
    name: Quality Checks
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: '**/package-lock.json'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run linting
        run: npm run lint:ci
        
      - name: Run tests
        run: npm run test:ci
        
      - name: Type check
        run: npm run type-check
        
      # Optional: Claude code analysis (only on PRs)
      - name: Claude Code Analysis
        if: github.event_name == 'pull_request'
        uses: anthropics/claude-code-action@beta
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
        continue-on-error: true

  # Job 2: Build
  build:
    name: Build Application
    runs-on: ubuntu-latest
    needs: quality-check
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: '**/package-lock.json'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Build client
        run: npm run build:client
        
      - name: Build workers (dry-run)
        run: npm run build:workers
        
      - name: Upload build artifacts
        uses: actions/upload-artifact@v4
        with:
          name: build-artifacts
          path: dist/
          retention-days: 7

  # Job 3: Deploy to Staging
  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    needs: build
    if: github.event_name == 'pull_request' || github.ref != 'refs/heads/main'
    
    environment:
      name: staging
      url: https://your-api-staging.workers.dev
      
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: '**/package-lock.json'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Deploy API Worker to staging
        run: npm run deploy:api:dev
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          
      - name: Deploy Pages to staging
        run: npm run pages:deploy
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}

  # Job 4: Deploy to Production
  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
    environment:
      name: production
      url: https://your-api.workers.dev
      
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: '**/package-lock.json'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Deploy API Worker to production
        run: npm run deploy:api
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          VITE_API_BASE_URL: https://your-api.workers.dev
          
      - name: Deploy Pages to production
        run: npm run pages:deploy:production
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}

  # Job 5: Smoke Tests
  smoke-tests:
    name: Smoke Tests
    runs-on: ubuntu-latest
    needs: [deploy-staging, deploy-production]
    if: always() && (needs.deploy-staging.result == 'success' || needs.deploy-production.result == 'success')
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: '**/package-lock.json'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Run smoke tests
        run: npm run test:smoke
        env:
          VITE_API_BASE_URL: ${{ needs.deploy-production.result == 'success' && 'https://your-api.workers.dev' || 'https://your-api-staging.workers.dev' }}
```

### Package.json Scripts

**Source**: See [`package.json`](../package.json) for complete script definitions

**Key Scripts**:
- `dev` - Start development servers
- `build` - Build for production
- `test` - Run test suite
- `deploy` - Deploy to production
- `lint` - Code quality checks

### Wrangler Configuration

**Source**: See configuration files in project root:
- [`wrangler.api.toml`](../wrangler.api.toml)
- [`wrangler.calculations.toml`](../wrangler.calculations.toml)
- [`wrangler.data.toml`](../wrangler.data.toml)

**Key Configuration Elements**:
- **Worker Names**: API, calculations, and data workers
- **Database Bindings**: D1 database connections
- **Environment Variables**: CORS origins, API versions
- **Service Bindings**: Inter-worker communication

---

## Quick Setup Checklist

### GitHub Setup
- [ ] Create repository
- [ ] Set up environments (staging, production)
- [ ] Add secrets (CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID)
- [ ] Add environment variables (API_BASE_URL, etc.)

### Cloudflare Setup
- [ ] Create Workers (API, Data)
- [ ] Create D1 databases
- [ ] Create Pages project
- [ ] Get API token and account ID

### Local Setup
- [ ] Install Wrangler CLI
- [ ] Configure Wrangler configs
- [ ] Test builds locally
- [ ] Create basic smoke tests

### Deployment
- [ ] Push to develop branch (staging deployment)
- [ ] Test staging environment
- [ ] Merge to main (production deployment)
- [ ] Verify production environment

---

## Next Steps

### When You're Ready to Scale

1. **Enable Analytics Engine** (requires paid plan)
2. **Add CPU limits** (requires paid plan)
3. **Create KV namespaces** for caching
4. **Set up Queues** for background processing
5. **Add Durable Objects** for stateful operations
6. **Implement security scanning**
7. **Add performance monitoring**

### Learning Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Cloudflare Workers Documentation](https://developers.cloudflare.com/workers/)
- [Wrangler CLI Documentation](https://developers.cloudflare.com/workers/wrangler/)
- [CI/CD Best Practices](https://martinfowler.com/articles/continuousIntegration.html)

---

*This guide is designed for small to medium projects. For enterprise applications, consider additional security, monitoring, and compliance requirements.*
