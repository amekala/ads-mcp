---
name: google-search-campaigns
description: Build and tune Google Ads Search campaigns with Adspirer Search Ads - keyword research, match types, ad groups, responsive search ads, sitelinks and callouts, and bid strategy. Use when the user wants a new Search campaign or to restructure one.
---

# Google Search campaigns

Follow `adspirer-search-ads` for how to call tools, currency and confirmation. Reads go through
`google_ads_read` and changes through `google_ads_write`. The account parameter is `customer_id`, as
a string.

## Creating a Search campaign

1. **Gather what's required:** what the business sells (one sentence), the landing page, the daily
   budget, the locations, and what counts as a conversion. Ask for anything missing. Resolve place
   names with `resolve_google_locations` rather than guessing ids.
2. **Research keywords first.** `create_search_campaign` expects `research_keywords` to have run.
   Group the results into tight themes, one ad group each, and choose match types on purpose: exact
   and phrase for proven intent, broad only with good conversion tracking and a smart bid strategy.
3. **Write the ads.** Responsive search ads need up to 15 headlines (30 characters each) and up to 4
   descriptions (90 characters each). Use only claims the user or their website supports: no invented
   prices, awards, guarantees or reviews.
4. **Confirm the plan** with the user: budget in the account's currency, locations, keywords, match
   types, and ad copy.
5. **Create it.** The campaign comes back **paused**, so it doesn't spend.
6. **Recommend extensions.** Sitelinks, callouts and structured snippets usually raise click-through
   rate; see `references/extensions.md`. Add the ones the business can support with real pages and
   real facts. Never invent landing pages or claims to reach a count. If the user asked for a
   minimal paused campaign, create that and suggest extensions as a next step.
7. **Read it back** with `get_campaign_structure`. Confirm budget, status, targeting and ads match
   the plan. Tell the user it's paused and ask whether to turn it on.

## Where keywords, negatives and ads attach

- Keywords and ads belong to an **ad group**: they need an `ad_group_id` from `get_campaign_structure`.
- `add_negative_keywords` adds negatives at the **campaign** level and needs a `campaign_id`. It
  affects every ad group in that campaign.
- Shared negative lists (`create_negative_keyword_list`, `attach_negative_keyword_list_to_campaign`)
  suit terms you want excluded across several campaigns.

Always check the schema with `get_tool_schema`; don't pass a campaign id where an ad group id is
expected.

## Bidding

See `references/bidding.md`. Smart bidding can use account-level data, so a new campaign in an
account that already converts can often start on a conversion-based strategy. An account with little
or no conversion history usually does better starting on clicks or manual bids. Explain the learning
period before changing a strategy with `update_bid_strategy`.

## Reading performance

`get_campaign_performance` is a direct tool; don't route it through `google_ads_read`. It renders a
card and includes keyword quality scores. Pass `raw_data: true` when the user wants the numbers.

## Rate limits

Google limits keyword operations, roughly 300 per hour and 500 per day at the keyword level. Batch
large keyword changes and tell the user if you're pacing them.
