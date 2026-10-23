import { jsonb, integer, pgTable, text } from 'drizzle-orm/pg-core';
import { tracks } from './tracks';

export const trackEmbeddings = pgTable('track_embeddings', {
  trackId: text('track_id').primaryKey().references(() => tracks.trackId, { onDelete: 'cascade' }),
  contentHash: text('content_hash').notNull(),
  model: text('model').notNull(),
  revision: text('revision').notNull(),
  dimensions: integer('dimensions').notNull(),
  retrievalVector: jsonb('retrieval_vector').$type<number[]>().notNull(),
  classificationVector: jsonb('classification_vector').$type<number[]>().notNull(),
  similarityVector: jsonb('similarity_vector').$type<number[]>().notNull(),
  indexedAt: text('indexed_at').notNull(),
});
