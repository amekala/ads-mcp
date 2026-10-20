---
name: adspirer-keywords
description: Paid-search keyword research with Adspirer — keyword ideas, match-type grouping, search-term mining, and negative-keyword candidates for Google Ads, plus a labeled planning exercise when Microsoft has no keyword-volume tool. Research only. Adding keywords or negatives needs an explicit yes.
---

# Keyword research

Follow `adspirer-mcp` and `adspirer-google-ads`. Research does not authorize a change.

## Before you pull anything

Establish the business, the landing page, geography, language, the objective, and an optional budget. If more than one Google Ads account is connected, take `customer_id` from `get_connections_status` and send it as a string. Discover the live names with `google_ads` `{"action": "list_tools"}` or `search_tools`. The usual tools are `research_keywords` (planner volume and competition) and `analyze_search_terms` (what people actually typed). `get_tool_schema` before you execute. Use only names the live list returns.

## Planner ideas and real queries are different things

`research_keywords` takes a business description, a website URL, 5–10 seed keywords, a location name such as "United States" (not a guessed geo id), a language, and `customer_id`.

`analyze_search_terms` is the account's own queries. For a raw report, sort by cost and ask for raw data. It is paged — say how many pages you read. Use explicit dates and report the window `freshness_state` actually covers.

The planner can return only a few ideas, and some seeds come back with no data. Report what came back. Never pad the list. Its broad-match default, intent tiers, and daily-budget suggestion are the tool's formula. Label them as such. Don't repeat them as your advice.

Keep planner estimates separate from observed search terms and conversions. Never present estimates as guaranteed traffic, rankings, or profit.

## How to group them

Group by commercial intent and relevance into proposed ad groups, with match types (exact, phrase, broad). Deliver a prioritized plan. Say the source, location, period, and limits of each number.

## Negatives

Read existing negatives first (`list_negative_keyword_lists`, `get_campaign_structure`) so you don't propose duplicates.

Propose negative candidates with a reason, a scope (campaign level unless there's a reason to go wider), and a match type.

- A brand term in a non-brand campaign is a **routing** negative. It sends brand traffic to the brand campaign. It is not wasted spend.
- The tool's negatives mode flags costly zero-conversion terms. Intent negatives — misspellings, another product, the wrong language — need judgment.
- Allow for conversion lag and small samples. Don't block an on-topic term that has one or two clicks.

Adding keywords or negatives (after you discover the live tool, often `add_negative_keywords`) needs an explicit yes for the exact list, the scope, and the account. Several changes go through the review table in `adspirer-optimize`.

## Microsoft

The Microsoft catalog has no keyword-volume or search-term tool. Check `list_tools` on `microsoft_ads` before you claim one. If it isn't there, offer a planning exercise, or Google-derived research applied to Microsoft, and say that's what it is. See `adspirer-microsoft-ads`.

Don't promise an SEO crawl, backlinks, or a competitor's private data. Competitor ads are `adspirer-competitors`.
