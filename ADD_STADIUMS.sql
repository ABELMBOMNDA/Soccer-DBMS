-- ============================================================
--  EPL DBMS - ALL UK STADIUMS
--  Premier League + Championship + Scottish Premiership
--  Run this in MySQL Workbench (safe to run multiple times)
-- ============================================================

USE epl_dbms;

-- Championship Stadiums
INSERT IGNORE INTO stadiums (stadium_name, city, country, capacity) VALUES
-- Championship
('Elland Road',                    'Leeds',          'England', 37890),
('Riverside Stadium',              'Middlesbrough',  'England', 34742),
('Hillsborough',                   'Sheffield',      'England', 39732),
('St Andrews',                     'Birmingham',     'England', 29409),
('Ewood Park',                     'Blackburn',      'England', 31367),
('Turf Moor',                      'Burnley',        'England', 21944),
('Cardiff City Stadium',           'Cardiff',        'Wales',   33280),
('Kenilworth Road',                'Luton',          'England', 10356),
('The Den',                        'London',         'England', 20146),
('Carrow Road',                    'Norwich',        'England', 27244),
('Loftus Road',                    'London',         'England', 18360),
('Stadium of Light',               'Sunderland',     'England', 48707),
('Swansea.com Stadium',            'Swansea',        'Wales',   21088),
('Vicarage Road',                  'Watford',        'England', 22200),
('Kassam Stadium',                 'Oxford',         'England', 12500),
('Deepdale',                       'Preston',        'England', 23404),
('Ashton Gate',                    'Bristol',        'England', 27000),
('Home Park',                      'Plymouth',       'England', 16500),
('Oakwell',                        'Barnsley',       'England', 23287),
('The Hawthorns',                  'West Bromwich',  'England', 26688),
('bet365 Stadium',                 'Stoke',          'England', 30089),
('Bramall Lane',                   'Sheffield',      'England', 32125),
('Fratton Park',                   'Portsmouth',     'England', 20688),
('Coventry Building Society Arena','Coventry',       'England', 32609),
('Pride Park Stadium',             'Derby',          'England', 33597),
('KCOM Stadium',                   'Hull',           'England', 25400),
('Madejski Stadium',               'Reading',        'England', 24161),
('Ipswich Town FC Stadium',        'Ipswich',        'England', 29837),
-- League One / League Two (notable)
('Valley Parade',                  'Bradford',       'England', 25136),
('DW Stadium',                     'Wigan',          'England', 25138),
('Boundary Park',                  'Oldham',         'England', 10638),
('Bloomfield Road',                'Blackpool',      'England', 17338),
('Adams Park',                     'High Wycombe',   'England', 10137),
('Ricoh Arena',                    'Coventry',       'England', 32609),
('Sincil Bank',                    'Lincoln',        'England', 10127),
('Highbury Stadium',               'Fleetwood',      'England',  5327),
('Crown Ground',                   'Accrington',     'England',  5057),
('Edgeley Park',                   'Stockport',      'England', 10641),
-- Scottish Premiership
('Celtic Park',                    'Glasgow',        'Scotland', 60411),
('Ibrox Stadium',                  'Glasgow',        'Scotland', 51082),
('Pittodrie Stadium',              'Aberdeen',       'Scotland', 20866),
('Easter Road',                    'Edinburgh',      'Scotland', 20421),
('Tynecastle Park',                'Edinburgh',      'Scotland', 20099),
('Tannadice Park',                 'Dundee',         'Scotland', 14223),
('Dens Park',                      'Dundee',         'Scotland', 11850),
('McDiarmid Park',                 'Perth',          'Scotland', 10696),
('Rugby Park',                     'Kilmarnock',     'Scotland', 17899),
('Fir Park',                       'Motherwell',     'Scotland', 13742),
('St Mirren Park',                 'Paisley',        'Scotland',  8023),
('Livingston FC Stadium',          'Livingston',     'Scotland', 10016),
-- Welsh Premier League
('Rodney Parade',                  'Newport',        'Wales',   10000),
('Cardiff Arms Park',              'Cardiff',        'Wales',    4500),
('Racecourse Ground',              'Wrexham',        'Wales',   15500),
('The New Saints FC Ground',       'Oswestry',       'Wales',    2000),
-- Northern Ireland
('Windsor Park',                   'Belfast',        'Northern Ireland', 18600),
('Seaview',                        'Belfast',        'Northern Ireland',  4000),
-- Additional notable UK stadiums
('Wembley Stadium',                'London',         'England', 90000),
('Allianz Stadium',                'Twickenham',     'England', 82000),
('Hampden Park',                   'Glasgow',        'Scotland', 52063),
('Murrayfield Stadium',            'Edinburgh',      'Scotland', 67144),
('Principality Stadium',           'Cardiff',        'Wales',   74500);

-- Show total stadiums
SELECT COUNT(*) AS total_stadiums FROM stadiums;
SELECT stadium_name, city, country, capacity FROM stadiums ORDER BY country, city, stadium_name;
