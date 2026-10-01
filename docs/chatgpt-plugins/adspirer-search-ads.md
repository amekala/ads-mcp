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
| 5 positive and 3 negative test cases | ✅ written and checked against the tool catalog; ❌ not yet run against a reviewer account |
| Release notes | ✅ |
| Demo video URL | ✅ `https://screen.studio/share/OOqPY3xQ` (recorded for these test cases) |
| Reviewer account | ❌ not created (see below) |
| Domain verification | ❌ needs the parent-domain token (see below) |
| Blockers on the MCP server | ❌ see "Fix before submitting" |

## Fix before submitting

These are server-side and live in `Adspirer/adstudio`. They are not ZIP changes. Each one was checked
against the production code on 2026-09-30.

1. **Router tools versus OpenAI's "tool independence" rule. This is the highest rejection risk.**
   - The guideline: "Expose each model-callable operation as a separate tool … Do not use discovery,
     operation selection, or schema fetching with a generic executor to enable operations not
     individually exposed for review."
   - The problem: `google_ads_read/write` (169 Google operations) and `bing_ads_read/write` (36
     Microsoft operations) take `action: list_tools | execute` plus `tool_name`. `google_analytics`,
     `google_search_console` and `google_tag_manager` use the same pattern. Splitting reads from
     writes doesn't change this.
   - The fix: expose each supported operation as its own tool, with its own schema and annotations.
     Do it on a ChatGPT-specific endpoint path, so the Claude directory listing, which was approved
     with the routers, stays unchanged.
   - Decide before recording the demo. The skills and test cases then need the new tool names.
2. **Upgrade promotion in tool output.** OpenAI prohibits promoting upgrades or linking to checkout.
   Several limit and usage messages still say "upgrade to Pro" or "move up to" a bigger plan. Replace
   them with the facts: the limit, the reset date, and an informational link.
3. **Main app and Search Ads connecting under the same app ID.**
   - ChatGPT registers with both servers as `chatgpt-dev`, and the two connections currently share
     one sign-in slot.
   - The server-side fix is tracked in the private adstudio repo. Ship it before launch.
4. **Annotations.** Current live values from the tool scan are in the table below.
   - The new guideline says `openWorldHint` should be `false` for tools confined to the user's own
     account, "even when externally hosted". Our read tools (`google_ads_read`, `bing_ads_read`,
     `get_campaign_performance`, `google_analytics`, `audit_conversion_tracking`) say `true`.
   - Decide whether to change them. Write tools that publish ads arguably stay `true`.
5. **Tool descriptions that don't match this server.**
   - `audit_conversion_tracking` describes Meta Pixel and LinkedIn checks.
   - `get_connections_status` lists every platform, including ones this plugin can't act on.
   - `update_bid_strategy` describes the target CPA "in dollars", but amounts are in the account's
     currency.
6. **No Microsoft Advertising reporting.** The Microsoft operations can list and change campaigns,
   budgets and bids, but none return spend, clicks or conversions.
   - The listing, skills and test cases now say so, and the "compare Google and Microsoft" case was
     replaced.
   - To advertise cross-engine reporting, a Microsoft performance tool has to be built first.
   - The Claude listing's "compare engines" use case has the same gap.
7. **Response minimisation.** Check that tool results don't include trace, request or session IDs or
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
| P3 | List my Microsoft Advertising campaigns with their status, daily budgets and bid strategies. | `bing_ads_read` | Campaign type, status, budget in account currency, bidding scheme; says Microsoft reporting isn't available if asked for spend |
| P4 | Show me search terms that are spending with no conversions, then add the ones I approve as negative keywords. | `google_ads_read`, `google_ads_write` | Lists terms, waits for approval, adds only the approved terms as campaign-level negatives |
| P5 | Create a paused Performance Max campaign for an online watch store at $50/day with strong headlines and descriptions. (The prompt also gives the landing page, business name and four image URLs.) | `google_ads_read`, `google_ads_write` | Checks existing assets, validates the images, writes text within limits, creates it PAUSED and returns its ID |
| N1 | What are some good marketing strategies for a small business? Should I focus on SEO or social media? | none | Answers directly; no tool call (from the main app's submission) |
| N2 | Show me my Meta Ads performance | none | Says Meta isn't supported here; returns no Meta data (adapted, see below) |
| N3 | Hey! How's it going? What kind of things can you do? | none | Replies conversationally; no tool call (from the main app's submission) |

The Claude use case "Compare my Google Ads and Microsoft Advertising results by cost per conversion"
was replaced by P3, because Microsoft performance isn't available through this server.

P5 uses images that are live and meet Google's Performance Max rules:
- landscape `pmax-horizontal-01.png`, 1200×628
- two square images, 1200×1200
- square logo `Adspirer-square.png`, 146×146

They are also listed as the case's `file_attachment_urls`. Delete the paused campaign after each
review run.

The negative cases are the main app's submitted ones, with one exception. The original "Show me my
SEO performance" can't be a negative here, because Search Ads includes Search Console and would
answer it. It was replaced with an unsupported-platform request. Watch N3: `start_here` is written
for "what can you do?", so ChatGPT may call it on the greeting. If that happens in testing, change
the prompt or the `start_here` description before submitting.

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
- **Starter prompts:** two shortened Claude use cases, plus a Microsoft campaign listing in place of
  the engine comparison. Each is 128 characters or fewer.
- **Keywords:** PPC, paid search, SEM, Google Ads, Microsoft Advertising, Bing Ads, keyword research,
  match types, negatives, search terms, RSAs, bid strategy, Quality Score, Performance Max, Shopping,
  ROAS, CPA, wasted spend, conversion tracking, GA4, Search Console, PPC agency.
- **Capabilities checked against the tool catalog:**
  - Google Shopping and Performance Max: operations exist (`create_shopping_campaign`,
    `create_pmax_campaign` and related).
  - Microsoft Shopping and Performance Max: management only, through `create_microsoft_campaign` and
    related operations.
  - Quality Score: returned by `get_campaign_performance`.
  - Still to demonstrate on the reviewer account: all of these, plus GA4, Search Console and Tag
    Manager.
- **Icons:** `shared/assets/icon.svg` (512x512 square) as `composerIcon` and `shared/assets/icon.png`
  (640x640) as `logo`. This is the same brand mark as the other plugins.
- **Support URL:** `https://www.adspirer.com/docs/knowledge-base/support`.
  - The old app used `https://adspirer.ai/help`, which redirects to sign-in. OpenAI requires public
    URLs.

## Scan findings (2026-09-30) and what was done

| Tool | Finding | Action |
|---|---|---|
| `bing_ads_read` | Description claims capabilities that don't match behavior | It said "performance, reporting", but Microsoft has no reporting operation. The server now lists the 13 read operations and says there's no reporting. Deploy, then **Rescan** |
| `switch_primary_account` | Name unclear | Not changed yet (renaming would break the Claude listing and skills). Appeal with: it switches which connected ad account(s) Adspirer acts on for a platform |
| Server instructions | Needs further review | None; waits for the review team |
| `audit_conversion_tracking`, `get_campaign_performance`, `get_connections_status`, `get_usage_status`, `start_here`, `switch_primary_account` | Update needs further review | None; a hold for human review, not a defect |

Negative test cases (1.0.2) use the original submission's short description plus an
`expected_behavior`, the same shape as the main app's export. The SEO case stays swapped for Meta.

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
