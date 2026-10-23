import { bigint, jsonb, integer, pgTable, text, index } from 'drizzle-orm/pg-core';
import { users } from './users';

export interface RecommendationItem {
  trackId: string;
  contentHash: string;
  score: number;
  seedTrackId?: string;
}

export interface RecommendationMetrics {
  windowDays: number;
  qualifiedPlays: number;
  distinctTracks: number;
  signals: string[];
}

/** A durable snapshot and the single active refresh pointer for each account. */
export const recommendationSnapshots = pgTable('recommendation_snapshots', {
  userId: text('user_id').primaryKey().references(() => users.userId, { onDelete: 'cascade' }),
  items: jsonb('items').$type<RecommendationItem[]>().notNull().default([]),
  basis: text('basis', { enum: ['history', 'cold-start'] }).notNull().default('cold-start'),
  metrics: jsonb('metrics').$type<RecommendationMetrics>(),
  modelKey: text('model_key'),
  generatedAt: text('generated_at'),
  nextRefreshAt: bigint('next_refresh_at', { mode: 'number' }),
  refreshJobId: text('refresh_job_id'),
  retryAfter: bigint('retry_after', { mode: 'number' }),
}, table => ({ dueIndex: index('recommendation_snapshots_due_idx').on(table.nextRefreshAt) }));
