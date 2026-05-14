# chain

## Backend (auth + base de données)

Le backend est un service Node.js avec SQLite pour l'authentification et la gestion des lots.

1. Démarrage rapide
   ```bash
   cd backend
   cp .env.example .env
   npm install
   npm run start
   ```
2. Variables d'environnement
   - `PORT` : port HTTP (par défaut 4000)
   - `JWT_SECRET` : secret de signature des tokens
   - `DB_PATH` : chemin du fichier SQLite (par défaut `./data/chain.db`)

## Flutter (API + session)

L'app appelle l'API via `API_BASE_URL` et stocke le token dans le stockage sécurisé.

Exemple (Android emulator) :
```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000
```

Exemple (iOS simulateur / web) :
```bash
flutter run --dart-define=API_BASE_URL=http://localhost:4000
```

> En production, utilisez HTTPS et un domaine stable.
