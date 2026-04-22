-- ============================================================
--  EPL DBMS - REMOVE NON-EPL/CHAMPIONSHIP STADIUMS
--  Keeps only: 20 Premier League + 25 EFL Championship stadiums
--  Run this in MySQL Workbench
-- ============================================================

USE epl_dbms;

-- Remove League One/Two, Scottish, Welsh, Northern Irish,
-- national/rugby stadiums, and duplicates
DELETE FROM stadiums WHERE stadium_id IN (
  39,  -- Oakwell (Barnsley - League One)
  47,  -- Madejski Stadium (Reading - not Championship 2024/25)
  48,  -- Ipswich Town FC Stadium (duplicate / promoted to PL)
  49,  -- Valley Parade (Bradford - League One)
  50,  -- DW Stadium (Wigan - League One)
  51,  -- Boundary Park (Oldham - League Two)
  52,  -- Bloomfield Road (Blackpool - League One)
  53,  -- Adams Park (High Wycombe - League One)
  54,  -- Ricoh Arena (duplicate of Coventry Building Society Arena)
  55,  -- Sincil Bank (Lincoln - League One)
  56,  -- Highbury Stadium (Fleetwood - League Two)
  57,  -- Crown Ground (Accrington - League Two)
  58,  -- Edgeley Park (Stockport - League One)
  59,  -- Celtic Park (Scotland)
  60,  -- Ibrox Stadium (Scotland)
  61,  -- Pittodrie Stadium (Scotland)
  62,  -- Easter Road (Scotland)
  63,  -- Tynecastle Park (Scotland)
  64,  -- Tannadice Park (Scotland)
  65,  -- Dens Park (Scotland)
  66,  -- McDiarmid Park (Scotland)
  67,  -- Rugby Park (Scotland)
  68,  -- Fir Park (Scotland)
  69,  -- St Mirren Park (Scotland)
  70,  -- Livingston FC Stadium (Scotland)
  71,  -- Rodney Parade (Wales - non-EFL)
  72,  -- Cardiff Arms Park (Wales - rugby)
  73,  -- Racecourse Ground (Wrexham - League One)
  74,  -- The New Saints FC Ground (Wales)
  75,  -- Windsor Park (Northern Ireland)
  76,  -- Seaview (Northern Ireland)
  77,  -- Wembley Stadium (national)
  78,  -- Allianz Stadium (rugby)
  79,  -- Hampden Park (Scotland - national)
  80,  -- Murrayfield Stadium (Scotland - rugby)
  81   -- Principality Stadium (Wales - rugby/national)
);

-- Verify what remains
SELECT stadium_id, stadium_name, city, country, capacity
FROM stadiums
ORDER BY stadium_id;

SELECT COUNT(*) AS total_stadiums FROM stadiums;
