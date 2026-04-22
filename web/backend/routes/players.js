const express = require('express');
const router = express.Router();
const pool = require('../config/db');

/**
 * @openapi
 * /api/players:
 *   get:
 *     summary: Get all players
 *     tags: [Players]
 *     responses:
 *       200:
 *         description: List of players
 */
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT p.player_id, p.first_name, p.last_name,
             CONCAT(p.first_name, ' ', p.last_name) AS player_name,
             p.date_of_birth, p.nationality, pos.position_code,
             p.squad_number, p.preferred_foot, c.club_name,
             p.market_value, p.position_id, p.current_club_id,
             COALESCE(p.player_status, 'ACTIVE') AS player_status
      FROM players p
      JOIN positions pos ON p.position_id = pos.position_id
      LEFT JOIN clubs c ON p.current_club_id = c.club_id
      ORDER BY p.player_id ASC
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/players/{id}:
 *   get:
 *     summary: Get a player by ID
 *     tags: [Players]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Player found
 *       404:
 *         description: Player not found
 */
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM players WHERE player_id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ error: 'Player not found' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/players:
 *   post:
 *     summary: Create a new player
 *     tags: [Players]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [first_name, last_name, date_of_birth, nationality, position_id, preferred_foot, market_value]
 *             properties:
 *               first_name: { type: string }
 *               last_name: { type: string }
 *               date_of_birth: { type: string, format: date }
 *               nationality: { type: string }
 *               position_id: { type: integer }
 *               squad_number: { type: integer }
 *               preferred_foot: { type: string, enum: [Right, Left, Both] }
 *               current_club_id: { type: integer }
 *               market_value: { type: number }
 *     responses:
 *       201:
 *         description: Player created
 */
router.post('/', async (req, res) => {
  try {
    const { first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value, player_status } = req.body;
    const [result] = await pool.query(
      'INSERT INTO players (first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value, player_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [first_name, last_name, date_of_birth, nationality, position_id, squad_number || null, preferred_foot, current_club_id || null, market_value, player_status || 'ACTIVE']
    );
    res.status(201).json({ player_id: result.insertId, message: 'Player created successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/players/{id}:
 *   put:
 *     summary: Update a player
 *     tags: [Players]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Player updated
 */
router.put('/:id', async (req, res) => {
  try {
    const { first_name, last_name, date_of_birth, nationality, position_id, squad_number, preferred_foot, current_club_id, market_value, player_status } = req.body;
    await pool.query(
      'UPDATE players SET first_name=?, last_name=?, date_of_birth=?, nationality=?, position_id=?, squad_number=?, preferred_foot=?, current_club_id=?, market_value=?, player_status=? WHERE player_id=?',
      [first_name, last_name, date_of_birth, nationality, position_id, squad_number || null, preferred_foot, current_club_id || null, market_value, player_status || 'ACTIVE', req.params.id]
    );
    res.json({ message: 'Player updated successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/players/{id}:
 *   delete:
 *     summary: Delete a player
 *     tags: [Players]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Player deleted
 */
router.delete('/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM players WHERE player_id = ?', [req.params.id]);
    res.json({ message: 'Player deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
