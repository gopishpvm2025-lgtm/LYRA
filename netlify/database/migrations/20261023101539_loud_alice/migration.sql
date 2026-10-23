CREATE TABLE "users" (
	"user_id" text PRIMARY KEY,
	"name" text NOT NULL,
	"email" text NOT NULL UNIQUE,
	"verified" integer DEFAULT 0 NOT NULL,
	"password_hash" text NOT NULL,
	"login_attempts" integer DEFAULT 0 NOT NULL,
	"last_login_at" text,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "user_track_plays" (
	"user_track_play_id" text PRIMARY KEY,
	"user_id" text NOT NULL,
	"track_id" text NOT NULL,
	"played_at" text NOT NULL,
	"play_duration_ms" integer,
	"source" text,
	"created_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "artists" (
	"artist_id" text PRIMARY KEY,
	"artist_image" text,
	"name" text NOT NULL,
	"musicbrainz_artist_id" text,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "artist_users" (
	"artist_user_id" text PRIMARY KEY,
	"artist_id" text NOT NULL,
	"user_id" text NOT NULL,
	"created_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "albums" (
	"album_id" text PRIMARY KEY,
	"title" text NOT NULL,
	"user_id" text NOT NULL,
	"year" integer,
	"cover_path" text,
	"processed_status" integer DEFAULT -1 NOT NULL,
	"folder_path" text,
	"musicbrainz_release_id" text,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "album_artists" (
	"album_artist_id" text PRIMARY KEY,
	"album_id" text NOT NULL,
	"artist_id" text NOT NULL,
	"is_primary_artist" integer DEFAULT 0,
	"role" text DEFAULT 'performer',
	"created_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "radio_channels" (
	"channel_id" text PRIMARY KEY,
	"user_id" text,
	"name" text NOT NULL,
	"dynamic" integer DEFAULT 1 NOT NULL,
	"logo_image_path" text,
	"background_image_path" text,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "radio_channel_tracks" (
	"radio_track_id" text PRIMARY KEY,
	"channel_id" text NOT NULL,
	"track_id" text NOT NULL,
	"added_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "radio_channel_artists" (
	"channel_id" text,
	"artist_id" text,
	CONSTRAINT "radio_channel_artists_pkey" PRIMARY KEY("channel_id","artist_id")
);
--> statement-breakpoint
CREATE TABLE "radio_channel_genres" (
	"channel_id" text,
	"genre_id" text,
	CONSTRAINT "radio_channel_genres_pkey" PRIMARY KEY("channel_id","genre_id")
);
--> statement-breakpoint
CREATE TABLE "tracks" (
	"track_id" text PRIMARY KEY,
	"title" text NOT NULL,
	"album_id" text,
	"genre" text,
	"year" integer,
	"track_number" integer,
	"disk_number" integer,
	"duration" integer,
	"explicit" boolean DEFAULT false NOT NULL,
	"file_path" text NOT NULL UNIQUE,
	"musicbrainz_track_id" text UNIQUE,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "artists_tracks" (
	"artists_tracks_id" text PRIMARY KEY,
	"artist_id" text NOT NULL,
	"track_id" text NOT NULL,
	"role" text,
	"is_primary_artist" integer DEFAULT 0 NOT NULL,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "playlists" (
	"playlist_id" text PRIMARY KEY,
	"user_id" text NOT NULL,
	"name" text NOT NULL,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "playlist_tracks" (
	"playlist_tracks_id" text PRIMARY KEY,
	"playlist_id" text NOT NULL,
	"track_id" text NOT NULL,
	"order" integer,
	"added_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "media_folders" (
	"media_folders_id" text PRIMARY KEY,
	"user_id" text NOT NULL,
	"path" text NOT NULL,
	"label" text,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "genres" (
	"genre_id" text PRIMARY KEY,
	"name" text NOT NULL UNIQUE,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "album_genres" (
	"album_genre_id" text PRIMARY KEY,
	"album_id" text NOT NULL,
	"genre_id" text NOT NULL,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "lyrics" (
	"lyrics_id" text PRIMARY KEY,
	"track_id" text NOT NULL,
	"lyrics_json" jsonb,
	"source" text,
	"llm_model_used" text,
	"raw_llm_output" text,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "discovery_playlists" (
	"discovery_playlist_id" text PRIMARY KEY,
	"user_id" text NOT NULL,
	"title" text NOT NULL,
	"type" text NOT NULL,
	"seed_artist_id" text,
	"generation_params" jsonb,
	"last_generated_at" text,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "discovery_playlist_tracks" (
	"discovery_playlist_track_id" text PRIMARY KEY,
	"discovery_playlist_id" text NOT NULL,
	"track_id" text NOT NULL,
	"order" integer NOT NULL,
	"added_at" text NOT NULL,
	"reason" text,
	"relevance_score" double precision
);
--> statement-breakpoint
CREATE TABLE "podcasts" (
	"podcast_id" text PRIMARY KEY,
	"feed_url" text NOT NULL UNIQUE,
	"title" text NOT NULL,
	"description" text,
	"image_url" text,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "podcast_subscriptions" (
	"subscription_id" text PRIMARY KEY,
	"user_id" text NOT NULL,
	"podcast_id" text NOT NULL,
	"created_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "job_queue" (
	"job_id" text PRIMARY KEY,
	"job_type" text NOT NULL,
	"payload" text NOT NULL,
	"state" text DEFAULT 'queued' NOT NULL,
	"attempts" integer DEFAULT 0 NOT NULL,
	"max_attempts" integer DEFAULT 3 NOT NULL,
	"run_after" bigint DEFAULT (extract(epoch from now())::bigint) NOT NULL,
	"leased_until" bigint,
	"lease_owner" text,
	"cancel_requested" boolean DEFAULT false NOT NULL,
	"progress" text,
	"result" text,
	"last_error" text,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "scan_files" (
	"scan_file_id" text PRIMARY KEY,
	"scan_id" text NOT NULL,
	"path" text NOT NULL,
	"size_bytes" bigint,
	"mtime_ms" bigint,
	"extension" text,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "scan_runs" (
	"scan_id" text PRIMARY KEY,
	"job_id" text NOT NULL,
	"user_id" text NOT NULL,
	"root_path" text NOT NULL,
	"state" text DEFAULT 'queued' NOT NULL,
	"files_discovered" integer DEFAULT 0 NOT NULL,
	"files_persisted" integer DEFAULT 0 NOT NULL,
	"batches_flushed" integer DEFAULT 0 NOT NULL,
	"errors" integer DEFAULT 0 NOT NULL,
	"last_error" text,
	"started_at" text,
	"finished_at" text,
	"cancelled_at" text,
	"created_at" text NOT NULL,
	"updated_at" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "recommendation_snapshots" (
	"user_id" text PRIMARY KEY,
	"items" jsonb DEFAULT '[]' NOT NULL,
	"basis" text DEFAULT 'cold-start' NOT NULL,
	"metrics" jsonb,
	"model_key" text,
	"generated_at" text,
	"next_refresh_at" bigint,
	"refresh_job_id" text,
	"retry_after" bigint
);
--> statement-breakpoint
CREATE TABLE "track_embeddings" (
	"track_id" text PRIMARY KEY,
	"content_hash" text NOT NULL,
	"model" text NOT NULL,
	"revision" text NOT NULL,
	"dimensions" integer NOT NULL,
	"retrieval_vector" jsonb NOT NULL,
	"classification_vector" jsonb NOT NULL,
	"similarity_vector" jsonb NOT NULL,
	"indexed_at" text NOT NULL
);
--> statement-breakpoint
CREATE INDEX "user_track_plays_user_played_idx" ON "user_track_plays" ("user_id","played_at");--> statement-breakpoint
CREATE UNIQUE INDEX "lyrics_track_idx" ON "lyrics" ("track_id");--> statement-breakpoint
CREATE UNIQUE INDEX "dp_user_type_title_idx" ON "discovery_playlists" ("user_id","type","title");--> statement-breakpoint
CREATE UNIQUE INDEX "dp_user_type_seed_artist_idx" ON "discovery_playlists" ("user_id","type","seed_artist_id");--> statement-breakpoint
CREATE INDEX "job_queue_type_state_run_after_idx" ON "job_queue" ("job_type","state","run_after");--> statement-breakpoint
CREATE INDEX "job_queue_state_run_after_idx" ON "job_queue" ("state","run_after");--> statement-breakpoint
CREATE INDEX "job_queue_lease_owner_idx" ON "job_queue" ("lease_owner");--> statement-breakpoint
CREATE UNIQUE INDEX "scan_files_scan_id_path_unique" ON "scan_files" ("scan_id","path");--> statement-breakpoint
CREATE INDEX "scan_files_scan_id_idx" ON "scan_files" ("scan_id");--> statement-breakpoint
CREATE INDEX "scan_runs_user_state_idx" ON "scan_runs" ("user_id","state");--> statement-breakpoint
CREATE INDEX "recommendation_snapshots_due_idx" ON "recommendation_snapshots" ("next_refresh_at");--> statement-breakpoint
ALTER TABLE "user_track_plays" ADD CONSTRAINT "user_track_plays_user_id_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "user_track_plays" ADD CONSTRAINT "user_track_plays_track_id_tracks_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "tracks"("track_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "artist_users" ADD CONSTRAINT "artist_users_artist_id_artists_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artists"("artist_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "artist_users" ADD CONSTRAINT "artist_users_user_id_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "albums" ADD CONSTRAINT "albums_user_id_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "album_artists" ADD CONSTRAINT "album_artists_album_id_albums_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "albums"("album_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "album_artists" ADD CONSTRAINT "album_artists_artist_id_artists_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artists"("artist_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "radio_channels" ADD CONSTRAINT "radio_channels_user_id_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "radio_channel_tracks" ADD CONSTRAINT "radio_channel_tracks_channel_id_radio_channels_channel_id_fkey" FOREIGN KEY ("channel_id") REFERENCES "radio_channels"("channel_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "radio_channel_tracks" ADD CONSTRAINT "radio_channel_tracks_track_id_tracks_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "tracks"("track_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "radio_channel_artists" ADD CONSTRAINT "radio_channel_artists_channel_id_radio_channels_channel_id_fkey" FOREIGN KEY ("channel_id") REFERENCES "radio_channels"("channel_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "radio_channel_artists" ADD CONSTRAINT "radio_channel_artists_artist_id_artists_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artists"("artist_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "radio_channel_genres" ADD CONSTRAINT "radio_channel_genres_channel_id_radio_channels_channel_id_fkey" FOREIGN KEY ("channel_id") REFERENCES "radio_channels"("channel_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "radio_channel_genres" ADD CONSTRAINT "radio_channel_genres_genre_id_genres_genre_id_fkey" FOREIGN KEY ("genre_id") REFERENCES "genres"("genre_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "tracks" ADD CONSTRAINT "tracks_album_id_albums_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "albums"("album_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "artists_tracks" ADD CONSTRAINT "artists_tracks_artist_id_artists_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artists"("artist_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "artists_tracks" ADD CONSTRAINT "artists_tracks_track_id_tracks_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "tracks"("track_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "playlists" ADD CONSTRAINT "playlists_user_id_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "playlist_tracks" ADD CONSTRAINT "playlist_tracks_playlist_id_playlists_playlist_id_fkey" FOREIGN KEY ("playlist_id") REFERENCES "playlists"("playlist_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "playlist_tracks" ADD CONSTRAINT "playlist_tracks_track_id_tracks_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "tracks"("track_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "media_folders" ADD CONSTRAINT "media_folders_user_id_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "album_genres" ADD CONSTRAINT "album_genres_album_id_albums_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "albums"("album_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "album_genres" ADD CONSTRAINT "album_genres_genre_id_genres_genre_id_fkey" FOREIGN KEY ("genre_id") REFERENCES "genres"("genre_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "lyrics" ADD CONSTRAINT "lyrics_track_id_tracks_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "tracks"("track_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "discovery_playlists" ADD CONSTRAINT "discovery_playlists_user_id_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "discovery_playlists" ADD CONSTRAINT "discovery_playlists_seed_artist_id_artists_artist_id_fkey" FOREIGN KEY ("seed_artist_id") REFERENCES "artists"("artist_id") ON DELETE SET NULL;--> statement-breakpoint
ALTER TABLE "discovery_playlist_tracks" ADD CONSTRAINT "discovery_playlist_tracks_T0h0qh1NROvT_fkey" FOREIGN KEY ("discovery_playlist_id") REFERENCES "discovery_playlists"("discovery_playlist_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "discovery_playlist_tracks" ADD CONSTRAINT "discovery_playlist_tracks_track_id_tracks_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "tracks"("track_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "podcast_subscriptions" ADD CONSTRAINT "podcast_subscriptions_user_id_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "podcast_subscriptions" ADD CONSTRAINT "podcast_subscriptions_podcast_id_podcasts_podcast_id_fkey" FOREIGN KEY ("podcast_id") REFERENCES "podcasts"("podcast_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "scan_files" ADD CONSTRAINT "scan_files_scan_id_scan_runs_scan_id_fkey" FOREIGN KEY ("scan_id") REFERENCES "scan_runs"("scan_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "scan_runs" ADD CONSTRAINT "scan_runs_job_id_job_queue_job_id_fkey" FOREIGN KEY ("job_id") REFERENCES "job_queue"("job_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "recommendation_snapshots" ADD CONSTRAINT "recommendation_snapshots_user_id_users_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("user_id") ON DELETE CASCADE;--> statement-breakpoint
ALTER TABLE "track_embeddings" ADD CONSTRAINT "track_embeddings_track_id_tracks_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "tracks"("track_id") ON DELETE CASCADE;