---
name: adspirer-ads-manager-sign-in
description: Have the user sign in to an ads manager in the agent-controlled browser before a read-only UI check. The user takes control and signs in themselves. The agent never asks for, types, or receives passwords or 2FA codes. If the host has no controllable browser, fall back to Adspirer API tools.
---

# Ads manager sign-in

The browser the agent controls is not the user's own browser. Connecting Adspirer at
`https://adspirer.ai/connections` does not sign that browser into an ads manager. This sign-in is
only for browser checks in `adspirer-ads-manager-browser`. It is separate from the Adspirer API
connection.

The agent never types, asks for, or stores a password, a 2FA code, or a recovery code. Don't put a
typed-login form in front of the user. These logins almost always need a phone prompt, a passkey,
or an account picker, so hand the screen over instead of clicking through it.

## If this host cannot hand over a browser

Say so once, and fall back to Adspirer API tools (`adspirer-mcp`, and `audit_conversion_tracking`
where that tool applies). Don't pretend the ads manager was opened. Don't ask the user to paste a
password or a code into the chat. They can still sign in on their own machine and share a
screenshot of the page you named.

## 1. Pick the platform

From `get_connections_status`, list the platforms that still need a browser check. Skip accounts
the user has marked out of scope. Ask which to sign in to now. One platform at a time.

| Platform | Login page to hand over |
|---|---|
| Google Ads | `https://ads.google.com/aw/overview` |
| Meta Ads Manager / Events Manager | `https://business.facebook.com` |
| Microsoft Advertising | `https://ads.microsoft.com` |
| LinkedIn Campaign Manager | `https://www.linkedin.com/campaignmanager` |
| TikTok Ads Manager | `https://ads.tiktok.com` |
| Amazon Ads | `https://advertising.amazon.com` |

For ChatGPT Ads, open only a URL the user or Adspirer gives you. Never guess one.

## 2. Hand over control

Use your host's take-control / hand-off-the-browser mechanism, and open the login page as part of
that handoff. Don't run a separate "am I already signed in?" pass first. If they are already
signed in, they confirm the account and hand control back.

Before the handoff, tell them in one or two sentences:

- sign in with the login that can access the account (name and id from `get_connections_status`)
- have their phone ready for 2FA
- if a picker appears, choose that exact ad account or business, then hand control back

Never click through login, consent, or 2FA yourself. You do not receive the credential.

When a host has a named tool for this, it is a short example in `adspirer-agent`'s
`references/host-surfaces.md`. The steps above are the same either way.

## 3. Confirm the account

When they hand control back, read the account name and id from a screenshot or from the page
(header or address bar). Compare it with the connected account. Only if it isn't visible, open the
account switcher and only look. If it's the wrong account, ask them to switch, or switch only to
an account they named. Never accept an invite, create an account, or change billing, users, or
permissions.

## 4. Record and continue

Tell them which platforms are ready and which are left. You may note the platform, the account,
and the date in the conversation, or in a notes file they already asked you to keep. No
credentials and no cookies. Then continue with `adspirer-ads-manager-browser`.

## When the session expires

If a later check lands on a login page, stop, name the platform, and repeat the handoff. If a
platform blocks this browser, or needs a hardware key the user can't use here, say so and mark
those checks not available. Use the API for whatever it can still show.
