-- Migration 0005: Historical Data
-- Description: Historical data tracking for equipment values and performance
-- Dependencies: 0001_core_foundation.sql

-- =============================================================================
-- HISTORICAL DATA
-- =============================================================================

-- Table: miner_price_history
-- Historical price tracking for miners
CREATE TABLE miner_price_history (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    miner_model_id INTEGER NOT NULL,
    recorded_date DATE NOT NULL,
    market_price_usd REAL NOT NULL,
    resale_price_usd REAL,
    market_demand_level VARCHAR(20),
    depreciation_rate_used REAL,
    calculation_method VARCHAR(20),
    data_source VARCHAR(50),
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(miner_model_id) REFERENCES miner_models(id)
);

-- =============================================================================
-- HISTORICAL DATA INDEXES
-- =============================================================================

CREATE INDEX idx_miner_price_history_user ON miner_price_history(user_id);
CREATE INDEX idx_miner_price_history_model_date ON miner_price_history(miner_model_id, recorded_date);
CREATE INDEX idx_miner_price_history_demand ON miner_price_history(market_demand_level);
CREATE INDEX idx_miner_price_history_calculation ON miner_price_history(calculation_method);
