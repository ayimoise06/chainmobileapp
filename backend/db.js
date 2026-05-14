const fs = require('fs');
const path = require('path');
const { open } = require('sqlite');
const sqlite3 = require('sqlite3');

const dbPath = process.env.DB_PATH || path.join(__dirname, 'data', 'chain.db');
const migrationsPath = path.join(__dirname, 'migrations');

let dbInstance;

const ensureDataDir = () => {
  const dir = path.dirname(dbPath);
  fs.mkdirSync(dir, { recursive: true });
};

const runMigrations = async (db) => {
  const migrationFile = path.join(migrationsPath, '001_init.sql');
  const sql = fs.readFileSync(migrationFile, 'utf8');
  await db.exec(sql);
};

const getDb = async () => {
  if (dbInstance) {
    return dbInstance;
  }
  ensureDataDir();
  dbInstance = await open({
    filename: dbPath,
    driver: sqlite3.Database,
  });
  await runMigrations(dbInstance);
  return dbInstance;
};

module.exports = { getDb };
