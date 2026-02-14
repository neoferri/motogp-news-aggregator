# Backlog — v1 (ship-first)

## Milestone M0 — Foundations (0.5 day)
- Repo scaffold (Next.js or similar)
- **PostgreSQL** DB + migrations (**Prisma**)
- Env/config

## Milestone M1 — Sources + ingestion (1–2 days)
### Sources
- `sources` table: (id, name, type, url, lang, enabled, created_at)
- Admin UI (simple) to add/enable/disable sources

### RSS ingestion
- Worker job: fetch enabled RSS sources
- Parse items → normalize → upsert into `items`
- Dedupe rules v0:
  - canonical_url if present
  - else normalized url (strip utm, fragments)
  - else hash(title + published_at day + source)

### YouTube ingestion (day 1)
- Represent each YT channel as a `source` with type=`youtube`
- Ingestion method v0: YouTube channel RSS feed
- Store items with type=`video`, external_id=videoId, thumbnail_url (duration not needed)

## Milestone M2 — Public web app (1–2 days)
- Feed page:
  - tabs: All / Articles / Videos
  - filters: language (EN/ES/IT), source
  - search (title + excerpt)
- Cluster view (optional): “also covered by”
- Item detail page: metadata + excerpt + link out

## Milestone M3 — Private YouTube channels + in-app notifications (public-first) (1–2 days)
### Auth
- **Defer**: keep v1 public-only. (Add auth in v1.1 once core feed value is proven.)
- v1 uses a single “owner/admin” access method (env secret) for Race Mode + admin pages.

### Private YouTube channels (URL-only)
- User can add a channel by URL only (channel/@handle URL).
- Resolve to canonical `channelId` and store in internal cache table.
- Visibility is private: channels only appear for the user who added them.

Proposed tables:
- `youtube_channels(channel_id, title, rss_url, last_fetched_at, created_at)` (internal cache)
- `user_youtube_channels(id, user_id, channel_id, created_at)` (private list)

UI:
- “Add YouTube channel” form (URL input)
- List/remove channels

### Notifications (in-app only)
- Create notification when:
  - new video item is ingested AND
  - its channelId exists in `user_youtube_channels` for that user
- Notification center page + bell icon unseen count
- Mark as read

## Milestone M4 — Race Mode (0.5 day)
- Global setting `race_mode` in DB
- Admin toggle in UI
- Scheduler reads it to pick polling interval:
  - OFF: 120 min
  - ON: 20 min

## Definition of Done (v1)
- Public feed works (articles + videos)
- YouTube follows + in-app notifications work
- Dedupe prevents obvious repeats
- Race mode toggle changes polling schedule
