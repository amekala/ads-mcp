---
name: adspirer-creative
description: Write and refresh ad creative with Adspirer — headlines, descriptions, primary text, and ad copy for Google, Meta, TikTok, LinkedIn, and Amazon, plus diagnosing and fixing creative fatigue when CTR falls and frequency rises. Respects each platform's character limits.
---

# Ad creative

Follow `adspirer-mcp` before any tool call. Load the platform skill for its exact limits.

## Write from evidence, not imagination

Before writing a single headline, look at what already works:

- `analyze_search_terms` (Google) or `get_amazon_search_terms` — the actual words people typed to
  find this business. Those words belong in the copy.
- `get_ad_performance` / `get_meta_ad_performance` — which existing ad has the best CTR, and why.
- The landing page. Copy that promises something the page doesn't deliver converts once and never
  again.

Ask what makes this business different if it isn't obvious. Generic ad copy is a choice, not a fate.

## Character limits

| Platform | Field | Limit |
|---|---|---|
| Google Search | Headline | 30 |
| | Description | 90 |
| | Long headline (PMax) | 90 |
| Meta | Headline | 255 (~40 visible) |
| | Primary text | 2200 (~125 visible) |
| | Description | 255 (~30 visible) |
| Meta carousel | Card headline | ~40 |
| LinkedIn | Headline | 70 |
| | Introductory text | 600 (~150 visible) |
| TikTok | Ad text | 100 |
| Amazon SB | Headline | 50 |

Where the hard limit and the visible limit differ, **write to the visible one.** Meta's 2200-character
primary text truncates at about 125; anything after that is read by nobody.

## What good looks like

- **Lead with the offer or the outcome**, not the company name. Nobody searched for your brand.
- **One idea per headline.** Google rotates them independently; a headline that only makes sense
  next to another headline will appear alone.
- **Specifics beat adjectives.** "Same-day callout, no fee" beats "Fast, reliable service."
- **Match the search intent.** Someone searching "emergency plumber near me" wants availability and
  a phone number, not your 30-year heritage.
- **Give Google variety.** Fifteen headlines that all say the same thing give the system nothing to
  test. Vary the angle: price, speed, proof, risk reversal, outcome.

Write more than you need and cut. Then check every claim is one the business can actually make —
"#1 in the UK" is a legal problem, not a headline.

## Refreshing fatigued creative

Rising frequency plus falling CTR is fatigue. The same people keep seeing the same ad. **No bid or
budget change fixes it** — a fatigued ad set with more budget just annoys the same people faster.

Diagnose: `detect_meta_creative_fatigue`, `detect_tiktok_creative_fatigue`,
`analyze_linkedin_creative_performance`. On Meta, a 7-day frequency above ~3 with declining CTR is
the signal.

Fix, in order of leverage:

1. **New creative concept** — a different hook, not the same image recoloured.
2. **New format** — video where there was static, carousel where there was a single image.
3. **Broaden or rotate the audience** — fatigue is partly an audience-size problem.
4. Only then touch budgets.

Change one variable at a time. Swapping the image *and* the copy *and* the audience teaches you
nothing about which one mattered.

## Show the variants together

Copy is judged by comparison. Fifteen headlines in a bulleted list all read the same; the same
fifteen laid out as cards, grouped by angle, with character counts and the truncation point marked,
are a decision the user can actually make.

Publish an **artifact**: variants side by side, each rendered at its real character limit so
truncation is visible, with a one-line note on the angle each one takes. For a fatigue refresh, show
the current ad next to its replacements.


Either way, render each variant against its platform's **visible** limit, not the hard one. A Meta
primary text that looks fine at 2,200 characters is worthless if the offer sits past 125.

## Applying it

Update in place with `update_ad_headlines`, `update_ad_descriptions`, or `update_ad_content` on
Google; the platform's ad-update tools elsewhere. Keep the winning ad running while the new one
gathers data — pausing the control before the challenger has proven itself is how accounts go
backwards.

Ads may need review before serving. Say so, rather than letting the user think it's live.

Creative fatigue is a recurring problem, not a one-time fix. Rather than promising to check back,
offer to schedule a fatigue check on this host — frequency and CTR, every couple of weeks — so the
next refresh is prompted by the data instead of by someone remembering.

A Cowork **scheduled task**, or a **remote routine** in Claude Code — not a local Desktop task.
Fatigue doesn't wait for the laptop to be open.
