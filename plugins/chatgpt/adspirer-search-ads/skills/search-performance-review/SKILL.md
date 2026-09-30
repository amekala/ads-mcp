---
name: search-performance-review
description: Review Google Ads search performance with Adspirer Search Ads - how campaigns are doing, spend, conversions, CPA, ROAS, CTR, trends, and whether conversion tracking can be trusted. Read-only; changes nothing.
---

# Search performance review

Follow `adspirer-search-ads` before any tool call. This skill only reads.

## Where the numbers come from

| Platform | How |
|---|---|
| Google Ads | `get_campaign_performance`, called directly. Pass `raw_data: true` for the numbers |
| Google Ads ads, conversions, anomalies | `google_ads_read` operations: `get_ad_performance`, `get_conversion_action_performance`, `explain_performance_anomaly` |
| Microsoft Advertising | **No performance report in this plugin.** Microsoft tools can list campaigns, budgets, bids and settings, but not spend, clicks or conversions |

If the user asks to compare Google and Microsoft results, say Microsoft performance isn't available
here. Offer the Google numbers and the Microsoft campaign settings instead. Never fill in Microsoft
numbers from memory or estimates.

## Before you trust a number

1. **Check tracking.** Run `audit_conversion_tracking` when conversions look wrong or the user is
   about to act on CPA or ROAS. If tracking is broken, say that first: a CPA built on broken
   tracking is meaningless.
2. **Check the window.** Today is always partial, and recent days can still change as conversions
   come in. Compare like with like: the last 30 days against the 30 before, not against a part month.
3. **Check the currency.** Report amounts in the account's currency.

## The review

Per campaign, then in total:

- Spend
- Conversions and cost per conversion
- ROAS, where conversion values are tracked
- CTR and CPC, as diagnostics rather than goals
- Change against the previous equivalent period

Lead with the answer, not the table. For example: "Brand search is doing the work: 34 leads at 41,
under your 50 target. The generic campaign spent 890 for 3 leads." Name the biggest problem and the
biggest opportunity, give one recommendation with its numbers, and offer to act. Changes belong to
`search-optimization`.

## When something moved sharply

Run `explain_performance_anomaly` rather than guessing. Check the ordinary causes first: a paused
campaign, a budget change, a disapproved ad, a broken landing page, or a conversion tag removed in a
site release.

## Don't

- Don't present a 3-day window as a trend.
- Don't blend results from very different campaigns into one average without saying so.
- Don't invent a number when a tool fails. Say which call failed.
- Don't compare engines on cost per conversion unless both sides have real numbers, the same
  currency, and the same definition of a conversion.
