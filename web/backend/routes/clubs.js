const express = require('express');
const router = express.Router();
const pool = require('../config/db');

/**
 * @openapi
 * /api/clubs:
 *   get:
 *     summary: Get all clubs
 *     tags: [Clubs]
 *     responses:
 *       200:
 *         description: List of clubs
 */
router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT c.club_id, c.club_name, c.short_name, c.founded_year,
             c.manager_name, c.sponsor_name, s.stadium_name, c.stadium_id
      FROM clubs c
      JOIN stadiums s ON c.stadium_id = s.stadium_id
      ORDER BY c.club_name
    `);
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/clubs/{id}:
 *   get:
 *     summary: Get a club by ID
 *     tags: [Clubs]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Club found
 *       404:
 *         description: Club not found
 */
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT c.*, s.stadium_name FROM clubs c
      JOIN stadiums s ON c.stadium_id = s.stadium_id
      WHERE c.club_id = ?`, [req.params.id]);
    if (!rows.length) return res.status(404).json({ error: 'Club not found' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/clubs:
 *   post:
 *     summary: Create a new club
 *     tags: [Clubs]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [club_name, short_name, founded_year, manager_name, stadium_id]
 *             properties:
 *               club_name: { type: string }
 *               short_name: { type: string }
 *               founded_year: { type: integer }
 *               manager_name: { type: string }
 *               sponsor_name: { type: string }
 *               stadium_id: { type: integer }
 *     responses:
 *       201:
 *         description: Club created
 */
router.post('/', async (req, res) => {
  try {
    const { club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id } = req.body;
    const [result] = await pool.query(
      'INSERT INTO clubs (club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id) VALUES (?, ?, ?, ?, ?, ?)',
      [club_name, short_name, founded_year, manager_name, sponsor_name || null, stadium_id]
    );
    res.status(201).json({ club_id: result.insertId, message: 'Club created successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/clubs/{id}:
 *   put:
 *     summary: Update a club
 *     tags: [Clubs]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *     responses:
 *       200:
 *         description: Club updated
 */
router.put('/:id', async (req, res) => {
  try {
    const { club_name, short_name, founded_year, manager_name, sponsor_name, stadium_id } = req.body;
    await pool.query(
      'UPDATE clubs SET club_name=?, short_name=?, founded_year=?, manager_name=?, sponsor_name=?, stadium_id=? WHERE club_id=?',
      [club_name, short_name, founded_year, manager_name, sponsor_name || null, stadium_id, req.params.id]
    );
    res.json({ message: 'Club updated successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * @openapi
 * /api/clubs/{id}:
 *   delete:
 *     summary: Delete a club
 *     tags: [Clubs]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *     responses:
 *       200:
 *         description: Club deleted
 */
router.delete('/:id', async (req, res) => {
  try {
    await pool.query('DELETE FROM clubs WHERE club_id = ?', [req.params.id]);
    res.json({ message: 'Club deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
