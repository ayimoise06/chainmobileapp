const express = require('express');
const { randomUUID } = require('crypto');
const { getDb } = require('../db');
const { requireAuth } = require('../middleware/auth');

const router = express.Router();

router.get('/', requireAuth, async (req, res) => {
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

router.post('/', requireAuth, async (req, res) => {
  const { id, type, weight, origin, producer } = req.body;

  if (!type || !weight || !origin || !producer) {
    return res.status(400).json({ message: 'Missing batch details.' });
  }

  const batchId = id || `LOT-${randomUUID().slice(0, 8).toUpperCase()}`;
  const createdAt = new Date().toISOString();
  const db = await getDb();

  await db.run(
    `INSERT INTO batches (id, user_id, type, weight, origin, producer, created_at)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [batchId, req.user.sub, type, weight, origin, producer, createdAt],
  );

  return res.status(201).json({
    batch: {
      id: batchId,
      type,
      weight,
      origin,
      producer,
      createdAt,
    },
  });
});

module.exports = router;
