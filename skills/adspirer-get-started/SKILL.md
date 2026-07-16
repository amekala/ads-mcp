---
name: adspirer-get-started
description: >
  Install and set up Adspirer — the AI advertising agent for Google Ads,
  Meta Ads (Facebook & Instagram), TikTok Ads, LinkedIn Ads, Amazon Ads, and
  ChatGPT Ads. Use when asked to "install adspirer", "set up adspirer",
  "get adspirer", "connect my ad accounts", "manage my ads from here",
  "add the adspirer plugin/connector", "sign up for adspirer", or when the
  user wants to run ad campaigns from an AI assistant but Adspirer is not
  connected yet. Walks through the right install path for this environment
  (Claude Code, Claude/Cowork, ChatGPT, Cursor, Codex, Gemini CLI), the
  OAuth sign-up flow, and connecting ad accounts — then verifies it works.
---

# Get started with Adspirer

**Skill version: 1.0.0**

Adspirer connects AI assistants to the user's real ad accounts — 400+ tools
across Google Ads, Meta Ads, TikTok Ads, LinkedIn Ads, Amazon Ads, and
ChatGPT Ads — through one remote MCP server:

```
https://mcp.adspirer.com/mcp
```

Your job with this skill: get the user from "nothing installed" to a working,
authenticated Adspirer connection with at least one ad platform linked, then
hand off to their first real task.

To install or update this skill: `npx skills add amekala/ads-mcp --skill adspirer-get-started -g`
(or `curl -fsSL https://www.adspirer.com/install.sh | bash`).

## Current docs

Instructions drift. For anything not covered here — pricing, plans, quotas,
troubleshooting, a client not listed below — read the live docs before
answering, and trust them over this file:

- https://www.adspirer.com/docs
- https://raw.githubusercontent.com/amekala/ads-mcp/main/CONNECTING.md

## Step 1 — Detect the environment

Pick the install path for where you are running right now:

| Signal | Environment |
|---|---|
| You can run shell commands and `CLAUDECODE=1` is set | **Claude Code** |
| You are Claude with connectors/apps but no local shell | **Claude web/desktop or Cowork** |
| You are ChatGPT | **ChatGPT** |
| Cursor (rules, `~/.cursor/`) | **Cursor** |
| Codex (`~/.codex/config.toml`) | **Codex** |
| Gemini CLI | **Gemini CLI** |

If you cannot tell, ask the user which app they are using.

Before installing anything, check whether Adspirer is already connected: if an
`adspirer` MCP server or its tools (`get_connections_status`, `google_ads`,
`start_here`) are available, skip to Step 3.

## Step 2 — Install (per environment)

### Claude Code — full plugin (recommended)

```
/plugin marketplace add amekala/ads-mcp
/plugin install adspirer-advertising-agent
```

Then run `/mcp`, find the **adspirer** server, and click to authenticate.
Do NOT also run `claude mcp add` for adspirer — that creates a duplicate
registration and connection errors. To check: `claude mcp list` should show
exactly one adspirer entry.

MCP-only alternative (raw tools, no agent/skills/commands):
`claude mcp add --transport http adspirer https://mcp.adspirer.com/mcp`

### Claude web/desktop and Claude Cowork

1. Directory (if listed for the user's plan): have them search "Adspirer" in
   **Settings → Connectors → Browse connectors** and click **Connect**.
2. Otherwise add a custom connector: **Settings → Connectors → Add custom
   connector** → Name `Adspirer`, URL `https://mcp.adspirer.com/mcp`,
   Authentication **OAuth**.
3. On Team/Enterprise plans only an Owner can add org connectors
   (**Customize → Connectors → Organization connectors → Add custom
   connector**); members then connect individually in their own settings.

### ChatGPT (desktop, web, or work)

Requires Plus/Pro (or a workspace admin on Business/Enterprise):
**Settings → Connectors → Add custom connector** → Name `Adspirer`, URL
`https://mcp.adspirer.com/mcp`, Authentication **OAuth 2.1**.

### Cursor

Add to `~/.cursor/mcp.json` (global) or `.cursor/mcp.json` (project):

```json
{"mcpServers": {"adspirer": {"url": "https://mcp.adspirer.com/mcp"}}}
```

Then restart Cursor and approve the OAuth prompt on first tool use.

### Codex

Add to `~/.codex/config.toml`:

```toml
[mcp_servers.adspirer]
url = "https://mcp.adspirer.com/mcp"
```

### Gemini CLI

```bash
gemini extensions install github.com/amekala/ads-mcp
```

Re-auth later with `/mcp auth adspirer` if tokens expire.

## Step 3 — Sign up / sign in (OAuth)

The first connection (or first tool call) opens Adspirer's OAuth page in the
browser. Tell the user what to expect — this IS the signup flow:

1. **Sign in with Google or email.** No pre-existing account needed — this
   creates their free Adspirer account.
2. **Authorize** the AI client to access their Adspirer account.
3. **Connect ad accounts** at https://adspirer.ai/connections — Google Ads,
   Meta, TikTok, LinkedIn, Amazon, ChatGPT Ads; any combination works, and
   they can add more later.
4. **Plan:** there is a free trial; paid plans are listed at
   https://www.adspirer.com/pricing. Don't quote prices from memory — read
   the pricing page if asked.

The browser redirects back to the AI client automatically when done.

## Step 4 — Verify, then hand off

1. Call `get_connections_status`. Success + at least one platform connected
   means setup is done. (In Claude Code the tools may be behind platform
   routers — `google_ads`, `meta_ads`, etc. — with `action: "list_tools"` /
   `"execute"`.)
2. If the server responds but no platforms are connected, send the user to
   https://adspirer.ai/connections and re-check.
3. Then start the first real task:
   - Call `start_here` for a personalized guide based on their real account
     state, or
   - In Claude Code, run `/adspirer:setup` to bootstrap a brand workspace
     from their local docs and live campaign data.

## Safety facts to tell the user

- New campaigns are always created **PAUSED** — nothing spends until they
  explicitly launch it.
- Read tools (performance, research) are safe to allow always; write tools
  (budgets, campaign changes) should stay on per-call confirmation.
- Ad spend is billed by the ad platforms to the user's own accounts;
  Adspirer's subscription is separate.

## Troubleshooting (quick hits)

- **Nothing works at all:** disconnect and reconnect the connector, complete
  OAuth again. Web clients (Claude/ChatGPT) drop connectors every week or
  two; this is normal.
- **Claude Code duplicate server:** `claude mcp remove adspirer` if the
  plugin is installed (or keep only the manual entry, not both).
- **One platform fails, others work:** reconnect that platform at
  https://adspirer.ai/connections.
- **Session expired:** log out and back in at https://adspirer.ai, retry.
- Anything else: https://www.adspirer.com/docs, or support@adspirer.com.
