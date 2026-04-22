-- ============================================================
--  Soccer DBMS - ALL CLUBS 2025/26
--  Premier League, Serie A, La Liga, Bundesliga, Ligue 1
--  Adds stadiums then clubs (INSERT IGNORE = safe to re-run)
-- ============================================================

USE epl_dbms;

-- ============================================================
-- UPDATE EXISTING EPL CLUBS (2025/26 managers & sponsors)
-- ============================================================
UPDATE clubs SET manager_name='Mikel Arteta',      sponsor_name='Adidas'      WHERE club_name='Arsenal';
UPDATE clubs SET manager_name='Unai Emery',        sponsor_name='Cazoo'       WHERE club_name='Aston Villa';
UPDATE clubs SET manager_name='Andoni Iraola',     sponsor_name='Umbro'       WHERE club_name='AFC Bournemouth';
UPDATE clubs SET manager_name='Thomas Frank',      sponsor_name='Nike'        WHERE club_name='Brentford';
UPDATE clubs SET manager_name='Fabian Hurzeler',   sponsor_name='Nike'        WHERE club_name='Brighton & Hove Albion';
UPDATE clubs SET manager_name='Enzo Maresca',      sponsor_name='Nike'        WHERE club_name='Chelsea';
UPDATE clubs SET manager_name='Oliver Glasner',    sponsor_name='Macron'      WHERE club_name='Crystal Palace';
UPDATE clubs SET manager_name='Sean Dyche',        sponsor_name='Hummel'      WHERE club_name='Everton';
UPDATE clubs SET manager_name='Marco Silva',       sponsor_name='Adidas'      WHERE club_name='Fulham';
UPDATE clubs SET manager_name='Kieran McKenna',    sponsor_name='Adidas'      WHERE club_name='Ipswich Town';
UPDATE clubs SET manager_name='Steve Cooper',      sponsor_name='Adidas'      WHERE club_name='Leicester City';
UPDATE clubs SET manager_name='Arne Slot',         sponsor_name='Nike'        WHERE club_name='Liverpool';
UPDATE clubs SET manager_name='Pep Guardiola',     sponsor_name='Puma'        WHERE club_name='Manchester City';
UPDATE clubs SET manager_name='Ruben Amorim',      sponsor_name='Adidas'      WHERE club_name='Manchester United';
UPDATE clubs SET manager_name='Eddie Howe',        sponsor_name='Castore'     WHERE club_name='Newcastle United';
UPDATE clubs SET manager_name='Nuno Espirito Santo',sponsor_name='Adidas'     WHERE club_name='Nottingham Forest';
UPDATE clubs SET manager_name='Russell Martin',    sponsor_name='Under Armour' WHERE club_name='Southampton';
UPDATE clubs SET manager_name='Ange Postecoglou',  sponsor_name='Nike'        WHERE club_name='Tottenham Hotspur';
UPDATE clubs SET manager_name='Julen Lopetegui',   sponsor_name='Umbro'       WHERE club_name='West Ham United';
UPDATE clubs SET manager_name='Gary ONeill',       sponsor_name='Castore'     WHERE club_name='Wolverhampton Wanderers';

-- ============================================================
-- STADIUMS FOR SERIE A, LA LIGA, BUNDESLIGA, LIGUE 1
-- ============================================================
INSERT IGNORE INTO stadiums (stadium_name, city, country, capacity) VALUES
-- Serie A full list
('San Siro',                      'Milan',         'Italy',    75923),
('Allianz Stadium',               'Turin',         'Italy',    41507),
('Stadio Olimpico',               'Rome',          'Italy',    70634),
('Diego Armando Maradona',        'Naples',        'Italy',    54726),
('Gewiss Stadium',                'Bergamo',       'Italy',    21747),
('Stadio Artemio Franchi',        'Florence',      'Italy',    43147),
('Stadio Luigi Ferraris',         'Genoa',         'Italy',    36536),
('Stadio Bentegodi',              'Verona',        'Italy',    31045),
('Stadio Via del Mare',           'Lecce',         'Italy',    33876),
('Stadio Renato Dall Ara',        'Bologna',       'Italy',    38279),
('Unipol Domus',                  'Cagliari',      'Italy',    16416),
('Stadio Olimpico Grande Torino', 'Turin',         'Italy',    28177),
('Stadio Friuli',                 'Udine',         'Italy',    25144),
('Stadio Castellani',             'Empoli',        'Italy',    16800),
('Stadio Adriatico',              'Pescara',       'Italy',    22000),
('Stadio Mapei',                  'Reggio Emilia', 'Italy',    21584),
('Stadio Luigi Ferraris Samp',    'Genoa',         'Italy',    36536),
('Stadio Tardini',                'Parma',         'Italy',    27906),
('Stadio Monza',                  'Monza',         'Italy',    18568),
('Stadio Brianteo',               'Monza',         'Italy',    16000),
-- La Liga full list
('Santiago Bernabeu',             'Madrid',        'Spain',    81044),
('Camp Nou',                      'Barcelona',     'Spain',    99354),
('Metropolitano',                 'Madrid',        'Spain',    68456),
('Ramon Sanchez-Pizjuan',         'Seville',       'Spain',    43883),
('Estadio de la Ceramica',        'Villarreal',    'Spain',    23500),
('San Mames',                     'Bilbao',        'Spain',    53289),
('Mestalla',                      'Valencia',      'Spain',    49430),
('Estadio Benito Villamarin',     'Seville',       'Spain',    60721),
('Reale Arena',                   'San Sebastian', 'Spain',    39500),
('El Sadar',                      'Pamplona',      'Spain',    23576),
('Estadio de Gran Canaria',       'Las Palmas',    'Spain',    32400),
('Estadio de Mendizorroza',       'Vitoria',       'Spain',    19840),
('Coliseum Alfonso Perez',        'Getafe',        'Spain',    17393),
('Estadio de Vallecas',           'Madrid',        'Spain',    14708),
('Estadio Municipal de Butarque', 'Leganes',       'Spain',    11454),
('Power Horse Stadium',           'Almeria',       'Spain',    22000),
('Estadio El Arcangel',           'Cordoba',       'Spain',    20989),
('Nou Estadi',                    'Tarragona',     'Spain',    14500),
('Estadio El Molinon',            'Gijon',         'Spain',    29029),
('Estadio de Mendizorroza 2',     'Vitoria',       'Spain',    19840),
-- Bundesliga full list
('Signal Iduna Park',             'Dortmund',      'Germany',  81365),
('Allianz Arena',                 'Munich',        'Germany',  75024),
('Red Bull Arena',                'Leipzig',       'Germany',  47069),
('BayArena',                     'Leverkusen',     'Germany',  30210),
('Europa-Park Stadion',           'Freiburg',      'Germany',  34700),
('MHPArena',                      'Stuttgart',     'Germany',  60558),
('Deutsche Bank Park',            'Frankfurt',     'Germany',  51500),
('Veltins-Arena',                 'Gelsenkirchen', 'Germany',  62271),
('PreZero Arena',                 'Sinsheim',      'Germany',  30150),
('Borussia-Park',                 'Monchengladbach','Germany', 54057),
('Coface Arena',                  'Mainz',         'Germany',  33305),
('WWK Arena',                     'Augsburg',      'Germany',  30660),
('Vonovia Ruhrstadion',           'Bochum',        'Germany',  27599),
('Volksparkstadion',              'Hamburg',       'Germany',  57274),
('HDI Arena',                     'Hannover',      'Germany',  49000),
('Olympiastadion Berlin',         'Berlin',        'Germany',  74475),
('RheinEnergieStadion',           'Cologne',       'Germany',  49827),
('Weserstadion',                  'Bremen',        'Germany',  42100),
-- Ligue 1 full list
('Parc des Princes',              'Paris',         'France',   47929),
('Orange Velodrome',              'Marseille',     'France',   67394),
('Groupama Stadium',              'Lyon',          'France',   59186),
('Allianz Riviera',               'Nice',          'France',   35624),
('Roazhon Park',                  'Rennes',        'France',   29778),
('Stade Pierre-Mauroy',           'Lille',         'France',   50186),
('Stade Louis II',                'Monaco',        'Monaco',   18523),
('Stade de la Meinau',            'Strasbourg',    'France',   26000),
('Stade Auguste-Delaune',         'Reims',         'France',   21684),
('Stade de la Beaujoire',         'Nantes',        'France',   37473),
('Stade du Havre',                'Le Havre',      'France',   25000),
('Stade Geoffroy-Guichard',       'Saint-Etienne', 'France',   41965),
('Stade de la Licorne',           'Amiens',        'France',   12097),
('Stade Bonal',                   'Montbeliard',   'France',   20005),
('Stade de Bordeaux',             'Bordeaux',      'France',   42115),
('Stade Velodrome Lens',          'Lens',          'France',   38223),
('MMArena',                       'Le Mans',       'France',   25020),
('Stade Marcel-Picot',            'Nancy',         'France',   20087);

-- ============================================================
-- SERIE A 2024/25 - ALL 20 CLUBS
-- ============================================================
INSERT IGNORE INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id) VALUES
('AC Milan',         'ACM',  1899, 'Sergio Conceicao',      'Emirates',   (SELECT stadium_id FROM stadiums WHERE stadium_name='San Siro' LIMIT 1)),
('Inter Milan',      'INT',  1908, 'Simone Inzaghi',        'Socios.com', (SELECT stadium_id FROM stadiums WHERE stadium_name='San Siro' LIMIT 1)),
('Juventus',         'JUV',  1897, 'Thiago Motta',          'Jeep',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Allianz Stadium' AND city='Turin' LIMIT 1)),
('AS Roma',          'ROM',  1927, 'Daniele De Rossi',      'Nike',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Olimpico' LIMIT 1)),
('SS Lazio',         'LAZ',  1900, 'Marco Baroni',          'Binance',    (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Olimpico' LIMIT 1)),
('SSC Napoli',       'NAP',  1926, 'Antonio Conte',         'IQOS',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Diego Armando Maradona' LIMIT 1)),
('Atalanta',         'ATA',  1907, 'Gian Piero Gasperini',  'Percassi',   (SELECT stadium_id FROM stadiums WHERE stadium_name='Gewiss Stadium' LIMIT 1)),
('ACF Fiorentina',   'FIO',  1926, 'Raffaele Palladino',    'Mediacom',   (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Artemio Franchi' LIMIT 1)),
('Genoa CFC',        'GEN',  1893, 'Patrick Vieira',        'Blu Dhabi',  (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Luigi Ferraris' LIMIT 1)),
('Hellas Verona',    'VER',  1903, 'Paolo Zanetti',         'AGSM',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Bentegodi' LIMIT 1)),
('US Lecce',         'LEC',  1908, 'Luca Gotti',            'Fila',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Via del Mare' LIMIT 1)),
('Bologna FC',       'BOL',  1909, 'Vincenzo Italiano',     'Volkswagen', (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Renato Dall Ara' LIMIT 1)),
('Cagliari Calcio',  'CAG',  1920, 'Davide Nicola',         'Puma',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Unipol Domus' LIMIT 1)),
('Torino FC',        'TOR',  1906, 'Paolo Vanoli',          'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Olimpico Grande Torino' LIMIT 1)),
('Udinese Calcio',   'UDI',  1896, 'Kosta Runjaic',         'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Friuli' LIMIT 1)),
('Empoli FC',        'EMP',  1920, 'Roberto DAversa',       'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Castellani' LIMIT 1)),
('Parma Calcio',     'PAR',  1913, 'Fabio Pecchia',         'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Tardini' LIMIT 1)),
('AC Monza',         'MON2', 1912, 'Alessandro Nesta',      'Betsson',    (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Monza' LIMIT 1)),
('Sassuolo',         'SAS',  1920, 'Davide Ballardini',     'Mapei',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Mapei' LIMIT 1)),
('Venezia FC',       'VEN',  1907, 'Eusebio Di Francesco',  'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadio Monza' LIMIT 1));

-- ============================================================
-- LA LIGA 2024/25 - ALL 20 CLUBS
-- ============================================================
INSERT IGNORE INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id) VALUES
('Real Madrid',          'RMA',  1902, 'Carlo Ancelotti',           'Emirates',   (SELECT stadium_id FROM stadiums WHERE stadium_name='Santiago Bernabeu' LIMIT 1)),
('FC Barcelona',         'BAR',  1899, 'Hansi Flick',               'Spotify',    (SELECT stadium_id FROM stadiums WHERE stadium_name='Camp Nou' LIMIT 1)),
('Atletico Madrid',      'ATM',  1903, 'Diego Simeone',             'Plus500',    (SELECT stadium_id FROM stadiums WHERE stadium_name='Metropolitano' LIMIT 1)),
('Sevilla FC',           'SEV',  1890, 'Garcia Pimienta',           'Betway',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Ramon Sanchez-Pizjuan' LIMIT 1)),
('Villarreal CF',        'VIL',  1923, 'Marcelino Garcia Toral',    'UralitaTejas',(SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio de la Ceramica' LIMIT 1)),
('Athletic Bilbao',      'ATH',  1898, 'Ernesto Valverde',          'Petronor',   (SELECT stadium_id FROM stadiums WHERE stadium_name='San Mames' LIMIT 1)),
('Valencia CF',          'VAL',  1919, 'Carlos Corberan',           'Lotto',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Mestalla' LIMIT 1)),
('Real Betis',           'BET',  1907, 'Manuel Pellegrini',         'Rayo',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Benito Villamarin' LIMIT 1)),
('Real Sociedad',        'RSO',  1909, 'Imanol Alguacil',           'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Reale Arena' LIMIT 1)),
('CA Osasuna',           'OSA',  1920, 'Jagoba Arrasate',           'Osasuna',    (SELECT stadium_id FROM stadiums WHERE stadium_name='El Sadar' LIMIT 1)),
('UD Las Palmas',        'LPA',  1949, 'Diego Martinez',            'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio de Gran Canaria' LIMIT 1)),
('Deportivo Alaves',     'ALA',  1921, 'Luis Garcia Plaza',         'Michelin',   (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio de Mendizorroza' LIMIT 1)),
('Getafe CF',            'GET',  1983, 'Jose Bordalas',             'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Coliseum Alfonso Perez' LIMIT 1)),
('Rayo Vallecano',       'RAY',  1924, 'Inigo Perez',               'Nike',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio de Vallecas' LIMIT 1)),
('CD Leganes',           'LEG',  1928, 'Borja Jimenez',             'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Municipal de Butarque' LIMIT 1)),
('RCD Mallorca',         'MAL',  1916, 'Jagoba Arrasate',           'Under Armour',(SELECT stadium_id FROM stadiums WHERE stadium_name='El Sadar' LIMIT 1)),
('Celta Vigo',           'CEL',  1923, 'Claudio Giráldez',          'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='El Sadar' LIMIT 1)),
('RCD Espanyol',         'ESP',  1900, 'Manolo Gonzalez',           'Joma',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Coliseum Alfonso Perez' LIMIT 1)),
('Girona FC',            'GIR',  1930, 'Michel Sanchez',            'Puma',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Reale Arena' LIMIT 1)),
('UD Almeria',           'ALM',  1989, 'Rubi',                      'Under Armour',(SELECT stadium_id FROM stadiums WHERE stadium_name='Power Horse Stadium' LIMIT 1));

-- ============================================================
-- BUNDESLIGA 2024/25 - ALL 18 CLUBS
-- ============================================================
INSERT IGNORE INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id) VALUES
('Bayern Munich',              'BAY',  1900, 'Vincent Kompany',     'T-Mobile',  (SELECT stadium_id FROM stadiums WHERE stadium_name='Allianz Arena' LIMIT 1)),
('Borussia Dortmund',          'BVB',  1909, 'Niko Kovac',          'Evonik',    (SELECT stadium_id FROM stadiums WHERE stadium_name='Signal Iduna Park' LIMIT 1)),
('RB Leipzig',                 'RBL',  2009, 'Marco Rose',          'Red Bull',  (SELECT stadium_id FROM stadiums WHERE stadium_name='Red Bull Arena' LIMIT 1)),
('Bayer Leverkusen',           'B04',  1904, 'Xabi Alonso',         'Bayer',     (SELECT stadium_id FROM stadiums WHERE stadium_name='BayArena' LIMIT 1)),
('SC Freiburg',                'SCF',  1904, 'Julian Schuster',     'JAKO',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Europa-Park Stadion' LIMIT 1)),
('VfB Stuttgart',              'VFB',  1893, 'Sebastian Hoeness',   'Porsche',   (SELECT stadium_id FROM stadiums WHERE stadium_name='MHPArena' LIMIT 1)),
('Eintracht Frankfurt',        'SGE',  1899, 'Dino Toppmoller',     'Jako',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Deutsche Bank Park' LIMIT 1)),
('TSG Hoffenheim',             'TSG',  1899, 'Christian Ilzer',     'SAP',       (SELECT stadium_id FROM stadiums WHERE stadium_name='PreZero Arena' LIMIT 1)),
('Borussia Monchengladbach',   'BMG',  1900, 'Gerardo Seoane',      'Postbank',  (SELECT stadium_id FROM stadiums WHERE stadium_name='Borussia-Park' LIMIT 1)),
('1. FSV Mainz 05',            'M05',  1905, 'Bo Henriksen',        'Entega',    (SELECT stadium_id FROM stadiums WHERE stadium_name='Coface Arena' LIMIT 1)),
('FC Augsburg',                'FCA',  1907, 'Jess Thorup',         'WWK',       (SELECT stadium_id FROM stadiums WHERE stadium_name='WWK Arena' LIMIT 1)),
('VfL Wolfsburg',              'WOB',  1945, 'Ralph Hasenhuttl',    'Volkswagen',(SELECT stadium_id FROM stadiums WHERE stadium_name='Volksparkstadion' LIMIT 1)),
('Werder Bremen',              'SVW',  1899, 'Ole Werner',          'wohninvest',(SELECT stadium_id FROM stadiums WHERE stadium_name='Weserstadion' LIMIT 1)),
('FC Union Berlin',            'FCU',  1906, 'Nenad Bjelica',       'Aroundtown',(SELECT stadium_id FROM stadiums WHERE stadium_name='Olympiastadion Berlin' LIMIT 1)),
('Hamburger SV',               'HSV',  1887, 'Steffen Baumgart',    'Emirates',  (SELECT stadium_id FROM stadiums WHERE stadium_name='Volksparkstadion' LIMIT 1)),
('Heidenheim',                 'FCH',  1846, 'Frank Schmidt',       'Jako',      (SELECT stadium_id FROM stadiums WHERE stadium_name='WWK Arena' LIMIT 1)),
('Holstein Kiel',              'KIE',  1900, 'Marcel Rapp',         'JAKO',      (SELECT stadium_id FROM stadiums WHERE stadium_name='HDI Arena' LIMIT 1)),
('St. Pauli',                  'STP',  1910, 'Alexander Blessin',   'Oke Godoy', (SELECT stadium_id FROM stadiums WHERE stadium_name='Volksparkstadion' LIMIT 1));

-- ============================================================
-- LIGUE 1 2024/25 - ALL 18 CLUBS
-- ============================================================
INSERT IGNORE INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id) VALUES
('Paris Saint-Germain',  'PSG', 1970, 'Luis Enrique',       'Nike',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Parc des Princes' LIMIT 1)),
('Olympique Marseille',  'OM',  1899, 'Roberto De Zerbi',   'PUMA',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Orange Velodrome' LIMIT 1)),
('Olympique Lyonnais',   'OL',  1950, 'Pierre Sage',        'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Groupama Stadium' LIMIT 1)),
('OGC Nice',             'NIC', 1904, 'Franck Haise',       'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Allianz Riviera' LIMIT 1)),
('Stade Rennais',        'REN', 1901, 'Jorge Sampaoli',     'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Roazhon Park' LIMIT 1)),
('LOSC Lille',           'LIL', 1944, 'Bruno Genesio',      'New Balance',(SELECT stadium_id FROM stadiums WHERE stadium_name='Stade Pierre-Mauroy' LIMIT 1)),
('AS Monaco',            'MON', 1924, 'Adi Hutter',         'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade Louis II' LIMIT 1)),
('RC Strasbourg',        'STR', 1906, 'Liam Rosenior',      'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade de la Meinau' LIMIT 1)),
('Stade de Reims',       'REI', 1931, 'Luka Elsner',        'Hungaria',   (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade Auguste-Delaune' LIMIT 1)),
('FC Nantes',            'NAN', 1943, 'Antoine Kombouare',  'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade de la Beaujoire' LIMIT 1)),
('Le Havre AC',          'HAC', 1872, 'Luka Elsner',        'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade du Havre' LIMIT 1)),
('Toulouse FC',          'TOU', 1937, 'Carles Martinez',    'Joma',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade Auguste-Delaune' LIMIT 1)),
('Montpellier HSC',      'MHC', 1974, 'Jean-Louis Gasset',  'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade Auguste-Delaune' LIMIT 1)),
('RC Lens',              'RCL', 1906, 'Will Still',         'New Balance',(SELECT stadium_id FROM stadiums WHERE stadium_name='Stade Velodrome Lens' LIMIT 1)),
('Brest',                'SB29',1950, 'Eric Roy',           'Under Armour',(SELECT stadium_id FROM stadiums WHERE stadium_name='Stade de la Meinau' LIMIT 1)),
('Clermont Foot',        'CF63',1911, 'Pascal Gastien',     'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade du Havre' LIMIT 1)),
('Metz',                 'FCM', 1932, 'Laszlo Boloni',      'Puma',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade Marcel-Picot' LIMIT 1)),
('Havre Athletic Club',  'HAV', 1872, 'Luka Elsner',        'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade du Havre' LIMIT 1));

SELECT COUNT(*) AS total_clubs FROM clubs;
SELECT club_id, club_name, manager_name, sponsor_name FROM clubs ORDER BY club_id;
