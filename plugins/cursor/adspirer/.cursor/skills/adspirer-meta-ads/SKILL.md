---
name: adspirer-meta-ads
description: Create and manage Meta Ads (Facebook and Instagram) through Adspirer — image, video, carousel, and lead-gen campaigns, ad sets, audiences, pixels, and creative fatigue. Use for anything on Facebook, Instagram, Meta, or FB ads. Covers the cents-not-dollars budget trap and the required Facebook page id.
---

# Meta Ads (Facebook and Instagram)

Everything on Meta goes through the `meta_ads` router. Follow `adspirer-mcp` for the two-step.

Account parameter: `ad_account_id`, as a **string**. An `act_` prefix is stripped for you.

## Budgets are in cents

`daily_budget` and `lifetime_budget` are **integers in cents**. `$50/day` is `5000`.

There is a second trap on top of that: any value **below 100** is read as dollars and multiplied by
100. So `50` books $50/day, and `500` books $5.00/day. Two values that look similar differ by 10×.
Always send cents, always ≥ 100, and read the created campaign back to confirm the number.

## Objectives

Meta uses ODAX objectives. Use these names:

`OUTCOME_AWARENESS` · `OUTCOME_TRAFFIC` · `OUTCOME_ENGAGEMENT` · `OUTCOME_LEADS` ·
`OUTCOME_APP_PROMOTION` · `OUTCOME_SALES`

Legacy names (`CONVERSIONS`, `LINK_CLICKS`, `LEAD_GENERATION`) are auto-mapped, but say the ODAX
name so the mapping is visible.

## Every ad needs a page and a URL

Meta refuses to create an ad without a Facebook `page_id` and an `http(s)` landing URL. Get the
page before you start building; asking for it halfway through a build wastes the user's time.
`list_meta_pixels` and `list_meta_instagram_accounts` find the other ids you'll want.

## Structure: one campaign, several ad sets

Targeting lives on the **ad set**, not the campaign. When a user wants to test three audiences,
that is one campaign with three ad sets — not three campaigns. Budget can sit at the campaign level
(Advantage+ / CBO) and be distributed, or at the ad-set level, but not usefully at both.

Build order: campaign → `add_meta_ad_set` → `add_meta_ad`. The campaign is created **paused**.

## Creative

- **Image**: feed 1:1 or 4:5, at least 600×600. Stories and Reels 9:16, at least 500×888. Under 30 MB.
- **Video**: MP4 or MOV, H.264, under 4 GB. Reels are 9:16, 3–90 seconds.
- **Carousel**: 2–10 cards. Every card needs its own landing URL, and all cards share one aspect
  ratio. Mixing ratios fails.
- **Text**: headline ≤ 255 characters. Primary text ≤ 2200, but it visually truncates around 125 —
  put the point first.

Full tables in `references/creative-specs.md`.

Run `validate_and_prepare_meta_assets` before creating an ad, and `discover_meta_assets` to reuse
what's already in the account.

## Writes are rate-guarded

Campaign creation is capped per user (about 100/hour, 300/day). Updates, pauses, and resumes are
not capped. If a write is blocked, stop and tell the user — do not retry in a loop, and do not
switch tools to get around it.

## Reading performance

`get_meta_campaign_performance` is a **direct, top-level tool** — do not route it through
`meta_ads`. It renders a performance card. Pass `raw_data: true` for the raw numbers.

`detect_meta_creative_fatigue` is the one to reach for when CTR is sliding and frequency is
climbing — that's fatigue, not a targeting problem. `analyze_meta_wasted_spend` finds ad sets
spending without converting.

Lead-gen campaigns: `list_meta_lead_forms` and `get_meta_lead_form_submissions` return real
people's contact details. Handle them as personal data — summarize, don't dump.

## References

- `references/creative-specs.md` — image, video, carousel, and text limits; ODAX objective map
