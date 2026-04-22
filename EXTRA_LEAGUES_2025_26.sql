-- ============================================================
--  Soccer DBMS - EXTRA LEAGUES 2025/26
--  Eredivisie (18), Liga Portugal (18), Pro League (16),
--  Süper Lig (19)  — full club lists with stadiums
--  Run AFTER FULL_CLUBS_2025_26.sql  (INSERT IGNORE = safe)
-- ============================================================

USE epl_dbms;

-- ============================================================
-- STADIUMS
-- ============================================================
INSERT IGNORE INTO stadiums (stadium_name, city, country, capacity) VALUES

-- Eredivisie extras
('Stadion Galgenwaard',           'Utrecht',        'Netherlands', 24500),
('Abe Lenstra Stadion',           'Heerenveen',     'Netherlands', 26100),
('Goffertstadion',                'Nijmegen',       'Netherlands', 12500),
('De Adelaarshorst',              'Deventer',       'Netherlands', 10500),
('Yanmar Stadion',                'Almere',         'Netherlands',  7000),
('Sparta Stadion Het Kasteel',    'Rotterdam',      'Netherlands', 11000),
('Polman Stadion',                'Almelo',         'Netherlands', 16000),
('MAC3PARK Stadion',              'Zwolle',         'Netherlands', 12500),
('Mandemakers Stadion',           'Waalwijk',       'Netherlands',  7500),
('Fortuna Sittard Stadion',       'Sittard',        'Netherlands', 12500),
('Rat Verlegh Stadion',           'Breda',          'Netherlands', 17500),
('Euroborg',                      'Groningen',      'Netherlands', 22500),
('Koning Willem II Stadion',      'Tilburg',        'Netherlands', 14700),

-- Liga Portugal extras
('Estadio do Bessa',              'Porto',          'Portugal',   28263),
('Estadio Cidade de Barcelos',    'Barcelos',       'Portugal',   12000),
('Estadio dos Arcos',             'Vila do Conde',  'Portugal',    9300),
('Estadio Municipal 22 de Junho', 'Vila Nova de Famalicao','Portugal', 5010),
('Estadio Antonio Coimbra da Mota','Estoril',       'Portugal',    8500),
('Estadio da Madeira',            'Funchal',        'Portugal',    5132),
('Estadio Municipal de Braga',    'Braga',          'Portugal',   30286),
('Estadio Municipal de Arouca',   'Arouca',         'Portugal',    4000),
('Estadio de Sao Luis',           'Faro',           'Portugal',   11000),
('Estadio Jose Gomes',            'Amadora',        'Portugal',    9500),
('Estadio do FC Vizela',          'Vizela',         'Portugal',    5000),
('Estadio Municipal Eng Branco Teixeira','Chaves',  'Portugal',    8400),
('Estadio Comendador Joaquim Freitas','Moreira de Conegos','Portugal',6000),
('Estadio Pina Manique',          'Lisbon',         'Portugal',    5000),

-- Pro League (Belgium) extras
('Stade Joseph Marien',           'Brussels',       'Belgium',    8000),
('Ghelamco Arena',                'Gent',           'Belgium',   20000),
('Stade de Sclessin',             'Liege',          'Belgium',   27670),
('Het Kuipje',                    'Westerlo',       'Belgium',    8000),
('AFAS Stadion Mechelen',         'Mechelen',       'Belgium',   16700),
('Stadion Den Dreef',             'Leuven',         'Belgium',   10000),
('Stayen',                        'Sint-Truiden',   'Belgium',   23700),
('Guldensporenstadion',           'Kortrijk',       'Belgium',    9399),
('Kehrwegstadion',                'Eupen',          'Belgium',    8500),
('Stade du Pays de Charleroi',    'Charleroi',      'Belgium',   15000),
('Olympisch Stadion Antwerpen',   'Antwerp',        'Belgium',   12771),
('Stadion Dender',                'Denderleeuw',    'Belgium',    5000),

-- Süper Lig extras
('Basaksehir Fatih Terim Stadyumu','Istanbul',      'Turkey',    17319),
('Yeni 4 Eylul Stadyumu',         'Sivas',          'Turkey',    27238),
('Recep Tayyip Erdogan Stadyumu', 'Istanbul',       'Turkey',    14234),
('Antalya Stadyumu',              'Antalya',        'Turkey',    32706),
('Yeni Rize Sehir Stadyumu',      'Rize',           'Turkey',    15468),
('Konya Buyuksehir Stadyumu',     'Konya',          'Turkey',    42000),
('Bahcesehir Okullari Stadyumu',  'Alanya',         'Turkey',    10000),
('Ataturk Olimpiyat Stadyumu',    'Istanbul',       'Turkey',    76092),
('Eryaman Stadyumu',              'Ankara',         'Turkey',    19209),
('Yeni Adana Stadyumu',           'Adana',          'Turkey',    33401),
('Samsun 19 Eylul Stadyumu',      'Samsun',         'Turkey',    22000),
('Kadir Has Stadyumu',            'Kayseri',        'Turkey',    32864),
('Kalyon Stadyumu',               'Gaziantep',      'Turkey',    33200),
('Buyuksehir Stadyumu',           'Istanbul',       'Turkey',    14500);

-- ============================================================
-- EREDIVISIE 2024/25 — ALL 18 CLUBS
-- ============================================================
INSERT IGNORE INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id) VALUES
-- already inserted via ADD_EUROPEAN_CLUBS.sql, included here for completeness
('Ajax',                    'AJX', 1900, 'Francesco Farioli',   'Adidas',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Johan Cruyff Arena' LIMIT 1)),
('PSV Eindhoven',           'PSV', 1913, 'Peter Bosz',          'Nike',        (SELECT stadium_id FROM stadiums WHERE stadium_name='Philips Stadion' LIMIT 1)),
('Feyenoord',               'FEY', 1908, 'Brian Priske',        'Adidas',      (SELECT stadium_id FROM stadiums WHERE stadium_name='De Kuip' LIMIT 1)),
('AZ Alkmaar',              'AZ',  1967, 'Maarten Martens',     'Nike',        (SELECT stadium_id FROM stadiums WHERE stadium_name='AFAS Stadion' LIMIT 1)),
('FC Twente',               'TWE', 1965, 'Joseph Oosting',      'Hummel',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Grolsch Veste' LIMIT 1)),
-- new clubs
('FC Utrecht',              'UTR', 1970, 'Ron Jans',            'Macron',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadion Galgenwaard' LIMIT 1)),
('SC Heerenveen',           'HEE', 1920, 'Robin van Persie',    'Under Armour',(SELECT stadium_id FROM stadiums WHERE stadium_name='Abe Lenstra Stadion' LIMIT 1)),
('NEC Nijmegen',            'NEC', 1900, 'Rogier Meijer',       'Joma',        (SELECT stadium_id FROM stadiums WHERE stadium_name='Goffertstadion' LIMIT 1)),
('Go Ahead Eagles',         'GAE', 1902, 'Paul Simonis',        'Jako',        (SELECT stadium_id FROM stadiums WHERE stadium_name='De Adelaarshorst' LIMIT 1)),
('Almere City FC',          'AMC', 1976, 'Alex Pastoor',        'Hummel',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Yanmar Stadion' LIMIT 1)),
('Sparta Rotterdam',        'SPR', 1888, 'Maurice Steijn',      'Macron',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Sparta Stadion Het Kasteel' LIMIT 1)),
('Heracles Almelo',         'HER', 1903, 'John Lammers',        'Hummel',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Polman Stadion' LIMIT 1)),
('PEC Zwolle',              'PEZ', 1910, 'Dick Schreuder',      'Kappa',       (SELECT stadium_id FROM stadiums WHERE stadium_name='MAC3PARK Stadion' LIMIT 1)),
('RKC Waalwijk',            'RKC', 1940, 'Joseph Oosting',      'Robey',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Mandemakers Stadion' LIMIT 1)),
('Fortuna Sittard',         'FSI', 1968, 'Danny Buijs',         'Kappa',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Fortuna Sittard Stadion' LIMIT 1)),
('NAC Breda',               'NAC', 1912, 'Carl Hoefkens',       'Nike',        (SELECT stadium_id FROM stadiums WHERE stadium_name='Rat Verlegh Stadion' LIMIT 1)),
('FC Groningen',            'GRO', 1971, 'Dennis van der Ree',  'Kappa',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Euroborg' LIMIT 1)),
('Willem II',               'WIL', 1896, 'Peter Maes',          'Acushnet',    (SELECT stadium_id FROM stadiums WHERE stadium_name='Koning Willem II Stadion' LIMIT 1));

-- ============================================================
-- LIGA PORTUGAL 2024/25 — ALL 18 CLUBS
-- ============================================================
INSERT IGNORE INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id) VALUES
-- already inserted
('SL Benfica',         'BEN', 1904, 'Bruno Lage',          'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio da Luz' LIMIT 1)),
('FC Porto',           'FCP', 1893, 'Vitor Bruno',         'New Balance',(SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio do Dragao' LIMIT 1)),
('Sporting CP',        'SCP', 1906, 'Ruben Amorim',        'Puma',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Jose Alvalade' LIMIT 1)),
('Vitoria SC',         'VSC', 1922, 'Rui Borges',          'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Dom Afonso Henriques' LIMIT 1)),
('SC Braga',           'SCB', 1921, 'Daniel Carvalho',     'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Municipal de Braga' LIMIT 1)),
-- new clubs
('Boavista FC',        'BOA', 1903, 'Petit',               'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio do Bessa' LIMIT 1)),
('Gil Vicente FC',     'GIV', 1924, 'Ivo Vieira',          'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Cidade de Barcelos' LIMIT 1)),
('Rio Ave FC',         'RAV', 1939, 'Luís Freire',         'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio dos Arcos' LIMIT 1)),
('FC Famalicao',       'FAM', 1931, 'Joao Pedro Sousa',    'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Municipal 22 de Junho' LIMIT 1)),
('Estoril Praia',      'EST', 1939, 'Vasco Seabra',        'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Antonio Coimbra da Mota' LIMIT 1)),
('CD Nacional',        'CDN', 1910, 'Paulo Alves',         'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio da Madeira' LIMIT 1)),
('FC Arouca',          'ARO', 1952, 'Gonzalo Garcia',      'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Municipal de Arouca' LIMIT 1)),
('SC Farense',         'FAR', 1910, 'Sergio Vieira',       'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio de Sao Luis' LIMIT 1)),
('Casa Pia AC',        'CPA', 1920, 'Filipe Martins',      'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Pina Manique' LIMIT 1)),
('Estrela da Amadora', 'EDA', 1932, 'Filipe Rocha',        'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Jose Gomes' LIMIT 1)),
('GD Chaves',          'CHA', 1949, 'Vitor Campelos',      'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Municipal Eng Branco Teixeira' LIMIT 1)),
('Moreirense FC',      'MOR', 1938, 'Damir Canadi',        'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio Comendador Joaquim Freitas' LIMIT 1)),
('AVS Futebol',        'AVS', 2023, 'Rui Borges',          'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Estadio do FC Vizela' LIMIT 1));

-- ============================================================
-- PRO LEAGUE (BELGIUM) 2024/25 — ALL 16 CLUBS
-- ============================================================
INSERT IGNORE INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id) VALUES
-- already inserted
('Club Brugge',          'CLB', 1891, 'Nicky Hayen',         'New Balance',(SELECT stadium_id FROM stadiums WHERE stadium_name='Jan Breydel Stadion' LIMIT 1)),
('RSC Anderlecht',       'AND', 1908, 'Brian Riemer',        'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Lotto Park' LIMIT 1)),
('KRC Genk',             'GNK', 1988, 'Thorsten Fink',       'Nike',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Cegeka Arena' LIMIT 1)),
-- new clubs
('Union Saint-Gilloise', 'USG', 1897, 'Alexander Blessin',   'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade Joseph Marien' LIMIT 1)),
('KAA Gent',             'GNT', 1900, 'Wouter Vrancken',     'Joma',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Ghelamco Arena' LIMIT 1)),
('Standard Liege',       'STD', 1898, 'Ivan Leko',           'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade de Sclessin' LIMIT 1)),
('Cercle Brugge',        'CEB', 1899, 'Miron Muslic',        'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Jan Breydel Stadion' LIMIT 1)),
('Westerlo',             'WES', 1933, 'Timmy Simons',        'Nike',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Het Kuipje' LIMIT 1)),
('KV Mechelen',          'MEC', 1904, 'Steven Defour',       'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='AFAS Stadion Mechelen' LIMIT 1)),
('OH Leuven',            'OHL', 1909, 'Oscar Garcia',        'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadion Den Dreef' LIMIT 1)),
('Sint-Truidense VV',    'STV', 1924, 'Felice Mazzu',        'Puma',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Stayen' LIMIT 1)),
('KV Kortrijk',          'KVK', 1901, 'Freyr Alexandersson', 'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Guldensporenstadion' LIMIT 1)),
('KAS Eupen',            'EUP', 1945, 'Stefan Krämer',       'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Kehrwegstadion' LIMIT 1)),
('Sporting Charleroi',   'CAR', 1904, 'Rik De Mil',          'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Stade du Pays de Charleroi' LIMIT 1)),
('Beerschot VA',         'BEE', 1899, 'Will Still',          'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Olympisch Stadion Antwerpen' LIMIT 1)),
('FCV Dender',           'DEN', 1913, 'Timmy Simons',        'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Stadion Dender' LIMIT 1));

-- ============================================================
-- SUPER LIG (TURKEY) 2024/25 — ALL 19 CLUBS
-- ============================================================
INSERT IGNORE INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id) VALUES
-- already inserted
('Galatasaray',          'GAL', 1905, 'Okan Buruk',             'Nike',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Turk Telekom Stadyumu' LIMIT 1)),
('Besiktas',             'BJK', 1903, 'Giovanni van Bronckhorst','Adidas',    (SELECT stadium_id FROM stadiums WHERE stadium_name='Vodafone Park' LIMIT 1)),
('Fenerbahce',           'FB',  1907, 'Jose Mourinho',           'Nike',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Fenerbahce Sukru Saracoglu' LIMIT 1)),
('Trabzonspor',          'TRA', 1967, 'Abdullah Avci',           'Umbro',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Yeni Malatyaspor Stadyumu' LIMIT 1)),
-- new clubs
('Istanbul Basaksehir',  'BAS', 1990, 'Tayfur Havutcu',          'Puma',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Basaksehir Fatih Terim Stadyumu' LIMIT 1)),
('Sivasspor',            'SIV', 1967, 'Bulent Uygun',            'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Yeni 4 Eylul Stadyumu' LIMIT 1)),
('Kasimpasa',            'KAS', 1921, 'Zeki Murat Göle',         'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Recep Tayyip Erdogan Stadyumu' LIMIT 1)),
('Antalyaspor',          'ANT', 1966, 'Nuri Sahin',              'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Antalya Stadyumu' LIMIT 1)),
('Rizespor',             'RIZ', 1953, 'Stjepan Tomas',           'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Yeni Rize Sehir Stadyumu' LIMIT 1)),
('Konyaspor',            'KON', 1922, 'Ilhan Palut',             'Puma',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Konya Buyuksehir Stadyumu' LIMIT 1)),
('Alanyaspor',           'ALY', 2009, 'Fatih Tekke',             'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Bahcesehir Okullari Stadyumu' LIMIT 1)),
('Fatih Karagumruk',     'KRG', 1926, 'Andrea Pirlo',            'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Ataturk Olimpiyat Stadyumu' LIMIT 1)),
('Ankaragucü',           'ANK', 1910, 'Ferhat Kiraz',            'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Eryaman Stadyumu' LIMIT 1)),
('Hatayspor',            'HAT', 1967, 'Volkan Demirel',          'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Antalya Stadyumu' LIMIT 1)),
('Adana Demirspor',      'ADE', 1940, 'Vincenzo Montella',       'Puma',       (SELECT stadium_id FROM stadiums WHERE stadium_name='Yeni Adana Stadyumu' LIMIT 1)),
('Samsunspor',           'SAM', 1965, 'Markus Gisdol',           'Macron',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Samsun 19 Eylul Stadyumu' LIMIT 1)),
('Kayserispor',          'KAY', 1966, 'Recep Ucar',              'Hummel',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Kadir Has Stadyumu' LIMIT 1)),
('Gaziantep FK',         'GAZ', 1905, 'Selcuk Inan',             'Kappa',      (SELECT stadium_id FROM stadiums WHERE stadium_name='Kalyon Stadyumu' LIMIT 1)),
('Eyupspor',             'EYU', 1930, 'Nursahin Diyadin',        'Adidas',     (SELECT stadium_id FROM stadiums WHERE stadium_name='Buyuksehir Stadyumu' LIMIT 1));

-- Verify
SELECT COUNT(*) AS total_clubs FROM clubs;
SELECT COUNT(*) AS total_stadiums FROM stadiums;
