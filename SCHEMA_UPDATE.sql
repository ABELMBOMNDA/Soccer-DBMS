-- ============================================================
--  Soccer DBMS - SCHEMA UPDATE
--  Adds contract_end_date, squad_type to players table
--  Run this FIRST before any player data files
-- ============================================================

USE epl_dbms;

-- Add contract end date
ALTER TABLE players
  ADD COLUMN IF NOT EXISTS contract_end_date DATE DEFAULT NULL,
  ADD COLUMN IF NOT EXISTS squad_type VARCHAR(20) DEFAULT 'FIRST_TEAM'
    COMMENT 'FIRST_TEAM, ACADEMY, LOAN';

-- Verify
DESCRIBE players;
