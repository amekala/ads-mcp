# Adspirer (main app): ChatGPT submission sheet

The plugin source is `plugins/chatgpt/adspirer-main/`. Build it with
`./scripts/package-chatgpt-plugin.sh adspirer-main`, which writes
`dist/chatgpt/adspirer-main-<version>.zip`.

MCP server: `https://mcp.adspirer.com/mcp`, the same URL the published app (2.0.0) uses. This ZIP is
an **update** to that app, not a new plugin.

- Package `name` is `app-69461dc91ee48191ae4a14eb9bde1c21`. That's the ID OpenAI gave the existing
  app when it moved apps to plugins, and an update must use it (`plugin_name_mismatch` otherwise).
  Never change it. The listing still shows `displayName` ("Adspirer").
- `version` must differ from the last upload. 2.0.0 was the last app version, so this is 2.1.0.
- `plugins/chatgpt/adspirer/` is the older skills-only upload. Its skills are synced from the
  source skills by `scripts/sync-skills.sh`. The copies in `adspirer-main/skills/` are edited for
  this listing (see "Skills") and are **not** a sync target, so a sync won't overwrite them.

## Status

| Item | State |
|---|---|
| ZIP builds and passes the validator | ✅ 2.1.0 |
| Listing text, category, capabilities, prompts, icons | ✅ in `plugin.json` |
| 5 positive and 3 negative test cases | ✅ in `plugin.json`; ❌ not yet run against a reviewer account |
| Demo video URL | ✅ the 2.0.0 video, `https://youtu.be/dYU-6sudjZM` (public) |
| Release notes | ✅ |
| Tool annotations on the server | ✅ all 23 tools set `readOnlyHint`, `destructiveHint` and `openWorldHint` explicitly |
| Annotation justifications (portal) | ⚠️ 15 carried over from 2.0.0; 8 new tools need them (below) |
| Reviewer account | ❌ enter in the portal (same rules as the Search Ads sheet) |
| Domain verification | ✅ `mcp.adspirer.com` already serves this app's token |

## What's in the ZIP

| Path | What |
|---|---|
| `plugin.json` | Portable Agent Plugins manifest, with `extensions.com.openai` holding the listing, capabilities, onboarding skill, review cases, demo URL and release notes |
| `mcp.json` | One `streamable-http` server, `https://mcp.adspirer.com/mcp` |
| `skills/` | 15 skills (below) |
| `assets/icon.svg`, `assets/logo.png` | Composer icon (512x512) and listing logo (640x640) |

`interface.capabilities` holds 16 entries (limit 20, 120 characters each). The Codex format
requires the field; the portable format makes it optional, so it's filled in to be safe either way.

## Tools the server exposes (simulated `tools/list`, 2026-09-30)

From `production-deployment` with the federated flag on (the state a signed-in reviewer sees). 23
tools; 15 were in 2.0.0 and 8 are new. Tool annotations live on the server, not in the ZIP; the
portal reads them from the tool scan.

| Tool | read-only | destructive | open-world | New |
|---|---|---|---|---|
| `start_here` | true | false | false | |
| `search_tools` | true | false | true | |
| `get_tool_schema` | true | false | false | |
| `get_campaign_performance` | true | false | true | |
| `get_usage_status` | true | false | false | new |
| `get_meta_campaign_performance` | true | false | true | |
| `audit_conversion_tracking` | true | false | true | |
| `get_connections_status` | true | false | false | |
| `switch_primary_account` | false | false | false | |
| `diagnose_funnel` | true | false | false | new |
| `competitor_ads_research` | true | false | true | new |
| `monitoring_and_reporting` | false | true | true | |
| `google_ads` | false | true | true | |
| `meta_ads` | false | true | true | |
| `linkedin_ads` | false | true | true | |
| `tiktok_ads` | false | true | true | |
| `amazon_ads` | false | true | true | |
| `chatgpt_ads` | false | true | true | |
| `microsoft_ads` | false | true | true | new |
| `google_analytics` | true | false | true | new |
| `klaviyo` | false | true | true | new |
| `google_search_console` | false | true | true | new |
| `google_tag_manager` | false | true | true | new |

## Justifications for the 8 new tools (paste into the portal if asked)

**`get_usage_status`**
- Read-only: Returns the user's tool-call usage for the current period, the limit and the reset date, and renders a usage meter. It changes nothing.
- Open-world (false): Reads usage from Adspirer's own database. It makes no third-party API call.
- Destructive (false): Read-only; it cannot create, change or delete anything.

**`diagnose_funnel`**
- Read-only: Reads the user's connected ad-account data and conversion-tracking settings, then reports the first broken step in the funnel (tracking, traffic, conversion, spend). It changes nothing in any account.
- Open-world (false): Works from the user's own connected accounts and Adspirer's stored metrics. It doesn't publish or send anything outside them.
- Destructive (false): Read-only; it cannot pause, edit or delete any campaign, ad or setting.

**`competitor_ads_research`**
- Read-only: Looks up a competitor's live ads from public ad-transparency sources for a domain the user gives, and compares them with the user's own account. It changes nothing.
- Open-world (true): Queries public third-party ad-transparency sources about other advertisers, outside the user's own account.
- Destructive (false): Read-only; it cannot change the user's account or anyone else's.

**`microsoft_ads`**
- Read-only (false): Fronts Microsoft Advertising operations, including creating and updating campaigns, ad groups, ads, keywords, budgets, bid strategies and targeting.
- Open-world (true): Calls the third-party Microsoft Advertising API and can change live campaigns that serve ads publicly.
- Destructive (true): Some operations delete targeting criteria or change budgets and status on a live account. New campaigns are created paused, and changes are made only when the user asks.

**`google_analytics`**
- Read-only (true): Runs Google Analytics 4 reports and reads property metadata for the user's connected properties. It changes nothing.
- Open-world (true): Calls the third-party Google Analytics API on the user's behalf.
- Destructive (false): Read-only; it cannot change or delete any property, stream or setting.

**`klaviyo`**
- Read-only (false): Can add profiles to lists, record events and trigger flows in the user's Klaviyo account, as well as read lists, campaigns and flows.
- Open-world (true): Calls the third-party Klaviyo API, and a triggered flow can send real email or SMS to subscribers.
- Destructive (true): Writes take effect immediately on a live account and can message real people. The tool asks for confirmation before any write.

**`google_search_console`**
- Read-only (false): Reads organic search performance and sitemaps, and can submit a URL to Google for re-indexing.
- Open-world (true): Calls the third-party Google Search Console API, and a re-index request notifies Google about a public page.
- Destructive (true): Submitting a URL as updated or deleted changes how Google treats that page. It runs only after the user confirms the exact URL.

**`google_tag_manager`**
- Read-only (false): Reads tags, triggers and variables, and can create or update tags and variables in the user's containers.
- Open-world (true): Calls the third-party Google Tag Manager API; containers fire tracking on the user's public website.
- Destructive (true): A wrong tag or variable change can break live tracking. It asks the user to pick the account, container and workspace and confirms before writing.

## Test cases

Imported from `plugin.json` (read-only in the portal). These are the 2.0.0 cases, with the
corrections noted.

| # | Prompt (short) | Tool | Change from 2.0.0 |
|---|---|---|---|
| P1 | LinkedIn Ads report, last 90 days | `linkedin_ads` | none |
| P2 | Which accounts are connected; flag reauth | `get_connections_status` | none |
| P3 | Audit conversion tracking across platforms | `audit_conversion_tracking` | none |
| P4 | Create a Meta single-image campaign, $20/day, paused | `meta_ads` | budget described in the account's currency; image added to `file_attachment_urls` |
| P5 | Google Ads report, last 90 days | `get_campaign_performance` | was `google_ads`; the direct tool renders the dashboard. "leads" became "conversions", which is Google's metric |
| N1 | Marketing strategies, SEO or social? | none | none |
| N2 | Show me my Pinterest Ads performance | none | replaces "Show me my SEO performance": Adspirer now has Search Console and would answer that one |
| N3 | Hey! How's it going? What can you do? | none | none; watch it, `start_here` is written for "what can you do?" |

P4 creates a paused Meta campaign on the reviewer account. Delete it after each review run.

## Skills

15 skills. Copied from the ChatGPT skills upload, then edited for this listing:

- **New:** `get-started` (the onboarding skill) and `microsoft-advertising` (through the
  `microsoft_ads` router; says Microsoft reporting isn't available).
- **`adspirer-mcp`:** the 23-tool surface (adds `diagnose_funnel`, `competitor_ads_research`,
  `microsoft_ads`, Search Console and Tag Manager; drops `echo_test` and `community_plugins`, which
  are hidden). Plan names, allowances and "upgrade link" wording are removed: at the limit it tells
  the user the limit and the reset date. Integration tools are always listed, not only when
  connected.
- **`adspirer-docs`:** no prices or plan recommendations; plans questions get the informational
  docs page, never a checkout link.
- **`adspirer-google-ads`, `adspirer-chatgpt-ads`:** budgets are in the account's currency, not
  dollars.
- **`adspirer-agent`:** the Codex `agents/openai.yaml` is left out; `mcp.json` declares the server.

## Server-side items that still apply (not ZIP changes)

These are tracked in the private adstudio repo and affect this app as much as Search Ads:

1. **Router tools.** `google_ads`, `meta_ads` and the other routers use `action: list_tools |
   execute` plus `tool_name`, which OpenAI's "tool independence" guideline names as a generic
   executor. 2.0.0 was submitted with the same routers; its review outcome is the best signal.
2. **Upgrade wording in tool output.** Some limit and usage messages still say "upgrade to Pro" or
   "move up to" a plan. OpenAI prohibits promoting upgrades. The skills no longer repeat it, but the
   server text needs the fix.
3. **Stale `microsoft_ads` description.** It says write operations are "when added" and lists only
   two operations, but the router fronts 36, including creates, updates and deletes. The annotations
   (`destructiveHint: true`) are right; the description should match them.
