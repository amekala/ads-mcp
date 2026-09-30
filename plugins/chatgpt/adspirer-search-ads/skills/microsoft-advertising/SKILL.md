---
name: microsoft-advertising
description: Manage Microsoft Advertising (Bing Ads) with Adspirer Search Ads - accounts, Search, Shopping and Performance Max campaigns, ad groups, keywords, responsive search ads, extensions, budgets and bid strategies. Use for anything on Microsoft or Bing Ads.
---

# Microsoft Advertising

Follow `adspirer-search-ads` for how to call tools and confirm changes. Reads go through
`bing_ads_read`; changes go through `bing_ads_write`.

## What's available

- **Read:** accounts, campaigns, ad groups, ads, keywords, budgets, bid strategies, extensions,
  audiences, targeting criteria and Performance Max asset groups.
- **Change:** create and edit campaigns of every type Microsoft supports (Search, Shopping, Dynamic
  Search, Audience, Performance Max and more), plus ad groups, keywords, ads, extensions, shared
  budgets, bid strategies and targeting.
- **Not available:** performance reporting. There's no spend, click or conversion report for
  Microsoft in this plugin. Say so if asked; don't estimate.

## Account and money

- Start with `list_microsoft_accounts`. Use the numeric `account_id`, not the account number shown in
  Microsoft's interface. If more than one account is connected, pass it on every call.
- Amounts are plain decimals in the account's currency (50 means 50.00). `list_microsoft_accounts`
  shows the currency.

## Building a campaign

1. Confirm the goal, campaign type, daily budget, locations, languages and landing page.
2. Create the campaign, then its ad groups, keywords and ads. **Everything is created paused.**
3. Responsive search ads take 3–15 headlines and 2–4 descriptions. Use only claims the business can
   support.
4. Add extensions with real pages and facts, then associate them with the campaign or ad group.
5. Read everything back with the list operations and confirm before asking whether to turn it on.

For Shopping or Performance Max, check for images first: `discover_microsoft_media` finds existing
media, and `validate_and_prepare_microsoft_assets` uploads new images from public URLs.

## Editing

- Updates only change the fields you pass; everything else stays as it is.
- A **shared budget** change affects every campaign using it. Say which campaigns before changing it.
- Pausing and resuming are status changes on the campaign, ad group, keyword or ad. Confirm first.
- Deleting targeting criteria is permanent. Prefer pausing or changing the bid adjustment.
