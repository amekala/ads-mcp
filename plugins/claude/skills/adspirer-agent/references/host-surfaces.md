# Host surfaces: artifacts, sites, and scheduled tasks

Your host may offer ways to show work and repeat work that the terminal or the chat transcript
can't. Use them when they genuinely fit. Don't announce a capability the host doesn't have.

## Anything recurring: use the host's scheduler when it has one

**If the host can schedule work, schedule it there.** The user gets one place to see, pause, and edit
everything they've automated, and the result lands where they already are — in the conversation, with
a notification. Offer to set it up rather than describing the UI; on both hosts the user can create a
task just by asking.

Use it for anything on a cadence: a Monday performance review, a mid-month pacing check, a watch on a
competitor's landing page, a nudge before a budget resets.

### What each host calls it

| Host | Feature | Runs when the machine is off? |
|---|---|---|
| ChatGPT | **Scheduled tasks** | Yes |
| Codex | **Scheduled tasks** (automations) | Yes |
| Claude Cowork | **Scheduled tasks**, via the `/schedule` skill | Yes — they run remotely |
| Claude Code | **Routines** — *local* task or *remote* routine | Local: **no**. Remote: yes |

**The one that bites: a Claude Code *local* Desktop task only fires while the app is open and the
computer is awake.** A machine that sleeps through 9am skips the run; on wake, Desktop starts exactly
one catch-up for the most recently missed time and discards anything older. For spend, pacing, or
disapprovals, create a **remote routine** instead — Anthropic's infrastructure, machine off, minimum
interval one hour.

Cowork's scheduled tasks do *not* have this problem. They run remotely on their cadence even with the
computer asleep or the app closed, and they can use connected tools, skills, and installed plugins —
including this one. Available on Pro, Max, Team, and Enterprise.

Write the prompt so a late run behaves. A task meant for 9am might fire at 11pm: "only look at
today's spend; if it's past 6pm, just summarize what changed."

Adspirer also has its own server-side monitors and email briefs, under the
`monitoring_and_reporting` router — threshold alerts on ROAS, CPA, spend and CTR, scheduled reports,
and async research jobs. Reach for those when the host has **no** scheduler at all (a plain CLI), when
the user wants the report to arrive as **email** rather than in a chat, or when they want an alert to
keep firing after they stop using this assistant. Otherwise prefer the host.

Discovery on that router is free — `{"action": "list_tools"}` — as are `list_monitors`,
`list_scheduled_tasks`, `get_monitor_history`, and `test_monitor`.

---

## Claude — artifacts

An artifact is a live page published from the session to a private URL on claude.ai. It updates in
place as the session continues.

Good for advertising work when the output is easier to *look at* than to read:

- a cross-platform performance scorecard with charts
- several ad-copy or creative variants laid out side by side for comparison
- a campaign plan to review before anything spends money
- an optimization checklist that fills in as you apply changes

**Constraints.** One self-contained page. No backend, no external requests — the CSP blocks scripts,
fonts, images, `fetch`, XHR, and WebSockets from other hosts, so everything is inlined and images are
data URIs. No forms that store data, no API calls at view time, no multiple routes. `.html`, `.htm`,
or `.md`, rendered under 16 MiB.

**Availability.** Pro, Max, Team, or Enterprise, signed in to claude.ai, on the Anthropic API,
running in the Claude Code CLI or the Claude desktop app. Not on Bedrock, Vertex, or Foundry, and off
by default in Agent SDK and MCP-server contexts. If Claude can't publish, it says so — fall back to a
markdown table in the transcript. Don't promise an artifact before you know it worked.

**Privacy.** Private to the author by default. On Team and Enterprise, shareable within the
organization only; there is no way to share one outside it. That makes artifacts a safe default for
client ad data.

A styled page costs more output tokens than the same content as text. Prefer SVG or HTML and CSS over
embedded raster images, skip interactivity you don't need, and summarize large datasets rather than
inlining every row.

## Claude Code — routines

Claude Code Desktop's **Routines** page holds two kinds:

- **Local scheduled tasks** run on the user's machine. They only fire while the desktop app is open
  and the computer is awake; a machine that sleeps through 9am simply skips the run, and on wake
  Desktop starts exactly one catch-up for the most recently missed time. Minimum interval one minute.
- **Remote routines** run on Anthropic's infrastructure even when the machine is off. Minimum
  interval one hour.

The user can create either by asking in a Desktop session — "set up a weekly performance review every
Monday at 9am" — so offer to set it up rather than describing the UI.

**A local task can silently skip a day.** For anything that matters — budget pacing, spend spikes,
disapproved ads — create a **remote routine** so it runs with the machine off.

`/loop` is a third option, but it lives only inside the current session and dies with it. Fine for
polling something for the next ten minutes; useless for a Monday report.

## Claude Cowork — scheduled tasks

Created with the `/schedule` skill from any chat, or from **Scheduled** in the sidebar. Cadences:
hourly, daily, weekly, weekdays, or on demand.

They **run remotely**, on their cadence, even when the computer is asleep or the Claude Desktop app is
closed — so unlike a Claude Code local task, there's no reliability caveat. They have the same
capabilities as a normal Cowork task, including connected tools, skills, and installed plugins.

Available on Pro, Max, Team, and Enterprise.

## Codex — scheduled tasks (automations)

The user creates one by asking inside a Codex task — describing the work, the cadence, and whether
each run continues the existing task or starts fresh — or from the **Scheduled** view.

That view is also the **inbox**: each run's findings land there with an unread indicator, and a run
with nothing to report can archive itself. Cadence can be a minute-based interval for a tight
follow-up loop, a daily or weekly time, or a custom RRULE.

Runs are unattended and inherit the sandbox settings already in force, so they execute without
approval prompts where policy allows. Be conservative about what you schedule: an unattended run that
writes to an ad account spends real money without anyone watching.

**Codex hooks are not a scheduler.** They are event handlers — `SessionStart`, `PreToolUse`,
`PostToolUse`, `Stop` — configured by the user for their own environment. Never offer a hook as a way
to run a recurring report.

## ChatGPT — sites

Sites lets ChatGPT create, host, and share websites and web apps at a production URL. Unlike an
artifact, a Site is persistent and can have real storage — a relational database, object storage,
authentication, environment variables.

Good for advertising work when the user wants something durable and shareable:

- a client-facing performance dashboard an agency updates each week
- a reporting portal for several brands

**Every Sites deployment URL is a production deployment.** Save a version and review it before
deploying.

**Privacy — the important one.** A Site can be invitation-only, workspace-wide, or **public to anyone
with the link**. Ad performance data, spend, customer lists, and lead-form submissions are
confidential. **Default to invitation-only.** Never publish a Site publicly with a client's account
data unless the user explicitly says to, and say plainly what would become visible before you do.

If the user wants a one-off visual and not a hosted product, that's a smaller ask than a Site — a
table or a chart in the conversation is usually right.

## ChatGPT — scheduled tasks

The user can create a task by asking in chat, or from the Scheduled page in the sidebar. Tasks run
whether or not the user is online, and notify by push and email when they finish.

Three kinds: one-off, recurring, and **monitoring tasks**, which check for changes and notify only
when there's something meaningful to report. A monitoring task is the natural fit for "tell me if my
CPA moves" — it re-checks the account and stays quiet until something is worth saying.

**Active-task limits are per plan** — roughly 3 on Go, 5 on Plus, 10 on Business and Edu, 15 on Pro
and Enterprise. At the limit, a new task can't be created until one is paused, deleted, or completes.
If creation fails, that's usually why; say so rather than retrying.

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
