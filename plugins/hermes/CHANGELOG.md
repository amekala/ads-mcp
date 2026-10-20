# Changelog

All notable changes to this project will be documented in this file.

## 1.1.0 - 2026-10-20

- Built from ads-mcp (`plugins/hermes`) and synced to this repository automatically, so Hermes gets
  skill fixes at the same time as the other hosts. Edit ads-mcp, never this repository.
- `get_tool_schema` no longer asks for the removed `intent` parameter. When a client doesn't list
  it, call it through any platform router.
- Ten new skills: ads-manager sign-in and read-only browser checks, Microsoft Advertising, keyword
  research, competitor ads, Google Analytics 4, Search Console, Tag Manager, dashboards, and email or
  Slack digests that send only after a fresh yes.
- Measurement: judge each conversion action by its own source, and put platform, account, date
  range, and currency on every number. A missing value is "not available", not 0.
- Setup asks the business type and flags test accounts. Launch is the only path that enables a
  campaign or raises spend. Optimize can watch thresholds without writing.

## 1.0.1 - 2026-09-28

- Replace the listing icon with the Adspirer brand square logo (640×640; was a 146×146 image).

## 1.0.0 - 2026-09-19

- Initial Hermes Agent distribution with fourteen paid-media workflow skills.
- Add the Adspirer hosted MCP connection through pinned `mcp-remote@0.1.49` so portable installs can
  complete OAuth until Agent Plugins v1 can carry remote OAuth configuration natively.
- Add approval, paused-creation, verification, and destructive-action safeguards.
- Add repository validation matching the Hermes catalog admission command.
