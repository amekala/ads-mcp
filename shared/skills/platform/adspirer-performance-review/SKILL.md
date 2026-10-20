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

**Verify conversion tracking before you trust a CPA.** Run `audit_conversion_tracking` for Google,
Meta, and LinkedIn. It does not cover Microsoft. It looks back from today. Read `freshness_state`
on the performance pull first. If that window had no delivery, a "no conversions" finding is not
proof the tag is broken — say the window had no delivery.

Advertisers don't all use a website tag. A GA4 import, an offline or API upload, calls, or a
platform lead form is judged by that source: last conversion, upload health, whether the action is
primary. A tag chip that says Urgent, or a Data manager with no source listed, only matters for
actions that use the tag. Two primaries for the same event (tag and GA4 both counting one purchase)
double-count. On Google, compare Conversions with All conv. — a wide gap means bidding is ignoring
most of the activity. Primary versus secondary is set in the ads UI, not via Adspirer.

If the audit ignores `customer_id` ("You have N google_ads accounts connected. Please specify..."),
retry once, then the error catalog in `adspirer-mcp`. The UI read, when you need the method the API
can't show, is `adspirer-ads-manager-browser`.

If tracking for the primary goal really is broken, say that before you present a CPA. "How are my
ads doing" is then "I can't tell you yet, and here's why."

Also check the window. Amazon's last 48 hours are incomplete. Today is always partial. A "drop" that
is really an unfinished day is the most common false alarm in this job. If a platform returns
`no_data`, look at the freshness window, look back only as far as that window (not past a year),
and report the range that has data. Label it. Don't write 0.

## The scorecard

Default period when they say "this week": the last full Monday–Sunday week against the week before.
"This month": the closed month against the month before. Compare like with like, not against a
partial week.

Report per platform and account. Follow the evidence rules in `adspirer-agent`.

- **Spend** — and pace against the monthly budget, in that account's currency
- **Conversions** and **cost per conversion**, using that platform's own conversion name and
  attribution window
- **ROAS**, where revenue is tracked
- **CTR** and **CPC** — diagnostic, not goals. CPM when the goal is awareness
- **Change vs the previous equivalent period**

Derived CTR, CPC, CPA, and ROAS come from totals and are labeled derived. If a breakdown (keyword,
ad group, ad set, ad) doesn't add up to the account total, mark it unverified and don't recommend
from it alone.

Google per-campaign clicks and impressions come from `analyze_wasted_spend` when
`get_campaign_performance` doesn't include them. Say where that tool's target ROAS came from
(account goal, a 90-day average, or its default). If no source has clicks, write "not available".
Don't back into them.

**Microsoft Advertising** has no performance tool unless `microsoft_ads` `list_tools` has grown
one. Show campaigns, status, and budgets (`adspirer-microsoft-ads`) and put metrics under what you
could not read.

**GA4 and Search Console**, when those routers are connected, are context only
(`adspirer-google-analytics`, `adspirer-search-console`). Never add their events or organic clicks
to ad conversions.

An inactive account that refuses a read goes under what you could not read. Ask before activating
it.

Totals only within one currency. Never sum conversions across platforms as if they were
deduplicated. A missing input is "not available", never 0. On a quota or tool error, say which
call failed. `get_usage_status` before and after a wide pull — don't assume every lookup is free.

End with a "could not read" list: every platform, account, metric, or range that was unavailable,
and why.

Lead with the biggest mover. Two to four next steps, as questions. Several proposed edits go to
the review table in `adspirer-optimize`. Anything that increases spend goes to `adspirer-launch`.
Offer `adspirer-dashboard` when a chart will help. Email or Slack is `adspirer-digest`, after a
yes. A scheduled run that finds no new data since the last report gets one line, not a full
scorecard.

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

A scorecard across platforms is a table the user will squint at, and a trend is a shape, not a
column of numbers. For an actual chart, load `adspirer-dashboard`.

<!-- BEGIN:CLAUDE -->
Offer an **artifact**: platform cards, a spend-vs-conversions chart, the anomalies called out. It's a
private page that updates in place, so a weekly review can republish to the same URL instead of
scrolling back through the transcript. Keep charts as SVG or CSS rather than embedded images.
<!-- END:CLAUDE -->

<!-- BEGIN:CHATGPT -->
Offer a **Site** when the user will revisit it or send it to a client — a hosted dashboard rather
than a message. Ask first, and default to invitation-only: this page carries their spend and
conversion data. For a one-off look, a chart in the conversation is enough.
<!-- END:CHATGPT -->

## Make it recurring

A review is worth more every week than once. When the user likes what they just read, offer to
schedule it — this host can, and they can create it just by asking.

<!-- BEGIN:CHATGPT -->
A recurring task re-runs this review and notifies them by push and email. A **monitoring task** is
better when they'd rather hear only about changes: it re-checks and stays quiet until something
moves.
<!-- END:CHATGPT -->

<!-- BEGIN:CLAUDE -->
In Cowork, that's a **scheduled task** via `/schedule` — it runs remotely, so a sleeping laptop
doesn't matter. In Claude Code, it's a **routine**; prefer a *remote* one, because a local Desktop
task is skipped whenever the machine is asleep at the scheduled hour — exactly when a Monday-morning
review would fire.
<!-- END:CLAUDE -->

<!-- BEGIN:CODEX -->
Codex calls it a **scheduled task**. Each run's findings land in the **Scheduled** inbox with an
unread marker, and a run with nothing worth reporting archives itself — which suits a weekly review
that's often uneventful.
<!-- END:CODEX -->

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
