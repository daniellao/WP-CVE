import { readdirSync, readFileSync } from 'node:fs';
import { DatabaseSync } from 'node:sqlite';

const migrationsDirectory = new URL('migrations/', import.meta.url);

export function openDatabase(path: string): DatabaseSync {
  const database = new DatabaseSync(path);
  database.exec('PRAGMA journal_mode = WAL; PRAGMA secure_delete = ON; PRAGMA foreign_keys = ON;');
  migrate(database);
  return database;
}

export function inTransaction<T>(database: DatabaseSync, work: () => T): T {
  database.exec('BEGIN');
  try {
    const result = work();
    database.exec('COMMIT');
    return result;
  } catch (error) {
    database.exec('ROLLBACK');
    throw error;
  }
}

function migrate(database: DatabaseSync): void {
  const appliedCount = readUserVersion(database);
  const pendingMigrations = readdirSync(migrationsDirectory)
    .filter((fileName) => fileName.endsWith('.sql'))
    .sort()
    .slice(appliedCount);

  pendingMigrations.forEach((fileName, index) => {
    const sql = readFileSync(new URL(fileName, migrationsDirectory), 'utf8');
    inTransaction(database, () => {
      database.exec(sql);
      database.exec(`PRAGMA user_version = ${String(appliedCount + index + 1)}`);
    });
  });
}

function readUserVersion(database: DatabaseSync): number {
  const row = database.prepare('PRAGMA user_version').get();
  return Number(row?.['user_version'] ?? 0);
}
