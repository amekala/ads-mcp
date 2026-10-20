---
name: adspirer-optimize
description: Find and fix wasted ad spend with Adspirer — cut spend that isn't converting, add negative keywords, exclude audiences and placements, reallocate budget to what works, and check whether campaigns are pacing over or under budget. Proposes changes and asks before spending or moving money.
---

# Cutting waste and pacing budget

Follow `adspirer-mcp` before any tool call. Load the platform skill for field rules. This skill
proposes changes and applies them **only after the user agrees to that specific change**.

## Find the waste

| Platform | Tool (through its router unless noted) |
|---|---|
| Google | `analyze_wasted_spend`, then `analyze_search_terms` |
| Meta | `analyze_meta_wasted_spend` |
| TikTok | `analyze_tiktok_wasted_spend` |
| LinkedIn | `analyze_linkedin_wasted_spend` |
| Amazon | `analyze_amazon_wasted_spend`, then `get_amazon_search_terms` |

Waste has a few shapes and they need different fixes:

- **Spend with zero conversions.** The obvious one. But check the volume first — an ad group with
  $40 spend and no conversions may simply not have had a chance yet at a $60 CPA.
- **Spend converting far above target.** Worse than zero, because it looks like it's working.
- **Search terms you never intended to buy.** On Google and Amazon this is where the money leaks:
  broad match matching "free", "jobs", "diy", a competitor's brand, or a wildly adjacent product.
- **Placements and audiences that never convert.** Display and TikTok especially.

## Before you cut anything

**Check the tracking first.** Run `audit_conversion_tracking`. A campaign that looks like it
converts nothing very often converts fine and reports nothing. Pausing it would destroy a working
campaign — this mistake is common and expensive.

Judge the method, not the tag chip. Zero conversions can be an import that stopped, a secondary
action bidding ignores, or a window with no spend. The audit looks back from today. If
`freshness_state` shows no delivery in that window, say so — it is not proof the tag is dead. A
website-tag warning does not condemn an offline or API import. When the API can't show the source,
or it ignores `customer_id` (retry once, then the error catalog), check the ads manager with
`adspirer-ads-manager-browser` before you pause anything. Microsoft has no audit tool;
`adspirer-microsoft-ads`.

**Check the volume.** Ten clicks and no conversions is not evidence. Roughly, you want at least
3× the target CPA in spend, or ~100 clicks, before you call something a loser.

**Check the assist.** The campaign with no last-click conversions may be the one introducing people
to the brand. Look at view-through and assisted conversions before killing an upper-funnel campaign.

## Fix it, in this order

1. **Negatives before pauses.** Adding negative keywords is precise, reversible, and keeps the
   campaign learning. `add_negative_keywords` (Google), the equivalent on Amazon. Pausing a whole
   ad group to stop one bad search term is a blunt instrument.
2. **Exclude placements and audiences** that spend without converting.
3. **Pause** the ad, ad group, or campaign — the narrowest thing that solves the problem.
4. **Reallocate** what you freed up.

**Never delete when pausing will do.** Removing keywords, deleting creatives, archiving campaigns —
these lose history and some cannot be undone. Say what will be lost and get an explicit yes.

## Reallocating budget

`optimize_budget_allocation` (Google) and its per-platform equivalents recommend a split. They
recommend; they don't apply.

Move money toward proven CPA, not toward the highest volume. Move in steps — a campaign whose budget
doubles overnight re-enters the learning phase and gets worse before it gets better. 20–30% at a
time, then wait a week.

Show the arithmetic: *"Move $30/day from Campaign A ($140 CPA, target $50) to Campaign B ($38 CPA).
Same total spend. If B holds, that's roughly 12 more leads a month."*

## Pacing

Compare spend so far against elapsed days in the period.

- **Underpacing** usually means the budget is capped, bids are too low for the auction, the target
  CPA is set below what the account can achieve, or the audience is too narrow. Check impression
  share before raising the budget — if the campaign isn't budget-limited, more budget changes
  nothing.
- **Overpacing** means the month runs out early. Cut the daily budget or fix what's expensive; don't
  just let it stop mid-month.

Google can overspend the daily budget by up to 2× on any given day, and settles over the month.
A single-day overspend is not a bug — say so before someone panics.

## A spend check, without changing anything

Use this when the user asks whether an account is overspending or broken, or when a scheduled run
is only supposed to watch. It proposes. It never pauses, never edits a budget or bid, and never
activates an account.

Thresholds come from the brand workspace when the user has set them. Otherwise:

- Pacing: month-to-date spend over 110% or under 80% of (monthly budget × elapsed days ÷ days in
  the month).
- A day over 150% of the daily budget, or of the 7-day average.
- CPA over 130% of target, or ROAS under 70% of target, across the last 7 days. Say where the
  target came from: the user, the workspace, or a tool default such as `analyze_wasted_spend`'s
  2.0.
- Conversions at 0 for a day when the 14-day daily average is 3 or more. Treat that as a possible
  tracking break, then check method and freshness before you call it one.
- Frequency over 4 in 7 days, or CTR down about 40% versus the prior 7 days. That's creative
  fatigue — `adspirer-creative`.
- A campaign limited by budget, with disapproved ads, or paused when the user didn't pause it.

**Quiet floor.** Don't fire a rule under about 100 clicks (or 10,000 impressions for awareness),
under 5 conversions for a CPA or ROAS rule, or under 50 in account currency for the window.
Yesterday may still be incomplete. Never fire a CPA rule on yesterday alone.

Pull yesterday, the last 7 days, and month to date, with the dates written out. Google and Meta
use their direct performance tools. Other platforms use the performance tool `list_tools` returns.
Microsoft has no performance report unless that list has grown one — budgets and status only,
metrics "not available". If a read is `no_data` and the freshness window ends in the past, say the
data is stale since that date. Don't turn staleness into a threshold breach.

`explain_performance_anomaly` (and `diagnose_funnel`, which is direct and read-only) can suggest a
cause. Treat what they say as a hypothesis, not a finding, until the account numbers agree.

If nothing crossed a line and the user asked, one line is enough. If you are running unattended,
stay quiet. If something fired: one line per alert with severity, platform, account, campaign,
value versus limit, window, and source. Then the smallest fix. Several fixes go through the review
table below. Anything that increases spend goes through `adspirer-launch`. Email or Slack goes
through `adspirer-digest`, and only after a yes.

## Several changes at once

When you are proposing two or more changes, put them in one review table before anything is
written. One row per atomic change: platform, account name and id, level, resource name and id,
the change, before, after, currency, estimated impact (labeled as an estimate), reason, evidence
(metric, date range, source), and whether it is reversible.

- Names and ids come from a read. Never guess them.
- Budgets and bids are plain decimals in the account currency unless the live schema says
  otherwise.
- If the evidence is older than the user asked for, state the window `freshness_state` actually
  covers.
- Search negatives: read existing negatives first and drop duplicates. A brand term in a non-brand
  campaign is a routing negative, not waste. Load `adspirer-keywords`.
- If `analyze_wasted_spend` supplied the figure, say where its target ROAS came from (account
  goal, a 90-day average, or the tool default).
- Any row that increases spend or enables a campaign is marked for `adspirer-launch`. Don't apply
  it from this table.
- Order: negatives and exclusions, then bids, copy, or creative, then pauses, then removals.
  Removals say what cannot be undone.
- If `list_tools` has no tool for that change, the row is for the user to apply in the platform UI.

The table lives in the conversation. A spreadsheet is optional, and only when they asked for one
or a spreadsheet tool is already connected. Same columns. A filled-in cell, a comment, or someone
else's edit is not approval.

When they say the review is done, restate the approved rows (resource, before → after) and ask
whether to apply those N changes. Apply only after they say yes in this conversation. Then one row
at a time, through that platform's router. If the schema has a confirmation flag, set it only now.
Read each write back and report applied, failed, and skipped. On a timeout, read current state
before any retry. A blank, a no, or a row edited after the yes needs a new yes.

Never take that yes from Slack, email, or a comment on the sheet.


## Then verify

After every change, read the object back and confirm it took. Report what actually happened, not
what you asked for. Tell the user what to expect: a learning period, a dip, a delay before the data
means anything.

## Don't promise to keep watching — schedule it

Pacing drifts, CPAs creep, and a campaign that was fine on Monday is over budget by Friday. Saying
"I'll keep an eye on it" is a promise you cannot keep; the conversation ends when the user closes it.

Offer to schedule the check on this host. They can create one just by asking, and it lands with a
notification wherever they already are.



A Codex **scheduled task** works here, and a run that finds nothing archives itself — so the user only
hears from it when pacing has actually drifted. Keep it read-only: an unattended run that changes
budgets spends real money with nobody watching.

Each run costs tool calls against their quota. Mid-month and month-end beats daily for pacing; daily
is for accounts where a day of overspend is real money.

If the host has no scheduler, or the user wants the alert to keep firing after they stop using this
assistant, Adspirer's `monitoring_and_reporting` router runs server-side threshold monitors on ROAS,
CPA, and spend. `test_monitor` proves one fires before they trust it, and it's free.
