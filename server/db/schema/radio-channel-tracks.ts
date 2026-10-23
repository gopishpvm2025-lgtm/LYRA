
import { pgTable, text } from 'drizzle-orm/pg-core';
import { sql, type InferSelectModel, type InferInsertModel } from 'drizzle-orm';
import { v7 as uuidv7 } from 'uuid';
import { radioChannels } from './radio-channels';
import { tracks } from './tracks';

export const radioChannelTracks = pgTable('radio_channel_tracks', {
  radioTrackId: text('radio_track_id').primaryKey().$defaultFn(() => uuidv7()),
  channelId: text('channel_id').references(() => radioChannels.channelId, { onDelete: 'cascade' }).notNull(),
  trackId: text('track_id').references(() => tracks.trackId, { onDelete: 'cascade' }).notNull(),
  addedAt: text('added_at').$defaultFn(() => new Date().toISOString()).notNull(),
});

export type RadioChannelTrack = InferSelectModel<typeof radioChannelTracks>;
export type NewRadioChannelTrack = InferInsertModel<typeof radioChannelTracks>;
