-- ============================================================
--  Soccer DBMS - SCHEMA UPDATE 2
--  Adds player_status to players, competition to fixtures
--  Run this BEFORE updating player/fixture data
-- ============================================================

USE epl_dbms;

-- Player status (ACTIVE, FREE_AGENT, RETIRED)
ALTER TABLE players
  ADD COLUMN IF NOT EXISTS player_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
    COMMENT 'ACTIVE, FREE_AGENT, RETIRED';

-- Competition / league on each fixture
ALTER TABLE fixtures
  ADD COLUMN IF NOT EXISTS competition VARCHAR(60) NOT NULL DEFAULT 'Premier League'
    COMMENT 'Premier League, Serie A, La Liga, Bundesliga, Ligue 1, Liga Portugal, Eredivisie, Pro League, Super Lig';

-- Verify
DESCRIBE players;
DESCRIBE fixtures;
