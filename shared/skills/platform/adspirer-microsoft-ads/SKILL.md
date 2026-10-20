---
name: adspirer-microsoft-ads
description: Create and manage Microsoft Advertising (Bing Ads) through Adspirer — accounts, campaigns, ad groups, keywords, ads, extensions, budgets, and targeting. Campaigns are created paused. There is no Microsoft performance, search-term, or conversion-audit tool unless list_tools shows one.
---

# Microsoft Advertising

Everything on Microsoft goes through the `microsoft_ads` router. Follow `adspirer-mcp`: `{"action": "list_tools"}` first (free), then `{"action": "execute", "tool_name": "...", "arguments": {...}}`. `get_tool_schema` before you execute. Never point a `google_ads` tool or a Google id at a Microsoft account.

## Accounts and units

`list_microsoft_accounts` returns `account_id`, the manager `customer_id`, and the currency. If several accounts are connected, send `account_id` as a string inside `arguments`. A multi-account reply means you must name one. It is not a broken connection.

Budgets and bids are plain decimals in the account's own currency. `50` means 50.00. Never send micros or cents, and never convert the user's currency to USD.

## What you can read

Use the live names. The usual reads are `list_microsoft_campaigns`, `list_microsoft_ad_groups`, `list_microsoft_keywords`, `list_microsoft_ads`, `list_microsoft_ad_extensions`, `list_microsoft_budgets`, `list_microsoft_bid_strategies`, `list_microsoft_campaign_criterions`, `list_microsoft_ad_group_criterions`, `list_microsoft_audiences`, `list_microsoft_asset_groups`, and `discover_microsoft_media`.

List responses can be Markdown, and names can contain `|`. Parse columns from the right, and say how many rows you saw versus the total.

## What the catalog does not have

Check `list_tools` (or `search_tools` with platform `microsoft-ads`) every time before you claim one of these. As tested, the live catalog has **no** Microsoft performance report, search-term report, keyword-volume tool, or negative-keyword tool, and `audit_conversion_tracking` does not cover Microsoft.

If the tool isn't there, say it is unavailable. Offer a labeled alternative: campaigns, status, and budgets from the list tools; a report the user pastes in; Google-derived keyword research marked as such (`adspirer-keywords`); or a read of the ads manager UI (`adspirer-ads-manager-browser`). Never invent metrics, and never assume Microsoft matches Google Ads.

For a scorecard, put Microsoft metrics under "not available" and still show campaign status and budgets. See `adspirer-performance-review`.

## Building (paused, and only after a yes)

1. Confirm the account, geography, language, landing page, objective, daily budget in account currency, bid strategy, and how conversions are measured (UET, offline, or app).
2. Present the plan: campaign, ad groups, keywords with match types, negatives, responsive-search copy with character counts, extensions, and targeting. Get a yes for that plan.
3. `create_microsoft_campaign` with paused status set explicitly, the way the live schema requires. If you cannot confirm the create will be paused, stop.
4. Then ad groups, keywords, ads, extensions, and criterions, using the live create tools. Ids have different scopes. Never send a campaign id where an ad-group id is required.
5. Read everything back. Report ids and any partial failure. **Enabling is a separate yes** — `adspirer-launch`.

An update tool changes live delivery immediately. Each update needs its own yes. Deleting criterions needs a yes too. Name what the delete removes.

## Reporting numbers

Follow the evidence rules in `adspirer-agent`. Microsoft figures stay in Microsoft's currency. Don't fold them into a Google total.
