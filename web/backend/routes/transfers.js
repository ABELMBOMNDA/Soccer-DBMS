const express = require('express');
const router = express.Router();
const pool = require('../config/db');

/**
 * @openapi
 * /api/transfers:
 *   get:
 *     summary: Get all transfers
 *     tags: [Transfers]
 *     responses:
 *       200:
 *         description: List of transfers
 */
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT t.transfer_id, CONCAT(p.first_name, ' ', p.last_name) AS player_name,
             s.season_name, COALESCE(fc.club_name, 'Free Agent') AS from_club,
             tc.club_name AS to_club, t.transfer_date, t.transfer_fee,
             t.transfer_type, t.status,
             t.player_id, t.season_id, t.from_club_id, t.to_club_id
      FROM transfers t
      JOIN players p ON t.player_id = p.player_id
      JOIN seasons s ON t.season_id = s.season_id
      LEFT JOIN clubs fc ON t.from_club_id = fc.club_id
      JOIN clubs tc ON t.to_club_id = tc.club_id
      ORDER BY t.transfer_date DESC
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/transfers/{id}:
 *   get:
 *     summary: Get a transfer by ID
 *     tags: [Transfers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Transfer found
 *       404:
 *         description: Transfer not found
 */
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM transfers WHERE transfer_id = ?', [req.params.id]);
    if (!rows.length) return res.status(404).json({ error: 'Transfer not found' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/transfers:
 *   post:
 *     summary: Create a new transfer
 *     tags: [Transfers]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [player_id, season_id, to_club_id, transfer_date, transfer_fee, transfer_type, status]
 *             properties:
 *               player_id: { type: integer }
 *               season_id: { type: integer }
 *               from_club_id: { type: integer }
 *               to_club_id: { type: integer }
 *               transfer_date: { type: string, format: date }
 *               transfer_fee: { type: number }
 *               transfer_type: { type: string, enum: [PERMANENT, LOAN, FREE_AGENT] }
 *               status: { type: string, enum: [PENDING, COMPLETED, CANCELLED] }
 *     responses:
 *       201:
 *         description: Transfer created
 */
router.post('/', async (req, res) => {
  try {
    const { player_id, season_id, from_club_id, to_club_id, transfer_date, transfer_fee, transfer_type, status } = req.body;
    if (from_club_id && from_club_id === to_club_id) return res.status(400).json({ error: 'From and To clubs must be different' });
    const [result] = await pool.query(
      'INSERT INTO transfers (player_id, season_id, from_club_id, to_club_id, transfer_date, transfer_fee, transfer_type, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [player_id, season_id, from_club_id || null, to_club_id, transfer_date, transfer_fee, transfer_type, status]
    );
    if (status === 'COMPLETED') {
      await pool.query('UPDATE players SET current_club_id = ? WHERE player_id = ?', [to_club_id, player_id]);
    }
    res.status(201).json({ transfer_id: result.insertId, message: 'Transfer created successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/transfers/{id}:
 *   put:
 *     summary: Update a transfer
 *     tags: [Transfers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Transfer updated
 */
router.put('/:id', async (req, res) => {
  try {
    const { player_id, season_id, from_club_id, to_club_id, transfer_date, transfer_fee, transfer_type, status } = req.body;
    if (from_club_id && from_club_id === to_club_id) return res.status(400).json({ error: 'From and To clubs must be different' });
    await pool.query(
      'UPDATE transfers SET player_id=?, season_id=?, from_club_id=?, to_club_id=?, transfer_date=?, transfer_fee=?, transfer_type=?, status=? WHERE transfer_id=?',
      [player_id, season_id, from_club_id || null, to_club_id, transfer_date, transfer_fee, transfer_type, status, req.params.id]
    );
    if (status === 'COMPLETED') {
      await pool.query('UPDATE players SET current_club_id = ? WHERE player_id = ?', [to_club_id, player_id]);
    }
    res.json({ message: 'Transfer updated successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/transfers/{id}:
 *   delete:
 *     summary: Delete a transfer
 *     tags: [Transfers]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Transfer deleted
 */
router.delete('/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM transfers WHERE transfer_id = ?', [req.params.id]);
    res.json({ message: 'Transfer deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
