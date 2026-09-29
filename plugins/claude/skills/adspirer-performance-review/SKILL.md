---
name: adspirer-performance-review
description: Review ad performance across platforms with Adspirer — how are my ads doing, weekly or monthly reports, a cross-channel scorecard, CPA, ROAS, CTR, spend trends, and auditing whether conversion tracking is set up correctly. Read-only; changes nothing.
---

# Performance review

Follow `adspirer-mcp` before any tool call. This skill only reads — it never changes a campaign.

## Where the numbers come from

The two big platforms have **direct, top-level** performance tools. The rest go through their router.

| Platform | How |
|---|---|
| Google Ads | `get_campaign_performance` — call it directly |
| Meta Ads | `get_meta_campaign_performance` — call it directly |
| TikTok | `tiktok_ads` router → `execute` → `get_tiktok_campaign_performance` |
| LinkedIn | `linkedin_ads` router → `execute` → `get_linkedin_campaign_performance` |
| Amazon | `amazon_ads` router → `execute` → `get_amazon_campaign_performance` |
| ChatGPT Ads | `chatgpt_ads` router → `execute` → `get_chatgpt_performance` |

Calling the routed ones directly by name will fail — they aren't in the tool list. Pass
`raw_data: true` when the user wants the numbers rather than the rendered summary.

Only pull the platforms the user has actually connected. Check `get_connections_status` first
instead of firing six calls and reporting five failures.

## Before you trust a single number

**Verify conversion tracking.** Run `audit_conversion_tracking`. It returns a health score and
findings across Google, Meta, and LinkedIn — pixels, CAPI, dedup, conversion actions, enhanced
conversions, attribution.

If tracking is broken, every conversion metric below is fiction, and the honest answer to "how are
my ads doing" is "I can't tell you yet, and here's why." Say that before presenting a CPA. This is
the single most valuable thing this skill does.

Also check the window. Amazon's last 48 hours are incomplete. Today is always partial. A "drop" that
is really an unfinished day is the most common false alarm in this job.

## The scorecard

Report per platform, then in total:

- **Spend** — and pace against the monthly budget
- **Conversions** and **cost per conversion**
- **ROAS**, where revenue is tracked
- **CTR** and **CPC** — diagnostic, not goals
- **Change vs the previous equivalent period**

Compare like with like: last 7 days against the 7 before, not against a partial week.

## Say what it means

A table is not a review. Lead with the answer:

> Google is doing the work — 34 leads at $41, under your $50 target. Meta spent $890 for 3 leads.
> The Meta ad set has a frequency of 4.2 and its CTR halved over two weeks; that's creative fatigue,
> not targeting.

Name the biggest problem and the biggest opportunity. Give one recommendation, with the number
attached. Offer to act — don't act. Changes belong to `adspirer-optimize`.

## When something moved sharply

Use the anomaly tools rather than speculating: `explain_performance_anomaly` (Google),
`explain_meta_anomaly`, `explain_tiktok_anomaly`, `explain_linkedin_anomaly`. They compare windows
and attribute the delta to a cause.

Before blaming the algorithm, check the boring explanations: a campaign paused, a budget changed, a
disapproved ad, a landing page that started 404ing, a conversion tag someone removed on deploy.

## Make it easier to look at

A scorecard across six platforms is a table the user will squint at, and a trend is a shape, not a
column of numbers.

Offer an **artifact**: platform cards, a spend-vs-conversions chart, the anomalies called out. It's a
private page that updates in place, so a weekly review can republish to the same URL instead of
scrolling back through the transcript. Keep charts as SVG or CSS rather than embedded images.


## Make it recurring

A review is worth more every week than once. When the user likes what they just read, offer to
schedule it — this host can, and they can create it just by asking.


In Cowork, that's a **scheduled task** via `/schedule` — it runs remotely, so a sleeping laptop
doesn't matter. In Claude Code, it's a **routine**; prefer a *remote* one, because a local Desktop
task is skipped whenever the machine is asleep at the scheduled hour — exactly when a Monday-morning
review would fire.


Each run costs tool calls against their monthly quota, the same as a live conversation. Weekly is the
right default; daily only for accounts spending enough to justify it. Say so before setting it up.

If the user wants it delivered by **email** instead, or this host has no scheduler, Adspirer's
`monitoring_and_reporting` router does server-side scheduled briefs. See `references/host-surfaces.md`
in `adspirer-agent`.

## Don't

- Don't average CPA across platforms with wildly different volumes and call it "blended performance"
  without saying so.
- Don't present a 3-day window as a trend.
- Don't fabricate a number when a tool fails. Say the call failed and which one.
- Don't schedule a daily review for an account that spends $20 a day. The runs cost more attention,
  and more quota, than the findings are worth.
