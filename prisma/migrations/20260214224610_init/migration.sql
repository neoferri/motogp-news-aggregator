-- CreateEnum
CREATE TYPE "SourceType" AS ENUM ('rss', 'youtube');

-- CreateEnum
CREATE TYPE "ItemType" AS ENUM ('article', 'video');

-- CreateTable
CREATE TABLE "sources" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "type" "SourceType" NOT NULL,
    "url" TEXT NOT NULL,
    "lang" VARCHAR(5) NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "sources_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "youtube_channels" (
    "channel_id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "rss_url" TEXT NOT NULL,
    "last_fetched_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "youtube_channels_pkey" PRIMARY KEY ("channel_id")
);

-- CreateTable
CREATE TABLE "items" (
    "id" SERIAL NOT NULL,
    "type" "ItemType" NOT NULL,
    "title" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "canonical_url" TEXT,
    "excerpt" TEXT,
    "published_at" TIMESTAMP(3),
    "fetched_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lang" VARCHAR(5) NOT NULL,
    "source_id" INTEGER NOT NULL,
    "channel_id" TEXT,
    "external_id" TEXT,
    "thumbnail_url" TEXT,
    "hash" TEXT NOT NULL,

    CONSTRAINT "items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "global_settings" (
    "key" TEXT NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "global_settings_pkey" PRIMARY KEY ("key")
);

-- CreateIndex
CREATE UNIQUE INDEX "sources_url_key" ON "sources"("url");

-- CreateIndex
CREATE UNIQUE INDEX "items_hash_key" ON "items"("hash");

-- CreateIndex
CREATE INDEX "items_published_at_idx" ON "items"("published_at");

-- CreateIndex
CREATE INDEX "items_source_id_idx" ON "items"("source_id");

-- CreateIndex
CREATE INDEX "items_lang_idx" ON "items"("lang");

-- CreateIndex
CREATE INDEX "items_type_idx" ON "items"("type");

-- AddForeignKey
ALTER TABLE "items" ADD CONSTRAINT "items_source_id_fkey" FOREIGN KEY ("source_id") REFERENCES "sources"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "items" ADD CONSTRAINT "items_channel_id_fkey" FOREIGN KEY ("channel_id") REFERENCES "youtube_channels"("channel_id") ON DELETE SET NULL ON UPDATE CASCADE;
