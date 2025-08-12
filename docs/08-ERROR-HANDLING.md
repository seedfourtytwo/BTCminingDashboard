# Error Handling Strategy - Solar Bitcoin Mining Calculator

## Overview

This document defines a comprehensive error handling strategy for the Solar Bitcoin Mining Calculator, focusing on robustness, user experience, and debugging capabilities for a personal project environment.

## Error Classification System

### Error Categories

```typescript
enum ErrorCategory {
  // User Input Errors
  VALIDATION = 'VALIDATION',           // Invalid user input
  CONFIGURATION = 'CONFIGURATION',     // Invalid system configuration
  
  // System Errors  
  DATABASE = 'DATABASE',               // Database operation failures
  CALCULATION = 'CALCULATION',         // Mathematical computation errors
  EXTERNAL_API = 'EXTERNAL_API',       // Third-party API failures
  
  // Runtime Errors
  TIMEOUT = 'TIMEOUT',                 // Operation timeout
  MEMORY = 'MEMORY',                   // Memory/resource limits
  NETWORK = 'NETWORK',                 // Network connectivity issues
  
  // Business Logic Errors
  BUSINESS_RULE = 'BUSINESS_RULE',     // Business logic violations
  DATA_INTEGRITY = 'DATA_INTEGRITY'   // Data consistency issues
}
```

### Error Severity Levels

```typescript
enum ErrorSeverity {
  LOW = 'LOW',         // Minor issues, system continues normally
  MEDIUM = 'MEDIUM',   // Notable issues, some functionality affected
  HIGH = 'HIGH',       // Major issues, significant functionality impaired
  CRITICAL = 'CRITICAL' // System-threatening issues, immediate attention needed
}
```

## Standardized Error Structure

### Base Error Interface

```typescript
interface BaseError {
  // Core identification
  code: string;                    // Unique error code (e.g., "CALC_001")
  category: ErrorCategory;         // Error category
  severity: ErrorSeverity;         // Severity level
  
  // User-facing information
  message: string;                 // Human-readable error message
  userMessage?: string;            // Simplified message for end users
  
  // Technical details
  details?: Record<string, any>;   // Additional error context
  stack?: string;                  // Stack trace (development only)
  
  // Context information
  timestamp: string;               // ISO timestamp
  component: string;               // Component where error occurred
  operation: string;               // Operation being performed
  
  // Troubleshooting
  suggestedAction?: string;        // What user should do
  documentationUrl?: string;       // Link to relevant docs
  
  // Tracing
  requestId?: string;              // Request identifier
  userId?: string;                 // User identifier (if applicable)
}
```

### Specific Error Types

```typescript
// Validation Errors
interface ValidationError extends BaseError {
  category: ErrorCategory.VALIDATION;
  field: string;                   // Field that failed validation
  providedValue: any;              // Value that was provided
  expectedFormat: string;          // Expected format/constraints
  validationRule: string;          // Rule that was violated
}

// Database Errors
interface DatabaseError extends BaseError {
  category: ErrorCategory.DATABASE;
  query?: string;                  // SQL query that failed
  queryParams?: any[];             // Query parameters
  sqliteErrorCode?: number;        // SQLite-specific error code
  retryable: boolean;              // Whether operation can be retried
}

// Calculation Errors
interface CalculationError extends BaseError {
  category: ErrorCategory.CALCULATION;
  inputParameters: Record<string, any>; // Input that caused the error
  calculationStep: string;         // Which step in calculation failed
  expectedRange?: [number, number]; // Expected value range
  actualValue?: number;            // Actual computed value
}

// External API Errors
interface ExternalAPIError extends BaseError {
  category: ErrorCategory.EXTERNAL_API;
  apiEndpoint: string;             // API endpoint that failed
  httpStatus?: number;             // HTTP status code
  apiErrorCode?: string;           // API-specific error code
  retryAfter?: number;             // Seconds until retry allowed
  fallbackAvailable: boolean;      // Whether fallback exists
}
```

## Error Codes Registry

### Validation Errors (VAL_xxx)
```typescript
const VALIDATION_ERRORS = {
  VAL_001: {
    message: "Invalid equipment quantity",
    severity: ErrorSeverity.MEDIUM,
    suggestedAction: "Enter a quantity between 1 and 1000"
  },
  VAL_002: {
    message: "Invalid date range",
    severity: ErrorSeverity.MEDIUM,
    suggestedAction: "End date must be after start date"
  },
  VAL_003: {
    message: "Invalid power consumption value",
    severity: ErrorSeverity.MEDIUM,
    suggestedAction: "Power consumption must be greater than 0"
  },
  VAL_004: {
    message: "Invalid location coordinates",
    severity: ErrorSeverity.HIGH,
    suggestedAction: "Latitude must be between -90 and 90, longitude between -180 and 180"
  },
  VAL_005: {
    message: "Missing required equipment specifications",
    severity: ErrorSeverity.HIGH,
    suggestedAction: "Please select at least one miner and one power source"
  }
} as const;
```

### Database Errors (DB_xxx)
```typescript
const DATABASE_ERRORS = {
  DB_001: {
    message: "Database connection failed",
    severity: ErrorSeverity.CRITICAL,
    suggestedAction: "Check database configuration and try again"
  },
  DB_002: {
    message: "Query execution timeout",
    severity: ErrorSeverity.HIGH,
    suggestedAction: "Reduce query complexity or try again later"
  },
  DB_003: {
    message: "Data integrity constraint violation",
    severity: ErrorSeverity.HIGH,
    suggestedAction: "Check data consistency and retry operation"
  },
  DB_004: {
    message: "Table or column not found",
    severity: ErrorSeverity.CRITICAL,
    suggestedAction: "Database schema may need migration"
  },
  DB_005: {
    message: "Database storage limit exceeded",
    severity: ErrorSeverity.CRITICAL,
    suggestedAction: "Clean up old data or increase storage capacity"
  }
} as const;
```

### Calculation Errors (CALC_xxx)
```typescript
const CALCULATION_ERRORS = {
  CALC_001: {
    message: "Solar irradiance calculation failed",
    severity: ErrorSeverity.HIGH,
    suggestedAction: "Verify location coordinates and try again"
  },
  CALC_002: {
    message: "Mining profitability calculation overflow",
    severity: ErrorSeverity.HIGH,
    suggestedAction: "Reduce projection timeframe or equipment quantity"
  },
  CALC_003: {
    message: "Equipment degradation model invalid",
    severity: ErrorSeverity.MEDIUM,
    suggestedAction: "Check equipment age and degradation parameters"
  },
  CALC_004: {
    message: "Monte Carlo simulation convergence failed",
    severity: ErrorSeverity.MEDIUM,
    suggestedAction: "Increase simulation runs or adjust parameters"
  },
  CALC_005: {
    message: "Economic calculation negative result",
    severity: ErrorSeverity.LOW,
    suggestedAction: "Review investment assumptions and market conditions"
  }
} as const;
```

### External API Errors (API_xxx)
```typescript
const EXTERNAL_API_ERRORS = {
  API_001: {
    message: "Bitcoin price API unavailable",
    severity: ErrorSeverity.HIGH,
    suggestedAction: "Using cached price data. Some calculations may be outdated."
  },
  API_002: {
    message: "Weather API rate limit exceeded",
    severity: ErrorSeverity.MEDIUM,
    suggestedAction: "Using historical weather data for calculations"
  },
  API_003: {
    message: "Blockchain network data fetch failed",
    severity: ErrorSeverity.HIGH,
    suggestedAction: "Network difficulty calculations may be inaccurate"
  },
  API_004: {
    message: "API request failed",
    severity: ErrorSeverity.HIGH,
    suggestedAction: "Check API endpoint configuration and connectivity"
  },
  API_005: {
    message: "API response malformed",
    severity: ErrorSeverity.MEDIUM,
    suggestedAction: "API provider may be experiencing issues"
  }
} as const;
```

## Error Handling Implementation

### 1. Error Creation Utilities

```typescript
class ErrorFactory {
  static createValidationError(
    code: keyof typeof VALIDATION_ERRORS,
    field: string,
    providedValue: any,
    additionalContext?: Record<string, any>
  ): ValidationError {
    const errorDef = VALIDATION_ERRORS[code];
    
    return {
      code,
      category: ErrorCategory.VALIDATION,
      severity: errorDef.severity,
      message: errorDef.message,
      userMessage: errorDef.suggestedAction,
      field,
      providedValue,
      expectedFormat: getExpectedFormat(field),
      validationRule: getValidationRule(field),
      timestamp: new Date().toISOString(),
      component: getCallingComponent(),
      operation: getCallingOperation(),
      suggestedAction: errorDef.suggestedAction,
      details: additionalContext
    };
  }
  
  static createDatabaseError(
    code: keyof typeof DATABASE_ERRORS,
    query?: string,
    sqliteError?: any,
    additionalContext?: Record<string, any>
  ): DatabaseError {
    const errorDef = DATABASE_ERRORS[code];
    
    return {
      code,
      category: ErrorCategory.DATABASE,
      severity: errorDef.severity,
      message: errorDef.message,
      userMessage: "Database operation failed. Please try again.",
      query: query?.substring(0, 200), // Truncate for security
      sqliteErrorCode: sqliteError?.code,
      retryable: isRetryableError(sqliteError),
      timestamp: new Date().toISOString(),
      component: getCallingComponent(),
      operation: getCallingOperation(),
      suggestedAction: errorDef.suggestedAction,
      details: additionalContext
    };
  }
  
  static createCalculationError(
    code: keyof typeof CALCULATION_ERRORS,
    inputParameters: Record<string, any>,
    calculationStep: string,
    additionalContext?: Record<string, any>
  ): CalculationError {
    const errorDef = CALCULATION_ERRORS[code];
    
    return {
      code,
      category: ErrorCategory.CALCULATION,
      severity: errorDef.severity,
      message: errorDef.message,
      userMessage: "Calculation failed. Please check your inputs.",
      inputParameters: sanitizeInputs(inputParameters),
      calculationStep,
      timestamp: new Date().toISOString(),
      component: getCallingComponent(),
      operation: getCallingOperation(),
      suggestedAction: errorDef.suggestedAction,
      details: additionalContext
    };
  }
}
```

### 2. Error Handling Middleware

```typescript
// For Cloudflare Workers API endpoints
export const errorHandlerMiddleware = async (
  request: Request,
  handler: (request: Request) => Promise<Response>
): Promise<Response> => {
  try {
    return await handler(request);
  } catch (error) {
    const handledError = normalizeError(error);
    
    // Log error for debugging
    console.error('API Error:', {
      error: handledError,
      url: request.url,
      method: request.method,
      userAgent: request.headers.get('User-Agent')
    });
    
    // Return appropriate response
    return new Response(JSON.stringify({
      success: false,
      error: {
        code: handledError.code,
        message: handledError.userMessage || handledError.message,
        details: handledError.severity === ErrorSeverity.LOW ? handledError.details : undefined
      },
      meta: {
        timestamp: handledError.timestamp,
        requestId: generateRequestId()
      }
    }), {
      status: getHttpStatus(handledError),
      headers: { 'Content-Type': 'application/json' }
    });
  }
};

function getHttpStatus(error: BaseError): number {
  switch (error.category) {
    case ErrorCategory.VALIDATION:
      return 400; // Bad Request
    case ErrorCategory.CONFIGURATION:
      return 422; // Unprocessable Entity
    case ErrorCategory.DATABASE:
      return error.retryable ? 503 : 500; // Service Unavailable or Internal Server Error
    case ErrorCategory.EXTERNAL_API:
      return 502; // Bad Gateway
    case ErrorCategory.TIMEOUT:
      return 504; // Gateway Timeout
    case ErrorCategory.BUSINESS_RULE:
      return 409; // Conflict
    default:
      return 500; // Internal Server Error
  }
}
```

### 3. Database Error Handling

```typescript
export class DatabaseManager {
  async executeQuery<T>(
    query: string,
    params: any[] = [],
    operation: string = 'unknown'
  ): Promise<T[]> {
    try {
      const stmt = this.db.prepare(query);
      const result = await stmt.bind(...params).all();
      return result.results as T[];
    } catch (sqliteError) {
      // Determine if error is retryable
      const retryable = this.isRetryableError(sqliteError);
      
      throw ErrorFactory.createDatabaseError(
        this.mapSqliteErrorCode(sqliteError.code),
        query,
        sqliteError,
        { operation, retryable }
      );
    }
  }
  
  private isRetryableError(error: any): boolean {
    // SQLite error codes that indicate temporary failures
    const retryableCodes = [
      5,   // SQLITE_BUSY
      6,   // SQLITE_LOCKED
      10,  // SQLITE_IOERR
      14   // SQLITE_CANTOPEN
    ];
    
    return retryableCodes.includes(error.code);
  }
  
  private mapSqliteErrorCode(code: number): keyof typeof DATABASE_ERRORS {
    switch (code) {
      case 1: return 'DB_003'; // SQLITE_ERROR
      case 5: case 6: return 'DB_002'; // SQLITE_BUSY/LOCKED
      case 10: return 'DB_001'; // SQLITE_IOERR
      case 11: return 'DB_005'; // SQLITE_CORRUPT
      default: return 'DB_001';
    }
  }
}
```

### 4. Calculation Error Handling

```typescript
export class CalculationEngine {
  async calculateSolarProduction(
    config: SolarConfig,
    location: Location,
    dateRange: DateRange
  ): Promise<SolarProductionResult> {
    try {
      // Validate inputs first
      this.validateSolarInputs(config, location, dateRange);
      
      // Perform calculation steps
      const irradianceData = await this.getIrradianceData(location, dateRange);
      const systemOutput = this.calculateSystemOutput(config, irradianceData);
      const degradationFactors = this.calculateDegradation(config, dateRange);
      
      return this.combineResults(systemOutput, degradationFactors);
      
    } catch (error) {
      if (error instanceof BaseError) {
        throw error; // Re-throw our custom errors
      }
      
      // Handle unexpected calculation errors
      throw ErrorFactory.createCalculationError(
        'CALC_001',
        { config, location, dateRange },
        'solar_production_calculation',
        { originalError: error.message }
      );
    }
  }
  
  private validateSolarInputs(
    config: SolarConfig,
    location: Location,
    dateRange: DateRange
  ): void {
    if (!config.panelCount || config.panelCount <= 0) {
      throw ErrorFactory.createValidationError(
        'VAL_001',
        'panelCount',
        config.panelCount
      );
    }
    
    if (!this.isValidCoordinates(location.latitude, location.longitude)) {
      throw ErrorFactory.createValidationError(
        'VAL_004',
        'coordinates',
        { lat: location.latitude, lng: location.longitude }
      );
    }
    
    if (dateRange.endDate <= dateRange.startDate) {
      throw ErrorFactory.createValidationError(
        'VAL_002',
        'dateRange',
        dateRange
      );
    }
  }
}
```

### 5. External API Error Handling

```typescript
export class ExternalAPIManager {
  async fetchBitcoinPrice(): Promise<number> {
    const apis = [
      { name: 'CoinGecko', url: 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd' },
      { name: 'CoinMarketCap', url: 'https://api.coinmarketcap.com/v1/ticker/bitcoin/' }
    ];
    
    let lastError: ExternalAPIError | null = null;
    
    for (const api of apis) {
      try {
        const response = await fetch(api.url, { 
          timeout: 5000,
          headers: { 'User-Agent': 'Solar-Mining-Calculator/1.0' }
        });
        
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        const data = await response.json();
        return this.extractPrice(data, api.name);
        
      } catch (error) {
        lastError = ErrorFactory.createExternalAPIError(
          'API_001',
          api.url,
          error.status,
          { 
            apiName: api.name,
            fallbackAvailable: true,
            originalError: error.message 
          }
        );
        
        // Log but continue to next API
        console.warn(`API ${api.name} failed:`, lastError);
      }
    }
    
    // All APIs failed, try cache
    const cachedPrice = await this.getCachedPrice();
    if (cachedPrice) {
      console.warn('Using cached Bitcoin price due to API failures');
      return cachedPrice;
    }
    
    // No fallback available
    throw lastError;
  }
  
  private async getCachedPrice(): Promise<number | null> {
    try {
      const cached = await this.db.prepare(
        'SELECT price_usd FROM bitcoin_price_history ORDER BY recorded_date DESC LIMIT 1'
      ).first();
      
      return cached?.price_usd || null;
    } catch (error) {
      console.error('Failed to get cached price:', error);
      return null;
    }
  }
}
```

## Frontend Error Handling

### 1. React Error Boundary

```typescript
interface ErrorBoundaryState {
  hasError: boolean;
  error: BaseError | null;
}

class ErrorBoundary extends React.Component<
  React.PropsWithChildren<{}>,
  ErrorBoundaryState
> {
  constructor(props: React.PropsWithChildren<{}>) {
    super(props);
    this.state = { hasError: false, error: null };
  }
  
  static getDerivedStateFromError(error: Error): ErrorBoundaryState {
    return {
      hasError: true,
      error: normalizeError(error)
    };
  }
  
  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    // Log error for debugging
    console.error('React Error Boundary caught an error:', {
      error,
      errorInfo,
      timestamp: new Date().toISOString()
    });
  }
  
  render() {
    if (this.state.hasError && this.state.error) {
      return <ErrorDisplay error={this.state.error} />;
    }
    
    return this.props.children;
  }
}
```

### 2. API Error Handling Hook

```typescript
export const useErrorHandler = () => {
  const [errors, setErrors] = useState<BaseError[]>([]);
  
  const handleError = useCallback((error: BaseError) => {
    setErrors(prev => [...prev, error]);
    
    // Auto-dismiss low severity errors
    if (error.severity === ErrorSeverity.LOW) {
      setTimeout(() => {
        setErrors(prev => prev.filter(e => e !== error));
      }, 5000);
    }
  }, []);
  
  const dismissError = useCallback((error: BaseError) => {
    setErrors(prev => prev.filter(e => e !== error));
  }, []);
  
  const clearErrors = useCallback(() => {
    setErrors([]);
  }, []);
  
  return { errors, handleError, dismissError, clearErrors };
};
```

### 3. User-Friendly Error Display

```typescript
interface ErrorDisplayProps {
  error: BaseError;
  onDismiss?: () => void;
  onRetry?: () => void;
}

export const ErrorDisplay: React.FC<ErrorDisplayProps> = ({ 
  error, 
  onDismiss, 
  onRetry 
}) => {
  const getSeverityColor = (severity: ErrorSeverity) => {
    switch (severity) {
      case ErrorSeverity.LOW: return 'bg-yellow-100 border-yellow-400 text-yellow-800';
      case ErrorSeverity.MEDIUM: return 'bg-orange-100 border-orange-400 text-orange-800';
      case ErrorSeverity.HIGH: return 'bg-red-100 border-red-400 text-red-800';
      case ErrorSeverity.CRITICAL: return 'bg-red-200 border-red-600 text-red-900';
    }
  };
  
  const getIcon = (category: ErrorCategory) => {
    switch (category) {
      case ErrorCategory.VALIDATION: return '⚠️';
      case ErrorCategory.DATABASE: return '💾';
      case ErrorCategory.CALCULATION: return '🧮';
      case ErrorCategory.EXTERNAL_API: return '🌐';
      default: return '❌';
    }
  };
  
  return (
    <div className={`border-l-4 p-4 ${getSeverityColor(error.severity)}`}>
      <div className="flex">
        <div className="flex-shrink-0">
          <span className="text-xl">{getIcon(error.category)}</span>
        </div>
        <div className="ml-3 flex-1">
          <h3 className="text-sm font-medium">
            {error.userMessage || error.message}
          </h3>
          
          {error.suggestedAction && (
            <p className="mt-2 text-sm">
              <strong>Suggested action:</strong> {error.suggestedAction}
            </p>
          )}
          
          {error.details && (
            <details className="mt-2">
              <summary className="text-sm cursor-pointer">Technical details</summary>
              <pre className="mt-1 text-xs bg-gray-100 p-2 rounded">
                {JSON.stringify(error.details, null, 2)}
              </pre>
            </details>
          )}
          
          <div className="mt-4 flex space-x-2">
            {onRetry && (
              <button
                onClick={onRetry}
                className="bg-blue-500 text-white px-3 py-1 rounded text-sm hover:bg-blue-600"
              >
                Retry
              </button>
            )}
            {onDismiss && (
              <button
                onClick={onDismiss}
                className="bg-gray-500 text-white px-3 py-1 rounded text-sm hover:bg-gray-600"
              >
                Dismiss
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
```

## Error Recovery Strategies

### 1. Automatic Retry Logic

```typescript
export const withRetry = async <T>(
  operation: () => Promise<T>,
  maxRetries: number = 3,
  backoffMs: number = 1000
): Promise<T> => {
  let lastError: Error;
  
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await operation();
    } catch (error) {
      lastError = error;
      
      // Don't retry if it's not a retryable error
      if (error instanceof BaseError && !isRetryableError(error)) {
        throw error;
      }
      
      // Don't retry on last attempt
      if (attempt === maxRetries) {
        throw error;
      }
      
      // Exponential backoff
      await sleep(backoffMs * Math.pow(2, attempt - 1));
    }
  }
  
  throw lastError!;
};

function isRetryableError(error: BaseError): boolean {
  if (error.category === ErrorCategory.DATABASE) {
    return (error as DatabaseError).retryable;
  }
  
  if (error.category === ErrorCategory.EXTERNAL_API) {
    return error.severity !== ErrorSeverity.CRITICAL;
  }
  
  return error.category === ErrorCategory.TIMEOUT || 
         error.category === ErrorCategory.NETWORK;
}
```

### 2. Graceful Degradation

```typescript
export class GracefulDegradationManager {
  async getCalculationWithFallback(
    primaryCalculation: () => Promise<any>,
    fallbackData: any,
    operation: string
  ): Promise<any> {
    try {
      return await primaryCalculation();
    } catch (error) {
      console.warn(`Primary calculation failed for ${operation}, using fallback:`, error);
      
      // Use fallback data with warning
      return {
        ...fallbackData,
        _warning: `Calculation used fallback data due to: ${error.message}`,
        _degraded: true
      };
    }
  }
  
  async getDataWithCache(
    primarySource: () => Promise<any>,
    cacheKey: string,
    maxAgeMs: number = 3600000 // 1 hour
  ): Promise<any> {
    try {
      return await primarySource();
    } catch (error) {
      // Try cache
      const cached = await this.getFromCache(cacheKey, maxAgeMs);
      if (cached) {
        console.warn(`Primary source failed, using cached data:`, error);
        return {
          ...cached,
          _fromCache: true,
          _cacheAge: Date.now() - cached._timestamp
        };
      }
      
      throw error;
    }
  }
}
```

## Error Monitoring and Logging

### 1. Structured Logging

```typescript
export class Logger {
  static error(
    message: string,
    error: BaseError | Error,
    context?: Record<string, any>
  ): void {
    const logEntry = {
      level: 'ERROR',
      timestamp: new Date().toISOString(),
      message,
      error: error instanceof BaseError ? error : normalizeError(error),
      context,
      environment: ENV.ENVIRONMENT
    };
    
    console.error(JSON.stringify(logEntry));
  }
  
  static warn(
    message: string,
    context?: Record<string, any>
  ): void {
    const logEntry = {
      level: 'WARN',
      timestamp: new Date().toISOString(),
      message,
      context,
      environment: ENV.ENVIRONMENT
    };
    
    console.warn(JSON.stringify(logEntry));
  }
}
```

### 2. Error Analytics

```typescript
export class ErrorAnalytics {
  static async trackError(error: BaseError): Promise<void> {
    try {
      // Store error in database for analysis
      await DB.prepare(`
        INSERT INTO error_log (
          code, category, severity, message, component, operation,
          timestamp, details
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `).bind(
        error.code,
        error.category,
        error.severity,
        error.message,
        error.component,
        error.operation,
        error.timestamp,
        JSON.stringify(error.details)
      ).run();
      
    } catch (dbError) {
      // Don't let error tracking break the application
      console.error('Failed to track error:', dbError);
    }
  }
  
  static async getErrorSummary(days: number = 7): Promise<ErrorSummary> {
    const since = new Date(Date.now() - days * 24 * 60 * 60 * 1000).toISOString();
    
    const results = await DB.prepare(`
      SELECT 
        category,
        severity,
        COUNT(*) as count,
        COUNT(DISTINCT code) as unique_codes
      FROM error_log 
      WHERE timestamp >= ?
      GROUP BY category, severity
      ORDER BY count DESC
    `).bind(since).all();
    
    return this.processErrorSummary(results);
  }
}
```

## Testing Error Handling

### 1. Error Scenario Tests

```typescript
describe('Error Handling', () => {
  describe('Validation Errors', () => {
    it('should handle invalid equipment quantity', () => {
      expect(() => {
        validateEquipmentConfig({ quantity: -5 });
      }).toThrow(ValidationError);
    });
    
    it('should provide helpful error message for invalid dates', () => {
      const error = () => validateDateRange('2024-12-01', '2024-01-01');
      expect(error).toThrow('End date must be after start date');
    });
  });
  
  describe('Database Errors', () => {
    it('should handle database connection failures gracefully', async () => {
      const mockDB = createMockDatabase({ shouldFail: true });
      const manager = new DatabaseManager(mockDB);
      
      await expect(manager.executeQuery('SELECT 1')).rejects.toThrow(DatabaseError);
    });
  });
  
  describe('API Errors', () => {
    it('should fallback to cache when API fails', async () => {
      const apiManager = new ExternalAPIManager();
      mockFailingAPI();
      mockCachedData({ price: 50000 });
      
      const price = await apiManager.fetchBitcoinPrice();
      expect(price).toBe(50000);
    });
  });
});
```

---

**Document Status**: Draft v1.0  
**Last Updated**: 2024-08-11  
**Implementation Priority**: High - Implement during initial development phase