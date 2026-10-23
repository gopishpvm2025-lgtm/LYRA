import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  dialect: 'postgresql',
  schema: './server/db/schema/index.ts',
  // Netlify applies migrations from this directory automatically on deploy.
  out: 'netlify/database/migrations',
  verbose: true,
  strict: true,
});
