const mysql = require('mysql2/promise');
require('dotenv').config();

// Support Railway's MySQL plugin env vars (MYSQLHOST etc.) and standard DB_* vars
const pool = mysql.createPool({
  host:     process.env.MYSQLHOST     || process.env.DB_HOST     || 'localhost',
  port:     process.env.MYSQLPORT     || process.env.DB_PORT     || 3306,
  database: process.env.MYSQLDATABASE || process.env.DB_NAME     || 'epl_dbms',
  user:     process.env.MYSQLUSER     || process.env.DB_USER     || 'epl_admin',
  password: process.env.MYSQLPASSWORD || process.env.DB_PASSWORD || 'epl_admin123',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

module.exports = pool;
