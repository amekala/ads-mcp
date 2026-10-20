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
4. **Whether conversion tracking works.** Run `audit_conversion_tracking` for Google, Meta, and
   LinkedIn. It does not cover Microsoft — say so, and use `adspirer-microsoft-ads` plus the ads
   UI if you need a read. Judge the method, not a tag chip: an offline or API import can be fine
   while the website tag says Urgent, and a lookback window with no delivery is not a broken tag
   (`freshness_state`). With several Google Ads accounts the audit can ignore `customer_id`;
   retry once, then the error catalog. The UI check is `adspirer-ads-manager-browser`. Launching
   a conversion-optimized campaign on tracking you have not actually checked wastes the budget.

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
- Send the budget in the account's own currency as a decimal — never cents, on any platform. For `$20/day` send `20`. Check `adspirer-mcp`.
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

## The only way to turn spend on

Enabling, resuming, or raising a budget, a bid, or a target is this section. Nothing else is.
Being signed in, a scheduled run, a row in a review table, a teammate's message, or a Slack or
email reply is not permission. Building the campaign is the section above. This is the moment it
starts spending, or spends more.

1. **Name the object.** Platform, account name and id, campaign name and id, and the exact change.
   One campaign at a time. If the account is inactive, activating it (`switch_primary_account` or
   the platform's own activate) is its own yes. Never activate it silently to "get the read to work."
2. **Read current state** with that platform's list or structure tool. Confirm status, daily or
   lifetime budget, bid strategy, currency, and timezone. `get_tool_schema` before you execute.
3. **Preflight.** Mark each item pass, fail, or unknown. Don't enable on an unknown that matters.
   - The account and campaign are the ones the user named.
   - Currency is confirmed. The budget is a plain decimal in that currency unless the live schema
     says otherwise.
   - Daily budget × 30.4, or the lifetime budget, fits the monthly budget they gave you or recorded
     in the brand workspace.
   - The bid strategy matches the conversion data you actually have. No target CPA on an account
     with no conversion history (`adspirer-google-ads`).
   - Tracking was checked (item 4 above), including the method.
   - Final URLs are the landing pages they named.
   - Geo, language, audience, placements, and schedule match the plan.
   - Ads or creatives exist and are not disapproved, where the platform exposes that.
   - Platform specifics from that platform's skill: Google extensions and negatives, PMax assets,
     social creative specs and the pixel or event, Amazon product eligibility, Microsoft paused
     create.
   - No billing or payment change is involved. If one comes up, stop and hand it to the user.
   - A checkpoint is agreed: when you'll look again (for example a day, then three days) and what
     stops it.
4. **Restate and ask.** One block: platform, account, campaign, before → after, budget, expected
   monthly spend or cap, currency, checkpoint, and stop condition. Ask them to enable that named
   campaign. Only an explicit yes in this conversation, for that campaign, counts.
5. **One write.** If the live schema has a confirmation flag, set it only now. Don't bundle in
   other edits.
6. **Read it back.** Report the status, budget, and id you actually find, including a partial
   failure. If the result is uncertain or the call times out, read current state before any retry.
   Never retry a spend change blind.

Don't enable as a side effect of creation, and don't raise a budget "so it can learn" without a
yes. A scheduled run never changes spend.

## Let them see it before it spends

A campaign is a lot of decisions — budget, targeting, bids, creative, extensions — and reading them
back as prose is how mistakes get approved.



Once it's live, don't leave it unattended. Offer to schedule a check on this host — a new campaign's
first week is when it either finds its footing or quietly burns budget, and the user should hear about
the second before the invoice does. Set it on the metric that defines success: CPA ceiling, ROAS
floor, daily spend.


Each run costs tool calls, so match the cadence to the spend.

## When the build fails halfway

Say exactly what exists and what doesn't. A campaign with an ad group and no ad is not "created" —
it's a half-built thing that will confuse them later. Either finish it or remove it, and tell them
which you did.
