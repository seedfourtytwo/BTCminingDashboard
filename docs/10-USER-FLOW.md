# User Flow - Solar Bitcoin Mining Calculator

## Table of Contents
- [Overview](#overview)
- [User Journey Mapping](#user-journey-mapping)
- [Primary User Flows](#primary-user-flows)
  - [Equipment Setup Flow](#equipment-setup-flow)
  - [System Configuration Flow](#system-configuration-flow)
  - [Projection Analysis Flow](#projection-analysis-flow)
  - [Results Review Flow](#results-review-flow)
- [Secondary User Flows](#secondary-user-flows)
  - [Data Management](#data-management)
  - [Report Generation](#report-generation)
  - [Settings Configuration](#settings-configuration)
- [Error Handling Flows](#error-handling-flows)
- [Performance Considerations](#performance-considerations)
- [Implementation Guidelines](#implementation-guidelines)

## Overview

This document outlines the user workflow for the Solar Bitcoin Mining Calculator, from hardware inventory management to scenario-based projections and comparisons.

## Core Workflow

### 1. Hardware Inventory Management
**Goal**: Build and maintain equipment inventory

#### 1.1 Add Equipment to Inventory
- **Miners**: Add ASIC miners (Antminer S19, S21, etc.)
  - Enter manufacturer, model, specifications
  - Add purchase date, price, warranty info
  - Set user-friendly nickname (e.g., "Main Miner", "Backup S19")
  - Configure depreciation settings

- **Solar Panels**: Add solar panel models
  - Enter manufacturer, model, specifications
  - Add installation date, purchase price
  - Set user-friendly nickname (e.g., "Main Array", "Backup Panels")

- **Storage Systems**: Add battery storage
  - Enter manufacturer, model, capacity
  - Add installation date, purchase price
  - Set user-friendly nickname (e.g., "Battery Bank 1")

- **Inverters**: Add solar inverters
  - Enter manufacturer, model, specifications
  - Add installation date, purchase price
  - Set user-friendly nickname (e.g., "Main Inverter")

#### 1.2 Manage Equipment Inventory
- **Edit Equipment**: Update specifications, prices, notes
- **Remove Equipment**: Archive or delete unused equipment
- **View Inventory**: See all equipment with current values
- **Track Depreciation**: Monitor equipment value over time

### 2. System Configuration
**Goal**: Create mining system setups using inventory equipment

#### 2.1 Create New System Configuration
- **Select Location**: Choose geographic location for solar calculations
- **Select Equipment from Inventory**:
  - Choose miners (quantity, configuration)
  - Choose solar panels (quantity, orientation)
  - Choose storage systems (if any)
  - Choose inverters
- **Configure Economic Parameters**:
  - Set electricity rate
  - Set net metering rate (if applicable)
- **Configure Mining Mode**:
  - Solar-only (no grid connection)
  - Grid-assisted (backup power)
  - Hybrid (battery + grid)
- **Set Mining Schedule** (for battery-free setups):
  - Auto-calculate based on solar generation
  - Manual schedule override

#### 2.2 System Configuration Examples
**Source**: System configurations are stored in the database schema

**User Interface**: See [`docs/07-USER-INTERFACE.md`](07-USER-INTERFACE.md) for interface specifications

```
System: "Main Solar Mining Setup"
├── Location: Phoenix, AZ
├── Equipment:
│   ├── 2x Antminer S19 Pro (from inventory)
│   ├── 20x 400W Solar Panels (from inventory)
│   ├── 1x 10kWh Battery Bank (from inventory)
│   └── 1x 8kW Solar Inverter (from inventory)
├── Mode: Solar-only (no grid)
└── Auto-calculate mining hours
```

### 3. Baseline Scenario Generation
**Goal**: Create reference projection using current market conditions

#### 3.1 Automatic Baseline Creation
When a system configuration is created, the system automatically:
- **Fetches Live Data**:
  - Current Bitcoin price (CoinGecko API)
  - Current network difficulty (Blockchain API)
  - Current weather conditions (OpenWeatherMap API)
  - Solar irradiance data (NREL API)
- **Calculates Baseline Projection**:
  - 5-year revenue and cost projections
  - Equipment degradation modeling
  - Solar production calculations
  - Mining profitability analysis

#### 3.2 Baseline Scenario Features
- **Real-time Data**: Live market and weather data
- **Equipment Degradation**: Annual performance decline modeling
- **Solar Production**: Location-specific solar calculations
- **Economic Analysis**: ROI, payback period, NPV calculations

### 4. Custom Scenario Creation
**Goal**: Create "what-if" scenarios for planning and analysis

#### 4.1 Scenario Parameters
- **Bitcoin Market Scenarios**:
  - Bull market (high price, low difficulty)
  - Bear market (low price, high difficulty)
  - Stable market (current trends)
  - Custom price and difficulty projections

- **Economic Scenarios**:
  - High electricity costs
  - Low electricity costs
  - Equipment price changes
  - Maintenance cost variations

- **Environmental Scenarios**:
  - Weather impact on solar production
  - Temperature effects on mining efficiency
  - Seasonal variations in performance

#### 4.2 Scenario Comparison
- **Side-by-side Analysis**: Compare multiple scenarios
- **Key Metrics**: ROI, payback period, profitability
- **Visual Charts**: Revenue, cost, and profit projections
- **Export Options**: PDF reports, CSV data export

## User Journey Mapping

### Primary User Journey
1. **Dashboard**: Overview and quick access to key functions
2. **Inventory**: Add and manage equipment
3. **Systems**: Create configurations using inventory
4. **Scenarios**: Generate baseline and create custom projections
5. **Reports**: Analyze results and generate reports

### Secondary Workflows
- **Equipment Research**: Catalog → Inventory → Systems
- **Scenario Analysis**: Systems → Scenarios → Reports
- **Data Management**: Settings → Data import/export
- **System Optimization**: Reports → Systems → Scenarios

## Primary User Flows

### Equipment Setup Flow
1. **Access Inventory Page**: Navigate to equipment management
2. **Add Equipment**: Select equipment type and enter specifications
3. **Configure Details**: Set purchase date, price, warranty information
4. **Save Equipment**: Store in inventory with unique identifier
5. **Verify Setup**: Review equipment in inventory list

### System Configuration Flow
1. **Create New System**: Start system configuration wizard
2. **Select Location**: Choose geographic location for calculations
3. **Choose Equipment**: Select from inventory with quantities
4. **Configure Parameters**: Set economic and operational parameters
5. **Validate Configuration**: System validates equipment compatibility
6. **Save System**: Store configuration for future use

### Projection Analysis Flow
1. **Select System**: Choose system configuration for analysis
2. **Generate Baseline**: Create baseline scenario with current data
3. **Create Scenarios**: Build custom "what-if" scenarios
4. **Run Analysis**: Execute calculations and projections
5. **Review Results**: Analyze projections and key metrics
6. **Compare Scenarios**: Side-by-side scenario comparison

### Results Review Flow
1. **View Dashboard**: Overview of current projections
2. **Analyze Charts**: Review revenue, cost, and profit charts
3. **Check Metrics**: Review ROI, payback period, NPV
4. **Export Data**: Generate reports or export data
5. **Share Results**: Share analysis with stakeholders

## Secondary User Flows

### Data Management
1. **Import Data**: Upload equipment specifications or historical data
2. **Export Data**: Download inventory, configurations, or results
3. **Backup Data**: Create backups of user data
4. **Restore Data**: Restore from backup if needed

### Report Generation
1. **Select Report Type**: Choose from available report templates
2. **Configure Parameters**: Set report scope and parameters
3. **Generate Report**: Create report with current data
4. **Review Report**: Check report accuracy and completeness
5. **Export Report**: Download in PDF, CSV, or other formats

### Settings Configuration
1. **Access Settings**: Navigate to application settings
2. **Configure Preferences**: Set default values and preferences
3. **Manage API Keys**: Configure external service credentials
4. **Set Notifications**: Configure alert and notification preferences
5. **Save Settings**: Store configuration changes

## Error Handling Flows

### Validation Errors
1. **Input Validation**: Real-time validation of user input
2. **Error Display**: Clear error messages with guidance
3. **Correction**: User corrects invalid input
4. **Re-validation**: System validates corrected input
5. **Proceed**: Continue with valid data

### System Errors
1. **Error Detection**: System detects operational error
2. **Error Logging**: Log error details for debugging
3. **User Notification**: Inform user of error occurrence
4. **Recovery Options**: Provide recovery or workaround options
5. **Resolution**: User or system resolves error

### Data Errors
1. **Data Validation**: Validate external data sources
2. **Fallback Data**: Use cached or default data if available
3. **User Notification**: Inform user of data issues
4. **Manual Override**: Allow user to provide manual data
5. **Retry**: Attempt to fetch data again

## Performance Considerations

### Response Time Targets
- **Page Load**: <3 seconds for dashboard
- **Data Entry**: <1 second for form validation
- **Calculations**: <30 seconds for complex projections
- **Report Generation**: <10 seconds for standard reports

### User Experience
- **Loading States**: Clear loading indicators for long operations
- **Progress Feedback**: Progress bars for multi-step processes
- **Error Recovery**: Graceful error handling with recovery options
- **Data Persistence**: Auto-save functionality for user data

### Scalability
- **Concurrent Users**: Support for 1000+ concurrent users
- **Data Volume**: Handle large equipment inventories and scenarios
- **Calculation Load**: Efficient processing of complex calculations
- **Storage**: Scalable data storage for user configurations

## Implementation Guidelines

### User Interface Design
- **Consistent Navigation**: Standard navigation patterns across pages
- **Clear Hierarchy**: Logical information hierarchy and organization
- **Responsive Design**: Optimized for desktop and tablet use
- **Accessibility**: WCAG 2.1 AA compliance

### Data Management
- **Real-time Updates**: Live data updates where appropriate
- **Caching Strategy**: Efficient caching of expensive calculations
- **Data Validation**: Input and data validation
- **Error Handling**: Robust error handling and recovery

### Performance Optimization
- **Lazy Loading**: Load data and components as needed
- **Optimistic Updates**: Immediate UI updates with background validation
- **Background Processing**: Process heavy calculations in background
- **Result Caching**: Cache calculation results for reuse

---

**Document Status**: Current Plan v1.0  
**Last Updated**: 2025-08-17  
**Next Review**: After Phase 1 implementation
