---
name: adspirer-google-ads
description: Create and manage Google Ads campaigns through Adspirer — Search, Performance Max, Demand Gen, YouTube, and Display. Use for Google Ads keywords, search terms, quality score, bid strategies, sitelinks and extensions, PMax asset groups, or anything on Google/AdWords. Covers the asset-bundle expiry and ad-group-id traps.
---

# Google Ads

Everything on Google goes through the `google_ads` router. Follow `adspirer-mcp` for the
two-step: `{"action": "list_tools"}` first, then `{"action": "execute", "tool_name": ..., "arguments": {...}}`.

Account parameter: `customer_id`, as a **string**. Hyphens are stripped for you.
Budgets are in **dollars** — `$50/day` is `50.0`.

## Creating a campaign

**1. Pick the type.** If the user just said "create a campaign," run `select_google_campaign_type`
rather than guessing. Search, Performance Max, Demand Gen, YouTube, and Display solve different
problems — `references/campaign-types.md` has the decision tree and the budget each type actually
needs to learn.

**2. Gather what's required.** Budget, final URL, locations, and the conversion goal. Resolve place
names with `resolve_google_locations` instead of guessing geo ids.

**3. Prepare assets.** For Performance Max, run `discover_existing_assets` first — the account
usually already has images and logos, and reusing them is faster and better than asking the user to
upload. Then `validate_and_prepare_assets`.

> **Asset bundles expire after one hour.** If more than an hour passed between preparing assets and
> creating the campaign, re-run `validate_and_prepare_assets` and use the fresh bundle. A stale
> bundle fails at create time.

**4. Create.** The campaign comes back **paused**. It does not spend.

**5. Add extensions. This is not optional for Search.** A Search campaign without extensions
underperforms badly and Google will tell you so. Add at least 4 sitelinks, 4–6 callouts, and
structured snippets before you call the build finished. See `references/extensions.md`.

**6. Read it back.** List the campaign and confirm budget, status, and targeting match what you
intended. Then tell the user it is paused and ask whether to resume.

## Keywords and ads attach to ad groups, not campaigns

Any tool that touches a keyword, a negative keyword, or an ad needs an `ad_group_id`. Run
`get_campaign_structure` to get them. Do not pass a campaign id where an ad group id is expected.

For keyword research, `research_keywords` returns volume and competition from Google's own planner.
`analyze_search_terms` shows what people actually typed — that's where the negatives come from.

## Bidding

Don't set a target CPA or ROAS on a campaign with no conversion history; it has nothing to learn
from and will underdeliver. Start with maximize clicks or manual CPC, let conversions accumulate,
then move to a target. `references/bidding.md` has the thresholds.

## Reading performance

`get_campaign_performance` is a **direct, top-level tool** — do not route it through `google_ads`.
It renders a performance card. Pass `raw_data: true` when the user wants the numbers rather than
the summary.

For waste, `analyze_wasted_spend` finds spend with no conversions. For a sudden change,
`explain_performance_anomaly` compares windows and attributes the delta.

## Rate limits

Google counts keyword operations, not calls: roughly 300/hour and 500/day at the keyword level.
Adding two thousand keywords in one sitting will hit the ceiling. Batch large keyword work and tell
the user if you're pacing it.

## References

- `references/campaign-types.md` — which type to use, and the budget each needs
- `references/bidding.md` — bid strategies and when each becomes viable
- `references/pmax-assets.md` — Performance Max asset requirements
- `references/extensions.md` — the mandatory extensions step
