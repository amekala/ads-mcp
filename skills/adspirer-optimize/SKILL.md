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

## Then verify

After every change, read the object back and confirm it took. Report what actually happened, not
what you asked for. Tell the user what to expect: a learning period, a dip, a delay before the data
means anything.

## Don't promise to keep watching — schedule it

Pacing drifts, CPAs creep, and a campaign that was fine on Monday is over budget by Friday. Saying
"I'll keep an eye on it" is a promise you cannot keep; the conversation ends when the user closes it.

Offer to schedule the check on this host. They can create one just by asking, and it lands with a
notification wherever they already are.


In Cowork, a **scheduled task** (`/schedule`) — it runs remotely. In Claude Code, a **remote
routine**, not a local Desktop task: a local one is skipped whenever the machine is asleep, and the
overspend you're watching for does not wait for the laptop to open.


Each run costs tool calls against their quota. Mid-month and month-end beats daily for pacing; daily
is for accounts where a day of overspend is real money.

If the host has no scheduler, or the user wants the alert to keep firing after they stop using this
assistant, Adspirer's `monitoring_and_reporting` router runs server-side threshold monitors on ROAS,
CPA, and spend. `test_monitor` proves one fires before they trust it, and it's free.

For the reallocation itself, an **artifact** makes the trade legible: current split beside proposed
split, CPA per campaign, and the projected change. Easier to approve, and easier to refuse.
