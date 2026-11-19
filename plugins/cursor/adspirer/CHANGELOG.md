# Changelog

## 1.2.0 - 2026-11-19

- Removed the `adspirer-ads-manager-sign-in` skill. Ads-manager checks ask the user to sign in to the ad platform in the browser themselves. The agent never asks for or accepts a password or a code in chat, stops on a login, 2FA, or account picker, and falls back to the Adspirer API when the host has no controllable browser (those UI checks are marked not available).
- Lean first run for Free plans (15 Adspirer calls a month) and any account with fewer than 30 calls left. The first call is `get_usage_status`. The first run stays within 5 calls, reads one account on one platform, skips discovery when the tool is already documented, and asks before any extra read. Usage is checked at most once per session or day. When calls run out, the agent says so with the reset date, suggests upgrading in the Adspirer account, and keeps helping with work that needs no call.

## 1.1.0 - 2026-10-20

- Lessons from the Grok Bot advertising agent, adapted for every host.
- New skills: ads-manager browser checks (read-only, method-aware), Microsoft Advertising, keyword research, GA4, Search Console, Tag Manager, competitor ads, dashboards, and email or Slack digests that send only after a fresh yes.
- Measurement: don't call tracking broken from a tag chip or an empty Data manager; judge each conversion action by its own source. `audit_conversion_tracking` can ignore `customer_id` when several Google Ads accounts are connected ([amekala/ads-mcp#41](https://github.com/amekala/ads-mcp/issues/41)) — retry once, then switch the primary account with a yes or read the Google Ads UI.
- Setup asks business type and flags test accounts. Launch is the only path that enables a campaign or raises spend. Optimize can watch thresholds without writing, and reviews several edits in one table before a yes.
- Evidence rules: platform, account, date range, and currency on every number; never sum conversions across platforms or currencies; a missing value is "not available", not 0; honor cached-data freshness.
- Ads-manager sign-in is its own skill on every host. The user takes control of the agent browser and signs in themselves. The agent never takes a password or a 2FA code. Hosts with no controllable browser fall back to the API. Grok's `request_box_help` is only an example of that handoff.

## 1.0.2 - 2026-09-29

- `adspirer-mcp` skill: stop asking for the user's request as `intent` (the Adspirer MCP server no longer takes it), and call `get_tool_schema` through a platform router when a client doesn't list it.

## 1.0.1 - 2026-09-28

- Replace the listing icon with the Adspirer brand square logo (640×640; was a 146×146 image).

## 1.0.0 - 2026-09-12

- Initial Cursor Marketplace package for Cursor and Grok Bot.
- Connects to Adspirer's hosted MCP server using OAuth.
- Includes paid-media skills and a performance-marketing subagent.
