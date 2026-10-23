
import { jsonb, pgTable, text, integer, uniqueIndex } from 'drizzle-orm/pg-core';
import { sql, type InferSelectModel, type InferInsertModel } from 'drizzle-orm';
import { v7 as uuidv7 } from 'uuid';
import { users } from './users';
import { artists } from './artists'; // For 'similar_to_artist' type

export const discoveryPlaylists = pgTable('discovery_playlists', {
  discoveryPlaylistId: text('discovery_playlist_id').primaryKey().$defaultFn(() => uuidv7()),
  userId: text('user_id').references(() => users.userId, { onDelete: 'cascade' }).notNull(),
  title: text('title').notNull(), // e.g., "New Discoveries", "Similar to Artist X"
  type: text('type').notNull(), // e.g., 'new_discoveries', 'similar_to_artist'
  // Optional: if type is 'similar_to_artist', this could store the seed artistId
  seedArtistId: text('seed_artist_id').references(() => artists.artistId, { onDelete: 'set null' }),
  // Optional: parameters used for generation, stored as JSON
  generationParams: jsonb('generation_params').$type<Record<string, any>>(),
  lastGeneratedAt: text('last_generated_at'),
  createdAt: text('created_at').$defaultFn(() => new Date().toISOString()).notNull(),
  updatedAt: text('updated_at').$defaultFn(() => new Date().toISOString()).notNull(),
}, (table) => {
  return {
    userTypeTitleIdx: uniqueIndex('dp_user_type_title_idx').on(table.userId, table.type, table.title),
    userTypeSeedArtistIdx: uniqueIndex('dp_user_type_seed_artist_idx').on(table.userId, table.type, table.seedArtistId),
  };
});

export type DiscoveryPlaylist = InferSelectModel<typeof discoveryPlaylists>;
export type NewDiscoveryPlaylist = InferInsertModel<typeof discoveryPlaylists>;
