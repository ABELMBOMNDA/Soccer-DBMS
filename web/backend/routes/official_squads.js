const express = require('express');
const router = express.Router();
const pool = require('../config/db');

/**
 * @openapi
 * /api/official-squads/seasons:
 *   get:
 *     summary: Get distinct season names from official squads
 *     tags: [Official Squads]
 *     responses:
 *       200:
 *         description: List of season names
 */
router.get('/seasons', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT DISTINCT season_name FROM official_registered_squads ORDER BY season_name DESC');
    res.json(rows.map(r => r.season_name));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/official-squads/clubs:
 *   get:
 *     summary: Get distinct club names for a season
 *     tags: [Official Squads]
 *     parameters:
 *       - in: query
 *         name: season
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: List of club names
 */
router.get('/clubs', async (req, res) => {
  try {
    const { season } = req.query;
    const [rows] = await pool.query('SELECT DISTINCT club_name FROM official_registered_squads WHERE season_name = ? ORDER BY club_name', [season]);
    res.json(rows.map(r => r.club_name));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/official-squads/summary:
 *   get:
 *     summary: Get club summary for a season
 *     tags: [Official Squads]
 *     parameters:
 *       - in: query
 *         name: season
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Club summary
 */
router.get('/summary', async (req, res) => {
  try {
    const { season } = req.query;
    const [rows] = await pool.query(`
      SELECT club_name,
             COUNT(*) AS registered_senior_players,
             SUM(CASE WHEN is_home_grown THEN 1 ELSE 0 END) AS home_grown_players,
             SUM(CASE WHEN is_home_grown THEN 0 ELSE 1 END) AS non_home_grown_players
      FROM official_registered_squads
      WHERE season_name = ?
      GROUP BY club_name ORDER BY club_name
    `, [season]);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/official-squads/home-grown:
 *   get:
 *     summary: Get home-grown players
 *     tags: [Official Squads]
 *     parameters:
 *       - in: query
 *         name: season
 *         required: true
 *         schema:
 *           type: string
 *       - in: query
 *         name: club
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: List of home-grown players
 */
router.get('/home-grown', async (req, res) => {
  try {
    const { season, club } = req.query;
    let sql = 'SELECT club_name, player_name FROM official_registered_squads WHERE season_name = ? AND is_home_grown = TRUE';
    const params = [season];
    if (club) { sql += ' AND club_name = ?'; params.push(club); }
    sql += ' ORDER BY club_name, player_name';
    const [rows] = await pool.query(sql, params);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/official-squads/snapshot:
 *   get:
 *     summary: Get latest snapshot date
 *     tags: [Official Squads]
 *     responses:
 *       200:
 *         description: Latest snapshot date
 */
router.get('/snapshot', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT MAX(source_snapshot_date) AS latest_snapshot FROM official_registered_squads');
    res.json({ latest_snapshot: rows[0].latest_snapshot });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/official-squads:
 *   get:
 *     summary: Get official squad entries with optional filters
 *     tags: [Official Squads]
 *     parameters:
 *       - in: query
 *         name: season
 *         schema:
 *           type: string
 *       - in: query
 *         name: club
 *         schema:
 *           type: string
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: List of official squad entries
 */
router.get('/', async (req, res) => {
  try {
    const { season, club, search } = req.query;
    let sql = `SELECT season_name, source_snapshot_date, club_name, player_name,
                      CASE WHEN is_home_grown THEN 'Yes' ELSE 'No' END AS home_grown, squad_scope
               FROM official_registered_squads WHERE 1=1`;
    const params = [];
    if (season) { sql += ' AND season_name = ?'; params.push(season); }
    if (club) { sql += ' AND club_name = ?'; params.push(club); }
    if (search) { sql += ' AND player_name LIKE ?'; params.push(`%${search}%`); }
    sql += ' ORDER BY club_name, player_name';
    const [rows] = await pool.query(sql, params);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
