# App Skeleton (v1) — MotoGP News Aggregator

## Goals (v1)
- Public-first web app (no auth)
- Unified feed: **Articles + YouTube videos**
- YouTube day-1 seed channels (from `sources.youtube.seed.json`)
- Ingestion + dedupe
- Filters + search
- Admin-only (env secret) settings:
  - Global **Race Mode** toggle (OFF: 120m / ON: 20m ingestion)
  - Reseed sources

## UI direction
- **Black / dark-first**, “race control” vibe.
- TailwindCSS.
- Design tokens (initial):
  - Background: near-black `#0B0D10`
  - Surfaces: `#10141A` / `#151B23`
  - Text: `#E6E8EB`
  - Muted: `#9AA4B2`
  - Accent: neon red `#FF2D55` (sparingly) + electric blue `#3B82F6` for links
  - Borders: subtle `rgba(255,255,255,0.06)`
- Components:
  - Top bar: logo + search + filters + Race Mode badge (admin view)
  - Feed card:
    - Video: thumbnail, title, channel, time, language badge
    - Article: title, source, excerpt, time

## Tech stack
- Next.js (App Router)
- TailwindCSS
- PostgreSQL
- Prisma (migrations)
- Ingestion scripts run as cron/scheduled tasks on Plesk

## Pages (v1)
- `/` Feed
  - Tabs: All / Videos / Articles
  - Filters: language (EN/ES/IT), source
  - Search: title + excerpt
- `/item/[id]` Item detail
  - Metadata + excerpt + canonical link
- `/sources` Sources list
- `/admin` Admin (protected by env secret)
  - Race Mode toggle
  - Reseed/refresh buttons

## Data model (v1)
### Prisma models (concept)
- `Source`
  - id, name, type('rss'|'youtube'), url, lang, enabled, createdAt
- `YoutubeChannel`
  - channelId (PK), title, rssUrl, lastFetchedAt, createdAt
- `Item`
  - id, type('article'|'video'), title, url, canonicalUrl, excerpt, publishedAt, fetchedAt,
  - lang, sourceId, channelId?, externalId?, thumbnailUrl?
  - hash (dedupe)
- `GlobalSetting`
  - key, value (race_mode)

## Ingestion (v1)
### YouTube
- Resolve handle/URL → `channelId` (no API key)
- Poll RSS: `https://www.youtube.com/feeds/videos.xml?channel_id=...`
- Store new uploads as `Item(type='video')`
- Save `thumbnailUrl` (duration not needed)

### RSS articles
- Poll RSS/Atom feeds
- Normalize, store as `Item(type='article')`

### Dedupe v0
- Prefer `canonicalUrl`
- Else normalized URL (strip utm, fragments)
- Else `hash(titleNormalized + publishedDay + source)`

## Jobs / scheduling (Plesk)
- Cron runs every 20 minutes.
- Worker checks DB `race_mode`:
  - OFF → only ingest if last run > 120m
  - ON → ingest if last run > 20m

## GitHub
- Repo: https://github.com/neoferri/motogp-news-aggregator

## Next actions
1) Scaffold Next.js + Tailwind
2) Add Prisma schema + migrations
3) Implement YouTube resolver + seed script
4) Implement ingestion workers + minimal UI feed
