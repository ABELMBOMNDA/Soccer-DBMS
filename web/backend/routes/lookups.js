const express = require('express');
const router = express.Router();
const pool = require('../config/db');

/**
 * @openapi
 * /api/lookups/clubs:
 *   get:
 *     summary: Get all clubs for dropdowns
 *     tags: [Lookups]
 *     responses:
 *       200:
 *         description: List of clubs
 */
router.get('/clubs', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT club_id, club_name FROM clubs ORDER BY club_name');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/lookups/seasons:
 *   get:
 *     summary: Get all seasons for dropdowns
 *     tags: [Lookups]
 *     responses:
 *       200:
 *         description: List of seasons
 */
router.get('/seasons', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT season_id, season_name FROM seasons ORDER BY start_date DESC');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/lookups/stadiums:
 *   get:
 *     summary: Get all stadiums for dropdowns
 *     tags: [Lookups]
 *     responses:
 *       200:
 *         description: List of stadiums
 */
router.get('/stadiums', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT stadium_id, stadium_name FROM stadiums ORDER BY stadium_name');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/lookups/positions:
 *   get:
 *     summary: Get all positions for dropdowns
 *     tags: [Lookups]
 *     responses:
 *       200:
 *         description: List of positions
 */
router.get('/positions', async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT position_id, CONCAT(position_code, ' - ', position_name) AS label FROM positions ORDER BY position_code");
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/lookups/players:
 *   get:
 *     summary: Get all players for dropdowns
 *     tags: [Lookups]
 *     responses:
 *       200:
 *         description: List of players
 */
router.get('/players', async (req, res) => {
  try {
    const [rows] = await pool.query("SELECT player_id, CONCAT(first_name, ' ', last_name) AS player_name, current_club_id FROM players ORDER BY last_name, first_name");
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
