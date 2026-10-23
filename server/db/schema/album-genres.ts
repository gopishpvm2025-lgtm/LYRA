
import { pgTable, text } from 'drizzle-orm/pg-core';
import { sql, type InferSelectModel, type InferInsertModel } from 'drizzle-orm';
import { v7 as uuidv7 } from 'uuid';
import { albums } from './albums';
import { genres } from './genres';

export const albumGenres = pgTable('album_genres', {
  albumGenreId: text('album_genre_id').primaryKey().$defaultFn(() => uuidv7()),
  albumId: text('album_id').references(() => albums.albumId, { onDelete: 'cascade' }).notNull(),
  genreId: text('genre_id').references(() => genres.genreId, { onDelete: 'cascade' }).notNull(),
  createdAt: text('created_at').$defaultFn(() => new Date().toISOString()).notNull(),
  updatedAt: text('updated_at').$defaultFn(() => new Date().toISOString()).notNull(),
});

export type AlbumGenre = InferSelectModel<typeof albumGenres>;
export type NewAlbumGenre = InferInsertModel<typeof albumGenres>;
