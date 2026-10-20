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


---

## Ads manager sign-in (this computer)

The browser on this computer is not the user's own browser. Connecting Adspirer at
`https://adspirer.ai/connections` does not sign this browser into Google Ads, Meta, Microsoft
Advertising, LinkedIn, TikTok, or Amazon. The read-only checks in `adspirer-ads-manager-browser`
need the user to sign in once per platform, here, themselves.

You never type, ask for, or store a password, a 2FA code, or a recovery code. Don't put a typed
login form in front of them. These logins almost always need a phone prompt, a passkey, or an
account picker, so hand over the screen instead of trying to click through it.

1. One platform at a time. In one or two sentences, name the account (`get_connections_status`:
   name and id), tell them to have their phone ready, and tell them to pick that exact ad account
   if a picker appears.
2. Hand them the screen already open on that platform's login page, and wait. Don't run a separate
   "am I already signed in?" pass first. If they are already signed in, they confirm the account
   and hand the screen back. When this host has `request_box_help`, call it with the login page
   as the url and reason auth, on that ads domain. If sign-in redirects, name the login host too
   (for example `accounts.google.com`). If that tool isn't available, stop and ask them to sign
   in on a browser they control.
3. Don't click through login, consent, or 2FA yourself. You don't receive the credential.
4. When they hand it back, read the account name and id from the screen (header or address bar).
   A screenshot of that screen is enough. Don't dispatch a second browser task unless the id
   isn't visible.
   Compare it with the connected account. If it isn't visible, open the account switcher and only
   look. If it's the wrong account, ask them to switch, or switch only to an account they named.
   Never accept an invite, create an account, or change billing, users, or permissions.
5. Tell them which platforms are ready. You may note platform, account, and date in the
   conversation or in a notes file they already asked you to keep. No credentials and no cookies.

| Platform | Page to open for them |
|---|---|
| Google Ads | `https://ads.google.com/aw/overview` |
| Meta Ads Manager / Events Manager | `https://business.facebook.com` |
| Microsoft Advertising | `https://ads.microsoft.com` |
| LinkedIn Campaign Manager | `https://www.linkedin.com/campaignmanager` |
| TikTok Ads Manager | `https://ads.tiktok.com` |
| Amazon Ads | `https://advertising.amazon.com` |

For ChatGPT Ads, open the ads manager URL the user or Adspirer gives you. Never guess one.

If a later check lands on a login page, the session expired. Stop, name the platform, and repeat
the handoff. If a platform blocks this browser, or needs a hardware key they can't use here, say
so and mark those checks not available.
