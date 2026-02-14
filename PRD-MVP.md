# PRD — MVP (Draft)

## Target user
Hardcore MotoGP fans who want to track *everything that matters* (news + rumors + incidents) without checking 20 sites.

## Core promise (before/after)
Before: fragmented sources, duplicates, noise, missed breaking updates.
After: one feed, deduped, ranked, filterable by rider/team/topic, with multilingual UI.

## MVP scope
### Must-have
- Source ingestion: **RSS + YouTube (day 1)**
- YouTube follows (per-user): users can follow favourite channels
- Notifications when a followed channel publishes (**v1: in-app only**; v2: Telegram/email/push)
- Unified feed with:
  - title
  - source
  - published time
  - canonical link
  - short excerpt (if available)
  - language tag
- Dedupe: avoid showing the same story 5 times
- Filters:
  - Category: MotoGP / Moto2 / Moto3 / MotoE (optional)
  - Rider/team keywords (simple)
  - Source filter
- Search
- Article detail page (internal): metadata + excerpt + link out

### Nice-to-have (if cheap)
- Story clusters: “Coverage” list per event
- Simple ‘importance’ ranking heuristics (race weekend boost, crash/injury keywords)

## Auth / accounts (phased)
- **v1:** fully public (no login). Focus on feed quality + ingestion.
- **v1.1:** optional registration unlocks:
  - add private YouTube channels (URL-only)
  - in-app notifications for new uploads
  - saved filters / mutes

## Non-goals (MVP)
- Full-text scraping + republishing
- Comments/community

## Data model (v0)
- sources(id, name, type, url, lang, enabled)
- items(id, source_id, title, url, canonical_url, published_at, fetched_at, excerpt, author, lang, hash)
- clusters(id, key, created_at)
- cluster_items(cluster_id, item_id)

## Success metrics
- Time-to-scan daily news < 5 minutes
- Duplicates reduced by 70%+
- Returning users (D7) for hardcore fans during race weekend
