
import { pgTable, text } from 'drizzle-orm/pg-core';
import { sql, type InferSelectModel, type InferInsertModel } from 'drizzle-orm';
import { v7 as uuidv7 } from 'uuid';

export const artists = pgTable('artists', {
  artistId: text('artist_id').primaryKey().$defaultFn(() => uuidv7()),
  artistImage: text('artist_image'),
  name: text('name').notNull(),
  musicbrainzArtistId: text('musicbrainz_artist_id'),
  createdAt: text('created_at').$defaultFn(() => new Date().toISOString()).notNull(),
  updatedAt: text('updated_at').$defaultFn(() => new Date().toISOString()).notNull(),
});

export type Artist = InferSelectModel<typeof artists>;
export type NewArtist = InferInsertModel<typeof artists>;
