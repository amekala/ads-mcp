# Host surfaces: what repeats after the session ends

Your host may offer ways to show work and repeat work that the terminal or the chat transcript
can't. Use them when they genuinely fit. Don't announce a capability the host doesn't have.

## Anything recurring: use the host's scheduler when it has one

**If the host can schedule work, schedule it there.** The user gets one place to see, pause, and edit
everything they've automated, and the result lands where they already are — in the conversation, with
a notification. Offer to set it up rather than describing the UI; on both hosts the user can create a
task just by asking.

Use it for anything on a cadence: a Monday performance review, a mid-month pacing check, a watch on a
competitor's landing page, a nudge before a budget resets.

Grok Build has no scheduler of its own and no publish surface — nothing here runs after the session
ends. Everything recurring goes to Adspirer's server side, described below. Don't offer the user a
scheduled task, a routine, or a published page; they don't exist on this host.

Adspirer also has its own server-side monitors and email briefs, under the
`monitoring_and_reporting` router — threshold alerts on ROAS, CPA, spend and CTR, scheduled reports,
and async research jobs. Reach for those when the host has **no** scheduler at all (a plain CLI), when
the user wants the report to arrive as **email** rather than in a chat, or when they want an alert to
keep firing after they stop using this assistant. Otherwise prefer the host.

Discovery on that router is free — `{"action": "list_tools"}` — as are `list_monitors`,
`list_scheduled_tasks`, `get_monitor_history`, and `test_monitor`.


## What a scheduled run costs

A scheduled task re-runs the work, which means it calls Adspirer tools again — every run draws on the
user's monthly tool-call quota exactly like a live conversation. A daily review costs roughly thirty
times what a monthly one does.

Pick a cadence the plan can carry, and say what it will cost in calls before setting it up. Weekly is
the right default for a performance review; daily is for accounts spending enough to justify it.
`get_usage_status` is free and shows what's left.

---

## How to offer, without overselling

1. **Do the work first.** The answer comes before the packaging.
2. **Offer the surface when it earns its place** — comparison, a chart, something the user will
   revisit or send to someone.
3. **Ask before publishing anything that leaves the conversation.** A shared page is outward-facing.
4. **If the host can't do it, say so once and move on.** A markdown table is a fine answer.
