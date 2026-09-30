---
name: adspirer-search-ads
description: Use Adspirer Search Ads to read and change the user's Google Ads and Microsoft Advertising (Bing) search campaigns, and to read GA4, Search Console and Tag Manager. Use for search campaign performance, search terms, keywords, negative keywords, budgets, bids, or connecting ad spend to site outcomes.
---

# Adspirer Search Ads

This server works on the user's real ad accounts. Reads are free to run; changes spend real money,
so confirm before making them.

## Which tool

| Need | Tool |
|---|---|
| Google Ads reads (reports, lists, analysis) | `google_ads_read` |
| Google Ads changes (create, update, pause, budget, delete) | `google_ads_write` |
| Microsoft Advertising reads | `bing_ads_read` |
| Microsoft Advertising changes | `bing_ads_write` |
| Google Ads performance card | `get_campaign_performance` (call directly) |
| Connected accounts and account switcher | `get_connections_status` (call directly) |
| What to try first | `start_here` (call directly, free) |
| Conversion tracking health check | `audit_conversion_tracking` (call directly) |
| Plan usage | `get_usage_status` (call directly) |
| Exact parameters for any tool | `get_tool_schema` (free) |
| Site outcomes | `google_analytics`, `google_search_console`, `google_tag_manager` |

The four routers work in two steps:

1. `{"action": "list_tools"}` to see what the router offers.
2. `{"action": "execute", "tool_name": "<name>", "arguments": {...}}` to run one.

Before the first `execute` of a tool, call `get_tool_schema` with its name and use exactly the
parameters it returns. Read routers only run read-only tools and write routers only run changes, so
if a router refuses a tool, use the other one.

The top-level tools in the table are called by name. Don't wrap them in a router.

## Accounts

- Never invent account ids. Get them from `get_connections_status`.
- If the user has more than one account on a platform and didn't say which, ask.
- `switch_primary_account` changes which accounts are active. Only call it when the user asks.
- If a GA4 property, Search Console site or Tag Manager container is ambiguous, the tool returns the
  list. Show it to the user and let them pick.
- `get_connections_status` can list Meta, LinkedIn or other accounts. This plugin can only act on
  Google Ads and Microsoft Advertising. If the user asks about another platform, say so plainly and
  don't call any tool for it.

## Before any change

1. Read the current state first (campaign, budget, keywords) with the read router.
2. Tell the user exactly what will change, with the numbers: old value, new value, and which campaign.
3. Make the change only after the user agrees.
4. Read it back and confirm the result.

New campaigns are created paused. Say so, and ask before resuming one.

## Common jobs

- **Weekly review:** `get_campaign_performance` for Google Ads, the equivalent read on
  `bing_ads_read` for Microsoft Ads. Lead with spend, conversions and cost per conversion, then the
  two or three campaigns that moved most.
- **Wasted spend:** look at search terms with spend and no conversions. Suggest negatives, grouped by
  theme, and add them only after the user approves the list.
- **Tie spend to the site:** compare ad clicks and conversions with GA4 sessions and conversions for
  the same dates, and with Search Console for the same queries. Say which source each number came
  from.

For building and tuning Google Search campaigns, follow the `google-search-campaigns` skill.
