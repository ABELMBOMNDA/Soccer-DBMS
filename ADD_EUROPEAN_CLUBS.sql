-- ============================================================
--  EPL DBMS - ADD EUROPEAN TOP DIVISION CLUBS
--  Serie A, La Liga, Bundesliga, Ligue 1, Liga Portugal,
--  Eredivisie, Pro League (Belgium), Süper Lig (Turkey)
--  Run this in MySQL Workbench (safe to run multiple times)
-- ============================================================

USE epl_dbms;

-- ============================================================
-- STEP 1: ADD EUROPEAN STADIUMS
-- ============================================================
INSERT IGNORE INTO stadiums (stadium_name, city, country, capacity) VALUES
-- Serie A (Italy)
('San Siro',                     'Milan',        'Italy',    75923),
('Allianz Stadium',              'Turin',        'Italy',    41507),
('Stadio Olimpico',              'Rome',         'Italy',    70634),
('Diego Armando Maradona',       'Naples',       'Italy',    54726),
('Gewiss Stadium',               'Bergamo',      'Italy',    21747),
('Stadio Artemio Franchi',       'Florence',     'Italy',    43147),
('Stadio Luigi Ferraris',        'Genoa',        'Italy',    36536),
('Stadio Bentegodi',             'Verona',       'Italy',    31045),
('Stadio Via del Mare',          'Lecce',        'Italy',    33876),
('Stadio Comunale Ennio Tardini','Parma',        'Italy',    27906),
('Stadio Renato Dall Ara',       'Bologna',      'Italy',    38279),
('Unipol Domus',                 'Cagliari',     'Italy',    16416),
('Stadio Olimpico Grande Torino','Turin',        'Italy',    28177),
('Stadio Friuli',                'Udine',        'Italy',    25144),
('Stadio Arechi',                'Salerno',      'Italy',    37843),
-- La Liga (Spain)
('Santiago Bernabeu',            'Madrid',       'Spain',    81044),
('Camp Nou',                     'Barcelona',    'Spain',    99354),
('Metropolitano',                'Madrid',       'Spain',    68456),
('Ramon Sanchez-Pizjuan',        'Seville',      'Spain',    43883),
('Estadio de la Ceramica',       'Villarreal',   'Spain',    23500),
('San Mames',                    'Bilbao',       'Spain',    53289),
('Mestalla',                     'Valencia',     'Spain',    49430),
('Estadio Benito Villamarin',    'Seville',      'Spain',    60721),
('Estadio de Mendizorroza',      'Vitoria',      'Spain',    19840),
('El Sadar',                     'Pamplona',     'Spain',    23576),
('Estadio de Gran Canaria',      'Las Palmas',   'Spain',    32400),
('Reale Arena',                  'San Sebastian','Spain',    39500),
('Estadio Municipal de Butarque','Leganes',      'Spain',    11454),
('Estadio Nuevo Mirandilla',     'Cadiz',        'Spain',    20700),
('Estadio Nuevo Los Carmenes',   'Granada',      'Spain',    19336),
-- Bundesliga (Germany)
('Signal Iduna Park',            'Dortmund',     'Germany',  81365),
('Allianz Arena',                'Munich',       'Germany',  75024),
('Red Bull Arena',               'Leipzig',      'Germany',  47069),
('BayArena',                     'Leverkusen',   'Germany',  30210),
('Europa-Park Stadion',          'Freiburg',     'Germany',  34700),
('Volksparkstadion',             'Hamburg',      'Germany',  57274),
('MHPArena',                     'Stuttgart',    'Germany',  60558),
('Deutsche Bank Park',           'Frankfurt',    'Germany',  51500),
('Veltins-Arena',                'Gelsenkirchen','Germany',  62271),
('PreZero Arena',                'Sinsheim',     'Germany',  30150),
('Borussia-Park',                'Monchengladbach','Germany',54057),
('Coface Arena',                 'Mainz',        'Germany',  33305),
('WWK Arena',                    'Augsburg',     'Germany',  30660),
('Vonovia Ruhrstadion',          'Bochum',       'Germany',  27599),
-- Ligue 1 (France)
('Parc des Princes',             'Paris',        'France',   47929),
('Orange Velodrome',             'Marseille',    'France',   67394),
('Groupama Stadium',             'Lyon',         'France',   59186),
('Allianz Riviera',              'Nice',         'France',   35624),
('Roazhon Park',                 'Rennes',       'France',   29778),
('Stade Pierre-Mauroy',          'Lille',        'France',   50186),
('Stade Louis II',               'Monaco',       'Monaco',   18523),
('Stade de la Meinau',           'Strasbourg',   'France',   26000),
('Stade Auguste-Delaune',        'Reims',        'France',   21684),
('Stade Geoffroy-Guichard',      'Saint-Etienne','France',   41965),
('Stade du Hainaut',             'Valenciennes', 'France',   25172),
('MMArena',                      'Le Mans',      'France',   25020),
-- Liga Portugal (Portugal)
('Estadio da Luz',               'Lisbon',       'Portugal', 64642),
('Estadio do Dragao',            'Porto',        'Portugal', 50033),
('Estadio Jose Alvalade',        'Lisbon',       'Portugal', 50095),
('Estadio Dom Afonso Henriques', 'Guimaraes',    'Portugal', 30029),
('Estadio Municipal de Braga',   'Braga',        'Portugal', 30286),
-- Eredivisie (Netherlands)
('Johan Cruyff Arena',           'Amsterdam',    'Netherlands', 54990),
('Philips Stadion',              'Eindhoven',    'Netherlands', 35000),
('De Kuip',                      'Rotterdam',    'Netherlands', 51117),
('AFAS Stadion',                 'Alkmaar',      'Netherlands', 19478),
('Grolsch Veste',                'Enschede',     'Netherlands', 30205),
('Vitesse Stadion GelreDome',    'Arnhem',       'Netherlands', 25000),
-- Pro League (Belgium)
('Jan Breydel Stadion',          'Bruges',       'Belgium',  29062),
('Lotto Park',                   'Brussels',     'Belgium',  21500),
('Stade Roi Baudouin',           'Brussels',     'Belgium',  50024),
('Cegeka Arena',                 'Genk',         'Belgium',  25000),
-- Super Lig (Turkey)
('Türk Telekom Stadyumu',        'Istanbul',     'Turkey',   52695),
('Vodafone Park',                'Istanbul',     'Turkey',   41903),
('Fenerbahçe Şükrü Saracoğlu',  'Istanbul',     'Turkey',   50530),
('Yeni Malatyaspor Stadyumu',    'Trabzon',      'Turkey',   40782);

-- ============================================================
-- STEP 2: ADD EUROPEAN CLUBS
-- ============================================================

-- SERIE A (Italy)
INSERT IGNORE INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id) VALUES
('AC Milan',         'ACM',  1899, 'Sergio Conceicao',  'Emirates',       (SELECT stadium_id FROM stadiums WHERE stadium_name = 'San Siro')),
('Inter Milan',      'INT',  1908, 'Simone Inzaghi',    'Socios.com',     (SELECT stadium_id FROM stadiums WHERE stadium_name = 'San Siro')),
('Juventus',         'JUV',  1897, 'Thiago Motta',      'Jeep',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Allianz Stadium' AND city = 'Turin')),
('AS Roma',          'ROM',  1927, 'Claudio Ranieri',   'DigitalBits',    (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stadio Olimpico')),
('SS Lazio',         'LAZ',  1900, 'Marco Baroni',      'Binance',        (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stadio Olimpico')),
('SSC Napoli',       'NAP',  1926, 'Antonio Conte',     'IQOS',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Diego Armando Maradona')),
('Atalanta',         'ATA',  1907, 'Gian Piero Gasperini', 'Percassi',   (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Gewiss Stadium')),
('ACF Fiorentina',   'FIO',  1926, 'Raffaele Palladino','Mediacom',       (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stadio Artemio Franchi')),
('Genoa CFC',        'GEN',  1893, 'Patrick Vieira',    'Blu Dhabi',      (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stadio Luigi Ferraris')),
('Hellas Verona',    'VER',  1903, 'Paolo Zanetti',     'AGSM',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stadio Bentegodi')),
('US Lecce',         'LEC',  1908, 'Luca Gotti',        'Fila',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stadio Via del Mare')),
('Parma Calcio',     'PAR',  1913, 'Fabio Pecchia',     'Kappa',          (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stadio Comunale Ennio Tardini')),
('Bologna FC',       'BOL',  1909, 'Vincenzo Italiano', 'Volkswagen',     (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stadio Renato Dall Ara')),
('Cagliari Calcio',  'CAG',  1920, 'Davide Nicola',     'Puma',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Unipol Domus')),
('Torino FC',        'TOR',  1906, 'Paolo Vanoli',      'Kappa',          (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stadio Olimpico Grande Torino')),
('Udinese Calcio',   'UDI',  1896, 'Kosta Runjaic',     'Macron',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stadio Friuli')),

-- LA LIGA (Spain)
('Real Madrid',      'RMA',  1902, 'Carlo Ancelotti',   'Emirates',       (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Santiago Bernabeu')),
('FC Barcelona',     'BAR',  1899, 'Hansi Flick',       'Spotify',        (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Camp Nou')),
('Atletico Madrid',  'ATM',  1903, 'Diego Simeone',     'Plus500',        (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Metropolitano')),
('Sevilla FC',       'SEV',  1890, 'Francisco Javier Garcia Pimienta', 'Betway', (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Ramon Sanchez-Pizjuan')),
('Villarreal CF',    'VIL',  1923, 'Marcelino Garcia Toral', 'UralitaTejas', (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Estadio de la Ceramica')),
('Athletic Bilbao',  'ATH',  1898, 'Ernesto Valverde',  'Petronor',       (SELECT stadium_id FROM stadiums WHERE stadium_name = 'San Mames')),
('Valencia CF',      'VAL',  1919, 'Carlos Corberan',   'Lotto',          (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Mestalla')),
('Real Betis',       'BET',  1907, 'Manuel Pellegrini', 'Rayo',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Estadio Benito Villamarin')),
('Deportivo Alaves', 'ALA',  1921, 'Luis Garcia',       'Michelin',       (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Estadio de Mendizorroza')),
('CA Osasuna',       'OSA',  1920, 'Jagoba Arrasate',   'Osasuna',        (SELECT stadium_id FROM stadiums WHERE stadium_name = 'El Sadar')),
('UD Las Palmas',    'LPA',  1949, 'Diego Martinez',    'Macron',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Estadio de Gran Canaria')),
('Real Sociedad',    'RSO',  1909, 'Imanol Alguacil',   'Macron',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Reale Arena')),

-- BUNDESLIGA (Germany)
('Borussia Dortmund','BVB',  1909, 'Niko Kovac',        'Evonik',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Signal Iduna Park')),
('Bayern Munich',    'BAY',  1900, 'Vincent Kompany',   'T-Mobile',       (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Allianz Arena')),
('RB Leipzig',       'RBL',  2009, 'Marco Rose',        'Red Bull',       (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Red Bull Arena')),
('Bayer Leverkusen', 'B04',  1904, 'Xabi Alonso',       'Bayer',          (SELECT stadium_id FROM stadiums WHERE stadium_name = 'BayArena')),
('SC Freiburg',      'SCF',  1904, 'Julian Schuster',   'JAKO',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Europa-Park Stadion')),
('VfB Stuttgart',    'VFB',  1893, 'Sebastian Hoeness', 'Porsche',        (SELECT stadium_id FROM stadiums WHERE stadium_name = 'MHPArena')),
('Eintracht Frankfurt','SGE',1899, 'Dino Toppmoller',   'Jako',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Deutsche Bank Park')),
('FC Schalke 04',    'S04',  1904, 'Karel Geraerts',    'Gazprom',        (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Veltins-Arena')),
('TSG Hoffenheim',   'TSG',  1899, 'Christian Ilzer',   'SAP',            (SELECT stadium_id FROM stadiums WHERE stadium_name = 'PreZero Arena')),
('Borussia Monchengladbach','BMG',1900,'Gerardo Seoane', 'Postbank',       (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Borussia-Park')),
('1. FSV Mainz 05',  'M05',  1905, 'Bo Henriksen',      'Entega',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Coface Arena')),
('FC Augsburg',      'FCA',  1907, 'Jess Thorup',       'WWK',            (SELECT stadium_id FROM stadiums WHERE stadium_name = 'WWK Arena')),
('VfL Bochum',       'BOC',  1848, 'Dieter Hecking',    'Vonovia',        (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Vonovia Ruhrstadion')),

-- LIGUE 1 (France)
('Paris Saint-Germain','PSG',1970, 'Luis Enrique',      'Nike',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Parc des Princes')),
('Olympique Marseille','OM', 1899, 'Roberto De Zerbi',  'PUMA',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Orange Velodrome')),
('Olympique Lyonnais','OL',  1950, 'Pierre Sage',       'Adidas',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Groupama Stadium')),
('OGC Nice',         'NIC',  1904, 'Franck Haise',      'Macron',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Allianz Riviera')),
('Stade Rennais',    'REN',  1901, 'Jorge Sampaoli',    'Hummel',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Roazhon Park')),
('LOSC Lille',       'LIL',  1944, 'Bruno Genesio',     'New Balance',    (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stade Pierre-Mauroy')),
('AS Monaco',        'MON',  1924, 'Adi Hutter',        'Kappa',          (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stade Louis II')),
('RC Strasbourg',    'STR',  1906, 'Liam Rosenior',     'Adidas',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stade de la Meinau')),
('Stade de Reims',   'REI',  1931, 'Luka Elsner',       'Hungaria',       (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Stade Auguste-Delaune')),

-- LIGA PORTUGAL (Portugal)
('SL Benfica',       'BEN',  1904, 'Bruno Lage',        'Adidas',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Estadio da Luz')),
('FC Porto',         'FCP',  1893, 'Vitor Bruno',       'New Balance',    (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Estadio do Dragao')),
('Sporting CP',      'SCP',  1906, 'Ruben Amorim',      'Puma',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Estadio Jose Alvalade')),
('Vitoria SC',       'VSC',  1922, 'Rui Borges',        'Macron',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Estadio Dom Afonso Henriques')),
('SC Braga',         'SCB',  1921, 'Joao Artur',        'Adidas',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Estadio Municipal de Braga')),

-- EREDIVISIE (Netherlands)
('Ajax',             'AJX',  1900, 'Francesco Farioli', 'Adidas',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Johan Cruyff Arena')),
('PSV Eindhoven',    'PSV',  1913, 'Peter Bosz',        'Nike',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Philips Stadion')),
('Feyenoord',        'FEY',  1908, 'Brian Priske',      'Adidas',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'De Kuip')),
('AZ Alkmaar',       'AZ',   1967, 'Maarten Martens',   'Nike',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'AFAS Stadion')),
('FC Twente',        'TWE',  1965, 'Joseph Oosting',    'Hummel',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Grolsch Veste')),

-- PRO LEAGUE (Belgium)
('Club Brugge',      'CLB',  1891, 'Nicky Hayen',       'New Balance',    (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Jan Breydel Stadion')),
('RSC Anderlecht',   'AND',  1908, 'Brian Riemer',      'Adidas',         (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Lotto Park')),
('KRC Genk',         'GNK',  1988, 'Thorsten Fink',     'Nike',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Cegeka Arena')),

-- SUPER LIG (Turkey)
('Galatasaray',      'GAL',  1905, 'Okan Buruk',        'Nike',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Türk Telekom Stadyumu')),
('Besiktas',         'BJK',  1903, 'Giovanni van Bronckhorst', 'Adidas', (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Vodafone Park')),
('Fenerbahce',       'FB',   1907, 'Jose Mourinho',     'Nike',           (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Fenerbahçe Şükrü Saracoğlu')),
('Trabzonspor',      'TRA',  1967, 'Abdullah Avci',     'Umbro',          (SELECT stadium_id FROM stadiums WHERE stadium_name = 'Yeni Malatyaspor Stadyumu'));

-- Verify
SELECT COUNT(*) AS total_clubs FROM clubs;
SELECT club_id, club_name, short_name FROM clubs ORDER BY club_id;
