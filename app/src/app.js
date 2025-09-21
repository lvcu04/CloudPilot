// simple REST API connecting to Postgres
const express = require('express');
const { Pool } = require('pg');

const app = express();
app.use(express.json());

app.use(express.static('src/public'));

const DATABASE_URL = process.env.DATABASE_URL || 'postgresql://postgres:password@cloudpilot:5432/postgres';

const pool = new Pool({
  connectionString: DATABASE_URL,
});

app.get('/', (req, res) => {
  res.json({ status: 'ok', time: new Date().toISOString() });
});

app.get('/items', async (req, res) => {
  const result = await pool.query('CREATE TABLE IF NOT EXISTS items (id SERIAL PRIMARY KEY, name TEXT); SELECT id, name FROM items ORDER BY id;');
  // For PostgreSQL multi-statement above, the SELECT will be in the last result.
  // pg client returns only last command for simple query; to keep simple, run SELECT separately:
  const { rows } = await pool.query('SELECT id, name FROM items ORDER BY id');
  res.json(rows);
});

app.post('/items', async (req, res) => {
  const { name } = req.body;
  if (!name) return res.status(400).json({ error: 'name required' });
  const { rows } = await pool.query('INSERT INTO items(name) VALUES($1) RETURNING id, name', [name]);
  res.status(201).json(rows[0]);
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`sample-api listening on ${port}`));
