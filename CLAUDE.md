# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MotoGP news aggregator: a web app that unifies MotoGP news from RSS feeds and YouTube channels into a single filterable, deduplicated feed. Targets hardcore MotoGP fans. Legal model: store metadata + short excerpts only, always link to original source.

## Tech Stack

- **Framework:** Next.js (App Router)
- **Styling:** TailwindCSS — dark-first "race control" aesthetic (bg `#0B0D10`, accent `#FF2D55`, links `#3B82F6`)
- **Database:** PostgreSQL
- **ORM/Migrations:** Prisma
- **Deployment:** Plesk VPS, ingestion scripts run as cron tasks

## Architecture

Two ingestion pipelines feed a unified `items` table:

1. **RSS worker** — polls RSS/Atom feeds, normalizes articles
2. **YouTube worker** — polls YouTube channel RSS feeds (`/feeds/videos.xml?channel_id=...`), no API key needed for v1

**Scheduling:** Controlled by a `race_mode` global setting in DB:
- OFF → ingest only if last run >120 min
- ON → ingest if last run >20 min
- Cron runs every 20 minutes; the worker decides whether to actually fetch based on race_mode

**Dedupe strategy (v0):**
1. `canonicalUrl` if present
2. Else normalized URL (strip utm params, fragments)
3. Else `hash(normalizedTitle + publishedDay + source)`

## Key Data Models (Prisma)

- `Source` — id, name, type (`rss`|`youtube`), url, lang, enabled
- `Item` — id, type (`article`|`video`), title, url, canonicalUrl, excerpt, publishedAt, fetchedAt, lang, sourceId, channelId?, externalId?, thumbnailUrl?, hash
- `YoutubeChannel` — channelId (PK), title, rssUrl, lastFetchedAt
- `GlobalSetting` — key/value store (e.g., `race_mode`)

## Pages

- `/` — Feed with tabs (All/Videos/Articles), filters (language EN/ES/IT, source), search
- `/item/[id]` — Item detail with metadata + excerpt + canonical link
- `/sources` — Sources list
- `/admin` — Protected by env secret; Race Mode toggle, reseed controls

## Seed Data

`sources.youtube.seed.json` contains day-1 YouTube channels (EN/ES/IT) to bootstrap the sources table.

## Current State

The project is in the planning/documentation phase. No application code has been written yet. Reference docs: `ROADMAP.md`, `PRD-MVP.md`, `ARCHITECTURE.md`, `BACKLOG-V1.md`, `app-skeleton.md`.

## Build Milestones (from BACKLOG-V1.md)

- **M0:** Scaffold Next.js + Prisma + DB config
- **M1:** Sources table + RSS/YouTube ingestion workers
- **M2:** Public web app (feed, filters, search, detail page)
- **M3:** Auth (v1.1), private YouTube channels, in-app notifications
- **M4:** Race Mode admin toggle + scheduler integration

## Languages

The app supports content in English, Spanish, and Italian (EN/ES/IT). UI should support multilingual content display.

## GitHub

Repo: https://github.com/neoferri/motogp-news-aggregator
