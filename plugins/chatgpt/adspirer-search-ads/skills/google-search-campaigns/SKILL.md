---
name: google-search-campaigns
description: Build and tune Google Ads Search campaigns through Adspirer Search Ads. Use for creating a Search campaign, keyword research, search terms and negative keywords, sitelinks and callouts, bid strategy, or quality score. Covers the ad-group-id trap and the mandatory extensions step.
---

# Google Search campaigns

Reads go through `google_ads_read` and changes through `google_ads_write`. Use the two steps from
the `adspirer-search-ads` skill: `list_tools`, then `get_tool_schema`, then `execute`.

The account parameter is `customer_id`, as a **string**. Hyphens are stripped for you.
Budgets are in **dollars**: `$50/day` is `50.0`.

## Creating a Search campaign

1. **Gather what's required:** daily budget, final URL, locations and the conversion goal. Resolve
   place names with the location tool instead of guessing geo ids.
2. **Research keywords:** use keyword research for volume and competition. Group keywords into tight
   themes, one ad group each.
3. **Confirm the plan with the user:** budget, locations, keywords and ad copy.
4. **Create it.** The campaign comes back **paused**, so it does not spend.
5. **Add extensions. This is not optional.** A Search campaign without them underperforms. Add at
   least 4 sitelinks, 4–6 callouts and one structured snippet. See `references/extensions.md`.
6. **Read it back.** Confirm budget, status and targeting match the plan, then tell the user it is
   paused and ask whether to resume.

## Keywords and ads belong to ad groups, not campaigns

Any tool that touches a keyword, a negative keyword or an ad needs an `ad_group_id`. Get it from the
campaign structure read. Don't pass a campaign id where an ad group id is expected.

Negatives come from search terms: what people actually typed. Look for terms that spent money
without converting, group them by theme, and show the list before adding anything.

## Bidding

Don't set a target CPA or ROAS on a campaign with no conversion history; it has nothing to learn
from and will underdeliver. Start with maximize clicks or manual CPC, let conversions build up, then
move to a target. `references/bidding.md` has the thresholds.

## Reading performance

`get_campaign_performance` is a top-level tool; don't route it through `google_ads_read`. It renders
a performance card. Pass `raw_data: true` when the user wants the numbers rather than the summary.

## Rate limits

Google counts keyword operations, not calls: roughly 300 per hour and 500 per day at the keyword
level. Batch large keyword work and tell the user if you're pacing it.

## References

- `references/extensions.md`: the mandatory extensions step
- `references/bidding.md`: bid strategies and when each becomes viable
