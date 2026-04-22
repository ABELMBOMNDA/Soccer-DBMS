const express = require('express');
const router = express.Router();
const pool = require('../config/db');

/**
 * @openapi
 * /api/fixtures:
 *   get:
 *     summary: Get all fixtures
 *     tags: [Fixtures]
 *     responses:
 *       200:
 *         description: List of fixtures
 */
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT f.fixture_id, s.season_name, f.matchweek,
             DATE_FORMAT(f.match_date, '%Y-%m-%d %H:%i') AS match_date,
             hc.club_name AS home_club, ac.club_name AS away_club,
             st.stadium_name, f.home_score, f.away_score,
             CONCAT(COALESCE(f.home_score,'?'), ' - ', COALESCE(f.away_score,'?')) AS score,
             f.status, f.attendance,
             COALESCE(f.competition, 'Premier League') AS competition,
             f.season_id, f.home_club_id, f.away_club_id, f.stadium_id
      FROM fixtures f
      JOIN seasons s ON f.season_id = s.season_id
      JOIN clubs hc ON f.home_club_id = hc.club_id
      JOIN clubs ac ON f.away_club_id = ac.club_id
      JOIN stadiums st ON f.stadium_id = st.stadium_id
      ORDER BY f.match_date DESC
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/fixtures/{id}:
 *   get:
 *     summary: Get a fixture by ID
 *     tags: [Fixtures]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Fixture found
 *       404:
 *         description: Fixture not found
 */
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM fixtures WHERE fixture_id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ error: 'Fixture not found' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/fixtures:
 *   post:
 *     summary: Create a new fixture
 *     tags: [Fixtures]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [season_id, matchweek, match_date, stadium_id, home_club_id, away_club_id, status]
 *             properties:
 *               season_id: { type: integer }
 *               matchweek: { type: integer }
 *               match_date: { type: string }
 *               stadium_id: { type: integer }
 *               home_club_id: { type: integer }
 *               away_club_id: { type: integer }
 *               home_score: { type: integer }
 *               away_score: { type: integer }
 *               status: { type: string, enum: [SCHEDULED, COMPLETED, POSTPONED, CANCELLED] }
 *               attendance: { type: integer }
 *     responses:
 *       201:
 *         description: Fixture created
 */
router.post('/', async (req, res) => {
  try {
    const { season_id, matchweek, match_date, stadium_id, home_club_id, away_club_id, home_score, away_score, status, attendance, competition } = req.body;
    if (home_club_id === away_club_id) return res.status(400).json({ error: 'Home and away clubs must be different' });
    const [result] = await pool.query(
      'INSERT INTO fixtures (season_id, matchweek, match_date, stadium_id, home_club_id, away_club_id, home_score, away_score, status, attendance, competition) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [season_id, matchweek, match_date, stadium_id, home_club_id, away_club_id, home_score ?? null, away_score ?? null, status, attendance || null, competition || 'Premier League']
    );
    res.status(201).json({ fixture_id: result.insertId, message: 'Fixture created successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/fixtures/{id}:
 *   put:
 *     summary: Update a fixture
 *     tags: [Fixtures]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Fixture updated
 */
router.put('/:id', async (req, res) => {
  try {
    const { season_id, matchweek, match_date, stadium_id, home_club_id, away_club_id, home_score, away_score, status, attendance, competition } = req.body;
    if (home_club_id === away_club_id) return res.status(400).json({ error: 'Home and away clubs must be different' });
    await pool.query(
      'UPDATE fixtures SET season_id=?, matchweek=?, match_date=?, stadium_id=?, home_club_id=?, away_club_id=?, home_score=?, away_score=?, status=?, attendance=?, competition=? WHERE fixture_id=?',
      [season_id, matchweek, match_date, stadium_id, home_club_id, away_club_id, home_score ?? null, away_score ?? null, status, attendance || null, competition || 'Premier League', req.params.id]
    );
    res.json({ message: 'Fixture updated successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/fixtures/{id}:
 *   delete:
 *     summary: Delete a fixture
 *     tags: [Fixtures]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Fixture deleted
 */
router.delete('/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM fixtures WHERE fixture_id = ?', [req.params.id]);
    res.json({ message: 'Fixture deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
