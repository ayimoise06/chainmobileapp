const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const { getDb } = require('./db');
const authRoutes = require('./routes/auth');
const batchRoutes = require('./routes/batches');

dotenv.config();

const app = express();
const port = process.env.PORT || 4000;

if (!process.env.JWT_SECRET) {
  console.error('JWT_SECRET is required to start the API.');
  process.exit(1);
}

app.use(cors());
app.use(express.json());

app.get('/health', async (_req, res) => {
  await getDb();
  res.json({ status: 'ok' });
});

app.use('/auth', authRoutes);
app.use('/batches', batchRoutes);

app.use((req, res) => {
  res.status(404).json({ message: 'Introuvable.' });
});

app.use((err, _req, res, _next) => {
  console.error(err);
  res.status(500).json({ message: 'Erreur serveur.' });
});

app.listen(port, () => {
  console.log(`API listening on port ${port}`);
});
