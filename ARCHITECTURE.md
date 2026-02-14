# Architecture (proposed)

## Overview
Web-first aggregator with two ingestion pipelines (RSS + YouTube), a unified item store, dedupe/clustering, and a public feed. Optional accounts unlock saved filters + YouTube follows + notifications.

## Deployment target
- Plesk VPS environment
- Recommendation for v1 DB: **PostgreSQL** (most robust for multi-user + background workers; easy backups)
- ORM/migrations: **Prisma**

## Components
### 1) Ingestion workers
- **RSS worker**
  - Poll enabled RSS sources on schedule.
  - Parse items, normalize, upsert.
- **YouTube worker**
  - Track channels (channelId).
  - Fetch latest uploads periodically.
  - Create items with type=`video`.

### 2) Scheduler / rate strategy
- Base polling: every 120 min.
- **Race weekend mode (auto):** every 15–30 min for key windows.
- Off-season / midweek can stay at 120 min.

### 3) API + Web app
- Public pages: feed, search, filters, clusters.
- Auth pages: register/login.
- User pages: saved filters, followed channels, notification settings.

## Data model additions
- `users(id, email, created_at, ...)`
- `youtube_channels(channel_id, title, rss_url, last_fetched_at, created_at)` (internal cache)
- `user_youtube_channels(id, user_id, channel_id, created_at)` (private list)
- `notifications(id, user_id, item_id, created_at, read_at)`
- Add to `items`: `type` ('article'|'video'), `external_id` (yt video id), `thumbnail_url` (**yes in v1**), `duration_sec` (optional; **not needed in v1**), `channel_id`

## YouTube ingestion options (choose)
1) **YouTube Data API v3** (recommended)
   - Pros: reliable, fast, metadata-rich.
   - Cons: API key + quota management.
2) **RSS via YouTube channel feeds**
   - Pros: no key.
   - Cons: less metadata, occasional lag/limitations.

We can ship MVP with option (2) and upgrade to (1) if/when needed.

## Race weekend calendar (official MotoGP)
- Prefer: consume an official calendar feed if available (iCal/JSON). If not:
  - nightly job fetches the official calendar page and extracts event dates.
  - store in `events` table; compute “race weekend mode” windows.

## Notification channels (staged)
- **v1: in-app notifications only** (notification bell + unseen count).
- v2: Telegram bot / email / push notifications.
