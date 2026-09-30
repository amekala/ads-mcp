---
name: adspirer-search-ads
description: How to use Adspirer Search Ads safely on the user's real Google Ads and Microsoft Advertising accounts. Use before any Adspirer Search Ads tool call - which tool does what, account selection, currency, quota, and the confirm-before-change rule.
---

# Adspirer Search Ads

This plugin works on the user's real ad accounts. Reading an account changes nothing; changing one
can spend real money. Confirm before every change.

## Which tool

| Need | Tool |
|---|---|
| Google Ads reports, lists and analysis | `google_ads_read` |
| Google Ads changes (create, update, pause, budget, delete) | `google_ads_write` |
| Microsoft Advertising lists and settings | `bing_ads_read` |
| Microsoft Advertising changes | `bing_ads_write` |
| Google Ads performance card | `get_campaign_performance` (call it directly) |
| Connected accounts, with an account switcher | `get_connections_status` (call it directly) |
| What to try first | `start_here` (call it directly) |
| Conversion tracking health check | `audit_conversion_tracking` (call it directly) |
| Plan usage | `get_usage_status` (call it directly) |
| Exact parameters for an operation | `get_tool_schema` |
| Site outcomes | `google_analytics`, `google_search_console`, `google_tag_manager` |

The four `*_read` / `*_write` tools take an operation name:

1. `{"action": "list_tools"}` lists the operations that tool can run.
2. Call `get_tool_schema` with the operation name and use exactly the parameters it returns.
3. `{"action": "execute", "tool_name": "<operation>", "arguments": {...}}` runs it.

Read tools only run read operations and write tools only run changes. If one refuses an operation,
use its pair. Call the direct tools in the table by name; don't wrap them.

## What this plugin can and can't do

- **Google Ads:** reporting, analysis, and full management of Search, Shopping and Performance Max
  campaigns.
- **Microsoft Advertising:** managing accounts, campaigns (Search, Shopping, Performance Max and more),
  ad groups, keywords, ads, extensions, budgets and bid strategies. **There is no Microsoft
  performance report in this plugin.** If the user asks for Microsoft spend, clicks or conversions,
  say so plainly and don't estimate them.
- **Other platforms** (Meta, LinkedIn, TikTok, Amazon): not supported. `get_connections_status` may
  still list those accounts. Say this plugin doesn't cover them and don't call a tool for them.

## Accounts

- Never invent account ids. Get Google ids from `get_connections_status` and Microsoft ids from
  `list_microsoft_accounts` (the numeric `account_id`, not the account number shown in Microsoft's UI).
- If the user has more than one account on a platform and didn't say which, ask.
- `switch_primary_account` changes which accounts are active. Only call it when the user asks.
- If a GA4 property, Search Console site or Tag Manager container is ambiguous, the tool returns the
  list. Show it and let the user pick.

## Money

Budgets, bids and targets are in the **ad account's own currency**, as plain amounts: 50 means 50.00
in whatever currency the account uses. Never convert currencies. If you don't know the account's
currency, check it (Microsoft lists it with the account; Google shows it with campaign data) and use
it when you talk about amounts.

## Quota

Reading doesn't change anything, but most read and write operations count against the user's monthly
tool calls. `start_here`, `get_connections_status`, `get_usage_status`, `get_tool_schema` and
`list_tools` don't. Don't repeat the same report in one conversation; reuse the result you already
have. If a call is refused because the limit was reached, tell the user what the tool said and stop;
don't retry.

## Before any change

1. Read the current state first with the read tool.
2. Tell the user exactly what will change: which account and campaign, the old value and the new value.
3. Make the change only after the user agrees to that specific change.
4. Read it back and report what actually happened, not what you asked for.

New Google and Microsoft campaigns, ad groups, ads and keywords are created paused. Say so, and ask
before resuming anything.

`google_search_console` can submit URLs for indexing, and `google_tag_manager` can edit tags. Both are
changes: confirm first, exactly as above.

## Related skills

- `google-search-campaigns`: building a Google Search campaign
- `search-performance-review`: reporting and reviews
- `search-optimization`: wasted spend, negatives and budget moves
- `microsoft-advertising`: managing Microsoft Advertising
