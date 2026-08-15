---
name: adspirer-amazon-ads
description: Create and manage Amazon Ads through Adspirer — Sponsored Products, Sponsored Brands, and Sponsored Display, with ASIN targeting, search-term reports, ACoS, and bid optimization. Use for anything on Amazon Advertising or Seller/Vendor Central ads.
---

# Amazon Ads

Everything on Amazon goes through the `amazon_ads` router. Follow `adspirer-mcp` for the two-step.

Account parameter: `profile_id`, as a **string** — a profile is a marketplace + account pair, so a
seller in the US and the UK has two. `list_amazon_profiles` enumerates them; get this right before
anything else or you will report the wrong marketplace's numbers.

Budgets are in the account's currency, minimum 1.00 in most marketplaces.

## The three ad types

- **Sponsored Products** (`create_amazon_sp_campaign`) — individual products in search results.
  Where almost everyone should start.
- **Sponsored Brands** (`create_amazon_sb_campaign`) — the banner with your logo and several
  products. Requires brand registry.
- **Sponsored Display** (`create_amazon_sd_campaign`) — retargeting on and off Amazon.

## Hierarchy

Campaign → ad group → product ad → keywords. Each level carries its parent's id. Keywords and
negative keywords attach to the **ad group**.

Campaigns are created **paused**. Resume with `resume_amazon_campaigns` after the user reviews.

## Start with automatic targeting

For a new product, automatic targeting lets Amazon discover which search terms convert. Run it for
a couple of weeks, pull `get_amazon_search_terms`, then promote the winners into a manual campaign
as exact-match keywords and add the losers as negatives. Jumping straight to manual targeting means
guessing what shoppers type.

## ACoS is the number that matters

Advertising Cost of Sale — ad spend divided by ad revenue. It is the inverse of ROAS. Whether a
given ACoS is good depends entirely on the product's margin: at a 40% margin, a 40% ACoS breaks
even. Ask for the margin before you call an ACoS good or bad.

`analyze_amazon_wasted_spend` finds spend without sales. `get_amazon_product_performance` and
`get_amazon_purchased_products` show what actually sold — including products the shopper bought
*instead of* the one you advertised, which is often the more interesting result.

## The unified API is a passthrough

`amazon_unified_api` reaches Amazon endpoints that have no dedicated tool, including writes. It is
powerful and unguarded. Know what an endpoint does before you call it, and never use it to work
around a validation error from a dedicated tool.

## Reading performance

Through the router: `{"action": "execute", "tool_name": "get_amazon_campaign_performance", ...}`.
Amazon reporting lags — data for the last 48 hours is incomplete, so don't read a same-day dip as
a trend.
