const jwt = require('jsonwebtoken');

const requireAuth = (req, res, next) => {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;

  if (!token) {
    return res.status(401).json({ message: "Jeton d'authentification manquant." });
  }

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET);
    req.user = payload;
    return next();
  } catch (error) {
    console.warn('Auth token verification failed.', error.message);
    return res.status(401).json({ message: 'Jeton invalide ou expiré.' });
  }
};

module.exports = { requireAuth };
