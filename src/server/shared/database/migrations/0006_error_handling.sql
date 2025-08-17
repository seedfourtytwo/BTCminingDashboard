-- Migration 0006: Error Handling Support
-- Description: Application error logging for debugging and monitoring
-- Dependencies: 0001_core_foundation.sql

-- =============================================================================
-- APPLICATION ERROR LOGGING
-- =============================================================================

-- Table: application_errors
-- Track application errors for debugging and monitoring
CREATE TABLE application_errors (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    error_type VARCHAR(50) NOT NULL, -- 'calculation', 'validation', 'system', 'api'
    error_category VARCHAR(50) NOT NULL, -- 'solar_calc', 'mining_calc', 'user_input', 'database'
    error_message TEXT NOT NULL,
    error_context JSON, -- Additional error details and context
    severity_level VARCHAR(20) DEFAULT 'error', -- 'info', 'warning', 'error', 'critical'
    stack_trace TEXT,
    user_action TEXT, -- What user was doing when error occurred
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id)
);

-- =============================================================================
-- ERROR LOGGING INDEXES
-- =============================================================================

-- Performance indexes for error querying
CREATE INDEX idx_app_errors_user_time ON application_errors(user_id, created_at);
CREATE INDEX idx_app_errors_type_category ON application_errors(error_type, error_category);
CREATE INDEX idx_app_errors_severity ON application_errors(severity_level);
CREATE INDEX idx_app_errors_created_at ON application_errors(created_at);

-- =============================================================================
-- ERROR CATEGORIES DOCUMENTATION
-- =============================================================================

-- Application error logging for debugging and monitoring.
--
-- Error Types:
-- - calculation: Mathematical or algorithmic errors
-- - validation: User input or data validation errors  
-- - system: Database, memory, or system-level errors
-- - api: External API integration errors
--
-- Error Categories:
-- - solar_calc: Solar generation calculation errors
-- - mining_calc: Mining performance calculation errors
-- - economic_calc: Financial and ROI calculation errors
-- - user_input: User data validation errors
-- - database: Database connection or constraint errors
-- - external_api: External API integration errors
-- - system_performance: Memory, timeout, or performance errors
--
-- Severity Levels:
-- - info: Informational messages
-- - warning: Non-critical issues
-- - error: Standard errors that need attention
-- - critical: Severe errors requiring immediate action

-- =============================================================================
-- ERROR CLEANUP FUNCTION (Application Level)
-- =============================================================================

-- Note: Error cleanup function will be implemented in application code
-- Function: cleanup_old_errors() - removes errors older than 30 days
