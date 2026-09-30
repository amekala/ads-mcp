# Adspirer Search Ads: ChatGPT submission sheet

The plugin source is `plugins/chatgpt/adspirer-search-ads/`. Build it with
`./scripts/package-chatgpt-plugin.sh adspirer-search-ads`.

MCP server: `https://mcp.adspirer.com/search-ads/mcp`. The code is in `Adspirer/adstudio`, under
`adspirer-mcp-search-ads/`.

## Status

| Item | State |
|---|---|
| ZIP builds and passes the validator | ✅ 1.0.0 |
| Listing text, category, prompts, icons | ✅ in `plugin.json` |
| 5 positive and 3 negative test cases | ✅ written; ❌ not yet run against a reviewer account |
| Release notes | ✅ |
| Demo video URL | ❌ not recorded |
| Reviewer account | ❌ not created (see below) |
| Domain verification | ❌ needs the parent-domain token (see below) |
| Blockers on the MCP server | ❌ see "Fix before submitting" |

## Fix before submitting

These are server-side and live in `Adspirer/adstudio`. They are not ZIP changes.

1. **Router tools versus OpenAI's "tool independence" rule. This is the highest rejection risk.**
   - The guideline: "Expose each model-callable operation as a separate tool … Do not use discovery,
     operation selection, or schema fetching with a generic executor to enable operations not
     individually exposed for review."
   - The problem: `google_ads_read`, `google_ads_write`, `bing_ads_read` and `bing_ads_write` take
     `action: list_tools | execute` plus `tool_name`, and `get_tool_schema` fetches schemas. That is
     the pattern the rule describes.
   - Options:
     - Expose the Google and Microsoft operations as individual tools on this server.
     - Or submit as-is and be ready to appeal.
   - Decide before recording the demo.
2. **Main app and Search Ads connecting under the same app ID.**
   - ChatGPT registers with both servers as `chatgpt-dev`, and the two connections currently share
     one sign-in slot.
   - The server-side fix is tracked in the private adstudio repo. Ship it before launch.
3. **Annotations.** Current live values from the tool scan are in the table below.
   - The new guideline says `openWorldHint` should be `false` for tools confined to the user's own
     account, "even when externally hosted". Our read tools (`google_ads_read`, `bing_ads_read`,
     `get_campaign_performance`, `google_analytics`, `audit_conversion_tracking`) say `true`.
   - Decide whether to change them. Write tools that publish ads arguably stay `true`.
4. **Tool descriptions that don't match this server.**
   - `audit_conversion_tracking` describes Meta Pixel and LinkedIn checks.
   - `get_connections_status` lists every platform, including ones this plugin can't act on.
5. **No upgrade or pricing prompts in tool output.**
   - Confirm that the usage-limit message, `get_usage_status` and `start_here` never link to checkout
     or promote plans.
   - Explaining that a limit was reached, with a link to an informational page, is allowed.
6. **Response minimisation.** Check that tool results don't include trace, request or session IDs or
   other internal identifiers.

## Domain verification

The portal gives a token to serve at `https://<host>/.well-known/openai-apps-challenge`.

- `https://mcp.adspirer.com/.well-known/openai-apps-challenge` already returns the main Adspirer
  app's token.
- OpenAI says not to replace another plugin's token. Use an allowed parent origin or a separate
  hostname instead.
- Plan: serve the Search Ads token at `https://adspirer.com/.well-known/openai-apps-challenge`, the
  parent origin. Today that URL returns HTTP 200 with an empty body.
- Fallback: give Search Ads its own hostname. That hostname would then be permanent, because the MCP
  origin can't change after submission.

## Reviewer account (entered in the portal, never in this repo)

OpenAI requires a **dedicated** account with sample data. It must work immediately, with no MFA,
email or SMS codes, or magic links.

- Create a separate Adspirer reviewer login with password sign-in. Confirm that Clerk won't ask it
  for an email code.
- Connect a Google Ads test account with a few Search campaigns, search terms and conversions over
  the last 30 days.
- Connect a Microsoft Advertising account with a campaign and 30 days of data.
- Don't reuse a team member's real login.
- Keep the account and its data in place for later reviews.

Sign-in steps to paste into Review details:

1. Open ChatGPT, then **Plugins**, and install **Adspirer Search Ads**.
2. When asked to connect, sign in at the Adspirer page with the reviewer email and password.
3. Click **Authorize**. You're returned to ChatGPT and the connection is complete.
4. Run the test prompts below in a new chat.

## Test cases

These are in `plugin.json` and are imported with the ZIP (read-only in the portal). The positive
cases are the five use cases from the Claude directory listing. Run every case with the reviewer
account before submitting, and fix either the expected result or the server.

| # | Prompt | Tool | Expected |
|---|---|---|---|
| P1 | Pull my Google Ads performance for the last 90 days: impressions, clicks, spend, and conversions, by campaign. | `get_campaign_performance` | Per-campaign metrics plus totals |
| P2 | Which Google Ads keywords spent the most with zero conversions in the last 90 days? | `google_ads_read` | Zero-conversion keywords, highest spend first |
| P3 | Compare my Google Ads and Microsoft Advertising results for the last 30 days by cost per conversion. | `get_campaign_performance`, `bing_ads_read` | Side-by-side cost per conversion |
| P4 | Show me search terms that are spending with no conversions, then add the ones I approve as negative keywords. | `google_ads_read`, `google_ads_write` | Lists terms, waits for approval, adds only the approved terms |
| P5 | Create a paused Google Search campaign for 'enterprise CRM software' at $30/day. | `google_ads_write` | Asks for any missing landing page or location, then creates it PAUSED and returns its ID |
| N1 | Create a Meta ads campaign for my online store. | none | Says Meta isn't supported here; creates nothing |
| N2 | Delete all my Google Ads campaigns. | none | Doesn't delete; lists campaigns and asks for explicit confirmation, or declines |
| N3 | What makes a good headline for a search ad? | none | Answers directly; no tool call |

P4 and P5 change the reviewer account: they add negatives and create a paused campaign. Before each
review, remove the negatives and the campaign so the account starts clean.

## Demo video

The video must cover the main use cases and tools. Record one take in ChatGPT on the web, then show
one prompt on mobile. Suggested order:

1. Install and connect.
2. P1 to P5, including the approval step in P4 and the paused campaign in P5.
3. N1 and N2.

Upload it somewhere a reviewer can open without signing in, and put the URL in
`review.demo_recording_url` (or in the portal).

## Screenshots

These are optional. OpenAI no longer shows screenshots in the directory, and they're only accepted
when the server has UI (this one does). If added, provide exactly one per starter prompt. Each must
be a PNG or JPEG, **706 px wide** and 400–860 px tall. The plan is to skip them for 1.0.0.

## Listing decisions

This listing is adapted from the Claude directory listing. These parts were changed to fit
OpenAI's rules or to match what this plugin actually does in ChatGPT:

| Claude listing | ChatGPT listing | Why |
|---|---|---|
| "autonomously runs your campaigns", "keep working after launch", "paces spend", "flags anything that needs a human call" | "keep improving them each time you check in" | The Search Ads server has no scheduled or background tools (no monitors), so in ChatGPT it acts only when asked. A reviewer would test the claim. |
| "works like a member of your team" | dropped | OpenAI rejects unverifiable claims. |
| "free tier includes 15 tool calls per month; paid plans raise the limit" | dropped; "Requires an Adspirer account" | OpenAI doesn't allow pricing, plans, trials or upgrades in listing text. |
| One-liner (148 characters) | "PPC agent for Google & Bing" | The subtitle limit is 30 characters. The full one-liner is the package `description`. |

- **Name:** "Adspirer Search Ads" (19/30). Brand plus function; no "MCP" or "Plugin".
- **Subtitle:** "PPC agent for Google & Bing" (27/30).
- **Category:** Business & Operations. This matches the main Adspirer app; "Data & Analytics" was the
  alternative.
- **Starter prompts:** shortened versions of the Claude use cases (each 128 characters or fewer).
- **Keywords:** PPC, paid search, SEM, Google Ads, Microsoft Advertising, Bing Ads, keyword research,
  match types, negatives, search terms, RSAs, bid strategy, Quality Score, Performance Max, Shopping,
  ROAS, CPA, wasted spend, conversion tracking, GA4, Search Console, PPC agency.
- **To confirm before submitting:** "Shopping and Performance Max" and "Microsoft Advertising search and
  shopping" come from the Claude listing. Check that the reviewer account can see them through
  `google_ads_read` and `bing_ads_read`, or remove them.
- **Icons:** `shared/assets/icon.svg` (512x512 square) as `composerIcon` and `shared/assets/icon.png`
  (640x640) as `logo`. This is the same brand mark as the other plugins.
- **Support URL:** `https://www.adspirer.com/docs/knowledge-base/support`.
  - The old app used `https://adspirer.ai/help`, which redirects to sign-in. OpenAI requires public
    URLs.

## Tool annotations (live scan, 2026-09-30)

The guidelines say justifications are no longer required, but the errors page still lists
`justification_required`. Keep these ready to paste in case the portal asks.

| Tool | read-only | destructive | open-world | Justification |
|---|---|---|---|---|
| `start_here` | true | false | false | Renders a getting-started card from Adspirer's own data; writes nothing. |
| `get_connections_status` | true | false | false | Reports connection status from Adspirer's database; cannot disconnect anything. |
| `switch_primary_account` | false | true | false | Changes which connected accounts are active (a stored preference); reversible, and no data is deleted. |
| `get_usage_status` | true | false | false | Reads the user's usage for the billing period. |
| `get_tool_schema` | true | false | false | Returns tool parameter schemas; runs nothing. |
| `get_campaign_performance` | true | false | true* | Reads Google Ads reporting for the user's account and renders a card; writes nothing. |
| `audit_conversion_tracking` | true | false | true* | Reads conversion-tracking settings from connected platforms and reports findings; changes nothing. |
| `google_ads_read` | true | false | true* | Runs only read operations (reports, lists, keyword research, search terms) on the user's Google Ads account. |
| `google_ads_write` | false | true | true | Creates, updates, pauses or deletes Google Ads objects; can remove keywords and change budgets. New campaigns are created paused. |
| `bing_ads_read` | true | false | true* | Read-only Microsoft Advertising reports and lists for the user's account. |
| `bing_ads_write` | false | true | true | Creates, updates, pauses or deletes Microsoft Advertising objects. |
| `google_analytics` | true | false | true* | Reads GA4 reports for the user's properties. |
| `google_search_console` | false | true | true | Reads organic search data and can submit URLs for re-indexing, which is an outbound write. |
| `google_tag_manager` | false | true | true | Reads and edits tags and variables in the user's containers. |

\* These tools only touch the user's own private account, so under the current guideline
`openWorldHint` could be `false`. See "Fix before submitting", item 3.
