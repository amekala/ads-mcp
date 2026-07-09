# Meta creative specs and objectives

## Objectives (ODAX)

| Objective | Use for |
|---|---|
| `OUTCOME_AWARENESS` | Reach, brand lift, video views |
| `OUTCOME_TRAFFIC` | Clicks to a site or app |
| `OUTCOME_ENGAGEMENT` | Messages, post engagement, event responses |
| `OUTCOME_LEADS` | Lead forms, sign-ups |
| `OUTCOME_APP_PROMOTION` | App installs and app events |
| `OUTCOME_SALES` | Purchases, catalog sales, retargeting |

Legacy names still work and are auto-mapped, but prefer the ODAX name:

`CONVERSIONS` → `OUTCOME_SALES` · `LINK_CLICKS` → `OUTCOME_TRAFFIC` ·
`LEAD_GENERATION` → `OUTCOME_LEADS` · `BRAND_AWARENESS`/`REACH` → `OUTCOME_AWARENESS` ·
`APP_INSTALLS` → `OUTCOME_APP_PROMOTION`

Suggested starting daily budgets, **in cents**: awareness 1000, traffic 1000, engagement 1000,
leads 1500, sales 2000, app promotion 2000.

## Required on every ad

- A Facebook **`page_id`**. There is no ad without a page.
- An **`http(s)`** landing URL. Not a bare domain.
- A call-to-action from Meta's valid set.

## Images

| Placement | Ratio | Minimum |
|---|---|---|
| Feed | 1:1 or 4:5 | 600 × 600 |
| Stories / Reels | 9:16 | 500 × 888 |
| Carousel card | 1:1 | 1080 × 1080 |

JPEG or PNG, under 30 MB. 4:5 outperforms 1:1 in feed because it occupies more screen.

## Video

MP4 or MOV, H.264, under 4 GB. Reels are 9:16 and 3–90 seconds. Design for sound-off: most people
never hear it, so the first frame has to carry the message and captions are not optional.

## Carousel

- **2 to 10 cards.** Fewer than 2 is not a carousel; more than 10 is rejected.
- Every card needs **its own landing URL**.
- **All cards share one aspect ratio.** Mixing ratios fails at create time.
- Card headlines are short — around 40 characters before truncation.

## Text limits

| Field | Hard limit | Practical |
|---|---|---|
| Headline | 255 | ~40 before truncation |
| Primary text | 2200 | ~125 before "See more" |
| Description | 255 | ~30 |

The hard limit and the visible limit are different numbers. Write for the visible one: put the
offer in the first 125 characters of the primary text, or nobody reads it.

## Structure

Targeting lives on the **ad set**. Three audiences means one campaign with three ad sets, not three
campaigns. Splitting into separate campaigns fragments the budget and slows learning.

Campaign-level budget (Advantage+ / CBO) lets Meta move money to the winning ad set. Ad-set budgets
give you control. Pick one; setting both is a common source of confusion.

Meta needs roughly 50 conversions per ad set per week to exit the learning phase. An ad set that
can't reach that is too narrow or too poorly funded to optimize.

## Fatigue

Rising frequency plus falling CTR is creative fatigue, not a targeting problem, and no amount of
bid tuning fixes it. `detect_meta_creative_fatigue` quantifies it. Above a frequency of about 3 in
a 7-day window, refresh the creative.
