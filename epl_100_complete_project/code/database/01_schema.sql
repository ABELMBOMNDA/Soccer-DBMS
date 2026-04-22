DROP DATABASE IF EXISTS epl_dbms;
CREATE DATABASE epl_dbms;
USE epl_dbms;

CREATE TABLE seasons (
    season_id INT AUTO_INCREMENT PRIMARY KEY,
    season_name VARCHAR(20) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'UPCOMING',
    CHECK (end_date > start_date),
    CHECK (status IN ('UPCOMING', 'ACTIVE', 'COMPLETED'))
);

CREATE TABLE stadiums (
    stadium_id INT AUTO_INCREMENT PRIMARY KEY,
    stadium_name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'England',
    capacity INT NOT NULL,
    CHECK (capacity > 0)
);

CREATE TABLE clubs (
    club_id INT AUTO_INCREMENT PRIMARY KEY,
    club_name VARCHAR(100) NOT NULL UNIQUE,
    short_name VARCHAR(20) NOT NULL UNIQUE,
    founded_year INT,
    manager_name VARCHAR(100) NOT NULL,
    sponsor_name VARCHAR(100),
    stadium_id INT NOT NULL,
    CHECK (founded_year IS NULL OR founded_year BETWEEN 1850 AND 2025),
    CONSTRAINT fk_club_stadium FOREIGN KEY (stadium_id)
        REFERENCES stadiums(stadium_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE positions (
    position_id INT AUTO_INCREMENT PRIMARY KEY,
    position_code VARCHAR(10) NOT NULL UNIQUE,
    position_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    date_of_birth DATE NOT NULL,
    nationality VARCHAR(60) NOT NULL,
    position_id INT NOT NULL,
    squad_number INT,
    preferred_foot VARCHAR(10) NOT NULL DEFAULT 'Right',
    current_club_id INT,
    market_value DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    CHECK (squad_number IS NULL OR squad_number BETWEEN 1 AND 99),
    CHECK (preferred_foot IN ('Right', 'Left', 'Both')),
    CHECK (market_value >= 0),
    CONSTRAINT fk_player_position FOREIGN KEY (position_id)
        REFERENCES positions(position_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_player_club FOREIGN KEY (current_club_id)
        REFERENCES clubs(club_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE club_registrations (
    registration_id INT AUTO_INCREMENT PRIMARY KEY,
    season_id INT NOT NULL,
    club_id INT NOT NULL,
    registration_date DATE NOT NULL,
    registration_status VARCHAR(20) NOT NULL DEFAULT 'APPROVED',
    UNIQUE KEY uq_season_club (season_id, club_id),
    CHECK (registration_status IN ('PENDING', 'APPROVED', 'SUSPENDED')),
    CONSTRAINT fk_reg_season FOREIGN KEY (season_id)
        REFERENCES seasons(season_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_reg_club FOREIGN KEY (club_id)
        REFERENCES clubs(club_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE fixtures (
    fixture_id INT AUTO_INCREMENT PRIMARY KEY,
    season_id INT NOT NULL,
    matchweek INT NOT NULL,
    match_date DATETIME NOT NULL,
    stadium_id INT NOT NULL,
    home_club_id INT NOT NULL,
    away_club_id INT NOT NULL,
    home_score INT DEFAULT 0,
    away_score INT DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED',
    attendance INT DEFAULT 0,
    CHECK (matchweek BETWEEN 1 AND 38),
    CHECK (home_score >= 0),
    CHECK (away_score >= 0),
    CHECK (attendance >= 0),
    CHECK (status IN ('SCHEDULED', 'COMPLETED', 'POSTPONED', 'CANCELLED')),
    CONSTRAINT fk_fixture_season FOREIGN KEY (season_id)
        REFERENCES seasons(season_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_fixture_stadium FOREIGN KEY (stadium_id)
        REFERENCES stadiums(stadium_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_fixture_home FOREIGN KEY (home_club_id)
        REFERENCES clubs(club_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_fixture_away FOREIGN KEY (away_club_id)
        REFERENCES clubs(club_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE match_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    fixture_id INT NOT NULL,
    minute_mark INT NOT NULL,
    event_type VARCHAR(20) NOT NULL,
    club_id INT NOT NULL,
    player_id INT NOT NULL,
    assisting_player_id INT NULL,
    description VARCHAR(255),
    CHECK (minute_mark BETWEEN 1 AND 130),
    CHECK (event_type IN ('GOAL', 'YELLOW_CARD', 'RED_CARD', 'SUBSTITUTION', 'OWN_GOAL', 'PENALTY_GOAL')),
    CONSTRAINT fk_event_fixture FOREIGN KEY (fixture_id)
        REFERENCES fixtures(fixture_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_event_club FOREIGN KEY (club_id)
        REFERENCES clubs(club_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_event_player FOREIGN KEY (player_id)
        REFERENCES players(player_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_event_assist FOREIGN KEY (assisting_player_id)
        REFERENCES players(player_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE standings (
    standing_id INT AUTO_INCREMENT PRIMARY KEY,
    season_id INT NOT NULL,
    club_id INT NOT NULL,
    played INT NOT NULL DEFAULT 0,
    wins INT NOT NULL DEFAULT 0,
    draws INT NOT NULL DEFAULT 0,
    losses INT NOT NULL DEFAULT 0,
    goals_for INT NOT NULL DEFAULT 0,
    goals_against INT NOT NULL DEFAULT 0,
    goal_difference INT NOT NULL DEFAULT 0,
    points INT NOT NULL DEFAULT 0,
    position_no INT,
    UNIQUE KEY uq_standing_season_club (season_id, club_id),
    UNIQUE KEY uq_standing_position (season_id, position_no),
    CHECK (played >= 0),
    CHECK (wins >= 0),
    CHECK (draws >= 0),
    CHECK (losses >= 0),
    CHECK (goals_for >= 0),
    CHECK (goals_against >= 0),
    CHECK (goal_difference = goals_for - goals_against),
    CHECK (points = (wins * 3) + draws),
    CHECK (played = wins + draws + losses),
    CONSTRAINT fk_standing_season FOREIGN KEY (season_id)
        REFERENCES seasons(season_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_standing_club FOREIGN KEY (club_id)
        REFERENCES clubs(club_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE transfers (
    transfer_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    season_id INT NOT NULL,
    from_club_id INT NULL,
    to_club_id INT NOT NULL,
    transfer_date DATE NOT NULL,
    transfer_fee DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    transfer_type VARCHAR(20) NOT NULL DEFAULT 'PERMANENT',
    status VARCHAR(20) NOT NULL DEFAULT 'COMPLETED',
    CHECK (transfer_fee >= 0),
    CHECK (transfer_type IN ('PERMANENT', 'LOAN', 'FREE_AGENT')),
    CHECK (status IN ('PENDING', 'COMPLETED', 'CANCELLED')),
    CONSTRAINT fk_transfer_player FOREIGN KEY (player_id)
        REFERENCES players(player_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_transfer_season FOREIGN KEY (season_id)
        REFERENCES seasons(season_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_transfer_from_club FOREIGN KEY (from_club_id)
        REFERENCES clubs(club_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT fk_transfer_to_club FOREIGN KEY (to_club_id)
        REFERENCES clubs(club_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE INDEX idx_player_last_name ON players(last_name, first_name);
CREATE INDEX idx_fixture_matchweek ON fixtures(season_id, matchweek, match_date);
CREATE INDEX idx_event_type ON match_events(event_type);
CREATE INDEX idx_transfer_date ON transfers(transfer_date);

CREATE OR REPLACE VIEW vw_current_standings AS
SELECT
    s.season_name,
    st.position_no,
    c.club_name,
    st.played,
    st.wins,
    st.draws,
    st.losses,
    st.goals_for,
    st.goals_against,
    st.goal_difference,
    st.points
FROM standings st
JOIN seasons s ON st.season_id = s.season_id
JOIN clubs c ON st.club_id = c.club_id
ORDER BY s.season_name, st.position_no;

CREATE OR REPLACE VIEW vw_top_scorers AS
SELECT
    se.season_name,
    p.player_id,
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    c.club_name,
    COUNT(*) AS goals
FROM match_events me
JOIN fixtures f ON me.fixture_id = f.fixture_id
JOIN seasons se ON f.season_id = se.season_id
JOIN players p ON me.player_id = p.player_id
JOIN clubs c ON p.current_club_id = c.club_id
WHERE me.event_type IN ('GOAL', 'PENALTY_GOAL')
GROUP BY se.season_name, p.player_id, player_name, c.club_name
ORDER BY goals DESC, player_name;


CREATE TABLE official_registered_squads (
    squad_entry_id INT AUTO_INCREMENT PRIMARY KEY,
    season_name VARCHAR(20) NOT NULL,
    source_snapshot_date DATE NOT NULL,
    club_name VARCHAR(100) NOT NULL,
    player_name VARCHAR(150) NOT NULL,
    is_home_grown BOOLEAN NOT NULL DEFAULT FALSE,
    squad_scope VARCHAR(50) NOT NULL DEFAULT 'Senior Registered Squad',
    source_note VARCHAR(255),
    UNIQUE KEY uq_official_squad_entry (season_name, source_snapshot_date, club_name, player_name, squad_scope)
);

CREATE OR REPLACE VIEW vw_current_official_squad_counts AS
SELECT
    season_name,
    source_snapshot_date,
    club_name,
    COUNT(*) AS registered_senior_players,
    SUM(CASE WHEN is_home_grown THEN 1 ELSE 0 END) AS home_grown_players,
    SUM(CASE WHEN is_home_grown THEN 0 ELSE 1 END) AS non_home_grown_players
FROM official_registered_squads
GROUP BY season_name, source_snapshot_date, club_name
ORDER BY club_name;

CREATE OR REPLACE VIEW vw_current_home_grown_players AS
SELECT
    season_name,
    source_snapshot_date,
    club_name,
    player_name
FROM official_registered_squads
WHERE is_home_grown = TRUE
ORDER BY club_name, player_name;
