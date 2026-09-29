# Performance Max asset groups

PMax serves your assets in combinations you don't control. Thin assets means bad ads everywhere at
once.

## Before you build

1. **`discover_existing_assets`** — the account almost always has approved images and logos already.
   Reuse them. Asking the user to upload things they've already uploaded is a bad experience.
2. **`audit_conversion_tracking`** — PMax optimizes toward conversions. If tracking is broken it
   optimizes toward nothing and spends the full budget doing it. Do not launch PMax on broken
   tracking; say why.
3. **`validate_and_prepare_assets`** — validates dimensions and formats and returns a bundle.

> The bundle **expires after one hour.** If more than an hour passes before you create the campaign,
> re-run `validate_and_prepare_assets`. A stale bundle fails at create time, and the error does not
> say "expired" clearly.

## What an asset group needs

| Asset | Minimum | Good |
|---|---|---|
| Headlines (≤30 chars) | 3 | 5, distinct angles |
| Long headline (≤90 chars) | 1 | 2 |
| Descriptions (≤90 chars) | 2 | 4 |
| Landscape image 1.91:1 | 1 | 3+ |
| Square image 1:1 | 1 | 3+ |
| Portrait image 4:5 | — | 2 |
| Logo 1:1 | 1 | plus a 4:1 landscape logo |
| Video | — | 1+ (Google auto-generates a bad one if you skip it) |

If no video is supplied, Google generates one from your images. It is usually poor and it will
still run. Supplying even one real video is a meaningful improvement.

## Audience signals are hints, not targeting

A PMax audience signal tells Google where to *start* looking. It does not restrict who sees the
ads. Users expect it to behave like Meta targeting and are surprised when it doesn't — say this out
loud. Feed it your customer list, site visitors, and high-intent search terms via
`add_pmax_audience_signal`.

Search themes (`add_pmax_search_themes`) are the closest thing to keywords PMax has. Up to 25, and
they behave like broad match.

## Reporting is limited by design

PMax will not tell you which placement or which search term drove which conversion, at anything like
Search-level detail. If the user's core question is "which keyword made me money," PMax is the wrong
campaign type and you should say so before they spend six weeks on it.
