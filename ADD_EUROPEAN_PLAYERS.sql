-- ============================================================
--  Soccer DBMS - EUROPEAN LEAGUE PLAYERS
--  Serie A, La Liga, Bundesliga, Ligue 1, Liga Portugal,
--  Eredivisie, Pro League (Belgium), Süper Lig (Turkey)
--  Run AFTER ADD_EUROPEAN_CLUBS.sql
--  Safe to run multiple times (INSERT IGNORE)
-- ============================================================

USE epl_dbms;

-- ============================================================
-- SERIE A (Italy)
-- ============================================================

-- AC Milan
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Mike',        'Maignan',      '1995-07-03', 'France',       1, 16, 'Right', (SELECT club_id FROM clubs WHERE short_name='ACM'), 45000000),
('Theo',        'Hernandez',    '1997-10-06', 'France',       5,  19, 'Left',  (SELECT club_id FROM clubs WHERE short_name='ACM'), 60000000),
('Fikayo',      'Tomori',       '1997-12-19', 'England',      4,  23, 'Right', (SELECT club_id FROM clubs WHERE short_name='ACM'), 38000000),
('Malick',      'Thiaw',        '2001-08-08', 'Germany',      4,  28, 'Right', (SELECT club_id FROM clubs WHERE short_name='ACM'), 30000000),
('Christian',   'Pulisic',      '1998-09-18', 'USA',          3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='ACM'), 45000000),
('Rafael',      'Leao',         '1999-06-10', 'Portugal',     3,  10, 'Left',  (SELECT club_id FROM clubs WHERE short_name='ACM'), 85000000),
('Ruben',       'Loftus-Cheek', '1996-01-23', 'England',      2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='ACM'), 25000000),
('Tijjani',     'Reijnders',    '1998-07-29', 'Netherlands',  2,  14, 'Right', (SELECT club_id FROM clubs WHERE short_name='ACM'), 55000000),
('Samuel',      'Chukwueze',    '1999-05-22', 'Nigeria',      3,  21, 'Right', (SELECT club_id FROM clubs WHERE short_name='ACM'), 30000000),
('Alvaro',      'Morata',       '1992-10-23', 'Spain',        4,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='ACM'), 20000000);

-- Inter Milan
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Lautaro',     'Martinez',     '1997-08-22', 'Argentina',    4,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='INT'), 110000000),
('Marcus',      'Thuram',       '1997-08-06', 'France',       4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='INT'), 65000000),
('Nicolo',      'Barella',      '1997-02-07', 'Italy',        2,  23, 'Right', (SELECT club_id FROM clubs WHERE short_name='INT'), 80000000),
('Hakan',       'Calhanoglu',   '1994-02-08', 'Turkey',       2,  20, 'Right', (SELECT club_id FROM clubs WHERE short_name='INT'), 45000000),
('Alessandro',  'Bastoni',      '1999-04-13', 'Italy',        5,  95, 'Left',  (SELECT club_id FROM clubs WHERE short_name='INT'), 70000000),
('Federico',    'Dimarco',      '1997-11-10', 'Italy',        5,  32, 'Left',  (SELECT club_id FROM clubs WHERE short_name='INT'), 50000000),
('Henrikh',     'Mkhitaryan',   '1989-01-21', 'Armenia',      2,  22, 'Right', (SELECT club_id FROM clubs WHERE short_name='INT'), 8000000),
('Yann',        'Sommer',       '1988-12-17', 'Switzerland',  1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='INT'), 5000000),
('Davide',      'Frattesi',     '1999-09-22', 'Italy',        2,  16, 'Right', (SELECT club_id FROM clubs WHERE short_name='INT'), 40000000),
('Benjamin',    'Pavard',       '1996-03-28', 'France',       4,  28, 'Right', (SELECT club_id FROM clubs WHERE short_name='INT'), 30000000);

-- Juventus
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Dusan',       'Vlahovic',     '2000-01-28', 'Serbia',       4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='JUV'), 80000000),
('Federico',    'Chiesa',       '1997-10-25', 'Italy',        3,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='JUV'), 35000000),
('Adrien',      'Rabiot',       '1995-04-03', 'France',       2,  25, 'Right', (SELECT club_id FROM clubs WHERE short_name='JUV'), 20000000),
('Manuel',      'Locatelli',    '1998-01-08', 'Italy',        2,  5,  'Right', (SELECT club_id FROM clubs WHERE short_name='JUV'), 30000000),
('Gleison',     'Bremer',       '1997-03-18', 'Brazil',       5,  3,  'Right', (SELECT club_id FROM clubs WHERE short_name='JUV'), 55000000),
('Andrea',      'Cambiaso',     '2000-02-22', 'Italy',        5,  27, 'Right', (SELECT club_id FROM clubs WHERE short_name='JUV'), 45000000),
('Wojciech',    'Szczesny',     '1990-04-18', 'Poland',       1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='JUV'), 8000000),
('Timothy',     'Weah',         '2000-02-22', 'USA',          3,  22, 'Right', (SELECT club_id FROM clubs WHERE short_name='JUV'), 20000000),
('Kenan',       'Yildiz',       '2005-05-04', 'Turkey',       3,  10, 'Left',  (SELECT club_id FROM clubs WHERE short_name='JUV'), 35000000),
('Arkadiusz',   'Milik',        '1994-02-28', 'Poland',       4,  14, 'Right', (SELECT club_id FROM clubs WHERE short_name='JUV'), 12000000);

-- SSC Napoli
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Victor',      'Osimhen',      '1998-12-29', 'Nigeria',      4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='NAP'), 130000000),
('Khvicha',     'Kvaratskhelia', '2001-02-12','Georgia',      3,  77, 'Left',  (SELECT club_id FROM clubs WHERE short_name='NAP'), 100000000),
('Stanislav',   'Lobotka',      '1994-11-25', 'Slovakia',     2,  68, 'Right', (SELECT club_id FROM clubs WHERE short_name='NAP'), 45000000),
('Piotr',       'Zielinski',    '1994-05-20', 'Poland',       2,  20, 'Right', (SELECT club_id FROM clubs WHERE short_name='NAP'), 30000000),
('Alex',        'Meret',        '1997-03-22', 'Italy',        1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='NAP'), 18000000),
('Giovanni',    'Di Lorenzo',   '1993-08-04', 'Italy',        5,  22, 'Right', (SELECT club_id FROM clubs WHERE short_name='NAP'), 25000000),
('Amir',        'Rrahmani',     '1994-02-24', 'Kosovo',       4,  13, 'Right', (SELECT club_id FROM clubs WHERE short_name='NAP'), 22000000),
('Frank',       'Anguissa',     '1995-11-16', 'Cameroon',     2,  99, 'Right', (SELECT club_id FROM clubs WHERE short_name='NAP'), 40000000),
('Matteo',      'Politano',     '1993-08-03', 'Italy',        3,  21, 'Right', (SELECT club_id FROM clubs WHERE short_name='NAP'), 18000000),
('Hirving',     'Lozano',       '1995-07-30', 'Mexico',       3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='NAP'), 20000000);

-- Atalanta
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Ademola',     'Lookman',      '1997-10-20', 'Nigeria',      3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATA'), 65000000),
('Mateo',       'Retegui',      '2000-04-29', 'Italy',        4,  32, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATA'), 35000000),
('Teun',        'Koopmeiners',  '1998-02-28', 'Netherlands',  2,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='ATA'), 60000000),
('Mario',       'Pasalic',      '1995-02-09', 'Croatia',      2,  88, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATA'), 25000000),
('Gianluca',    'Scamacca',     '1999-01-01', 'Italy',        4,  90, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATA'), 35000000),
('Giorgio',     'Scalvini',     '2003-12-11', 'Italy',        4,  42, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATA'), 40000000),
('Juan',        'Musso',        '1994-05-06', 'Argentina',    1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='ATA'), 20000000),
('Davide',      'Zappacosta',   '1992-06-11', 'Italy',        5,  77, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATA'), 10000000),
('Rafael',      'Toloi',        '1990-10-10', 'Brazil',       4,  2,  'Right', (SELECT club_id FROM clubs WHERE short_name='ATA'), 5000000),
('Ederson',     'Dos Santos',   '1999-01-07', 'Brazil',       2,  13, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATA'), 45000000);

-- ============================================================
-- LA LIGA (Spain)
-- ============================================================

-- Real Madrid
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Vinicius',    'Junior',       '2000-07-12', 'Brazil',       3,  7,  'Left',  (SELECT club_id FROM clubs WHERE short_name='RMA'), 180000000),
('Jude',        'Bellingham',   '2003-06-29', 'England',      2,  5,  'Right', (SELECT club_id FROM clubs WHERE short_name='RMA'), 180000000),
('Kylian',      'Mbappe',       '1998-12-20', 'France',       4,  9,  'Left',  (SELECT club_id FROM clubs WHERE short_name='RMA'), 180000000),
('Rodrygo',     'Goes',         '2001-01-09', 'Brazil',       3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='RMA'), 120000000),
('Toni',        'Kroos',        '1990-01-04', 'Germany',      2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='RMA'), 15000000),
('Luka',        'Modric',       '1985-09-09', 'Croatia',      2,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='RMA'), 10000000),
('Eduardo',     'Camavinga',    '2002-11-10', 'France',       2,  12, 'Left',  (SELECT club_id FROM clubs WHERE short_name='RMA'), 100000000),
('Aurelien',    'Tchouameni',   '2000-01-16', 'France',       2,  18, 'Right', (SELECT club_id FROM clubs WHERE short_name='RMA'), 80000000),
('David',       'Alaba',        '1992-06-24', 'Austria',      5,  4,  'Left',  (SELECT club_id FROM clubs WHERE short_name='RMA'), 20000000),
('Thibaut',     'Courtois',     '1992-05-11', 'Belgium',      1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='RMA'), 40000000),
('Dani',        'Carvajal',     '1992-01-11', 'Spain',        5,  2,  'Right', (SELECT club_id FROM clubs WHERE short_name='RMA'), 25000000),
('Antonio',     'Rudiger',      '1993-03-03', 'Germany',      4,  22, 'Right', (SELECT club_id FROM clubs WHERE short_name='RMA'), 20000000);

-- FC Barcelona
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Robert',      'Lewandowski',  '1988-08-21', 'Poland',       4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAR'), 25000000),
('Pedri',       'Gonzalez',     '2002-11-25', 'Spain',        2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAR'), 100000000),
('Gavi',        'Paez',         '2004-08-05', 'Spain',        2,  6,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAR'), 90000000),
('Ferran',      'Torres',       '2000-02-29', 'Spain',        3,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAR'), 40000000),
('Lamine',      'Yamal',        '2007-07-13', 'Spain',        3,  19, 'Right', (SELECT club_id FROM clubs WHERE short_name='BAR'), 120000000),
('Raphinha',    'Belloli',      '1996-12-14', 'Brazil',       3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='BAR'), 65000000),
('Frenkie',     'de Jong',      '1997-05-12', 'Netherlands',  2,  21, 'Right', (SELECT club_id FROM clubs WHERE short_name='BAR'), 60000000),
('Ronald',      'Araujo',       '1999-03-07', 'Uruguay',      4,  4,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAR'), 70000000),
('Jules',       'Kounde',       '1998-11-12', 'France',       4,  23, 'Right', (SELECT club_id FROM clubs WHERE short_name='BAR'), 65000000),
('Marc-Andre',  'ter Stegen',   '1992-04-30', 'Germany',      1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAR'), 30000000),
('Alejandro',   'Balde',        '2003-10-18', 'Spain',        5,  3,  'Left',  (SELECT club_id FROM clubs WHERE short_name='BAR'), 55000000),
('Dani',        'Olmo',         '1998-05-07', 'Spain',        3,  20, 'Right', (SELECT club_id FROM clubs WHERE short_name='BAR'), 60000000);

-- Atletico Madrid
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Antoine',     'Griezmann',    '1991-03-21', 'France',       4,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='ATM'), 30000000),
('Julian',      'Alvarez',      '2000-01-31', 'Argentina',    4,  19, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATM'), 80000000),
('Conor',       'Gallagher',    '2000-02-06', 'England',      2,  12, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATM'), 55000000),
('Rodrigo',     'De Paul',      '1994-05-24', 'Argentina',    2,  5,  'Right', (SELECT club_id FROM clubs WHERE short_name='ATM'), 28000000),
('Jose',        'Gimenez',      '1995-01-20', 'Uruguay',      4,  2,  'Right', (SELECT club_id FROM clubs WHERE short_name='ATM'), 30000000),
('Jan',         'Oblak',        '1993-01-07', 'Slovenia',     1,  13, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATM'), 35000000),
('Samuel',      'Lino',         '1999-11-20', 'Portugal',     3,  16, 'Left',  (SELECT club_id FROM clubs WHERE short_name='ATM'), 25000000),
('Marcos',      'Llorente',     '1995-01-30', 'Spain',        2,  14, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATM'), 22000000),
('Robin',       'Le Normand',   '1996-11-11', 'Spain',        4,  24, 'Right', (SELECT club_id FROM clubs WHERE short_name='ATM'), 35000000),
('Clement',     'Lenglet',      '1995-06-17', 'France',       4,  15, 'Left',  (SELECT club_id FROM clubs WHERE short_name='ATM'), 12000000);

-- ============================================================
-- BUNDESLIGA (Germany)
-- ============================================================

-- Bayern Munich
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Harry',       'Kane',         '1993-07-28', 'England',      4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAY'), 100000000),
('Jamal',       'Musiala',      '2003-02-26', 'Germany',      3,  42, 'Right', (SELECT club_id FROM clubs WHERE short_name='BAY'), 150000000),
('Leroy',       'Sane',         '1996-01-11', 'Germany',      3,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='BAY'), 55000000),
('Kingsley',    'Coman',        '1996-06-13', 'France',       3,  11, 'Left',  (SELECT club_id FROM clubs WHERE short_name='BAY'), 40000000),
('Thomas',      'Muller',       '1989-09-13', 'Germany',      4,  25, 'Right', (SELECT club_id FROM clubs WHERE short_name='BAY'), 8000000),
('Joshua',      'Kimmich',      '1995-02-08', 'Germany',      2,  6,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAY'), 70000000),
('Leon',        'Goretzka',     '1995-02-06', 'Germany',      2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAY'), 40000000),
('Alphonso',    'Davies',       '2000-11-02', 'Canada',       5,  19, 'Left',  (SELECT club_id FROM clubs WHERE short_name='BAY'), 70000000),
('Manuel',      'Neuer',        '1986-03-27', 'Germany',      1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAY'), 8000000),
('Kim',         'Min-Jae',      '1996-11-15', 'South Korea',  4,  3,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAY'), 50000000),
('Dayot',       'Upamecano',    '1998-10-27', 'France',       4,  2,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAY'), 50000000),
('Serge',       'Gnabry',       '1995-07-14', 'Germany',      3,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='BAY'), 35000000);

-- Borussia Dortmund
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Gregor',      'Kobel',        '1997-12-06', 'Switzerland',  1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='BVB'), 40000000),
('Nico',        'Schlotterbeck','2000-01-01', 'Germany',      4,  4,  'Left',  (SELECT club_id FROM clubs WHERE short_name='BVB'), 35000000),
('Emre',        'Can',          '1994-01-12', 'Germany',      2,  23, 'Right', (SELECT club_id FROM clubs WHERE short_name='BVB'), 12000000),
('Julian',      'Brandt',       '1996-05-02', 'Germany',      3,  19, 'Right', (SELECT club_id FROM clubs WHERE short_name='BVB'), 35000000),
('Karim',       'Adeyemi',      '2002-01-18', 'Germany',      3,  27, 'Right', (SELECT club_id FROM clubs WHERE short_name='BVB'), 40000000),
('Donyell',     'Malen',        '1999-01-19', 'Netherlands',  3,  21, 'Right', (SELECT club_id FROM clubs WHERE short_name='BVB'), 30000000),
('Sebastien',   'Haller',       '1994-06-22', 'Ivory Coast',  4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='BVB'), 15000000),
('Felix',       'Nmecha',       '2000-10-10', 'Germany',      2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='BVB'), 25000000),
('Marcel',      'Sabitzer',     '1994-03-17', 'Austria',      2,  20, 'Right', (SELECT club_id FROM clubs WHERE short_name='BVB'), 15000000),
('Yan',         'Couto',        '2002-06-03', 'Brazil',       5,  26, 'Right', (SELECT club_id FROM clubs WHERE short_name='BVB'), 22000000);

-- Bayer Leverkusen
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Florian',     'Wirtz',        '2003-05-03', 'Germany',      3,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='B04'), 150000000),
('Granit',      'Xhaka',        '1992-09-27', 'Switzerland',  2,  34, 'Right', (SELECT club_id FROM clubs WHERE short_name='B04'), 15000000),
('Victor',      'Boniface',     '2000-12-23', 'Nigeria',      4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='B04'), 45000000),
('Alejandro',   'Grimaldo',     '1995-09-20', 'Spain',        5,  12, 'Left',  (SELECT club_id FROM clubs WHERE short_name='B04'), 40000000),
('Jonas',       'Hofmann',      '1992-07-14', 'Germany',      3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='B04'), 18000000),
('Exequiel',    'Palacios',     '1998-10-05', 'Argentina',    2,  25, 'Right', (SELECT club_id FROM clubs WHERE short_name='B04'), 35000000),
('Jonathan',    'Tah',          '1996-02-11', 'Germany',      4,  4,  'Right', (SELECT club_id FROM clubs WHERE short_name='B04'), 35000000),
('Lukas',       'Hradecky',     '1989-11-24', 'Finland',      1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='B04'), 8000000),
('Martin',      'Terrier',      '1997-03-04', 'France',       3,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='B04'), 22000000),
('Robert',      'Andrich',      '1994-09-22', 'Germany',      2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='B04'), 25000000);

-- RB Leipzig
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Lois',        'Openda',       '2000-02-16', 'Belgium',      4,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='RBL'), 70000000),
('Benjamin',    'Sesko',        '2003-05-31', 'Slovenia',     4,  30, 'Right', (SELECT club_id FROM clubs WHERE short_name='RBL'), 65000000),
('Xavi',        'Simons',       '2003-04-21', 'Netherlands',  3,  20, 'Right', (SELECT club_id FROM clubs WHERE short_name='RBL'), 80000000),
('Dani',        'Olmo',         '1998-05-07', 'Spain',        3,  26, 'Right', (SELECT club_id FROM clubs WHERE short_name='RBL'), 60000000),
('Willi',       'Orban',        '1992-11-03', 'Hungary',      4,  4,  'Right', (SELECT club_id FROM clubs WHERE short_name='RBL'), 10000000),
('Peter',       'Gulacsi',      '1990-05-06', 'Hungary',      1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='RBL'), 8000000),
('Lukas',       'Klostermann',  '1996-06-03', 'Germany',      5,  5,  'Right', (SELECT club_id FROM clubs WHERE short_name='RBL'), 15000000),
('Kevin',       'Kampl',        '1990-10-09', 'Slovenia',     2,  44, 'Right', (SELECT club_id FROM clubs WHERE short_name='RBL'), 8000000),
('Christoph',   'Baumgartner',  '1999-08-01', 'Austria',      2,  18, 'Right', (SELECT club_id FROM clubs WHERE short_name='RBL'), 28000000),
('Mohamed',     'Simakan',      '2000-05-03', 'France',       4,  36, 'Right', (SELECT club_id FROM clubs WHERE short_name='RBL'), 35000000);

-- ============================================================
-- LIGUE 1 (France)
-- ============================================================

-- Paris Saint-Germain
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Ousmane',     'Dembele',      '1997-05-15', 'France',       3,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='PSG'), 60000000),
('Bradley',     'Barcola',      '2002-09-02', 'France',       3,  29, 'Left',  (SELECT club_id FROM clubs WHERE short_name='PSG'), 80000000),
('Vitinha',     'Ferreira',     '2000-02-13', 'Portugal',     2,  17, 'Right', (SELECT club_id FROM clubs WHERE short_name='PSG'), 70000000),
('Fabian',      'Ruiz',         '1996-04-03', 'Spain',        2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='PSG'), 40000000),
('Marquinhos',  'Correa',       '1994-05-14', 'Brazil',       4,  5,  'Right', (SELECT club_id FROM clubs WHERE short_name='PSG'), 40000000),
('Achraf',      'Hakimi',       '1998-11-04', 'Morocco',      5,  2,  'Right', (SELECT club_id FROM clubs WHERE short_name='PSG'), 70000000),
('Gianluigi',   'Donnarumma',   '1999-02-25', 'Italy',        1,  99, 'Right', (SELECT club_id FROM clubs WHERE short_name='PSG'), 60000000),
('Nuno',        'Mendes',       '2002-06-19', 'Portugal',     5,  25, 'Left',  (SELECT club_id FROM clubs WHERE short_name='PSG'), 60000000),
('Warren',      'Zaire-Emery',  '2006-03-08', 'France',       2,  33, 'Right', (SELECT club_id FROM clubs WHERE short_name='PSG'), 50000000),
('Goncalo',     'Ramos',        '2001-06-20', 'Portugal',     4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='PSG'), 55000000),
('Milan',       'Skriniar',     '1995-02-11', 'Slovakia',     4,  37, 'Right', (SELECT club_id FROM clubs WHERE short_name='PSG'), 20000000),
('Desire',      'Doue',         '2005-06-03', 'France',       3,  21, 'Right', (SELECT club_id FROM clubs WHERE short_name='PSG'), 45000000);

-- Olympique Marseille
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Pierre-Emerick','Aubameyang',  '1989-06-18','Gabon',        4,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='OM'), 6000000),
('Mason',       'Greenwood',    '2001-10-01', 'England',      3,  22, 'Right', (SELECT club_id FROM clubs WHERE short_name='OM'), 35000000),
('Jonathan',    'Clauss',       '1992-09-25', 'France',       5,  2,  'Right', (SELECT club_id FROM clubs WHERE short_name='OM'), 15000000),
('Valentin',    'Rongier',      '1994-12-07', 'France',       2,  21, 'Right', (SELECT club_id FROM clubs WHERE short_name='OM'), 15000000),
('Leonardo',    'Balerdi',      '1999-01-26', 'Argentina',    4,  6,  'Right', (SELECT club_id FROM clubs WHERE short_name='OM'), 25000000),
('Pau',         'Lopez',        '1994-12-13', 'Spain',        1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='OM'), 12000000),
('Azzedine',    'Ounahi',       '2000-01-19', 'Morocco',      2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='OM'), 20000000),
('Chancel',     'Mbemba',       '1994-08-08', 'DR Congo',     4,  99, 'Right', (SELECT club_id FROM clubs WHERE short_name='OM'), 8000000),
('Iliman',      'Ndiaye',       '2000-06-06', 'Senegal',      3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='OM'), 30000000),
('Geoffrey',    'Kondogbia',    '1993-02-15', 'Central Africa',2,14,  'Right', (SELECT club_id FROM clubs WHERE short_name='OM'), 10000000);

-- AS Monaco
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Takumi',      'Minamino',     '1995-01-16', 'Japan',        3,  18, 'Right', (SELECT club_id FROM clubs WHERE short_name='MON'), 15000000),
('Wissam',      'Ben Yedder',   '1990-08-12', 'France',       4,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='MON'), 12000000),
('Maghnes',     'Akliouche',    '2002-05-16', 'France',       3,  24, 'Right', (SELECT club_id FROM clubs WHERE short_name='MON'), 35000000),
('Denis',       'Zakaria',      '1996-11-20', 'Switzerland',  2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='MON'), 18000000),
('Aleksandr',   'Golovin',      '1996-05-30', 'Russia',       2,  17, 'Right', (SELECT club_id FROM clubs WHERE short_name='MON'), 20000000),
('Radoslaw',    'Majecki',      '2000-03-15', 'Poland',       1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='MON'), 12000000),
('Caio',        'Henrique',     '1997-08-31', 'Brazil',       5,  5,  'Left',  (SELECT club_id FROM clubs WHERE short_name='MON'), 22000000),
('Wilfried',    'Singo',        '2000-12-25', 'Ivory Coast',  5,  30, 'Right', (SELECT club_id FROM clubs WHERE short_name='MON'), 30000000),
('Mohamed',     'Camara',       '2000-01-01', 'Guinea',       2,  6,  'Right', (SELECT club_id FROM clubs WHERE short_name='MON'), 25000000),
('Eliot',       'Matazo',       '2002-07-18', 'Belgium',      2,  28, 'Right', (SELECT club_id FROM clubs WHERE short_name='MON'), 15000000);

-- LOSC Lille
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Jonathan',    'David',        '2000-01-14', 'Canada',       4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='LIL'), 70000000),
('Remy',        'Cabella',      '1990-03-08', 'France',       3,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='LIL'), 5000000),
('Bafode',      'Diakite',      '2000-01-15', 'France',       4,  5,  'Right', (SELECT club_id FROM clubs WHERE short_name='LIL'), 18000000),
('Alexsandro',  'Bispo',        '1998-02-06', 'Brazil',       4,  6,  'Right', (SELECT club_id FROM clubs WHERE short_name='LIL'), 20000000),
('Lucas',       'Chevalier',    '2001-09-26', 'France',       1,  30, 'Right', (SELECT club_id FROM clubs WHERE short_name='LIL'), 25000000),
('Nabil',       'Bentaleb',     '1994-11-24', 'Algeria',      2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='LIL'), 6000000),
('Angel',       'Gomes',        '2000-08-31', 'England',      2,  28, 'Right', (SELECT club_id FROM clubs WHERE short_name='LIL'), 30000000),
('Edon',        'Zhegrova',     '1999-03-10', 'Kosovo',       3,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='LIL'), 35000000),
('Leny',        'Yoro',         '2005-11-04', 'France',       4,  15, 'Right', (SELECT club_id FROM clubs WHERE short_name='LIL'), 60000000),
('Hakon',       'Evjen',        '2000-08-14', 'Norway',       3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='LIL'), 15000000);

-- ============================================================
-- LIGA PORTUGAL (Portugal)
-- ============================================================

-- SL Benfica
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Angel',       'Di Maria',     '1988-02-14', 'Argentina',    3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='BEN'), 4000000),
('Rafa',        'Silva',        '1993-05-17', 'Portugal',     3,  27, 'Right', (SELECT club_id FROM clubs WHERE short_name='BEN'), 15000000),
('Fredrik',     'Aursnes',      '1995-12-10', 'Norway',       5,  4,  'Right', (SELECT club_id FROM clubs WHERE short_name='BEN'), 20000000),
('Nicolas',     'Otamendi',     '1988-02-12', 'Argentina',    4,  30, 'Right', (SELECT club_id FROM clubs WHERE short_name='BEN'), 5000000),
('Anatoliy',    'Trubin',       '2001-08-01', 'Ukraine',      1,  13, 'Right', (SELECT club_id FROM clubs WHERE short_name='BEN'), 35000000),
('Orkun',       'Kokcu',        '2000-12-20', 'Turkey',       2,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='BEN'), 35000000),
('Arthur',      'Cabral',       '1998-04-25', 'Brazil',       4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='BEN'), 18000000),
('Joao',        'Neves',        '2004-09-27', 'Portugal',     2,  87, 'Right', (SELECT club_id FROM clubs WHERE short_name='BEN'), 60000000),
('Di Maria',    'Marcos',       '1995-10-07', 'Portugal',     5,  3,  'Left',  (SELECT club_id FROM clubs WHERE short_name='BEN'), 12000000),
('Florentino',  'Luis',         '1999-08-19', 'Portugal',     2,  6,  'Right', (SELECT club_id FROM clubs WHERE short_name='BEN'), 20000000);

-- FC Porto
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Mehdi',       'Taremi',       '1992-07-18', 'Iran',         4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='FCP'), 25000000),
('Wenderson',   'Galeno',       '1997-08-20', 'Brazil',       3,  7,  'Left',  (SELECT club_id FROM clubs WHERE short_name='FCP'), 30000000),
('Pepe',        'Correia',      '1983-02-26', 'Portugal',     4,  3,  'Right', (SELECT club_id FROM clubs WHERE short_name='FCP'), 2000000),
('Ivan',        'Marcano',      '1987-06-23', 'Spain',        4,  5,  'Right', (SELECT club_id FROM clubs WHERE short_name='FCP'), 2000000),
('Diogo',       'Costa',        '2000-09-19', 'Portugal',     1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='FCP'), 45000000),
('Alan',        'Varela',       '2001-06-01', 'Argentina',    2,  26, 'Right', (SELECT club_id FROM clubs WHERE short_name='FCP'), 25000000),
('Otavio',      'Edmilson',     '1995-02-09', 'Portugal',     2,  25, 'Right', (SELECT club_id FROM clubs WHERE short_name='FCP'), 12000000),
('Evanilson',   'Barbosa',      '1999-08-27', 'Brazil',       4,  20, 'Right', (SELECT club_id FROM clubs WHERE short_name='FCP'), 35000000),
('Zaidu',       'Sanusi',       '1999-06-11', 'Nigeria',      5,  35, 'Left',  (SELECT club_id FROM clubs WHERE short_name='FCP'), 15000000),
('Danny',       'Namaso',       '2002-10-17', 'England',      3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='FCP'), 20000000);

-- Sporting CP
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Pedro',       'Goncalves',    '1998-06-28', 'Portugal',     3,  28, 'Right', (SELECT club_id FROM clubs WHERE short_name='SCP'), 45000000),
('Viktor',      'Gyokeres',     '1998-06-04', 'Sweden',       4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='SCP'), 100000000),
('Morten',      'Hjulmand',     '1999-06-25', 'Denmark',      2,  25, 'Right', (SELECT club_id FROM clubs WHERE short_name='SCP'), 40000000),
('Matheus',     'Reis',         '1996-05-28', 'Brazil',       5,  3,  'Left',  (SELECT club_id FROM clubs WHERE short_name='SCP'), 15000000),
('Goncalo',     'Inacio',       '2001-08-05', 'Portugal',     4,  15, 'Left',  (SELECT club_id FROM clubs WHERE short_name='SCP'), 45000000),
('Franco',      'Israel',       '2000-07-19', 'Uruguay',      1,  12, 'Right', (SELECT club_id FROM clubs WHERE short_name='SCP'), 15000000),
('Nuno',        'Santos',       '1995-11-13', 'Portugal',     5,  18, 'Left',  (SELECT club_id FROM clubs WHERE short_name='SCP'), 12000000),
('Marcus',      'Edwards',      '1998-12-03', 'England',      3,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='SCP'), 20000000),
('Hidemasa',    'Morita',       '1995-04-16', 'Japan',        2,  20, 'Right', (SELECT club_id FROM clubs WHERE short_name='SCP'), 18000000),
('Francisco',   'Trincao',      '2000-12-29', 'Portugal',     3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='SCP'), 25000000);

-- ============================================================
-- EREDIVISIE (Netherlands)
-- ============================================================

-- Ajax
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Steven',      'Berghuis',     '1991-12-19', 'Netherlands',  3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='AJX'), 8000000),
('Jordan',      'Henderson',    '1990-06-17', 'England',      2,  6,  'Right', (SELECT club_id FROM clubs WHERE short_name='AJX'), 4000000),
('Branco',      'van den Boomen','1995-07-21','Netherlands',  2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='AJX'), 10000000),
('Bertrand',    'Traore',       '1995-09-06', 'Burkina Faso', 3,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='AJX'), 8000000),
('Sivert',      'Mannsverk',    '2001-07-26', 'Norway',       2,  28, 'Right', (SELECT club_id FROM clubs WHERE short_name='AJX'), 12000000),
('Devyne',      'Rensch',       '2003-02-22', 'Netherlands',  5,  2,  'Right', (SELECT club_id FROM clubs WHERE short_name='AJX'), 20000000),
('Jorrel',      'Hato',         '2005-10-28', 'Netherlands',  5,  52, 'Left',  (SELECT club_id FROM clubs WHERE short_name='AJX'), 25000000),
('Remko',       'Pasveer',      '1983-11-07', 'Netherlands',  1,  22, 'Right', (SELECT club_id FROM clubs WHERE short_name='AJX'), 2000000),
('Wout',        'Weghorst',     '1992-08-07', 'Netherlands',  4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='AJX'), 8000000),
('Carlos',      'Forbs',        '2004-06-22', 'Denmark',      3,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='AJX'), 20000000);

-- PSV Eindhoven
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Luuk',        'de Jong',      '1990-08-27', 'Netherlands',  4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='PSV'), 5000000),
('Hirving',     'Lozano',       '1995-07-30', 'Mexico',       3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='PSV'), 20000000),
('Joey',        'Veerman',      '1998-09-29', 'Netherlands',  2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='PSV'), 30000000),
('Guus',        'Til',          '1997-12-22', 'Netherlands',  2,  6,  'Right', (SELECT club_id FROM clubs WHERE short_name='PSV'), 15000000),
('Walter',      'Benitez',      '1993-01-13', 'Argentina',    1,  23, 'Right', (SELECT club_id FROM clubs WHERE short_name='PSV'), 12000000),
('Olivier',     'Boscagli',     '1997-11-18', 'France',       4,  17, 'Left',  (SELECT club_id FROM clubs WHERE short_name='PSV'), 15000000),
('Noa',         'Lang',         '1999-06-17', 'Netherlands',  3,  7,  'Left',  (SELECT club_id FROM clubs WHERE short_name='PSV'), 35000000),
('Ivan',        'Perisic',      '1989-02-02', 'Croatia',      5,  4,  'Left',  (SELECT club_id FROM clubs WHERE short_name='PSV'), 4000000),
('Malik',       'Tillman',      '2002-05-28', 'USA',          2,  14, 'Right', (SELECT club_id FROM clubs WHERE short_name='PSV'), 22000000),
('Johan',       'Bakayoko',     '2004-04-26', 'Belgium',      3,  33, 'Right', (SELECT club_id FROM clubs WHERE short_name='PSV'), 30000000);

-- ============================================================
-- PRO LEAGUE (Belgium)
-- ============================================================

-- Club Brugge
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Charles',     'De Ketelaere', '2001-03-10', 'Belgium',      3,  90, 'Right', (SELECT club_id FROM clubs WHERE short_name='CLB'), 35000000),
('Hans',        'Vanaken',      '1992-08-24', 'Belgium',      2,  20, 'Right', (SELECT club_id FROM clubs WHERE short_name='CLB'), 12000000),
('Simon',       'Mignolet',     '1988-03-06', 'Belgium',      1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='CLB'), 4000000),
('Denis',       'Odoi',         '1988-05-27', 'Belgium',      4,  3,  'Right', (SELECT club_id FROM clubs WHERE short_name='CLB'), 2000000),
('Ferran',      'Jutgla',       '1999-05-22', 'Spain',        4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='CLB'), 18000000),
('Antonio',     'Nusa',         '2005-10-29', 'Norway',       3,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='CLB'), 35000000),
('Brandon',     'Mechele',      '1993-01-28', 'Belgium',      4,  5,  'Right', (SELECT club_id FROM clubs WHERE short_name='CLB'), 5000000),
('Raphael',     'Onyedika',     '2001-07-09', 'Nigeria',      2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='CLB'), 20000000),
('Chemsdine',   'Talbi',        '2004-04-24', 'Morocco',      3,  17, 'Right', (SELECT club_id FROM clubs WHERE short_name='CLB'), 12000000),
('Bjorn',       'Meijer',       '2002-07-18', 'Netherlands',  5,  15, 'Left',  (SELECT club_id FROM clubs WHERE short_name='CLB'), 15000000);

-- ============================================================
-- SUPER LIG (Turkey)
-- ============================================================

-- Galatasaray
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Mauro',       'Icardi',       '1993-02-19', 'Argentina',    4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='GAL'), 8000000),
('Dries',       'Mertens',      '1987-05-06', 'Belgium',      3,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='GAL'), 3000000),
('Victor',      'Nelsson',      '1999-02-14', 'Denmark',      4,  25, 'Right', (SELECT club_id FROM clubs WHERE short_name='GAL'), 20000000),
('Davinson',    'Sanchez',      '1996-06-12', 'Colombia',     4,  6,  'Right', (SELECT club_id FROM clubs WHERE short_name='GAL'), 18000000),
('Fernando',    'Muslera',      '1986-06-16', 'Uruguay',      1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='GAL'), 2000000),
('Sergio',      'Oliveira',     '1992-06-02', 'Portugal',     2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='GAL'), 8000000),
('Wilfried',    'Zaha',         '1992-11-10', 'Ivory Coast',  3,  11, 'Left',  (SELECT club_id FROM clubs WHERE short_name='GAL'), 10000000),
('Hakim',       'Ziyech',       '1993-03-19', 'Morocco',      3,  22, 'Right', (SELECT club_id FROM clubs WHERE short_name='GAL'), 12000000),
('Lucas',       'Torreira',     '1996-02-11', 'Uruguay',      2,  34, 'Right', (SELECT club_id FROM clubs WHERE short_name='GAL'), 12000000),
('Kerem',       'Akturkoglu',   '1998-10-01', 'Turkey',       3,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='GAL'), 25000000);

-- Fenerbahce
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Edin',        'Dzeko',        '1986-03-17', 'Bosnia',       4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='FB'), 3000000),
('Michy',       'Batshuayi',    '1993-10-02', 'Belgium',      4,  23, 'Right', (SELECT club_id FROM clubs WHERE short_name='FB'), 5000000),
('Irfan',       'Can Kahveci',  '1996-07-15', 'Turkey',       2,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='FB'), 20000000),
('Enner',       'Valencia',     '1989-11-13', 'Ecuador',      4,  13, 'Right', (SELECT club_id FROM clubs WHERE short_name='FB'), 4000000),
('Dusan',       'Tadic',        '1988-11-20', 'Serbia',       3,  11, 'Left',  (SELECT club_id FROM clubs WHERE short_name='FB'), 6000000),
('Dominik',     'Livakovic',    '1995-01-09', 'Croatia',      1,  1,  'Right', (SELECT club_id FROM clubs WHERE short_name='FB'), 20000000),
('Alexander',   'Djiku',        '1994-08-09', 'Ghana',        4,  4,  'Right', (SELECT club_id FROM clubs WHERE short_name='FB'), 12000000),
('Rodrigo',     'Becao',        '1996-12-26', 'Brazil',       4,  25, 'Right', (SELECT club_id FROM clubs WHERE short_name='FB'), 15000000),
('Sebastian',   'Szymanski',    '1999-05-10', 'Poland',       2,  28, 'Right', (SELECT club_id FROM clubs WHERE short_name='FB'), 22000000),
('Jayden',      'Oosterwolde',  '2001-05-16', 'Netherlands',  5,  17, 'Left',  (SELECT club_id FROM clubs WHERE short_name='FB'), 18000000);

-- Besiktas
INSERT IGNORE INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value) VALUES
('Ciro',        'Immobile',     '1990-02-20', 'Italy',        4,  9,  'Right', (SELECT club_id FROM clubs WHERE short_name='BJK'), 5000000),
('Milot',       'Rashica',      '1996-06-28', 'Kosovo',       3,  7,  'Right', (SELECT club_id FROM clubs WHERE short_name='BJK'), 8000000),
('Arthur',      'Masuaku',      '1993-11-07', 'DR Congo',     5,  3,  'Left',  (SELECT club_id FROM clubs WHERE short_name='BJK'), 5000000),
('Ersin',       'Destanoglu',   '2001-05-01', 'Turkey',       1,  47, 'Right', (SELECT club_id FROM clubs WHERE short_name='BJK'), 10000000),
('Gedson',      'Fernandes',    '1999-01-09', 'Portugal',     2,  20, 'Right', (SELECT club_id FROM clubs WHERE short_name='BJK'), 15000000),
('Rachid',      'Ghezzal',      '1992-05-09', 'Algeria',      3,  11, 'Right', (SELECT club_id FROM clubs WHERE short_name='BJK'), 6000000),
('Dele',        'Alli',         '1996-04-11', 'England',      2,  10, 'Right', (SELECT club_id FROM clubs WHERE short_name='BJK'), 4000000),
('Al-Musrati',  'Omar',         '1996-08-14', 'Libya',        2,  8,  'Right', (SELECT club_id FROM clubs WHERE short_name='BJK'), 10000000),
('Gabriel',     'Paulista',     '1990-11-26', 'Brazil',       4,  5,  'Right', (SELECT club_id FROM clubs WHERE short_name='BJK'), 3000000),
('Joao',        'Mario',        '1993-01-19', 'Portugal',     2,  14, 'Right', (SELECT club_id FROM clubs WHERE short_name='BJK'), 8000000);

-- ============================================================
-- VERIFY
-- ============================================================
SELECT COUNT(*) AS total_players FROM players;
SELECT COUNT(*) AS total_clubs FROM clubs;
