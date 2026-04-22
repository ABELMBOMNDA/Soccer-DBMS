-- ============================================================
--  EPL DBMS - COMPLETE DATABASE SETUP
--  2025/26 Premier League Season | All 20 Clubs
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;
DROP DATABASE IF EXISTS epl_dbms;
CREATE DATABASE epl_dbms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE epl_dbms;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- TABLES
-- ============================================================

CREATE TABLE seasons (
    season_id   INT AUTO_INCREMENT PRIMARY KEY,
    season_name VARCHAR(20)  NOT NULL UNIQUE,
    start_date  DATE         NOT NULL,
    end_date    DATE         NOT NULL,
    status      VARCHAR(20)  NOT NULL DEFAULT 'UPCOMING',
    CHECK (end_date > start_date),
    CHECK (status IN ('UPCOMING','ACTIVE','COMPLETED'))
);

CREATE TABLE stadiums (
    stadium_id   INT AUTO_INCREMENT PRIMARY KEY,
    stadium_name VARCHAR(100) NOT NULL UNIQUE,
    city         VARCHAR(100) NOT NULL,
    country      VARCHAR(100) NOT NULL DEFAULT 'England',
    capacity     INT          NOT NULL,
    CHECK (capacity > 0)
);

CREATE TABLE clubs (
    club_id      INT AUTO_INCREMENT PRIMARY KEY,
    club_name    VARCHAR(100) NOT NULL UNIQUE,
    short_name   VARCHAR(20)  NOT NULL UNIQUE,
    founded_year INT,
    manager_name VARCHAR(100) NOT NULL,
    sponsor_name VARCHAR(100),
    stadium_id   INT          NOT NULL,
    CHECK (founded_year IS NULL OR founded_year BETWEEN 1850 AND 2025),
    CONSTRAINT fk_club_stadium FOREIGN KEY (stadium_id)
        REFERENCES stadiums(stadium_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE positions (
    position_id   INT AUTO_INCREMENT PRIMARY KEY,
    position_code VARCHAR(10)  NOT NULL UNIQUE,
    position_name VARCHAR(50)  NOT NULL UNIQUE
);

CREATE TABLE players (
    player_id       INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(60)    NOT NULL,
    last_name       VARCHAR(60)    NOT NULL,
    date_of_birth   DATE           NOT NULL,
    nationality     VARCHAR(60)    NOT NULL,
    position_id     INT            NOT NULL,
    squad_number    INT,
    preferred_foot  VARCHAR(10)    NOT NULL DEFAULT 'Right',
    current_club_id INT,
    market_value    DECIMAL(12,2)  NOT NULL DEFAULT 0.00,
    CHECK (squad_number IS NULL OR squad_number BETWEEN 1 AND 99),
    CHECK (preferred_foot IN ('Right','Left','Both')),
    CHECK (market_value >= 0),
    CONSTRAINT fk_player_position FOREIGN KEY (position_id)
        REFERENCES positions(position_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_player_club FOREIGN KEY (current_club_id)
        REFERENCES clubs(club_id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE club_registrations (
    registration_id     INT AUTO_INCREMENT PRIMARY KEY,
    season_id           INT  NOT NULL,
    club_id             INT  NOT NULL,
    registration_date   DATE NOT NULL,
    registration_status VARCHAR(20) NOT NULL DEFAULT 'APPROVED',
    UNIQUE KEY uq_season_club (season_id, club_id),
    CHECK (registration_status IN ('PENDING','APPROVED','SUSPENDED')),
    CONSTRAINT fk_reg_season FOREIGN KEY (season_id)
        REFERENCES seasons(season_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reg_club FOREIGN KEY (club_id)
        REFERENCES clubs(club_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE fixtures (
    fixture_id   INT AUTO_INCREMENT PRIMARY KEY,
    season_id    INT      NOT NULL,
    matchweek    INT      NOT NULL,
    match_date   DATETIME NOT NULL,
    stadium_id   INT      NOT NULL,
    home_club_id INT      NOT NULL,
    away_club_id INT      NOT NULL,
    home_score   INT      DEFAULT NULL,
    away_score   INT      DEFAULT NULL,
    status       VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED',
    attendance   INT      DEFAULT NULL,
    CHECK (matchweek BETWEEN 1 AND 38),
    CHECK (home_score IS NULL OR home_score >= 0),
    CHECK (away_score IS NULL OR away_score >= 0),
    CHECK (attendance IS NULL OR attendance >= 0),
    CHECK (status IN ('SCHEDULED','COMPLETED','POSTPONED','CANCELLED')),
    CONSTRAINT fk_fixture_season  FOREIGN KEY (season_id)    REFERENCES seasons(season_id)  ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_fixture_stadium FOREIGN KEY (stadium_id)   REFERENCES stadiums(stadium_id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_fixture_home    FOREIGN KEY (home_club_id) REFERENCES clubs(club_id)       ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_fixture_away    FOREIGN KEY (away_club_id) REFERENCES clubs(club_id)       ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE match_events (
    event_id            INT AUTO_INCREMENT PRIMARY KEY,
    fixture_id          INT NOT NULL,
    minute_mark         INT NOT NULL,
    event_type          VARCHAR(20) NOT NULL,
    club_id             INT NOT NULL,
    player_id           INT NOT NULL,
    assisting_player_id INT NULL,
    description         VARCHAR(255),
    CHECK (minute_mark BETWEEN 1 AND 130),
    CHECK (event_type IN ('GOAL','YELLOW_CARD','RED_CARD','SUBSTITUTION','OWN_GOAL','PENALTY_GOAL')),
    CONSTRAINT fk_event_fixture FOREIGN KEY (fixture_id)          REFERENCES fixtures(fixture_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_event_club    FOREIGN KEY (club_id)             REFERENCES clubs(club_id)       ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_event_player  FOREIGN KEY (player_id)           REFERENCES players(player_id)   ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_event_assist  FOREIGN KEY (assisting_player_id) REFERENCES players(player_id)   ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE standings (
    standing_id     INT AUTO_INCREMENT PRIMARY KEY,
    season_id       INT NOT NULL,
    club_id         INT NOT NULL,
    played          INT NOT NULL DEFAULT 0,
    wins            INT NOT NULL DEFAULT 0,
    draws           INT NOT NULL DEFAULT 0,
    losses          INT NOT NULL DEFAULT 0,
    goals_for       INT NOT NULL DEFAULT 0,
    goals_against   INT NOT NULL DEFAULT 0,
    goal_difference INT NOT NULL DEFAULT 0,
    points          INT NOT NULL DEFAULT 0,
    position_no     INT,
    UNIQUE KEY uq_standing_season_club (season_id, club_id),
    UNIQUE KEY uq_standing_position    (season_id, position_no),
    CHECK (played >= 0),
    CHECK (wins >= 0),
    CHECK (draws >= 0),
    CHECK (losses >= 0),
    CHECK (goals_for >= 0),
    CHECK (goals_against >= 0),
    CHECK (goal_difference = goals_for - goals_against),
    CHECK (points = (wins * 3) + draws),
    CHECK (played = wins + draws + losses),
    CONSTRAINT fk_standing_season FOREIGN KEY (season_id) REFERENCES seasons(season_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_standing_club   FOREIGN KEY (club_id)   REFERENCES clubs(club_id)     ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE transfers (
    transfer_id   INT AUTO_INCREMENT PRIMARY KEY,
    player_id     INT           NOT NULL,
    season_id     INT           NOT NULL,
    from_club_id  INT           NULL,
    to_club_id    INT           NOT NULL,
    transfer_date DATE          NOT NULL,
    transfer_fee  DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    transfer_type VARCHAR(20)   NOT NULL DEFAULT 'PERMANENT',
    status        VARCHAR(20)   NOT NULL DEFAULT 'COMPLETED',
    CHECK (transfer_fee >= 0),
    CHECK (transfer_type IN ('PERMANENT','LOAN','FREE_AGENT')),
    CHECK (status IN ('PENDING','COMPLETED','CANCELLED')),
    CONSTRAINT fk_transfer_player    FOREIGN KEY (player_id)    REFERENCES players(player_id)   ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_transfer_season    FOREIGN KEY (season_id)    REFERENCES seasons(season_id)   ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_transfer_from_club FOREIGN KEY (from_club_id) REFERENCES clubs(club_id)       ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_transfer_to_club   FOREIGN KEY (to_club_id)   REFERENCES clubs(club_id)       ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE official_registered_squads (
    squad_entry_id       INT AUTO_INCREMENT PRIMARY KEY,
    season_name          VARCHAR(20)  NOT NULL,
    source_snapshot_date DATE         NOT NULL,
    club_name            VARCHAR(100) NOT NULL,
    player_name          VARCHAR(150) NOT NULL,
    is_home_grown        BOOLEAN      NOT NULL DEFAULT FALSE,
    squad_scope          VARCHAR(50)  NOT NULL DEFAULT 'Senior Registered Squad',
    source_note          VARCHAR(255),
    UNIQUE KEY uq_official_squad_entry (season_name, source_snapshot_date, club_name, player_name, squad_scope)
);

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX idx_player_last_name  ON players(last_name, first_name);
CREATE INDEX idx_fixture_matchweek ON fixtures(season_id, matchweek, match_date);
CREATE INDEX idx_event_type        ON match_events(event_type);
CREATE INDEX idx_transfer_date     ON transfers(transfer_date);

-- ============================================================
-- VIEWS
-- ============================================================

CREATE OR REPLACE VIEW vw_current_standings AS
SELECT s.season_name, st.position_no, c.club_name,
       st.played, st.wins, st.draws, st.losses,
       st.goals_for, st.goals_against, st.goal_difference, st.points
FROM standings st
JOIN seasons s ON st.season_id = s.season_id
JOIN clubs c   ON st.club_id   = c.club_id
ORDER BY s.season_name, st.position_no;

CREATE OR REPLACE VIEW vw_top_scorers AS
SELECT se.season_name, p.player_id,
       CONCAT(p.first_name,' ',p.last_name) AS player_name,
       c.club_name, COUNT(*) AS goals
FROM match_events me
JOIN fixtures f ON me.fixture_id = f.fixture_id
JOIN seasons se ON f.season_id   = se.season_id
JOIN players p  ON me.player_id  = p.player_id
JOIN clubs c    ON p.current_club_id = c.club_id
WHERE me.event_type IN ('GOAL','PENALTY_GOAL')
GROUP BY se.season_name, p.player_id, player_name, c.club_name
ORDER BY goals DESC, player_name;

CREATE OR REPLACE VIEW vw_current_official_squad_counts AS
SELECT season_name, source_snapshot_date, club_name,
       COUNT(*) AS registered_senior_players,
       SUM(CASE WHEN is_home_grown THEN 1 ELSE 0 END) AS home_grown_players,
       SUM(CASE WHEN is_home_grown THEN 0 ELSE 1 END) AS non_home_grown_players
FROM official_registered_squads
GROUP BY season_name, source_snapshot_date, club_name
ORDER BY club_name;

CREATE OR REPLACE VIEW vw_current_home_grown_players AS
SELECT season_name, source_snapshot_date, club_name, player_name
FROM official_registered_squads
WHERE is_home_grown = TRUE
ORDER BY club_name, player_name;

-- ============================================================
-- SEASONS
-- ============================================================

INSERT INTO seasons (season_name, start_date, end_date, status) VALUES
('2023/24', '2023-08-11', '2024-05-19', 'COMPLETED'),
('2024/25', '2024-08-16', '2025-05-25', 'COMPLETED'),
('2025/26', '2025-08-15', '2026-05-24', 'ACTIVE');

-- ============================================================
-- STADIUMS (all 20 clubs)
-- ============================================================

INSERT INTO stadiums (stadium_name, city, country, capacity) VALUES
('Emirates Stadium',          'London',        'England', 60704),  -- id 1
('Villa Park',                'Birmingham',    'England', 42682),  -- id 2
('Vitality Stadium',          'Bournemouth',   'England', 11307),  -- id 3
('Gtech Community Stadium',   'London',        'England', 17250),  -- id 4
('Amex Stadium',              'Brighton',      'England', 31800),  -- id 5
('Stamford Bridge',           'London',        'England', 40343),  -- id 6
('Selhurst Park',             'London',        'England', 25486),  -- id 7
('Goodison Park',             'Liverpool',     'England', 39414),  -- id 8
('Craven Cottage',            'London',        'England', 29600),  -- id 9
('Portman Road',              'Ipswich',       'England', 29837),  -- id 10
('King Power Stadium',        'Leicester',     'England', 32312),  -- id 11
('Anfield',                   'Liverpool',     'England', 61276),  -- id 12
('Etihad Stadium',            'Manchester',    'England', 53400),  -- id 13
('Old Trafford',              'Manchester',    'England', 74031),  -- id 14
('St James Park',             'Newcastle',     'England', 52305),  -- id 15
('City Ground',               'Nottingham',    'England', 30445),  -- id 16
('St Marys Stadium',          'Southampton',   'England', 32384),  -- id 17
('Tottenham Hotspur Stadium', 'London',        'England', 62850),  -- id 18
('London Stadium',            'London',        'England', 62500),  -- id 19
('Molineux Stadium',          'Wolverhampton', 'England', 31750);  -- id 20

-- ============================================================
-- CLUBS (all 20 current Premier League clubs)
-- ============================================================

INSERT INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id) VALUES
('Arsenal',                 'ARS', 1886, 'Mikel Arteta',        'Emirates',           1),  -- id 1
('Aston Villa',             'AVL', 1874, 'Unai Emery',          'Cazoo',              2),  -- id 2
('AFC Bournemouth',         'BOU', 1899, 'Andoni Iraola',       'Dafabet',            3),  -- id 3
('Brentford',               'BRE', 1889, 'Thomas Frank',        'Hollywoodbets',      4),  -- id 4
('Brighton & Hove Albion',  'BHA', 1901, 'Fabian Hurzeler',     'American Express',   5),  -- id 5
('Chelsea',                 'CHE', 1905, 'Enzo Maresca',        'Infinite Athlete',   6),  -- id 6
('Crystal Palace',          'CRY', 1905, 'Oliver Glasner',      'Cinch',              7),  -- id 7
('Everton',                 'EVE', 1878, 'David Moyes',         'Stake.com',          8),  -- id 8
('Fulham',                  'FUL', 1879, 'Marco Silva',         'W88',                9),  -- id 9
('Ipswich Town',            'IPS', 1878, 'Kieran McKenna',      'bet365',            10),  -- id 10
('Leicester City',          'LEI', 1884, 'Steve Cooper',        'Sportsbet.io',      11),  -- id 11
('Liverpool',               'LIV', 1892, 'Arne Slot',           'Standard Chartered',12),  -- id 12
('Manchester City',         'MCI', 1880, 'Pep Guardiola',       'Etihad Airways',    13),  -- id 13
('Manchester United',       'MUN', 1878, 'Ruben Amorim',        'TeamViewer',        14),  -- id 14
('Newcastle United',        'NEW', 1892, 'Eddie Howe',          'Fun88',             15),  -- id 15
('Nottingham Forest',       'NFO', 1865, 'Nuno Espirito Santo', 'UNHCR',             16),  -- id 16
('Southampton',             'SOU', 1885, 'Ivan Juric',          'Sportsbet.io',      17),  -- id 17
('Tottenham Hotspur',       'TOT', 1882, 'Ange Postecoglou',    'AIA',               18),  -- id 18
('West Ham United',         'WHU', 1895, 'Graham Potter',       'Betway',            19),  -- id 19
('Wolverhampton Wanderers', 'WOL', 1877, 'Vitor Pereira',       'AstroPay',          20);  -- id 20

-- ============================================================
-- POSITIONS
-- ============================================================

INSERT INTO positions (position_code, position_name) VALUES
('GK', 'Goalkeeper'),   -- id 1
('DF', 'Defender'),     -- id 2
('MF', 'Midfielder'),   -- id 3
('FW', 'Forward');      -- id 4

-- ============================================================
-- PLAYERS (4-5 per club, 88 total)
-- club_id: ARS=1 AVL=2 BOU=3 BRE=4 BHA=5 CHE=6 CRY=7 EVE=8
--          FUL=9 IPS=10 LEI=11 LIV=12 MCI=13 MUN=14 NEW=15
--          NFO=16 SOU=17 TOT=18 WHU=19 WOL=20
-- position_id: GK=1 DF=2 MF=3 FW=4
-- ============================================================

INSERT INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
-- Arsenal (club 1) | players 1-5
('David',      'Raya',              '1995-09-14', 'Spain',         1, 22, 'Right',  1,  25000000.00),
('Gabriel',    'Magalhaes',         '1997-12-19', 'Brazil',        2,  6, 'Left',   1,  65000000.00),
('Martin',     'Odegaard',          '1998-12-17', 'Norway',        3,  8, 'Right',  1,  90000000.00),
('Declan',     'Rice',              '1999-01-14', 'England',       3, 41, 'Right',  1, 100000000.00),
('Bukayo',     'Saka',              '2001-09-05', 'England',       4,  7, 'Left',   1, 130000000.00),
-- Aston Villa (club 2) | players 6-9
('Emiliano',   'Martinez',          '1992-09-02', 'Argentina',     1,  1, 'Right',  2,  30000000.00),
('Ezri',       'Konsa',             '1997-10-23', 'England',       2,  4, 'Right',  2,  45000000.00),
('Morgan',     'Rogers',            '2002-07-26', 'England',       3, 10, 'Right',  2,  45000000.00),
('Ollie',      'Watkins',           '1995-12-30', 'England',       4, 11, 'Right',  2,  70000000.00),
-- Bournemouth (club 3) | players 10-13
('Neto',       'Murara',            '1989-07-19', 'Brazil',        1, 13, 'Right',  3,   5000000.00),
('Marcos',     'Senesi',            '1997-05-10', 'Argentina',     2, 25, 'Right',  3,  25000000.00),
('Lewis',      'Cook',              '1997-02-03', 'England',       3,  4, 'Right',  3,  18000000.00),
('Antoine',    'Semenyo',           '2000-01-07', 'Ghana',         4, 24, 'Right',  3,  30000000.00),
-- Brentford (club 4) | players 14-17
('Mark',       'Flekken',           '1993-06-13', 'Netherlands',   1,  1, 'Right',  4,  12000000.00),
('Nathan',     'Collins',           '2001-04-30', 'Ireland',       2,  5, 'Right',  4,  35000000.00),
('Bryan',      'Mbeumo',            '1999-08-07', 'Cameroon',      4, 19, 'Right',  4,  55000000.00),
('Yoane',      'Wissa',             '1996-09-03', 'DR Congo',      4, 11, 'Right',  4,  35000000.00),
-- Brighton (club 5) | players 18-21
('Bart',       'Verbruggen',        '2002-08-18', 'Netherlands',   1,  1, 'Right',  5,  20000000.00),
('Lewis',      'Dunk',              '1991-11-21', 'England',       2,  5, 'Right',  5,  10000000.00),
('Billy',      'Gilmour',           '2001-06-11', 'Scotland',      3, 29, 'Right',  5,  25000000.00),
('Simon',      'Adingra',           '2002-01-03', 'Ivory Coast',   4, 23, 'Right',  5,  30000000.00),
-- Chelsea (club 6) | players 22-26
('Robert',     'Sanchez',           '1997-11-18', 'Spain',         1,  1, 'Right',  6,  20000000.00),
('Reece',      'James',             '1999-12-08', 'England',       2, 24, 'Right',  6,  50000000.00),
('Moises',     'Caicedo',           '2001-11-02', 'Ecuador',       3, 25, 'Right',  6,  80000000.00),
('Cole',       'Palmer',            '2002-05-06', 'England',       3, 20, 'Left',   6, 100000000.00),
('Nicolas',    'Jackson',           '2001-06-20', 'Senegal',       4, 15, 'Right',  6,  60000000.00),
-- Crystal Palace (club 7) | players 27-30
('Dean',       'Henderson',         '1997-03-12', 'England',       1,  1, 'Right',  7,  12000000.00),
('Marc',       'Guehi',             '2000-07-13', 'England',       2,  6, 'Right',  7,  60000000.00),
('Eberechi',   'Eze',               '1998-06-29', 'England',       3, 10, 'Right',  7,  70000000.00),
('Jean-Philippe','Mateta',          '1997-06-28', 'France',        4, 14, 'Right',  7,  35000000.00),
-- Everton (club 8) | players 31-34
('Jordan',     'Pickford',          '1994-03-07', 'England',       1,  1, 'Right',  8,  22000000.00),
('Jarrad',     'Branthwaite',       '2002-06-27', 'England',       2, 32, 'Right',  8,  75000000.00),
('James',      'Garner',            '2001-03-13', 'England',       3, 37, 'Right',  8,  22000000.00),
('Dominic',    'Calvert-Lewin',     '1997-03-16', 'England',       4,  9, 'Right',  8,  28000000.00),
-- Fulham (club 9) | players 35-38
('Bernd',      'Leno',              '1992-03-04', 'Germany',       1, 17, 'Right',  9,   8000000.00),
('Antonee',    'Robinson',          '1997-08-08', 'USA',           2, 33, 'Left',   9,  25000000.00),
('Andreas',    'Pereira',           '1996-01-01', 'Brazil',        3, 18, 'Right',  9,  20000000.00),
('Raul',       'Jimenez',           '1991-05-05', 'Mexico',        4,  7, 'Right',  9,  12000000.00),
-- Ipswich Town (club 10) | players 39-42
('Christian',  'Walton',            '1995-11-09', 'England',       1,  1, 'Right', 10,   4000000.00),
('Leif',       'Davis',             '1999-12-31', 'England',       2,  3, 'Left',  10,  20000000.00),
('Kalvin',     'Phillips',          '1995-12-02', 'England',       3, 23, 'Right', 10,  15000000.00),
('Liam',       'Delap',             '2003-02-08', 'England',       4, 19, 'Right', 10,  40000000.00),
-- Leicester City (club 11) | players 43-46
('Mads',       'Hermansen',         '1999-09-08', 'Denmark',       1,  1, 'Right', 11,  15000000.00),
('Wout',       'Faes',              '1998-04-03', 'Belgium',       2,  3, 'Right', 11,  20000000.00),
('Kiernan',    'Dewsbury-Hall',     '1998-09-06', 'England',       3,  8, 'Right', 11,  35000000.00),
('Jamie',      'Vardy',             '1987-01-11', 'England',       4,  9, 'Right', 11,   3000000.00),
-- Liverpool (club 12) | players 47-51
('Alisson',    'Becker',            '1992-10-02', 'Brazil',        1,  1, 'Right', 12,  40000000.00),
('Virgil',     'van Dijk',          '1991-07-08', 'Netherlands',   2,  4, 'Right', 12,  35000000.00),
('Trent',      'Alexander-Arnold',  '1998-10-07', 'England',       2, 66, 'Right', 12,  80000000.00),
('Dominik',    'Szoboszlai',        '2000-10-25', 'Hungary',       3,  8, 'Right', 12,  70000000.00),
('Mohamed',    'Salah',             '1992-06-15', 'Egypt',         4, 11, 'Left',  12,  40000000.00),
-- Manchester City (club 13) | players 52-56
('Ederson',    'Moraes',            '1993-08-17', 'Brazil',        1, 31, 'Right', 13,  35000000.00),
('Ruben',      'Dias',              '1997-05-14', 'Portugal',      2,  3, 'Right', 13,  70000000.00),
('Kevin',      'De Bruyne',         '1991-06-28', 'Belgium',       3, 17, 'Right', 13,  45000000.00),
('Phil',       'Foden',             '2000-05-28', 'England',       3, 47, 'Right', 13, 150000000.00),
('Erling',     'Haaland',           '2000-07-21', 'Norway',        4,  9, 'Left',  13, 200000000.00),
-- Manchester United (club 14) | players 57-61
('Andre',      'Onana',             '1996-04-02', 'Cameroon',      1, 24, 'Right', 14,  30000000.00),
('Lisandro',   'Martinez',          '1998-01-18', 'Argentina',     2,  6, 'Left',  14,  55000000.00),
('Bruno',      'Fernandes',         '1994-09-08', 'Portugal',      3,  8, 'Right', 14,  55000000.00),
('Marcus',     'Rashford',          '1997-10-31', 'England',       4, 10, 'Right', 14,  40000000.00),
('Rasmus',     'Hojlund',           '2003-02-04', 'Denmark',       4, 11, 'Right', 14,  70000000.00),
-- Newcastle United (club 15) | players 62-66
('Nick',       'Pope',              '1992-04-19', 'England',       1, 22, 'Right', 15,  20000000.00),
('Sven',       'Botman',            '2000-01-12', 'Netherlands',   2,  4, 'Right', 15,  40000000.00),
('Bruno',      'Guimaraes',         '1997-11-16', 'Brazil',        3, 39, 'Right', 15,  85000000.00),
('Anthony',    'Gordon',            '2001-02-24', 'England',       4, 10, 'Left',  15,  65000000.00),
('Alexander',  'Isak',              '1999-09-21', 'Sweden',        4, 14, 'Right', 15, 120000000.00),
-- Nottingham Forest (club 16) | players 67-70
('Matz',       'Sels',              '1992-02-26', 'Belgium',       1,  1, 'Right', 16,   8000000.00),
('Murillo',    'Ceballos',          '2002-04-26', 'Brazil',        2, 40, 'Right', 16,  40000000.00),
('Morgan',     'Gibbs-White',       '2000-01-27', 'England',       3, 10, 'Right', 16,  55000000.00),
('Chris',      'Wood',              '1991-12-07', 'New Zealand',   4, 11, 'Right', 16,  12000000.00),
-- Southampton (club 17) | players 71-74
('Alex',       'McCarthy',          '1989-12-03', 'England',       1, 13, 'Right', 17,   3000000.00),
('Jan',        'Bednarek',          '1996-04-12', 'Poland',        2, 35, 'Right', 17,  12000000.00),
('Will',       'Smallbone',         '2000-02-21', 'Ireland',       3, 27, 'Right', 17,  20000000.00),
('Adam',       'Armstrong',         '1997-02-10', 'England',       4, 11, 'Right', 17,  15000000.00),
-- Tottenham Hotspur (club 18) | players 75-79
('Guglielmo',  'Vicario',           '1996-10-07', 'Italy',         1, 13, 'Right', 18,  30000000.00),
('Micky',      'van de Ven',        '2001-04-19', 'Netherlands',   2, 37, 'Left',  18,  60000000.00),
('Cristian',   'Romero',            '1998-04-27', 'Argentina',     2, 17, 'Right', 18,  65000000.00),
('James',      'Maddison',          '1996-11-23', 'England',       3, 10, 'Right', 18,  45000000.00),
('Son',        'Heung-min',         '1992-07-08', 'South Korea',   4,  7, 'Left',  18,  30000000.00),
-- West Ham United (club 19) | players 80-84
('Alphonse',   'Areola',            '1993-02-27', 'France',        1, 23, 'Right', 19,   8000000.00),
('Aaron',      'Wan-Bissaka',       '1997-11-26', 'England',       2, 29, 'Right', 19,  18000000.00),
('Lucas',      'Paqueta',           '1997-08-27', 'Brazil',        3, 11, 'Right', 19,  45000000.00),
('Jarrod',     'Bowen',             '1996-12-20', 'England',       4, 20, 'Right', 19,  55000000.00),
('Mohammed',   'Kudus',             '2000-08-02', 'Ghana',         4, 14, 'Right', 19,  55000000.00),
-- Wolverhampton Wanderers (club 20) | players 85-88
('Jose',       'Sa',                '1993-01-17', 'Portugal',      1,  1, 'Right', 20,  15000000.00),
('Nelson',     'Semedo',            '1993-11-16', 'Portugal',      2, 22, 'Right', 20,  15000000.00),
('Joao',       'Gomes',             '2001-02-13', 'Brazil',        3, 35, 'Right', 20,  35000000.00),
('Matheus',    'Cunha',             '1999-05-27', 'Brazil',        4, 12, 'Right', 20,  65000000.00);

-- ============================================================
-- CLUB REGISTRATIONS (all 20 clubs, seasons 2 and 3)
-- ============================================================

INSERT INTO club_registrations (season_id, club_id, registration_date, registration_status) VALUES
(2,1,'2024-08-01','APPROVED'),(2,2,'2024-08-01','APPROVED'),(2,3,'2024-08-01','APPROVED'),(2,4,'2024-08-01','APPROVED'),
(2,5,'2024-08-01','APPROVED'),(2,6,'2024-08-01','APPROVED'),(2,7,'2024-08-01','APPROVED'),(2,8,'2024-08-01','APPROVED'),
(2,9,'2024-08-01','APPROVED'),(2,10,'2024-08-01','APPROVED'),(2,11,'2024-08-01','APPROVED'),(2,12,'2024-08-01','APPROVED'),
(2,13,'2024-08-01','APPROVED'),(2,14,'2024-08-01','APPROVED'),(2,15,'2024-08-01','APPROVED'),(2,16,'2024-08-01','APPROVED'),
(2,17,'2024-08-01','APPROVED'),(2,18,'2024-08-01','APPROVED'),(2,19,'2024-08-01','APPROVED'),(2,20,'2024-08-01','APPROVED'),
(3,1,'2025-08-01','APPROVED'),(3,2,'2025-08-01','APPROVED'),(3,3,'2025-08-01','APPROVED'),(3,4,'2025-08-01','APPROVED'),
(3,5,'2025-08-01','APPROVED'),(3,6,'2025-08-01','APPROVED'),(3,7,'2025-08-01','APPROVED'),(3,8,'2025-08-01','APPROVED'),
(3,9,'2025-08-01','APPROVED'),(3,10,'2025-08-01','APPROVED'),(3,11,'2025-08-01','APPROVED'),(3,12,'2025-08-01','APPROVED'),
(3,13,'2025-08-01','APPROVED'),(3,14,'2025-08-01','APPROVED'),(3,15,'2025-08-01','APPROVED'),(3,16,'2025-08-01','APPROVED'),
(3,17,'2025-08-01','APPROVED'),(3,18,'2025-08-01','APPROVED'),(3,19,'2025-08-01','APPROVED'),(3,20,'2025-08-01','APPROVED');

-- ============================================================
-- FIXTURES - Matchweek 1 & 2 of 2025/26 (season_id=3)
-- stadium_id matches the home club's stadium
-- ============================================================

INSERT INTO fixtures (season_id, matchweek, match_date, stadium_id, home_club_id, away_club_id, home_score, away_score, status, attendance) VALUES
-- Matchweek 1 (all COMPLETED)
(3,1,'2025-08-16 12:30:00', 1,  1, 20,  2, 1, 'COMPLETED', 60000),  -- Arsenal 2-1 Wolves          | f1
(3,1,'2025-08-16 15:00:00', 2,  2, 19,  1, 0, 'COMPLETED', 42000),  -- Aston Villa 1-0 West Ham     | f2
(3,1,'2025-08-16 15:00:00', 4,  4,  7,  1, 2, 'COMPLETED', 17000),  -- Brentford 1-2 Crystal Palace | f3
(3,1,'2025-08-16 15:00:00', 5,  5,  8,  2, 2, 'COMPLETED', 31500),  -- Brighton 2-2 Everton         | f4
(3,1,'2025-08-16 17:30:00', 6,  6, 13,  3, 1, 'COMPLETED', 40000),  -- Chelsea 3-1 Man City         | f5
(3,1,'2025-08-17 14:00:00', 9,  9,  3,  2, 0, 'COMPLETED', 29000),  -- Fulham 2-0 Bournemouth       | f6
(3,1,'2025-08-17 14:00:00',11, 11, 14,  1, 3, 'COMPLETED', 32000),  -- Leicester 1-3 Man United     | f7
(3,1,'2025-08-17 16:30:00',12, 12, 10,  3, 1, 'COMPLETED', 61000),  -- Liverpool 3-1 Ipswich        | f8
(3,1,'2025-08-17 14:00:00',15, 15, 17,  2, 0, 'COMPLETED', 52000),  -- Newcastle 2-0 Southampton    | f9
(3,1,'2025-08-17 14:00:00',18, 18, 16,  2, 1, 'COMPLETED', 62500),  -- Tottenham 2-1 Nottm Forest   | f10
-- Matchweek 2 (all COMPLETED)
(3,2,'2025-08-23 15:00:00', 3,  3, 15,  0, 2, 'COMPLETED', 11000),  -- Bournemouth 0-2 Newcastle    | f11
(3,2,'2025-08-23 15:00:00', 7,  7,  1,  0, 2, 'COMPLETED', 25000),  -- Crystal Palace 0-2 Arsenal   | f12
(3,2,'2025-08-23 15:00:00', 8,  8,  6,  1, 2, 'COMPLETED', 39000),  -- Everton 1-2 Chelsea          | f13
(3,2,'2025-08-23 15:00:00',10, 10,  5,  1, 3, 'COMPLETED', 29500),  -- Ipswich 1-3 Brighton         | f14
(3,2,'2025-08-23 17:30:00',13, 13, 11,  3, 0, 'COMPLETED', 53000),  -- Man City 3-0 Leicester       | f15
(3,2,'2025-08-24 14:00:00',14, 14,  9,  2, 1, 'COMPLETED', 73000),  -- Man United 2-1 Fulham        | f16
(3,2,'2025-08-24 14:00:00',16, 16, 12,  1, 2, 'COMPLETED', 30000),  -- Nottm Forest 1-2 Liverpool   | f17
(3,2,'2025-08-24 14:00:00',17, 17, 18,  0, 3, 'COMPLETED', 31500),  -- Southampton 0-3 Tottenham    | f18
(3,2,'2025-08-24 14:00:00',19, 19,  4,  2, 1, 'COMPLETED', 62000),  -- West Ham 2-1 Brentford       | f19
(3,2,'2025-08-24 14:00:00',20, 20,  2,  2, 2, 'COMPLETED', 31000),  -- Wolves 2-2 Aston Villa       | f20
-- Matchweek 32 (SCHEDULED - upcoming)
(3,32,'2026-04-18 15:00:00', 1,  1, 12, NULL, NULL, 'SCHEDULED', NULL),  -- Arsenal vs Liverpool
(3,32,'2026-04-18 15:00:00',13, 13, 18, NULL, NULL, 'SCHEDULED', NULL),  -- Man City vs Tottenham
(3,32,'2026-04-19 14:00:00', 6,  6, 15, NULL, NULL, 'SCHEDULED', NULL),  -- Chelsea vs Newcastle
(3,32,'2026-04-19 14:00:00', 2,  2,  5, NULL, NULL, 'SCHEDULED', NULL),  -- Aston Villa vs Brighton
(3,32,'2026-04-19 14:00:00',16, 16, 14, NULL, NULL, 'SCHEDULED', NULL);  -- Nottm Forest vs Man United

-- ============================================================
-- MATCH EVENTS (goals from MW1 and MW2)
-- player IDs: Saka=5,Rice=4,Cunha=88,Watkins=9,Mbeumo=16,Eze=29,Mateta=30,
--             Adingra=21,Gilmour=20,Calvert-Lewin=34,Palmer=25,Jackson=26,Caicedo=24,
--             Haaland=56,De Bruyne=54,Jimenez=38,Robinson=36,Pereira=37,
--             Fernandes=59,Vardy=46,Rashford=60,Hojlund=61,Salah=51,
--             Szoboszlai=50,van Dijk=48,Delap=42,Isak=66,Gordon=65,
--             Son=79,Maddison=78,Wood=70,Guimaraes=64,Bowen=83
-- ============================================================

INSERT INTO match_events (fixture_id, minute_mark, event_type, club_id, player_id, assisting_player_id, description) VALUES
-- f1: Arsenal 2-1 Wolves
(1, 23, 'GOAL',  1,  5,  3, 'Saka curls in from the right'),
(1, 56, 'GOAL',  1,  4, NULL, 'Rice thunders in from distance'),
(1, 71, 'GOAL', 20, 88, NULL, 'Cunha pulls one back for Wolves'),
-- f2: Aston Villa 1-0 West Ham
(2, 45, 'GOAL',  2,  9,  8, 'Watkins heads in Rogers cross'),
-- f3: Brentford 1-2 Crystal Palace
(3, 33, 'GOAL',  4, 16, NULL, 'Mbeumo finishes from close range'),
(3, 67, 'GOAL',  7, 29, 30, 'Eze curls in assisted by Mateta'),
(3, 88, 'GOAL',  7, 30, NULL, 'Mateta taps in at the far post'),
-- f4: Brighton 2-2 Everton
(4, 15, 'GOAL',  5, 21, NULL, 'Adingra fires in on the break'),
(4, 42, 'GOAL',  8, 34, 32, 'Calvert-Lewin heads in Branthwaite long ball'),
(4, 68, 'GOAL',  8, 34, NULL, 'Calvert-Lewin slots home the equalizer'),
(4, 85, 'GOAL',  5, 20, NULL, 'Gilmour drives in a late leveller'),
-- f5: Chelsea 3-1 Man City
(5, 12, 'GOAL',  6, 25, NULL, 'Palmer opens scoring with a free kick'),
(5, 35, 'GOAL', 13, 56, 54, 'Haaland converts De Bruyne cross'),
(5, 55, 'GOAL',  6, 26, 25, 'Jackson tucks in assisted by Palmer'),
(5, 78, 'GOAL',  6, 24, NULL, 'Caicedo powers in from midfield'),
-- f6: Fulham 2-0 Bournemouth
(6, 28, 'GOAL',  9, 38, 36, 'Jimenez finishes Robinson cross'),
(6, 71, 'GOAL',  9, 37, NULL, 'Pereira seals it with a long-range effort'),
-- f7: Leicester 1-3 Man United
(7, 22, 'GOAL', 14, 59, NULL, 'Fernandes opens with a penalty'),
(7, 45, 'GOAL', 11, 46, NULL, 'Vardy equalises with a sharp finish'),
(7, 61, 'GOAL', 14, 60, 59, 'Rashford restored the lead'),
(7, 80, 'GOAL', 14, 61, NULL, 'Hojlund seals it with a powerful header'),
-- f8: Liverpool 3-1 Ipswich
(8,  8, 'GOAL', 12, 51, NULL, 'Salah opens scoring early'),
(8, 31, 'GOAL', 12, 50, 51, 'Szoboszlai doubles the lead'),
(8, 58, 'GOAL', 10, 42, NULL, 'Delap pulls one back for Ipswich'),
(8, 77, 'GOAL', 12, 48, NULL, 'Van Dijk heads in from a corner'),
-- f9: Newcastle 2-0 Southampton
(9, 20, 'GOAL', 15, 66, 65, 'Isak finishes Gordon assist'),
(9, 65, 'GOAL', 15, 65, NULL, 'Gordon drives in a second'),
-- f10: Tottenham 2-1 Nottm Forest
(10, 14, 'GOAL', 18, 79, 78, 'Son finishes Maddison through ball'),
(10, 50, 'GOAL', 16, 70, NULL, 'Wood heads in for Forest'),
(10, 82, 'GOAL', 18, 78, NULL, 'Maddison seals it with a free kick'),
-- MW2 goals
-- f11: Bournemouth 0-2 Newcastle
(11, 35, 'GOAL', 15, 66, 64, 'Isak scores again'),
(11, 78, 'GOAL', 15, 64, NULL, 'Guimaraes adds a second'),
-- f12: Crystal Palace 0-2 Arsenal
(12, 18, 'GOAL',  1,  5, NULL, 'Saka races in on goal'),
(12, 62, 'GOAL',  1,  3, NULL, 'Odegaard curls in beautifully'),
-- f13: Everton 1-2 Chelsea
(13, 25, 'GOAL',  6, 25, NULL, 'Palmer scores from the spot'),
(13, 55, 'GOAL',  8, 34, NULL, 'Calvert-Lewin equalises'),
(13, 88, 'GOAL',  6, 26, 25, 'Jackson wins it late'),
-- f14: Ipswich 1-3 Brighton
(14, 10, 'GOAL',  5, 21, NULL, 'Adingra opens quickly'),
(14, 33, 'GOAL',  5, 20, 21, 'Gilmour taps in'),
(14, 60, 'GOAL', 10, 42, NULL, 'Delap scores for Ipswich'),
(14, 83, 'GOAL',  5, 19, NULL, 'Dunk heads in from a corner'),
-- f15: Man City 3-0 Leicester
(15, 20, 'GOAL', 13, 56, 54, 'Haaland nets first of the game'),
(15, 48, 'GOAL', 13, 55, NULL, 'Foden adds a second'),
(15, 74, 'GOAL', 13, 56, NULL, 'Haaland completes a brace'),
-- f16: Man United 2-1 Fulham
(16, 30, 'GOAL', 14, 59, NULL, 'Fernandes free kick'),
(16, 58, 'GOAL',  9, 38, NULL, 'Jimenez replies for Fulham'),
(16, 85, 'GOAL', 14, 61, NULL, 'Hojlund wins it late'),
-- f17: Nottm Forest 1-2 Liverpool
(17, 22, 'GOAL', 12, 51, NULL, 'Salah strikes early'),
(17, 55, 'GOAL', 16, 69, NULL, 'Gibbs-White equalises'),
(17, 79, 'GOAL', 12, 50, NULL, 'Szoboszlai wins it'),
-- f18: Southampton 0-3 Tottenham
(18, 15, 'GOAL', 18, 79, NULL, 'Son taps in early'),
(18, 44, 'GOAL', 18, 78, NULL, 'Maddison doubles the lead'),
(18, 70, 'GOAL', 18, 76, NULL, 'Van de Ven headers in'),
-- f19: West Ham 2-1 Brentford
(19, 28, 'GOAL', 19, 83, 82, 'Bowen finishes Paqueta assist'),
(19, 51, 'GOAL',  4, 16, NULL, 'Mbeumo replies'),
(19, 88, 'GOAL', 19, 84, NULL, 'Kudus wins it at the death'),
-- f20: Wolves 2-2 Aston Villa
(20, 19, 'GOAL', 20, 88, NULL, 'Cunha opens the scoring'),
(20, 40, 'GOAL',  2,  9, NULL, 'Watkins equalises'),
(20, 65, 'GOAL',  2,  8, NULL, 'Rogers puts Villa ahead'),
(20, 90, 'GOAL', 20, 88, NULL, 'Cunha saves a point for Wolves');

-- ============================================================
-- STANDINGS
-- 2024/25 COMPLETED (season_id=2) - Liverpool Champions
-- 2025/26 ACTIVE   (season_id=3) - Matchweek 32, April 2026
-- All constraints satisfied: played=W+D+L, pts=W*3+D, GD=GF-GA
-- ============================================================

INSERT INTO standings (season_id, club_id, played, wins, draws, losses, goals_for, goals_against, goal_difference, points, position_no) VALUES
-- 2024/25 Final Table (season_id=2)
(2, 12, 38, 26,  6,  6,  82, 40,  42, 84,  1),  -- Liverpool
(2,  1, 38, 24,  8,  6,  73, 35,  38, 80,  2),  -- Arsenal
(2,  6, 38, 22,  6, 10,  70, 52,  18, 72,  3),  -- Chelsea
(2, 13, 38, 21,  7, 10,  71, 48,  23, 70,  4),  -- Manchester City
(2, 16, 38, 20,  5, 13,  55, 44,  11, 65,  5),  -- Nottingham Forest
(2, 15, 38, 18,  8, 12,  60, 48,  12, 62,  6),  -- Newcastle United
(2,  2, 38, 18,  6, 14,  61, 54,   7, 60,  7),  -- Aston Villa
(2, 18, 38, 16,  9, 13,  58, 56,   2, 57,  8),  -- Tottenham Hotspur
(2,  5, 38, 15,  9, 14,  58, 60,  -2, 54,  9),  -- Brighton
(2,  9, 38, 15,  7, 16,  52, 55,  -3, 52, 10),  -- Fulham
(2,  4, 38, 13,  9, 16,  50, 58,  -8, 48, 11),  -- Brentford
(2,  7, 38, 13,  7, 18,  45, 62, -17, 46, 12),  -- Crystal Palace
(2, 19, 38, 12,  8, 18,  48, 66, -18, 44, 13),  -- West Ham United
(2,  3, 38, 12,  6, 20,  50, 66, -16, 42, 14),  -- AFC Bournemouth
(2, 20, 38, 11,  8, 19,  42, 63, -21, 41, 15),  -- Wolves
(2,  8, 38, 10,  8, 20,  42, 68, -26, 38, 16),  -- Everton
(2, 14, 38, 10,  5, 23,  40, 70, -30, 35, 17),  -- Manchester United
(2, 11, 38,  7,  6, 25,  38, 78, -40, 27, 18),  -- Leicester City
(2, 10, 38,  5,  9, 24,  35, 80, -45, 24, 19),  -- Ipswich Town
(2, 17, 38,  4,  4, 30,  28, 89, -61, 16, 20),  -- Southampton
-- 2025/26 Current Table (season_id=3) - 32 games played
(3,  1, 32, 24,  4,  4,  68, 28,  40, 76,  1),  -- Arsenal
(3, 12, 32, 22,  5,  5,  70, 35,  35, 71,  2),  -- Liverpool
(3, 13, 32, 20,  6,  6,  62, 38,  24, 66,  3),  -- Manchester City
(3,  6, 32, 19,  5,  8,  58, 42,  16, 62,  4),  -- Chelsea
(3, 16, 32, 17,  7,  8,  50, 38,  12, 58,  5),  -- Nottingham Forest
(3, 15, 32, 17,  5, 10,  55, 44,  11, 56,  6),  -- Newcastle United
(3,  2, 32, 16,  6, 10,  54, 46,   8, 54,  7),  -- Aston Villa
(3, 18, 32, 15,  7, 10,  54, 48,   6, 52,  8),  -- Tottenham Hotspur
(3,  5, 32, 14,  8, 10,  50, 46,   4, 50,  9),  -- Brighton
(3,  9, 32, 14,  6, 12,  48, 48,   0, 48, 10),  -- Fulham
(3,  4, 32, 13,  7, 12,  46, 48,  -2, 46, 11),  -- Brentford
(3, 19, 32, 12,  8, 12,  44, 50,  -6, 44, 12),  -- West Ham United
(3,  7, 32, 12,  6, 14,  40, 50, -10, 42, 13),  -- Crystal Palace
(3,  3, 32, 11,  8, 13,  44, 52,  -8, 41, 14),  -- AFC Bournemouth
(3,  8, 32, 10,  8, 14,  38, 54, -16, 38, 15),  -- Everton
(3, 20, 32,  9,  8, 15,  40, 58, -18, 35, 16),  -- Wolves
(3, 14, 32,  9,  6, 17,  36, 60, -24, 33, 17),  -- Manchester United
(3, 11, 32,  7,  6, 19,  32, 66, -34, 27, 18),  -- Leicester City
(3, 10, 32,  5,  8, 19,  30, 68, -38, 23, 19),  -- Ipswich Town
(3, 17, 32,  3,  5, 24,  22, 80, -58, 14, 20);  -- Southampton

-- ============================================================
-- TRANSFERS (notable 2024/25 and 2025/26 summer windows)
-- ============================================================

INSERT INTO transfers (player_id, season_id, from_club_id, to_club_id, transfer_date, transfer_fee, transfer_type, status) VALUES
-- Summer 2024 (2024/25 season_id=2)
(81, 2, 14, 19, '2024-08-01',  15000000.00, 'PERMANENT', 'COMPLETED'),  -- Wan-Bissaka: Man Utd -> West Ham
(61, 2, NULL, 14, '2024-07-15', 72000000.00, 'PERMANENT', 'COMPLETED'),  -- Hojlund signed (Man Utd)
-- Summer 2025 (2025/26 season_id=3)
(42, 3, 13, 10, '2025-07-01',  20000000.00, 'PERMANENT', 'COMPLETED'),  -- Delap: Man City -> Ipswich
(41, 3, 13, 10, '2025-07-15',  12000000.00, 'PERMANENT', 'COMPLETED'),  -- K.Phillips: Man City -> Ipswich
(64, 3,  2, 15, '2025-07-20',  45000000.00, 'PERMANENT', 'COMPLETED'),  -- Guimaraes retained at Newcastle
(66, 3, NULL, 15,'2025-07-10', 70000000.00, 'PERMANENT', 'COMPLETED');  -- Isak contract extended

-- ============================================================
-- OFFICIAL REGISTERED SQUADS (2025/26 PL - Feb 2026 snapshot)
-- ============================================================

INSERT IGNORE INTO official_registered_squads (season_name, source_snapshot_date, club_name, player_name, is_home_grown, squad_scope, source_note) VALUES
('2025/26','2026-02-05','AFC Bournemouth','Adams, Tyler',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','AFC Bournemouth','Cook, Lewis',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','AFC Bournemouth','Kluivert, Justin',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','AFC Bournemouth','Scott, Alex',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','AFC Bournemouth','Semenyo, Antoine',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','AFC Bournemouth','Senesi, Marcos',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','AFC Bournemouth','Smith, Adam',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Arsenal','Calafiori, Riccardo',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Arsenal','Magalhaes, Gabriel',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Arsenal','Odegaard, Martin',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Arsenal','Raya, David',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Arsenal','Rice, Declan',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Arsenal','Saka, Bukayo',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Arsenal','Saliba, William',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Arsenal','White, Benjamin',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Aston Villa','Konsa, Ezri',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Aston Villa','Martinez, Emiliano',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Aston Villa','McGinn, John',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Aston Villa','Rogers, Morgan',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Aston Villa','Watkins, Ollie',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Brentford','Collins, Nathan',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Brentford','Flekken, Mark',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Brentford','Mbeumo, Bryan',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Brentford','Wissa, Yoane',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Brighton & Hove Albion','Adingra, Simon',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Brighton & Hove Albion','Dunk, Lewis',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Brighton & Hove Albion','Gilmour, Billy',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Brighton & Hove Albion','Verbruggen, Bart',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Chelsea','Caicedo, Moises',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Chelsea','Colwill, Levi',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Chelsea','Jackson, Nicolas',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Chelsea','James, Reece',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Chelsea','Madueke, Noni',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Chelsea','Palmer, Cole',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Chelsea','Sanchez, Robert',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Crystal Palace','Eze, Eberechi',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Crystal Palace','Guehi, Marc',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Crystal Palace','Henderson, Dean',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Crystal Palace','Mateta, Jean-Philippe',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Everton','Branthwaite, Jarrad',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Everton','Calvert-Lewin, Dominic',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Everton','Garner, James',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Everton','Pickford, Jordan',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Fulham','Leno, Bernd',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Fulham','Pereira, Andreas',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Fulham','Robinson, Antonee',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Ipswich Town','Davis, Leif',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Ipswich Town','Delap, Liam',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Ipswich Town','Phillips, Kalvin',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Leicester City','Dewsbury-Hall, Kiernan',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Leicester City','Faes, Wout',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Leicester City','Hermansen, Mads',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Leicester City','Vardy, Jamie',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Liverpool','Alexander-Arnold, Trent',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Liverpool','Alisson Becker',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Liverpool','Salah, Mohamed',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Liverpool','Szoboszlai, Dominik',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Liverpool','van Dijk, Virgil',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Manchester City','De Bruyne, Kevin',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Manchester City','Dias, Ruben',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Manchester City','Ederson',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Manchester City','Foden, Phil',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Manchester City','Haaland, Erling',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Manchester United','Fernandes, Bruno',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Manchester United','Hojlund, Rasmus',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Manchester United','Martinez, Lisandro',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Manchester United','Onana, Andre',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Manchester United','Rashford, Marcus',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Newcastle United','Botman, Sven',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Newcastle United','Gordon, Anthony',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Newcastle United','Guimaraes, Bruno',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Newcastle United','Isak, Alexander',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Newcastle United','Pope, Nick',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Nottingham Forest','Gibbs-White, Morgan',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Nottingham Forest','Murillo',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Nottingham Forest','Sels, Matz',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Nottingham Forest','Wood, Chris',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Southampton','Armstrong, Adam',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Southampton','Bednarek, Jan',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Southampton','Smallbone, Will',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Tottenham Hotspur','Maddison, James',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Tottenham Hotspur','Romero, Cristian',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Tottenham Hotspur','Son, Heung-min',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Tottenham Hotspur','van de Ven, Micky',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Tottenham Hotspur','Vicario, Guglielmo',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','West Ham United','Areola, Alphonse',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','West Ham United','Bowen, Jarrod',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','West Ham United','Kudus, Mohammed',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','West Ham United','Paqueta, Lucas',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','West Ham United','Wan-Bissaka, Aaron',1,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Wolverhampton Wanderers','Cunha, Matheus',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Wolverhampton Wanderers','Gomes, Joao',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Wolverhampton Wanderers','Sa, Jose',0,'Senior Registered Squad','PL updated squad lists Feb 2026'),
('2025/26','2026-02-05','Wolverhampton Wanderers','Semedo, Nelson',0,'Senior Registered Squad','PL updated squad lists Feb 2026');

-- ============================================================
-- VERIFY
-- ============================================================
SELECT 'seasons'               AS tbl, COUNT(*) AS `rows` FROM seasons
UNION ALL SELECT 'stadiums',           COUNT(*) FROM stadiums
UNION ALL SELECT 'clubs',              COUNT(*) FROM clubs
UNION ALL SELECT 'positions',          COUNT(*) FROM positions
UNION ALL SELECT 'players',            COUNT(*) FROM players
UNION ALL SELECT 'club_registrations', COUNT(*) FROM club_registrations
UNION ALL SELECT 'fixtures',           COUNT(*) FROM fixtures
UNION ALL SELECT 'match_events',       COUNT(*) FROM match_events
UNION ALL SELECT 'standings',          COUNT(*) FROM standings
UNION ALL SELECT 'transfers',          COUNT(*) FROM transfers
UNION ALL SELECT 'official_squads',    COUNT(*) FROM official_registered_squads;
