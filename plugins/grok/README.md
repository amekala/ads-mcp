# Adspirer for Grok Build

Manage paid media without leaving Grok. Adspirer connects Grok Build to live ad accounts on
**Google Ads, Meta Ads (Facebook & Instagram), TikTok Ads, LinkedIn Ads, Amazon Ads, and ChatGPT Ads**
— create campaigns, review cross-platform performance, find wasted spend, and write brand-voice ad copy
against real account data.

Adspirer is a hosted MCP server. Nothing runs locally: the plugin ships a server URL and a set of
skills that teach the agent how to call it correctly.

## Installation

In Grok Build, open `/plugin`, search for **adspirer**, and install.

On first connection, Grok opens Adspirer's OAuth flow in the browser. Sign in, then connect the ad
accounts you want to manage at [adspirer.com/connections](https://www.adspirer.com/connections).

Then run `/adspirer:setup` to bootstrap a brand workspace in the current folder.

## Commands

| Command | What it does |
|---|---|
| `/adspirer:setup` | Connect ad accounts, scan the folder for brand docs, pull live campaign data, and write `AGENTS.md` |
| `/adspirer:performance-review` | Cross-platform performance review scored against your KPI targets |
| `/adspirer:wasted-spend` | Find wasted spend across platforms and recommend specific fixes |
| `/adspirer:write-ad-copy` | Generate brand-voice-compliant ad copy informed by real search-term data |
| `/adspirer:refresh-brand-context` | Re-scan brand docs and refresh the workspace with current numbers |

## Skills

| Skill | What it does |
|---|---|
| `adspirer-agent` | Core agent behavior — how to plan, confirm, and report on paid-media work |
| `adspirer-mcp` | The MCP call contract: which tools are direct and which go through a platform router |
| `adspirer-setup` | Bootstraps the brand workspace on first run |
| `adspirer-launch` | Plans and launches a new campaign across one or several platforms |
| `adspirer-optimize` | Finds and fixes wasted spend — negative keywords, audience exclusions, budget shifts |
| `adspirer-performance-review` | Cross-channel reporting and KPI comparison |
| `adspirer-creative` | Writes and refreshes headlines, descriptions, and primary text |
| `adspirer-google-ads` | Search, Performance Max, Demand Gen, YouTube, and Display |
| `adspirer-meta-ads` | Image, video, carousel, and lead-gen campaigns on Facebook and Instagram |
| `adspirer-tiktok-ads` | In-feed video, Spark Ads, carousel, app promotion, and conversions |
| `adspirer-linkedin-ads` | Sponsored content, single image, video, carousel, text, and lead-gen forms |
| `adspirer-amazon-ads` | Sponsored Products, Sponsored Brands, and Sponsored Display |
| `adspirer-chatgpt-ads` | Ads that appear inside ChatGPT responses |
| `adspirer-docs` | Answers questions about Adspirer itself — pricing, quotas, connecting accounts |

## Agent

`performance-marketing-agent` — a subagent scoped to paid media that reads the brand workspace,
pulls live platform data, and manages campaigns with brand awareness.

## Safety

- **New campaigns are always created PAUSED.** Nothing starts spending without an explicit unpause.
- **No campaign is deleted and no budget is modified without approval.** Every write is confirmed
  with the user first.
- Budget guardrails from the brand workspace (`AGENTS.md`) are enforced on every proposed change.

## Network access and credentials

Declared for review — this is everything the plugin talks to:

| Endpoint | Purpose |
|---|---|
| `https://mcp.adspirer.com/mcp` | The only endpoint the plugin calls. Streamable-HTTP MCP server; all campaign reads and writes go through it. |
| `https://www.adspirer.com` | Referenced in prose only (sign-in, connections, docs). Not called by the plugin. |

**Credentials.** OAuth 2.1 with PKCE and dynamic client registration (RFC 7591), handled by Grok's
MCP client. The plugin stores no API keys, reads no local credential files, and sets no environment
variables. Ad-platform tokens are held server-side by Adspirer and scoped to the accounts the user
explicitly connects.

**No local execution.** This plugin ships skills, commands, an agent definition, and one `.mcp.json`.
It contains no hooks, no scripts, no install steps, and no LSP servers — nothing in it executes code
on the user's machine.

## Links

- Website: [adspirer.com](https://www.adspirer.com)
- MCP Registry: [`com.adspirer/ads`](https://registry.modelcontextprotocol.io)
- Source of truth: [github.com/amekala/ads-mcp](https://github.com/amekala/ads-mcp) — this repo is a
  generated distribution of `plugins/grok/`, synced daily. Open issues and PRs upstream; edits made
  directly here are overwritten by the next sync.

## License

MIT — see [LICENSE](LICENSE).
