---
name: adspirer-launch
description: Plan and launch a new ad campaign with Adspirer — start, create, set up, or launch campaigns on one or several platforms, choose which channel fits the goal, and split a budget across channels. Campaigns are created paused and never spend without explicit approval.
---

# Launching a campaign

Follow `adspirer-mcp` before any tool call. Load the target platform's skill for its field rules —
this skill deliberately stays platform-agnostic.

## Before you build anything

Establish four things. If you skip these you will build the wrong campaign competently.

1. **The objective, in business terms.** Leads, sales, calls, installs, awareness. "More traffic"
   is rarely what anyone actually wants.
2. **What a conversion is worth.** A target CPA or ROAS is meaningless without it. If they don't
   know, ask what a customer is worth and work backwards.
3. **The budget, and whether it's real.** Daily and monthly. Say the monthly number out loud —
   `$50/day` is about `$1,520/month`, and people routinely don't do that multiplication.
4. **Whether conversion tracking works.** Run `audit_conversion_tracking`. Launching a
   conversion-optimized campaign on broken tracking wastes the entire budget, silently. This is
   worth the one call.

Then check what exists: `get_connections_status` for the accounts, and the platform's list tools for
campaigns already running. Do not build a duplicate of something already there.

## Choosing the platform

Let the goal choose, not the fashion.

| Situation | Platform |
|---|---|
| People already search for this | Google Search |
| Visual product, impulse or discovery | Meta, TikTok |
| B2B, targeting by job title or company | LinkedIn |
| Selling a product on Amazon | Amazon |
| Broad goal, good tracking, wants automation | Google Performance Max |
| Winning back site visitors | Meta or Google Display retargeting |

When the budget is small, **one platform done properly beats three done thinly.** Splitting $30/day
across Google, Meta, and TikTok gives all three too little data to learn from. Say this rather than
quietly obliging.

If the user insists on several channels, weight toward the one where intent is highest and treat
the rest as a test with a stated review date.

## Building

Load the platform skill and follow its order. Universally:

- Resolve locations, audiences, and pixel ids with the platform's lookup tools. Never guess an id.
- Send the budget in the platform's unit. **Meta is cents.** Check `adspirer-mcp`.
- The campaign is created **paused**, on every platform.

## After you build — verify, then hand over

Read the campaign back. Confirm name, status, budget, targeting, and creative are what you intended,
and report what you actually found rather than what you asked for. If something landed wrong, fix it
before telling the user it's ready.

Then say, plainly:

- what was created, and that it is **paused**
- the daily budget and the implied monthly spend
- what remains before it should go live (extensions on Google Search, a second creative, tracking)
- ask whether to resume it

**Never resume a campaign you just created without being asked.** Creating and launching are two
decisions and the second one is the user's.

## Let them see it before it spends

A campaign is a lot of decisions — budget, targeting, bids, creative, extensions — and reading them
back as prose is how mistakes get approved.

Before you create anything, publish the plan as an **artifact**: structure, daily and monthly spend,
targeting, the creative, and what's still missing. It's much easier to catch "that's the wrong
landing page" on a page than in a paragraph. Republish it after the build with what actually landed.


Once it's live, don't leave it unattended. Offer to schedule a check on this host — a new campaign's
first week is when it either finds its footing or quietly burns budget, and the user should hear about
the second before the invoice does. Set it on the metric that defines success: CPA ceiling, ROAS
floor, daily spend.

A Cowork **scheduled task** runs remotely; in Claude Code make it a **remote routine** rather than a
local Desktop task, so a sleeping laptop doesn't skip the day the campaign went wrong.

Each run costs tool calls, so match the cadence to the spend.

## When the build fails halfway

Say exactly what exists and what doesn't. A campaign with an ad group and no ad is not "created" —
it's a half-built thing that will confuse them later. Either finish it or remove it, and tell them
which you did.
