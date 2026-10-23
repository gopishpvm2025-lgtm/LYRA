// server/db/index.ts
// Netlify Database (managed Postgres). The connection is configured by the platform.
import { drizzle } from 'drizzle-orm/netlify-db';
import * as schema from './schema';

export const db = drizzle({ schema });

export type Db = typeof db;

export { schema };
