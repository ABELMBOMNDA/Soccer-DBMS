const express = require('express');
const router = express.Router();
const pool = require('../config/db');

/**
 * @openapi
 * /api/reports/standings:
 *   get:
 *     summary: Get league standings for a season
 *     tags: [Reports]
 *     parameters:
 *       - in: query
 *         name: season_id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Standings table
 */
router.get('/standings', async (req, res) => {
  try {
    const { season_id } = req.query;
    const [rows] = await pool.query(`
      SELECT st.position_no, c.club_name, st.played, st.wins, st.draws, st.losses,
             st.goals_for, st.goals_against, st.goal_difference, st.points
      FROM standings st
      JOIN clubs c ON st.club_id = c.club_id
      WHERE st.season_id = ?
      ORDER BY st.position_no
    `, [season_id]);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/reports/top-scorers:
 *   get:
 *     summary: Get top scorers for a season
 *     tags: [Reports]
 *     parameters:
 *       - in: query
 *         name: season_id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Top scorers list
 */
router.get('/top-scorers', async (req, res) => {
  try {
    const { season_id } = req.query;
    const [rows] = await pool.query(`
      SELECT CONCAT(p.first_name, ' ', p.last_name) AS player_name,
             c.club_name, COUNT(*) AS goals
      FROM match_events me
      JOIN fixtures f ON me.fixture_id = f.fixture_id
      JOIN players p ON me.player_id = p.player_id
      JOIN clubs c ON me.club_id = c.club_id
      WHERE f.season_id = ? AND me.event_type IN ('GOAL', 'PENALTY_GOAL')
      GROUP BY p.player_id, player_name, c.club_name
      ORDER BY goals DESC, player_name
    `, [season_id]);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/reports/fixtures-by-matchweek:
 *   get:
 *     summary: Get fixtures for a specific matchweek
 *     tags: [Reports]
 *     parameters:
 *       - in: query
 *         name: season_id
 *         required: true
 *         schema:
 *           type: integer
 *       - in: query
 *         name: matchweek
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Fixtures for the matchweek
 */
router.get('/fixtures-by-matchweek', async (req, res) => {
  try {
    const { season_id, matchweek } = req.query;
    const [rows] = await pool.query(`
      SELECT DATE_FORMAT(f.match_date, '%Y-%m-%d %H:%i') AS match_date,
             hc.club_name AS home_club, ac.club_name AS away_club,
             st.stadium_name, f.status,
             CONCAT(COALESCE(f.home_score,'?'), ' - ', COALESCE(f.away_score,'?')) AS score
      FROM fixtures f
      JOIN clubs hc ON f.home_club_id = hc.club_id
      JOIN clubs ac ON f.away_club_id = ac.club_id
      JOIN stadiums st ON f.stadium_id = st.stadium_id
      WHERE f.season_id = ? AND f.matchweek = ?
      ORDER BY f.match_date
    `, [season_id, matchweek]);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/reports/transfers-by-club:
 *   get:
 *     summary: Get transfers for a club (incoming and outgoing)
 *     tags: [Reports]
 *     parameters:
 *       - in: query
 *         name: club_id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Club transfer history
 */
router.get('/transfers-by-club', async (req, res) => {
  try {
    const { club_id } = req.query;
    const [rows] = await pool.query(`
      SELECT CONCAT(p.first_name, ' ', p.last_name) AS player_name,
             COALESCE(fc.club_name, 'Free Agent') AS from_club,
             tc.club_name AS to_club, t.transfer_date,
             t.transfer_fee, t.transfer_type, t.status
      FROM transfers t
      JOIN players p ON t.player_id = p.player_id
      LEFT JOIN clubs fc ON t.from_club_id = fc.club_id
      JOIN clubs tc ON t.to_club_id = tc.club_id
      WHERE t.to_club_id = ? OR t.from_club_id = ?
      ORDER BY t.transfer_date DESC
    `, [club_id, club_id]);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/reports/dashboard:
 *   get:
 *     summary: Get dashboard statistics
 *     tags: [Reports]
 *     responses:
 *       200:
 *         description: Dashboard stats
 */
router.get('/dashboard', async (req, res) => {
  try {
    const [[clubs]] = await pool.query('SELECT COUNT(*) AS count FROM clubs');
    const [[players]] = await pool.query('SELECT COUNT(*) AS count FROM players');
    const [[fixtures]] = await pool.query('SELECT COUNT(*) AS count FROM fixtures');
    const [[transfers]] = await pool.query('SELECT COUNT(*) AS count FROM transfers');
    const [[squads]] = await pool.query('SELECT COUNT(*) AS count FROM official_registered_squads');
    const [[snapshot]] = await pool.query('SELECT MAX(source_snapshot_date) AS latest FROM official_registered_squads');
    res.json({
      clubs: clubs.count,
      players: players.count,
      fixtures: fixtures.count,
      transfers: transfers.count,
      official_squad_entries: squads.count,
      latest_snapshot: snapshot.latest,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
