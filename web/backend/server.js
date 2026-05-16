require('dotenv').config();
const express = require('express');
const cors = require('cors');
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const clubsRouter = require('./routes/clubs');
const playersRouter = require('./routes/players');
const fixturesRouter = require('./routes/fixtures');
const transfersRouter = require('./routes/transfers');
const officialSquadsRouter = require('./routes/official_squads');
const reportsRouter = require('./routes/reports');
const lookupsRouter = require('./routes/lookups');
const pool = require('./config/db');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors({
  origin: process.env.FRONTEND_URL || '*',
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type'],
}));
app.use(express.json());

// OpenAPI / Swagger setup
const swaggerOptions = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'EPL DBMS API',
      version: '1.0.0',
      description: 'English Premier League Database Management System REST API',
    },
    servers: [{ url: `http://localhost:${PORT}` }],
    tags: [
      { name: 'Clubs', description: 'Club management' },
      { name: 'Players', description: 'Player management' },
      { name: 'Fixtures', description: 'Fixture management' },
      { name: 'Transfers', description: 'Transfer management' },
      { name: 'Official Squads', description: 'Official registered squads' },
      { name: 'Reports', description: 'Reports and analytics' },
      { name: 'Lookups', description: 'Dropdown data' },
    ],
  },
  apis: ['./routes/*.js'],
};

const swaggerSpec = swaggerJsdoc(swaggerOptions);
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
app.get('/api-docs.json', (req, res) => res.json(swaggerSpec));

// Health check — tests DB connection
app.get('/api/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', database: 'connected' });
  } catch (err) {
    res.status(500).json({ status: 'error', database: 'disconnected', error: err.message });
  }
});

// Routes
app.use('/api/clubs', clubsRouter);
app.use('/api/players', playersRouter);
app.use('/api/fixtures', fixturesRouter);
app.use('/api/transfers', transfersRouter);
app.use('/api/official-squads', officialSquadsRouter);
app.use('/api/reports', reportsRouter);
app.use('/api/lookups', lookupsRouter);

app.get('/', (req, res) => res.json({ message: 'EPL DBMS API is running', docs: '/api-docs', health: '/api/health' }));

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: `Route ${req.method} ${req.originalUrl} not found` });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error('Unhandled error:', err);
  res.status(500).json({ error: err.message || 'Internal server error' });
});

// Kill any existing process on the port before starting
const server = app.listen(PORT, () => {
  console.log(`\n EPL DBMS Backend running on http://localhost:${PORT}`);
  console.log(` API Docs: http://localhost:${PORT}/api-docs`);
  console.log(` Health:   http://localhost:${PORT}/api/health\n`);
});

server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.error(`\n Port ${PORT} is already in use.`);
    console.error(` Run this command to free it: lsof -ti :${PORT} | xargs kill -9\n`);
    process.exit(1);
  }
});
