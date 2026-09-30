---
name: search-optimization
description: Find and fix wasted Google Ads search spend with Adspirer Search Ads - zero-conversion keywords and search terms, negative keywords, pausing, and moving budget toward what converts. Proposes changes and applies only the ones the user approves.
---

# Search optimization

Follow `adspirer-search-ads` before any tool call. This skill proposes changes and applies each one
**only after the user approves that specific change**.

## Find the waste

Use `google_ads_read`:

- `analyze_wasted_spend`: keywords and campaigns spending without results
- `analyze_search_terms`: what people actually typed, with suggested negatives and new keywords

Waste comes in a few shapes:

- **Spend with no conversions.** Check volume before calling it a loser. As a rough guide, wait for
  spend of about three times the target cost per conversion, or around 100 clicks.
- **Spend converting far above target.** Easy to miss, because it looks like it's working.
- **Search terms you never meant to buy:** "free", "jobs", "DIY", other brands, unrelated products.

## Before cutting anything

- **Check tracking.** A campaign that "converts nothing" often converts fine but reports nothing. Run
  `audit_conversion_tracking` before pausing on the basis of zero conversions.
- **Check its role.** An upper-funnel campaign may assist conversions that another campaign gets
  credit for. Say so when it's likely.

## Fix it, in this order

1. **Negatives before pauses.** Show the list of search terms and the negatives you'd add, grouped by
   theme, with the match type for each. Add only the ones the user approves, with
   `add_negative_keywords` (campaign level, needs `campaign_id`) or a shared negative list.
2. **Pause the narrowest thing** that solves the problem: a keyword, then an ad, then an ad group,
   then a campaign.
3. **Move budget** toward proven cost per conversion. `optimize_budget_allocation` recommends a split;
   it doesn't apply one. Move in steps of about 20–30% and give the new level a week, because a big
   jump can reset learning.

Show the arithmetic in the account's currency, for example: "Move 30 a day from Campaign A (CPA 140,
target 50) to Campaign B (CPA 38). Same total spend."

**Never delete when pausing will do.** Removing keywords or ads loses their history. Say what will
be lost and get an explicit yes.

## Pacing

Compare spend so far with the share of the month that has passed.

- **Underpacing** usually means low bids, a target that's too strict, or narrow targeting. Check
  whether the campaign is actually limited by budget before raising it.
- **Overpacing** means the budget runs out early. Lower the daily budget or fix what's expensive.

Google can spend up to twice the daily budget on a single day and balances it over the month, so one
high day isn't a fault.

## Then verify

After each change, read the object back and report what actually changed. Tell the user what to
expect next: a learning period, or a few days before the data means anything.
