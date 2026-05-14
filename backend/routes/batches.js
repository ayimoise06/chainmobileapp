const express = require('express');
const { randomUUID } = require('crypto');
const { getDb } = require('../db');
const { requireAuth } = require('../middleware/auth');
const { apiLimiter } = require('../middleware/rate_limit');

const router = express.Router();

router.get('/', apiLimiter, requireAuth, async (req, res) => {
  const db = await getDb();
  const batches = await db.all(
    'SELECT * FROM batches WHERE user_id = ? ORDER BY created_at DESC',
    [req.user.sub],
  );
  return res.json({
    batches: batches.map((batch) => ({
      id: batch.id,
      type: batch.type,
      weight: batch.weight,
      origin: batch.origin,
      producer: batch.producer,
      createdAt: batch.created_at,
    })),
  });
});

router.post('/', apiLimiter, requireAuth, async (req, res) => {
  const { id, type, weight, origin, producer } = req.body;

  if (!type || !weight || !origin || !producer) {
    return res.status(400).json({ message: 'Informations du lot manquantes.' });
  }

  const weightValue = Number(weight);
  if (!Number.isFinite(weightValue) || weightValue <= 0) {
    return res.status(400).json({ message: 'Le poids doit être un nombre positif.' });
  }

  const batchId = id || `LOT-${randomUUID().slice(0, 8).toUpperCase()}`;
  const createdAt = new Date().toISOString();
  const db = await getDb();

  await db.run(
    `INSERT INTO batches (id, user_id, type, weight, origin, producer, created_at)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [batchId, req.user.sub, type, weightValue, origin, producer, createdAt],
  );

  return res.status(201).json({
    batch: {
      id: batchId,
      type,
      weight: weightValue,
      origin,
      producer,
      createdAt,
    },
  });
});

module.exports = router;
