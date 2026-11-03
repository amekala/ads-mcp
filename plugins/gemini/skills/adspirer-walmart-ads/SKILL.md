---
name: adspirer-walmart-ads
description: Create and manage Walmart Connect ads through Adspirer — Sponsored Products with auto or manual targeting, keywords, placements and bid multipliers, brand assets and video, plus search-term, keyword, item and Display performance with ACoS and ROAS. Use for anything on Walmart Advertising, Walmart Connect, or Walmart.com ads.
---

# Walmart Connect

Everything on Walmart goes through the `walmart_ads` router. Follow `adspirer-mcp` for the
two-step, and read a tool's exact parameters with `get_tool_schema` before you execute it.

Account parameter: `advertiser_id`, as a **string**. A 1P supplier and a 3P marketplace seller are
different advertisers. `list_walmart_advertisers` enumerates them. With one advertiser connected
you can omit the id. With several, a call without it returns the list of advertisers. That is not a
connection problem; re-run with the one the user means. Walmart advertisers are connected and
disconnected in the Adspirer app, not with `switch_primary_account`.

Budgets and bids are **plain-decimal USD** (`50` means $50, never cents). Daily-budget minimums
depend on the advertiser type: **1P $50/day, 3P $10/day**.

## What you can run

- **Sponsored Products** (`create_walmart_campaign` → `create_walmart_ad_group` →
  `create_walmart_ad_item`): your items in Walmart search and browse results. Where to start.
- **Keywords** (`create_walmart_keyword`, `create_walmart_negative_keyword`) on a manual campaign.
- **Placements and bid multipliers** (`set_walmart_placements`,
  `set_walmart_placement_multipliers`, `set_walmart_platform_multipliers`) to bias bids by placement
  (search, browse, item page) and platform (app, desktop, mobile). Read
  `get_walmart_page_type_performance` and `get_walmart_platform_performance` before you move them.
- **Brand assets and video** (`create_walmart_brand_asset`; `upload_walmart_video` →
  `complete_walmart_video_upload` → `attach_walmart_video`). Some assets go through Walmart's review
  (`submit_walmart_brand_asset_review`, `submit_walmart_review`).
- **Display** campaigns have their own read tools (`get_walmart_display_campaign_performance` and
  the line-item, tactic, SKU and creative reports). Check `list_tools` before promising a Display
  write.

## Hierarchy

Campaign → ad group → ad item → keywords. Each level carries its parent's id. Keywords and negative
keywords attach to the **ad group**.

Campaigns are created **paused**. Enabling one with `update_walmart_campaign` (status) starts real
spend, so it needs the user's yes for that campaign.

`delete_walmart_campaign` only works on a scheduled campaign that has never served, and it can't be
undone. A campaign that has served can only be paused or completed. Name what will be lost and ask
before deleting a campaign, a brand asset or a video.

## Start with automatic targeting

For a new item, automatic targeting lets Walmart find the search terms that convert. Run it, pull
`get_walmart_search_term_performance`, then promote the winners into a manual campaign as keywords
and add the losers as negatives. Going straight to manual means guessing what shoppers type.

## ACoS is the number that matters

Advertising Cost of Sale = ad spend ÷ attributed sales, the inverse of ROAS. Whether an ACoS is good
depends on the item's margin, so ask for it before you grade one. State the attribution window with
every sales figure (the warehouse reports default to 14 days).

Performance reads come from Adspirer's warehouse and return instantly: `get_walmart_ad_group_performance`,
`get_walmart_ad_item_performance`, `get_walmart_keyword_performance` and
`get_walmart_search_term_performance`. `walmart_stats` is today's near-real-time spend and remaining
budget. Today is always partial.

## Useful reads

- `get_walmart_out_of_budget`: campaigns that capped out in the last 7 days, with Walmart's
  suggested budgets. The place to start a budget-increase conversation.
- `get_walmart_keyword_recommendations`, `get_walmart_item_recommendations`,
  `walmart_keyword_suggestions` and `walmart_keyword_analytics` for keyword and item ideas.
- `get_walmart_catalog_insights`, `get_walmart_item_alerts` and `get_walmart_search_trends` for item
  health and demand signals.
