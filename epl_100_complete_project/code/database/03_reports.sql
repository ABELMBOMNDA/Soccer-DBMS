USE epl_dbms;

-- 1. Current standings
SELECT *
FROM vw_current_standings
WHERE season_name = '2025/2026';

-- 2. Top scorers
SELECT *
FROM vw_top_scorers
WHERE season_name = '2025/2026';

-- 3. Fixtures for a given matchweek
SELECT
    s.season_name,
    f.matchweek,
    DATE_FORMAT(f.match_date, '%Y-%m-%d %H:%i') AS match_date,
    hc.club_name AS home_club,
    ac.club_name AS away_club,
    f.status,
    CONCAT(f.home_score, ' - ', f.away_score) AS score
FROM fixtures f
JOIN seasons s ON f.season_id = s.season_id
JOIN clubs hc ON f.home_club_id = hc.club_id
JOIN clubs ac ON f.away_club_id = ac.club_id
WHERE s.season_name = '2025/2026' AND f.matchweek = 1
ORDER BY f.match_date;

-- 4. Players in a club
SELECT
    c.club_name,
    p.player_id,
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    pos.position_name,
    p.squad_number,
    p.nationality
FROM players p
JOIN clubs c ON p.current_club_id = c.club_id
JOIN positions pos ON p.position_id = pos.position_id
WHERE c.club_name = 'Manchester United'
ORDER BY p.squad_number, p.last_name;

-- 5. Transfers made by a club
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    COALESCE(fc.club_name, 'Free Agent') AS from_club,
    tc.club_name AS to_club,
    t.transfer_date,
    t.transfer_fee,
    t.transfer_type,
    t.status
FROM transfers t
JOIN players p ON t.player_id = p.player_id
LEFT JOIN clubs fc ON t.from_club_id = fc.club_id
JOIN clubs tc ON t.to_club_id = tc.club_id
WHERE tc.club_name = 'Tottenham Hotspur'
ORDER BY t.transfer_date DESC;

-- 6. Club with most wins in a season
SELECT
    s.season_name,
    c.club_name,
    st.wins,
    st.points
FROM standings st
JOIN seasons s ON st.season_id = s.season_id
JOIN clubs c ON st.club_id = c.club_id
WHERE s.season_name = '2025/2026'
ORDER BY st.wins DESC, st.points DESC
LIMIT 1;

-- 7. Yellow/red card summary
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS player_name,
    c.club_name,
    SUM(CASE WHEN me.event_type = 'YELLOW_CARD' THEN 1 ELSE 0 END) AS yellow_cards,
    SUM(CASE WHEN me.event_type = 'RED_CARD' THEN 1 ELSE 0 END) AS red_cards
FROM match_events me
JOIN players p ON me.player_id = p.player_id
JOIN clubs c ON me.club_id = c.club_id
GROUP BY p.player_id, player_name, c.club_name
ORDER BY red_cards DESC, yellow_cards DESC, player_name;


-- 8. Official current senior squad counts by club
SELECT *
FROM vw_current_official_squad_counts
WHERE season_name = '2025/26';

-- 9. Official registered squad for Arsenal
SELECT
    player_name,
    CASE WHEN is_home_grown THEN 'Yes' ELSE 'No' END AS home_grown
FROM official_registered_squads
WHERE season_name = '2025/26'
  AND club_name = 'Arsenal'
ORDER BY player_name;

-- 10. All home-grown players in the official registered squads
SELECT *
FROM vw_current_home_grown_players
WHERE season_name = '2025/26';
