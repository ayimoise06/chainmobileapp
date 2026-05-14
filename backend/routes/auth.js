const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { randomUUID } = require('crypto');
const { getDb } = require('../db');
const { requireAuth } = require('../middleware/auth');
const { authLimiter, apiLimiter } = require('../middleware/rate_limit');

const router = express.Router();

const normalizeRole = (role = '') => {
  const value = role.toLowerCase();
  if (value.includes('agriculteur') || value === 'farmer') {
    return 'farmer';
  }
  if (value.includes('coop')) {
    return 'cooperative';
  }
  if (value.includes('export')) {
    return 'exporter';
  }
  return 'farmer';
};

const signToken = (user) =>
  jwt.sign(
    {
      sub: user.id,
      role: user.role,
      email: user.email,
    },
    process.env.JWT_SECRET,
    { expiresIn: '7d' },
  );

const sanitizeUser = (user) => ({
  id: user.id,
  email: user.email,
  role: user.role,
  firstName: user.first_name,
  lastName: user.last_name,
  phone: user.phone,
  createdAt: user.created_at,
});

router.post('/register', authLimiter, async (req, res) => {
  const { email, password, firstName, lastName, phone, role } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email et mot de passe requis.' });
  }

  const db = await getDb();
  const existing = await db.get('SELECT id FROM users WHERE email = ?', [email.toLowerCase()]);
  if (existing) {
    return res.status(409).json({ message: 'Email déjà utilisé.' });
  }

  const user = {
    id: randomUUID(),
    email: email.toLowerCase(),
    password_hash: await bcrypt.hash(password, 10),
    first_name: firstName || null,
    last_name: lastName || null,
    phone: phone || null,
    role: normalizeRole(role),
    created_at: new Date().toISOString(),
  };

  await db.run(
    `INSERT INTO users (id, email, password_hash, first_name, last_name, phone, role, created_at)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    [
      user.id,
      user.email,
      user.password_hash,
      user.first_name,
      user.last_name,
      user.phone,
      user.role,
      user.created_at,
    ],
  );

  const token = signToken(user);
  return res.status(201).json({ token, user: sanitizeUser(user) });
});

router.post('/login', authLimiter, async (req, res) => {
  const { email, password, role } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: 'Email et mot de passe requis.' });
  }

  if (!role) {
    return res.status(400).json({ message: 'Rôle requis.' });
  }

  const db = await getDb();
  const user = await db.get('SELECT * FROM users WHERE email = ?', [email.toLowerCase()]);

  if (!user) {
    return res.status(401).json({ message: 'Identifiants invalides.' });
  }

  const passwordMatches = await bcrypt.compare(password, user.password_hash);
  if (!passwordMatches) {
    return res.status(401).json({ message: 'Identifiants invalides.' });
  }

  const normalizedRole = normalizeRole(role);
  if (normalizedRole !== user.role) {
    return res.status(403).json({ message: 'Rôle invalide pour ce compte.' });
  }

  const token = signToken(user);
  return res.json({ token, user: sanitizeUser(user) });
});

router.get('/me', apiLimiter, requireAuth, async (req, res) => {
  const db = await getDb();
  const user = await db.get('SELECT * FROM users WHERE id = ?', [req.user.sub]);

  if (!user) {
    return res.status(404).json({ message: 'Utilisateur introuvable.' });
  }

  return res.json({ user: sanitizeUser(user) });
});

module.exports = router;
