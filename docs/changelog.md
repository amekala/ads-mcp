# Changelog

## [1.1.2] - 2026-02-26

### Changed — Campaign Creation Reliability Hardening
- Added launch **Definition of Done** checks in shared skills to prevent false-success reporting when campaigns are missing ads, keywords, or extensions.
- Added strict completion statuses: `SUCCESS`, `PARTIAL_SUCCESS`, `FAILED`.
- Added extension verification fallback logic when `list_campaign_extensions` fails (retry once + cross-check before final status).
- Added per-campaign verification/readback requirements in agent instructions across Cursor, Codex, and Claude Code variants.
- Added ad quality guardrails requiring keyword-theme coverage in headlines and length validation before submission.
- Added explicit platform limitation guidance: conversion action primary/secondary setup is manual in Google Ads UI (not configurable through Adspirer MCP tools).
- Aligned OpenClaw standalone skill with the same reliability and reporting contract.

### Propagation
- Updated source templates in `shared/skills/`.
- Regenerated Cursor/Codex/Claude skill outputs via `scripts/sync-skills.sh`.
- Verified sync and integrity with `scripts/validate.sh` (all checks passing).

## [1.1.1] - 2026-02-22

### Added — Shared Skills Architecture
- **Shared skill templates** (`shared/skills/`) — single source of truth for all 5 skills across IDEs
- **Template compiler** (`scripts/sync-skills.sh`) — generates IDE-specific skills with variable substitution (`{{CONTEXT_FILE}}`, `{{AUTH_TROUBLESHOOT}}`) and conditional blocks (`<!-- BEGIN:CODEX -->`, `<!-- BEGIN:HAS_MEMORY -->`, etc.)
- **Validation suite** (`scripts/validate.sh`) — 39 automated checks for sync consistency, frontmatter, context file correctness, template marker leaks, and skill inventory
- **OpenClaw plugin** (`plugins/openclaw/`) — standalone skill (claw.json + SKILL.md) for the OpenClaw platform, listed on [ClawHub](https://clawhub.ai/amekala/adspirer-ads-agent)
- **Developer documentation**:
  - `monorepo-restructure-plan.md` — full architecture doc (replaces outdated symlink plan)
  - `docs/architecture.md` — template syntax, conditional blocks, sync workflow
  - `docs/adding-platforms.md` — how to add new ad platforms (YouTube, Snapchat, etc.)
  - `docs/adding-ides.md` — how to add new IDE support (Windsurf, Cline, etc.)

### Changed
- **README.md** — added OpenClaw install instructions, Supported Plugins table (4 platforms), expanded Developer Guide with quick-reference commands
- **Install scripts** — added comments noting skills are generated from templates
- **.gitignore** — added TTS generation artifacts (.tts-venv/, *.mp3, generate-tts.py)

### Architecture
- Skills authored once in `shared/skills/`, compiled to Cursor (BRAND.md), Codex (AGENTS.md), and Claude Code (CLAUDE.md) variants
- OpenClaw uses standalone skill (not template-compiled) due to different document structure
- Claude Code gets 1 generated skill (adspirer-ads → ad-campaign-management); other 4 workflows are slash commands

### Revert instructions
To revert this commit: `git revert c92c54e`. This will remove `shared/`, `scripts/`, `docs/architecture.md`, `docs/adding-*.md`, `plugins/openclaw/`, and `monorepo-restructure-plan.md`. Existing generated skills in `plugins/*/skills/` and `skills/` remain intact — they were not modified by this commit, only the source templates and tooling were added.

---

## [1.0.0] - 2025-10-27

### Added
- Initial public release
- Google Ads Performance Max campaign creation
- Google Ads Search campaign creation
- Progress streaming (MCP 2025-03-26 protocol)
- OAuth 2.1 with Protected Resource Metadata (RFC 9728)
- Image validation with SSRF protection
- User-Agent and retry logic for CDN compatibility
- Comprehensive error handling and validation

### Features
- Real-time progress updates for long-running tools
- Deterministic progress fields (stage, current, total, message)
- Dual-mode progress (with/without token)
- Metrics logging (duration, token usage)
- URL-based asset validation (postimages.org)

### Platforms Supported
- Google Ads (Search + Performance Max)
- TikTok (coming soon)
