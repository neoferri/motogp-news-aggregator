# Roadmap — MotoGP News Aggregator

## Phase 0 — Positioning & constraints (1–2h)
- Define target user: hardcore fan / fantasy player / bettor / journalist / casual.
- Define “job”: keep up with *what matters* without doomscrolling.
- Define legal stance: metadata + short excerpt/snippet; always link to source.

## Phase 1 — MVP (weekend → 3–7 days)
### Core
- Source registry (RSS + site feeds + **YouTube channels (must-have)** + optional X later).
- Ingestion workers (polling + backoff + dedupe).
- Race mode: **manual + global** (MVP); optional automatic calendar later.
- Normalization: title, url, source, published_at, author, tags (optional), summary (optional).
- Dedupe + clustering (same story across multiple outlets).
- Web app feed: filters (Rider / Team / Track / Category: MotoGP/Moto2/Moto3), search.

### Nice-to-have in MVP
- Email/Telegram “Daily Top 10” digest.
- Simple keyword alerts (e.g., “Marquez”, “Ducati”, “penalty”).

## Phase 2 — Differentiation (week 2)
- AI ranking: importance score (crash, injury, penalty, transfer rumors, race weekend).
- Topic pages: each rider/team with timeline.
- “What changed?”: updated articles & corrections.
- Source credibility labels + user controls.

## Phase 3 — Retention & monetization (week 3–4)
- Accounts + saved filters + alerts.
- Premium: instant alerts, fewer ads, advanced filters, weekly PDF briefing.
- Sponsorship placements (non-intrusive): helmet brands, merch, tickets.

## Phase 4 — Expansion
- Other motorsports (WSBK, F1 feeder, MotoE) with same engine.

## Decisions (2026-02-14)
- Audience: **hardcore fans**
- Platform: **web-first**
- Languages: **EN + ES + IT**

## Open questions (only blockers)
1) Optional registration: which perks in v1? (suggested: saved filters/sources, mutes)
2) Refresh strategy: fixed (e.g., 60–120 min) vs adaptive (race weekend faster, weekdays slower)
