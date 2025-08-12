# User Interface & Workflow Specifications

## Overview

The Solar Bitcoin Mining Calculator features a desktop-first React application designed for comprehensive mining operation planning and analysis. The interface prioritizes data visualization, ease of configuration, and powerful scenario comparison capabilities.

## Design Principles

### 1. Desktop-First Approach
- **Primary Target**: Desktop and laptop computers (1366x768 minimum)
- **Secondary Support**: Tablet landscape orientation (1024x768+)
- **No Mobile Support**: Complex calculations and data visualization require larger screens

### 2. Information Density
- **High Information Density**: Multiple metrics and charts visible simultaneously
- **Contextual Detail**: Drill-down capabilities for detailed analysis
- **Professional Appearance**: Clean, technical interface suitable for business use

### 3. Workflow-Centric Design
- **Task-Oriented Navigation**: Clear paths for equipment selection, configuration, and analysis
- **Progressive Disclosure**: Advanced features accessible but not overwhelming for basic users
- **Comparison Focus**: Side-by-side scenario analysis as core functionality

## Application Architecture

### Overall Layout Structure
```
┌─────────────────────────────────────────────────────────┐
│                    Header Navigation                     │
├─────────────────────────────────────────────────────────┤
│ Sidebar Nav │              Main Content Area             │
│             │                                           │
│   - Dashboard│  ┌─────────────────────────────────────┐  │
│   - Equipment│  │                                     │  │
│   - Scenarios│  │         Page-Specific Content       │  │
│   - Analytics│  │                                     │  │
│   - Settings │  │                                     │  │
│             │  └─────────────────────────────────────┘  │
│             │                                           │
│             │  ┌─────────────────────────────────────┐  │
│             │  │          Action Panel              │  │
│             │  │    (Context-sensitive controls)    │  │
│             │  └─────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### Color Scheme and Branding
```css
:root {
  /* Primary Colors */
  --primary-blue: #2563eb;
  --primary-dark: #1e40af;
  --primary-light: #3b82f6;
  
  /* Solar/Energy Colors */
  --solar-yellow: #fbbf24;
  --wind-cyan: #06b6d4;
  --battery-green: #10b981;
  
  /* Bitcoin Colors */
  --bitcoin-orange: #f97316;
  --profit-green: #16a34a;
  --loss-red: #dc2626;
  
  /* Neutral Colors */
  --gray-50: #f9fafb;
  --gray-100: #f3f4f6;
  --gray-200: #e5e7eb;
  --gray-800: #1f2937;
  --gray-900: #111827;
}
```

## Page-by-Page Specifications

### 1. DASHBOARD PAGE

#### 1.1 Overview Cards Section
```html
<!-- Top row of key metrics -->
<div class="metrics-overview">
  <div class="metric-card bitcoin-price">
    <h3>Bitcoin Price</h3>
    <div class="value">$45,250</div>
    <div class="change positive">+2.15% (24h)</div>
    <div class="trend-sparkline"></div>
  </div>
  
  <div class="metric-card network-difficulty">
    <h3>Network Difficulty</h3>
    <div class="value">90.67T</div>
    <div class="next-adjustment">Next: +3.2% in 8 days</div>
  </div>
  
  <div class="metric-card solar-production">
    <h3>Solar Production Today</h3>
    <div class="value">145.5 kWh</div>
    <div class="capacity-factor">21% capacity factor</div>
  </div>
  
  <div class="metric-card mining-profit">
    <h3>Daily Profit (Est.)</h3>
    <div class="value profit">$489.48</div>
    <div class="breakdown">Revenue $565 - Costs $76</div>
  </div>
</div>
```

#### 1.2 Main Charts Section
```html
<!-- Central visualization area -->
<div class="charts-section">
  <div class="chart-container primary">
    <h3>Power Generation vs Consumption (24h)</h3>
    <canvas id="power-flow-chart"></canvas>
    <div class="chart-controls">
      <select id="timeframe">
        <option value="24h">Last 24 Hours</option>
        <option value="7d">Last 7 Days</option>
        <option value="30d">Last 30 Days</option>
      </select>
    </div>
  </div>
  
  <div class="chart-container secondary">
    <h3>Profitability Trend</h3>
    <canvas id="profitability-chart"></canvas>
  </div>
</div>
```

#### 1.3 System Status Panel
```html
<!-- Right sidebar with system status -->
<div class="system-status">
  <h3>Active Configuration</h3>
  <div class="config-summary">
    <div class="solar-system">
      <span class="icon">☀️</span>
      <span>50kW Solar Array</span>
      <span class="status generating">Generating</span>
    </div>
    <div class="mining-rigs">
      <span class="icon">⚡</span>
      <span>10x Antminer S19 Pro</span>
      <span class="status online">Online</span>
    </div>
  </div>
  
  <h3>Quick Actions</h3>
  <div class="quick-actions">
    <button class="btn-primary">New Scenario</button>
    <button class="btn-secondary">Export Report</button>
    <button class="btn-secondary">Update Prices</button>
  </div>
</div>
```

### 2. EQUIPMENT MANAGEMENT PAGE

#### 2.1 Equipment Categories Navigation
```html
<div class="equipment-nav">
  <div class="category-tabs">
    <button class="tab active" data-category="miners">
      <span class="icon">🔧</span>
      Bitcoin Miners
    </button>
    <button class="tab" data-category="solar">
      <span class="icon">☀️</span>
      Solar Panels
    </button>
    <button class="tab" data-category="wind">
      <span class="icon">💨</span>
      Wind Turbines
    </button>
    <button class="tab" data-category="storage">
      <span class="icon">🔋</span>
      Batteries
    </button>
    <button class="tab" data-category="custom">
      <span class="icon">⚙️</span>
      Custom Sources
    </button>
  </div>
</div>
```

#### 2.2 Equipment Catalog Interface
```html
<div class="equipment-catalog">
  <!-- Search and Filter Controls -->
  <div class="catalog-controls">
    <div class="search-bar">
      <input type="text" placeholder="Search equipment models..." />
      <button class="search-btn">🔍</button>
    </div>
    
    <div class="filters">
      <select id="manufacturer-filter">
        <option value="">All Manufacturers</option>
        <option value="bitmain">Bitmain</option>
        <option value="microbt">MicroBT</option>
        <option value="canaan">Canaan</option>
      </select>
      
      <select id="efficiency-filter">
        <option value="">All Efficiency Ranges</option>
        <option value="20-30">20-30 J/TH</option>
        <option value="30-40">30-40 J/TH</option>
        <option value="40+">40+ J/TH</option>
      </select>
      
      <select id="sort-by">
        <option value="efficiency">Sort by Efficiency</option>
        <option value="hashrate">Sort by Hashrate</option>
        <option value="price">Sort by Price</option>
      </select>
    </div>
  </div>
  
  <!-- Equipment Grid -->
  <div class="equipment-grid">
    <div class="equipment-card" data-id="8">
      <div class="card-header">
        <h4>Antminer S19 Pro</h4>
        <span class="manufacturer">Bitmain</span>
      </div>
      
      <div class="card-specs">
        <div class="spec-row">
          <span class="label">Hashrate:</span>
          <span class="value">110 TH/s</span>
        </div>
        <div class="spec-row">
          <span class="label">Power:</span>
          <span class="value">3,250W</span>
        </div>
        <div class="spec-row">
          <span class="label">Efficiency:</span>
          <span class="value efficiency-good">29.5 J/TH</span>
        </div>
        <div class="spec-row">
          <span class="label">Price:</span>
          <span class="value">$3,500</span>
        </div>
      </div>
      
      <div class="card-actions">
        <button class="btn-primary add-to-config">Add to Config</button>
        <button class="btn-secondary view-details">Details</button>
      </div>
    </div>
    
    <!-- More equipment cards... -->
  </div>
</div>
```

#### 2.3 Equipment Comparison Modal
```html
<div class="equipment-comparison-modal">
  <div class="modal-header">
    <h2>Equipment Comparison</h2>
    <button class="close-btn">×</button>
  </div>
  
  <div class="comparison-table">
    <table>
      <thead>
        <tr>
          <th>Specification</th>
          <th>Antminer S19 Pro</th>
          <th>WhatsMiner M30S++</th>
          <th>AvalonMiner 1246</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Hashrate (TH/s)</td>
          <td class="best-value">110</td>
          <td>112</td>
          <td>90</td>
        </tr>
        <tr>
          <td>Power (W)</td>
          <td>3,250</td>
          <td>3,472</td>
          <td>3,420</td>
        </tr>
        <tr>
          <td>Efficiency (J/TH)</td>
          <td class="best-value">29.5</td>
          <td>31.0</td>
          <td>38.0</td>
        </tr>
        <!-- More rows... -->
      </tbody>
    </table>
  </div>
</div>
```

### 3. SCENARIO PLANNING PAGE

#### 3.1 Scenario Management Interface
```html
<div class="scenario-management">
  <div class="scenario-list">
    <h3>My Scenarios</h3>
    <div class="scenario-cards">
      <div class="scenario-card active">
        <h4>Conservative 5-Year</h4>
        <div class="scenario-summary">
          <span>10x S19 Pro + 50kW Solar</span>
          <span class="roi">ROI: 348%</span>
        </div>
        <div class="card-actions">
          <button class="btn-edit">Edit</button>
          <button class="btn-duplicate">Duplicate</button>
          <button class="btn-delete">Delete</button>
        </div>
      </div>
      
      <div class="scenario-card">
        <h4>Optimistic Bull Market</h4>
        <div class="scenario-summary">
          <span>15x S19 XP + 75kW Solar</span>
          <span class="roi">ROI: 892%</span>
        </div>
      </div>
      
      <div class="new-scenario-card">
        <button class="btn-primary">+ New Scenario</button>
      </div>
    </div>
  </div>
</div>
```

#### 3.2 Scenario Configuration Panel
```html
<div class="scenario-config">
  <h3>Scenario Configuration</h3>
  
  <!-- System Configuration Section -->
  <div class="config-section">
    <h4>System Configuration</h4>
    <div class="config-grid">
      <div class="config-item">
        <label>Location</label>
        <select id="location-select">
          <option value="12">Phoenix, AZ</option>
          <option value="15">Las Vegas, NV</option>
          <option value="8">Austin, TX</option>
        </select>
      </div>
      
      <div class="config-item">
        <label>Solar Array Size</label>
        <div class="input-group">
          <input type="number" value="50" min="0" max="1000" />
          <span class="unit">kW</span>
        </div>
      </div>
      
      <div class="config-item">
        <label>Mining Equipment</label>
        <div class="equipment-selector">
          <select id="miner-model">
            <option value="8">Antminer S19 Pro</option>
            <option value="9">WhatsMiner M30S++</option>
          </select>
          <input type="number" value="10" min="1" max="100" placeholder="Quantity" />
        </div>
      </div>
    </div>
  </div>
  
  <!-- Economic Assumptions Section -->
  <div class="config-section">
    <h4>Economic Assumptions</h4>
    <div class="config-grid">
      <div class="config-item">
        <label>Electricity Rate</label>
        <div class="input-group">
          <input type="number" value="0.12" step="0.01" />
          <span class="unit">$/kWh</span>
        </div>
      </div>
      
      <div class="config-item">
        <label>Bitcoin Price Model</label>
        <select id="price-model">
          <option value="exponential">Exponential Growth</option>
          <option value="stochastic">Stochastic Model</option>
          <option value="conservative">Conservative Linear</option>
        </select>
      </div>
    </div>
  </div>
  
  <!-- Projection Parameters Section -->
  <div class="config-section">
    <h4>Projection Parameters</h4>
    <div class="config-grid">
      <div class="config-item">
        <label>Time Horizon</label>
        <select id="time-horizon">
          <option value="1">1 Year</option>
          <option value="3">3 Years</option>
          <option value="5" selected>5 Years</option>
          <option value="10">10 Years</option>
        </select>
      </div>
      
      <div class="config-item">
        <label>Monte Carlo Runs</label>
        <select id="simulation-runs">
          <option value="100">100 (Fast)</option>
          <option value="1000" selected>1,000 (Standard)</option>
          <option value="10000">10,000 (Detailed)</option>
        </select>
      </div>
    </div>
  </div>
</div>
```

#### 3.3 Real-time Results Preview
```html
<div class="results-preview">
  <h3>Projection Summary</h3>
  
  <div class="summary-metrics">
    <div class="metric">
      <span class="label">Total Investment</span>
      <span class="value">$85,000</span>
    </div>
    <div class="metric">
      <span class="label">5-Year Revenue</span>
      <span class="value">$2,847,500</span>
    </div>
    <div class="metric">
      <span class="label">Net Profit</span>
      <span class="value profit">$2,421,900</span>
    </div>
    <div class="metric">
      <span class="label">ROI</span>
      <span class="value roi-good">348%</span>
    </div>
    <div class="metric">
      <span class="label">Payback Period</span>
      <span class="value">18.5 months</span>
    </div>
  </div>
  
  <div class="mini-chart">
    <canvas id="projection-preview-chart"></canvas>
  </div>
  
  <div class="action-buttons">
    <button class="btn-primary calculate-full">Calculate Full Projection</button>
    <button class="btn-secondary save-scenario">Save Scenario</button>
  </div>
</div>
```

### 4. ANALYTICS & COMPARISON PAGE

#### 4.1 Scenario Comparison Interface
```html
<div class="scenario-comparison">
  <div class="comparison-controls">
    <h3>Scenario Comparison</h3>
    
    <div class="scenario-selectors">
      <div class="selector-group">
        <label>Scenario A</label>
        <select id="scenario-a">
          <option value="15">Conservative 5-Year</option>
          <option value="16">Optimistic Bull Market</option>
        </select>
      </div>
      
      <div class="selector-group">
        <label>Scenario B</label>
        <select id="scenario-b">
          <option value="16" selected>Optimistic Bull Market</option>
          <option value="17">Bear Market Survival</option>
        </select>
      </div>
      
      <button class="btn-add-scenario">+ Add Scenario C</button>
    </div>
  </div>
  
  <!-- Side-by-side comparison charts -->
  <div class="comparison-charts">
    <div class="chart-row">
      <div class="chart-container">
        <h4>Cumulative Profit Comparison</h4>
        <canvas id="profit-comparison-chart"></canvas>
      </div>
    </div>
    
    <div class="chart-row">
      <div class="chart-container half">
        <h4>Power Generation Mix</h4>
        <canvas id="power-mix-chart-a"></canvas>
        <div class="chart-label">Scenario A</div>
      </div>
      
      <div class="chart-container half">
        <h4>Power Generation Mix</h4>
        <canvas id="power-mix-chart-b"></canvas>
        <div class="chart-label">Scenario B</div>
      </div>
    </div>
  </div>
</div>
```

#### 4.2 Risk Analysis Dashboard
```html
<div class="risk-analysis">
  <h3>Risk Analysis</h3>
  
  <div class="risk-metrics">
    <div class="risk-card">
      <h4>Value at Risk (5%)</h4>
      <div class="var-value">-$125,000</div>
      <div class="var-explanation">5% chance of losing more than this amount</div>
    </div>
    
    <div class="risk-card">
      <h4>Probability of Loss</h4>
      <div class="prob-value">12.5%</div>
      <div class="prob-explanation">Chance of negative ROI over 5 years</div>
    </div>
    
    <div class="risk-card">
      <h4>Maximum Drawdown</h4>
      <div class="drawdown-value">-45%</div>
      <div class="drawdown-explanation">Worst-case portfolio decline</div>
    </div>
  </div>
  
  <div class="confidence-intervals">
    <h4>Profit Distribution (5-Year)</h4>
    <div class="distribution-chart">
      <canvas id="profit-distribution"></canvas>
    </div>
    
    <div class="confidence-table">
      <table>
        <thead>
          <tr>
            <th>Confidence Level</th>
            <th>Minimum Profit</th>
            <th>Maximum Profit</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>90% (5th-95th percentile)</td>
            <td>$1,856,000</td>
            <td>$3,542,000</td>
          </tr>
          <tr>
            <td>50% (25th-75th percentile)</td>
            <td>$2,125,000</td>
            <td>$2,784,000</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</div>
```

### 5. SETTINGS & CONFIGURATION PAGE

#### 5.1 General Settings
```html
<div class="settings-page">
  <div class="settings-nav">
    <button class="settings-tab active" data-section="general">General</button>
    <button class="settings-tab" data-section="api">API Keys</button>
    <button class="settings-tab" data-section="notifications">Notifications</button>
    <button class="settings-tab" data-section="export">Export/Import</button>
  </div>
  
  <div class="settings-content">
    <div class="settings-section active" id="general">
      <h3>General Settings</h3>
      
      <div class="setting-group">
        <label>Default Currency</label>
        <select id="currency">
          <option value="USD" selected>USD ($)</option>
          <option value="EUR">EUR (€)</option>
          <option value="GBP">GBP (£)</option>
        </select>
      </div>
      
      <div class="setting-group">
        <label>Default Projection Period</label>
        <select id="default-projection">
          <option value="1">1 Year</option>
          <option value="3">3 Years</option>
          <option value="5" selected>5 Years</option>
        </select>
      </div>
      
      <div class="setting-group">
        <label>Chart Theme</label>
        <select id="chart-theme">
          <option value="light" selected>Light</option>
          <option value="dark">Dark</option>
          <option value="auto">Auto (System)</option>
        </select>
      </div>
    </div>
  </div>
</div>
```

## User Workflows

### 1. NEW USER ONBOARDING WORKFLOW

#### Step 1: Welcome and Location Setup
```html
<div class="onboarding-step" data-step="1">
  <h2>Welcome to Solar Mining Calculator</h2>
  <p>Let's start by setting up your location for accurate solar resource data.</p>
  
  <div class="location-setup">
    <input type="text" placeholder="Enter city, state or coordinates" />
    <button class="btn-primary">Find Location</button>
  </div>
  
  <div class="location-preview">
    <h4>Phoenix, Arizona</h4>
    <div class="location-stats">
      <span>Avg. Peak Sun Hours: 6.2</span>
      <span>Solar Resource Class: Excellent</span>
    </div>
  </div>
</div>
```

#### Step 2: Equipment Selection Wizard
```html
<div class="onboarding-step" data-step="2">
  <h2>What equipment are you considering?</h2>
  
  <div class="equipment-wizard">
    <div class="equipment-category">
      <h4>Mining Equipment</h4>
      <div class="quick-select">
        <button class="equipment-option" data-preset="small">
          Small Setup<br>
          <small>5x Antminer S19 Pro</small>
        </button>
        <button class="equipment-option" data-preset="medium">
          Medium Setup<br>
          <small>10x Antminer S19 Pro</small>
        </button>
        <button class="equipment-option" data-preset="large">
          Large Setup<br>
          <small>20x Antminer S19 XP</small>
        </button>
      </div>
    </div>
    
    <div class="equipment-category">
      <h4>Power Source</h4>
      <div class="quick-select">
        <button class="equipment-option" data-power="solar">
          Solar Only<br>
          <small>Grid-tied solar array</small>
        </button>
        <button class="equipment-option" data-power="hybrid">
          Solar + Storage<br>
          <small>Solar with battery backup</small>
        </button>
        <button class="equipment-option" data-power="mixed">
          Mixed Sources<br>
          <small>Solar + wind + grid</small>
        </button>
      </div>
    </div>
  </div>
</div>
```

#### Step 3: Quick Projection
```html
<div class="onboarding-step" data-step="3">
  <h2>Your Initial Projection</h2>
  
  <div class="quick-results">
    <div class="result-summary">
      <h3>5-Year Projection Summary</h3>
      <div class="big-numbers">
        <div class="number">
          <span class="value">$2.4M</span>
          <span class="label">Estimated Profit</span>
        </div>
        <div class="number">
          <span class="value">348%</span>
          <span class="label">ROI</span>
        </div>
        <div class="number">
          <span class="value">18.5</span>
          <span class="label">Payback (months)</span>
        </div>
      </div>
    </div>
    
    <div class="next-steps">
      <h4>Ready to dive deeper?</h4>
      <button class="btn-primary">Create Detailed Scenario</button>
      <button class="btn-secondary">Explore Equipment</button>
    </div>
  </div>
</div>
```

### 2. SCENARIO CREATION WORKFLOW

#### Phase 1: Basic Configuration
1. **Location Selection**: Choose or add new location
2. **Power Sources**: Select and configure solar/wind/other
3. **Mining Equipment**: Choose miners and quantities
4. **Storage**: Optional battery configuration

#### Phase 2: Economic Parameters
1. **Electricity Rates**: Grid rates, time-of-use, net metering
2. **Initial Investment**: Equipment costs, installation
3. **Operating Costs**: Maintenance, insurance, etc.

#### Phase 3: Market Assumptions
1. **Bitcoin Price Model**: Growth scenarios, volatility
2. **Network Difficulty**: Growth projections
3. **Equipment Degradation**: Performance decline rates

#### Phase 4: Projection Calculation
1. **Time Horizon**: 1-10 years
2. **Calculation Frequency**: Daily, weekly, monthly
3. **Monte Carlo Settings**: Number of simulation runs

### 3. EQUIPMENT COMPARISON WORKFLOW

#### Step 1: Equipment Discovery
- Browse categories (miners, solar, wind, storage)
- Filter by specifications (efficiency, power, price)
- Search by model or manufacturer

#### Step 2: Detailed Comparison
- Select 2-4 equipment models
- Side-by-side specification comparison
- Performance and economic analysis

#### Step 3: Configuration Integration
- Add selected equipment to system configuration
- Adjust quantities and settings
- See immediate impact on projections

## Responsive Design Considerations

### Desktop (1366x768+)
- **Full Feature Access**: All functionality available
- **Multi-column Layouts**: Side-by-side comparisons
- **Large Charts**: Detailed visualizations with hover interactions
- **Keyboard Shortcuts**: Power user efficiency features

### Tablet Landscape (1024x768+)
- **Simplified Layouts**: Reduced columns, stacked elements
- **Touch-Friendly Controls**: Larger buttons and touch targets
- **Essential Features**: Core functionality maintained
- **Condensed Navigation**: Collapsible sidebar

### Unsupported: Mobile Portrait
- **Redirect Message**: "This application is optimized for desktop and tablet use"
- **Mobile App Suggestion**: Link to potential future mobile app
- **Basic Calculator**: Simple ROI calculator for mobile users

## Accessibility Features

### Keyboard Navigation
- **Tab Order**: Logical navigation through interface
- **Keyboard Shortcuts**: Alt+1 (Dashboard), Alt+2 (Equipment), etc.
- **Focus Indicators**: Clear visual focus states
- **Skip Links**: Jump to main content areas

### Visual Accessibility
- **High Contrast Mode**: Alternative color scheme
- **Scalable Fonts**: Support for browser zoom up to 200%
- **Color Independence**: No information conveyed by color alone
- **Alternative Text**: All charts have text descriptions

### Screen Reader Support
- **ARIA Labels**: Proper labeling of interactive elements
- **Live Regions**: Dynamic content updates announced
- **Semantic HTML**: Proper heading structure and landmarks
- **Chart Accessibility**: Data tables as alternatives to charts

---

**Document Status**: Draft v1.0  
**Last Updated**: 2024-08-11  
**Next Review**: After deployment documentation