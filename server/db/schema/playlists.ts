
import { pgTable, text } from 'drizzle-orm/pg-core';
import { sql, type InferSelectModel, type InferInsertModel } from 'drizzle-orm';
import { v7 as uuidv7 } from 'uuid';
import { users } from './users'; // For foreign key reference

export const playlists = pgTable('playlists', {
  playlistId: text('playlist_id').primaryKey().$defaultFn(() => uuidv7()),
  userId: text('user_id').references(() => users.userId, { onDelete: 'cascade' }).notNull(),
  name: text('name').notNull(),
  createdAt: text('created_at').$defaultFn(() => new Date().toISOString()).notNull(),
  updatedAt: text('updated_at').$defaultFn(() => new Date().toISOString()).notNull(),
});

export type Playlist = InferSelectModel<typeof playlists>;
export type NewPlaylist = InferInsertModel<typeof playlists>;
