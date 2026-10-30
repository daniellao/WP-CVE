import { mkdirSync } from 'node:fs';
import { dirname } from 'node:path';

import Fastify from 'fastify';

import { openDatabase } from './database/database.ts';

const databasePath = process.env['DATABASE_PATH'] ?? 'data/wp-cve.db';
const port = Number(process.env['PORT'] ?? 3000);

mkdirSync(dirname(databasePath), { recursive: true });
const database = openDatabase(databasePath);

const server = Fastify({ logger: true });
server.addHook('onClose', () => {
  database.close();
});

await server.listen({ port });
