import { describe, expect, it } from 'vitest';

import { openDatabase } from './database.ts';

describe('openDatabase', () => {
  it('creates the delivery record and error log tables', () => {
    const database = openDatabase(':memory:');

    const tableNames = database
      .prepare("SELECT name FROM sqlite_schema WHERE type = 'table' ORDER BY name")
      .all()
      .map((row) => row['name']);

    expect(tableNames).toEqual(['delivery_record', 'error_log']);
  });

  it('enables foreign keys and secure delete', () => {
    const database = openDatabase(':memory:');

    expect(database.prepare('PRAGMA foreign_keys').get()).toEqual({ foreign_keys: 1 });
    expect(database.prepare('PRAGMA secure_delete').get()).toEqual({ secure_delete: 1 });
  });

  it('deletes error log entries together with their delivery record', () => {
    const database = openDatabase(':memory:');
    database.exec(`
      INSERT INTO delivery_record (id, profile_id, channel, status, is_test) VALUES (1, 1, 'email', 'failed', 0);
      INSERT INTO error_log (source, delivery_record_id, error_message) VALUES ('email', 1, 'Rejected.');
      DELETE FROM delivery_record WHERE id = 1;
    `);

    expect(database.prepare('SELECT COUNT(*) AS count FROM error_log').get()).toEqual({ count: 0 });
  });
});
