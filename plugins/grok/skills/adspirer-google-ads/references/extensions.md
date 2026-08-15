# Google Ads extensions

Extensions (Google calls them "assets") add links, text, and detail beneath a Search ad. They cost
nothing extra, they raise CTR, and Google penalizes ads that lack them via Ad Rank.

**A Search campaign is not finished until it has extensions.** Treat this as part of the build, not
a follow-up task.

## The minimum

| Extension | Tool | Minimum | Notes |
|---|---|---|---|
| Sitelinks | `add_sitelinks` | **4** | Each needs a link text plus two description lines and its own URL. Point them at genuinely different pages. |
| Callouts | `add_callout_extensions` | **4–6** | Short, non-clickable proof: "Free Shipping", "24/7 Support", "No Setup Fee". ≤25 chars. |
| Structured snippets | `add_structured_snippets` | 1 header | Pick a header (Services, Brands, Types, Courses…) and list 3–10 values under it. |

`list_campaign_extensions` shows what's already there. Don't duplicate.

## Writing them well

**Sitelinks that repeat the ad are wasted.** If the headline says "Emergency Plumbing", the
sitelinks should be Pricing, Service Areas, Reviews, Book Online — the things a ready buyer clicks
next. Each must land on a page that actually exists and matches its label.

**Callouts are not slogans.** "Quality You Can Trust" says nothing. "Same-Day Callout", "Licensed &
Insured", "No Call-Out Fee" are reasons to choose this business.

**Structured snippets need a real category.** Don't jam unrelated things under one header.

## Removal is permanent

`remove_sitelinks`, `remove_callouts`, and `remove_structured_snippets` delete the asset. Historical
performance goes with it. Confirm before removing, and prefer replacing.

## Also worth having

Call extensions, location extensions, and price extensions matter a lot for local and e-commerce
advertisers. If the business has a phone number or a storefront and neither is attached to the ads,
that's the first thing to fix.
