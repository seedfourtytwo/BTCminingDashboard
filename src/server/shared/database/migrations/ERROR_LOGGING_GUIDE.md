# Error Logging Implementation Guide

## Overview

The error logging system provides comprehensive tracking of application errors for debugging and monitoring. This guide shows how to implement error logging in your application code.

## Error Logging Table Structure

```sql
application_errors (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    error_type VARCHAR(50) NOT NULL,      -- 'calculation', 'validation', 'system', 'api'
    error_category VARCHAR(50) NOT NULL,  -- 'solar_calc', 'mining_calc', 'user_input', etc.
    error_message TEXT NOT NULL,
    error_context JSON,                   -- Additional error details
    severity_level VARCHAR(20) DEFAULT 'error', -- 'info', 'warning', 'error', 'critical'
    stack_trace TEXT,
    user_action TEXT,                     -- What user was doing
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
)
```

## Implementation Examples

### 1. Calculation Error Logging

```typescript
// Solar calculation error
try {
  const solarGeneration = calculateSolarGeneration(params);
  if (solarGeneration > maxCapacity) {
    await logError({
      userId: currentUser.id,
      errorType: 'calculation',
      errorCategory: 'solar_calc',
      errorMessage: 'Solar generation exceeds panel capacity',
      errorContext: {
        systemId: systemId,
        calculatedGeneration: solarGeneration,
        maxCapacity: maxCapacity,
        params: params
      },
      severityLevel: 'error',
      userAction: 'Running solar generation calculation'
    });
  }
} catch (error) {
  await logError({
    userId: currentUser.id,
    errorType: 'calculation',
    errorCategory: 'solar_calc',
    errorMessage: error.message,
    errorContext: { params: params },
    severityLevel: 'critical',
    stackTrace: error.stack,
    userAction: 'Solar generation calculation'
  });
}
```

### 2. Validation Error Logging

```typescript
// User input validation error
if (hashrate < 0) {
  await logError({
    userId: currentUser.id,
    errorType: 'validation',
    errorCategory: 'user_input',
    errorMessage: 'Hashrate cannot be negative',
    errorContext: {
      field: 'hashrate_th',
      value: hashrate,
      table: 'miner_models',
      formData: formData
    },
    severityLevel: 'warning',
    userAction: 'Adding new miner to inventory'
  });
  throw new ValidationError('Invalid hashrate value');
}
```

### 3. System Error Logging

```typescript
// Database constraint violation
try {
  await db.insert('system_configs', configData);
} catch (error) {
  if (error.code === 'SQLITE_CONSTRAINT') {
    await logError({
      userId: currentUser.id,
      errorType: 'system',
      errorCategory: 'database',
      errorMessage: 'Foreign key constraint violation',
      errorContext: {
        table: 'system_configs',
        constraint: 'fk_location_id',
        data: configData,
        errorCode: error.code
      },
      severityLevel: 'error',
      userAction: 'Creating new system configuration'
    });
  }
}
```

### 4. API Error Logging

```typescript
// External API error
try {
  const bitcoinPrice = await fetchBitcoinPrice();
} catch (error) {
  await logError({
    userId: currentUser.id,
    errorType: 'api',
    errorCategory: 'external_api',
    errorMessage: 'Bitcoin price API request failed',
    errorContext: {
      apiEndpoint: 'https://api.coingecko.com/v3/simple/price',
      errorCode: error.status,
      responseText: error.responseText
    },
    severityLevel: 'error',
    userAction: 'Fetching current Bitcoin price'
  });
}
```

## Error Categories Reference

### Calculation Errors
- `solar_calc` - Solar generation calculations
- `mining_calc` - Mining performance calculations
- `economic_calc` - Financial and ROI calculations
- `weather_calc` - Weather impact calculations

### Validation Errors
- `user_input` - User data validation
- `equipment_specs` - Equipment specification validation
- `system_config` - System configuration validation
- `scenario_params` - Scenario parameter validation

### System Errors
- `database` - Database connection and constraint errors
- `memory` - Memory usage and performance errors
- `timeout` - Request timeout errors
- `file_system` - File system errors

### API Errors
- `external_api` - External API integration errors
- `rate_limit` - API rate limiting errors
- `network` - Network connectivity errors
- `data_format` - API response format errors

## Severity Levels

### `info`
- Informational messages
- Normal operation notes
- Debug information

### `warning`
- Non-critical issues
- Potential problems
- Deprecated feature usage

### `error`
- Standard errors
- Issues that need attention
- Failed operations

### `critical`
- Severe errors
- System failures
- Data corruption issues

## Querying Error Logs

### Recent Errors by User
```sql
SELECT * FROM application_errors 
WHERE user_id = ? 
ORDER BY created_at DESC 
LIMIT 50;
```

### Errors by Category
```sql
SELECT error_category, COUNT(*) as error_count 
FROM application_errors 
WHERE created_at > datetime('now', '-7 days')
GROUP BY error_category 
ORDER BY error_count DESC;
```

### Critical Errors
```sql
SELECT * FROM application_errors 
WHERE severity_level = 'critical' 
ORDER BY created_at DESC;
```

### Error Trends
```sql
SELECT 
    DATE(created_at) as error_date,
    error_type,
    COUNT(*) as error_count
FROM application_errors 
WHERE created_at > datetime('now', '-30 days')
GROUP BY DATE(created_at), error_type
ORDER BY error_date DESC;
```

## Cleanup and Maintenance

### Automatic Cleanup
The system includes a cleanup function to remove old error logs:

```sql
-- Clean up errors older than 30 days
SELECT cleanup_old_errors();
```

### Manual Cleanup
```sql
-- Remove errors older than 7 days
DELETE FROM application_errors 
WHERE created_at < datetime('now', '-7 days');

-- Remove specific error types
DELETE FROM application_errors 
WHERE error_type = 'info' 
AND created_at < datetime('now', '-1 day');
```

## Best Practices

### 1. Log Meaningful Context
```typescript
// Good: Include relevant data
errorContext: {
  systemId: 15,
  calculatedValue: 5000,
  expectedRange: [0, 4000],
  inputParams: params
}

// Bad: Too generic
errorContext: { error: 'something went wrong' }
```

### 2. Use Appropriate Severity Levels
```typescript
// Critical: System failure
severityLevel: 'critical'

// Error: Operation failed
severityLevel: 'error'

// Warning: Potential issue
severityLevel: 'warning'

// Info: Normal operation
severityLevel: 'info'
```

### 3. Include User Action Context
```typescript
// Good: Specific user action
userAction: 'Creating new system configuration with 2 miners'

// Bad: Too generic
userAction: 'User action'
```

### 4. Handle Sensitive Data
```typescript
// Don't log sensitive information
errorContext: {
  userId: 123,
  // Don't include: password, apiKey, personalData
  action: 'login_attempt',
  ipAddress: '192.168.1.1'
}
```

## Integration with Application

### Error Logging Service
```typescript
class ErrorLoggingService {
  async logError(params: {
    userId?: number;
    errorType: string;
    errorCategory: string;
    errorMessage: string;
    errorContext?: any;
    severityLevel?: string;
    stackTrace?: string;
    userAction?: string;
    ipAddress?: string;
    userAgent?: string;
  }) {
    // Implementation here
  }
}
```

### Global Error Handler
```typescript
// Global error handler for uncaught exceptions
process.on('uncaughtException', async (error) => {
  await logError({
    errorType: 'system',
    errorCategory: 'uncaught_exception',
    errorMessage: error.message,
    severityLevel: 'critical',
    stackTrace: error.stack
  });
});
```

This error logging system will help you debug issues quickly and maintain a reliable application!
