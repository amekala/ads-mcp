# Adspirer for Hermes Agent

Create, analyze, and optimize paid-media campaigns from Hermes Agent. This portable Agent Plugins
v1 package connects Hermes to Adspirer's hosted MCP service and includes workflow skills for Google
Ads, Meta Ads, TikTok Ads, LinkedIn Ads, Amazon Ads, ChatGPT Ads, and Microsoft Advertising.

## Install

After the plugin is accepted into the Hermes catalog:

```bash
hermes plugins install adspirer --no-enable
hermes plugins enable adspirer
```

Until then, install directly from the official Adspirer repository:

```bash
hermes plugins install Adspirer/adspirer-hermes-plugin --no-enable
hermes plugins enable adspirer
```

Start a new Hermes session or run `/reload-mcp`. The first connection opens a browser for Adspirer
sign-in; complete the authorization and return to Hermes. Connect or reconnect advertising accounts at
[adspirer.ai/connections](https://adspirer.ai/connections).

The plugin requires Node.js 20.18.1 or newer with `npx` available on `PATH`. Hermes launches the
exactly pinned `mcp-remote@0.1.49` package as a local stdio-to-HTTP OAuth bridge; no global npm
installation is required.

## Try it

Open a brand or project directory and ask Hermes:

- "Set up this folder as my Adspirer brand workspace."
- "Review the last 30 days across every connected ad platform."
- "Find wasted spend and show me the changes you recommend."
- "Create a Google Search campaign for this landing page with a $50 daily budget."
- "Write three Meta ad variants in the brand voice from BRAND.md."

For first-time setup, load the bundled `adspirer-setup` skill. Hermes exposes portable skills under
a namespaced installed-plugin identifier; use `skills_list` to find the full qualified name.

## Safety contract

Adspirer manages advertising accounts that can spend real money. The bundled skills require the
agent to:

- inspect the live account before proposing a write;
- show the exact budget and request explicit approval before spending or moving money;
- create new campaigns paused;
- verify every create or update by reading it back; and
- prefer reversible actions and confirm destructive operations.

Authentication and advertising-platform authorization remain scoped to the user's Adspirer
account. This repository contains no access tokens, API keys, ad-platform credentials, or customer
data.

## Included components

- One stdio MCP entry backed by the hosted Streamable HTTP server at `https://mcp.adspirer.com/mcp`
- Twenty-four advertising and campaign-management skills
- OAuth 2.1 authorization with PKCE and dynamic client registration
- An exact `mcp-remote@0.1.49` runtime pin; no bootstrap script, hook, native tool, or self-updater

The package follows the published
[Agent Plugins v1 specification](https://agent-plugins.org/specification). Hermes discovers the
root `plugin.json`, `mcp.json`, and immediate child directories under `skills/`.

## Included skills

| Skill | Purpose |
| --- | --- |
| `adspirer-agent` | Safety contract and routing for paid-media work |
| `adspirer-setup` | Connect Adspirer and build `BRAND.md` and `STRATEGY.md` |
| `adspirer-mcp` | MCP tool discovery, router calls, account IDs, quotas, and budget units |
| `adspirer-launch` | Plan and create paused campaigns |
| `adspirer-performance-review` | Cross-platform performance reporting and diagnosis |
| `adspirer-optimize` | Wasted-spend analysis and approval-gated optimization |
| `adspirer-creative` | Platform-aware ad-copy and creative workflows |
| `adspirer-google-ads` | Google Ads campaign guidance |
| `adspirer-meta-ads` | Meta Ads campaign guidance |
| `adspirer-tiktok-ads` | TikTok Ads campaign guidance |
| `adspirer-linkedin-ads` | LinkedIn Ads campaign guidance |
| `adspirer-amazon-ads` | Amazon Ads campaign guidance |
| `adspirer-chatgpt-ads` | ChatGPT Ads campaign guidance |
| `adspirer-docs` | Adspirer product, plan, connection, and troubleshooting documentation |
| `adspirer-microsoft-ads` | Microsoft Advertising campaign guidance |
| `adspirer-keywords` | Keyword research, match types, search terms, and negatives |
| `adspirer-competitors` | Competitors' public ads: offers, formats, and landing pages |
| `adspirer-google-analytics` | Google Analytics 4 data for paid-media decisions |
| `adspirer-search-console` | Google Search Console data for paid search |
| `adspirer-tag-manager` | Google Tag Manager inspection for conversion-tracking checks |
| `adspirer-dashboard` | A visual cross-platform dashboard |
| `adspirer-digest` | Email or Slack digests, sent only after the user approves |
| `adspirer-ads-manager-sign-in` | The user signs in to an ads manager in the agent's browser themselves |
| `adspirer-ads-manager-browser` | Read-only checks in an ad platform's own web UI |

## Authentication

The plugin intentionally stores no credentials in `mcp.json`. On first connection, the pinned
`mcp-remote` bridge discovers Adspirer's OAuth metadata, opens the browser login, completes the PKCE
exchange, and stores the resulting tokens locally in `~/.mcp-auth/mcp-remote-0.1.49/`. To
reauthorize, remove only the Adspirer entry from that versioned token directory and run
`/reload-mcp`, or use the Hermes connector UI when available.

Why a bridge? Agent Plugins v1 does not have a portable field for declaring OAuth on a remote MCP
entry. Hermes supports OAuth for native MCP configuration, but its portable plugin translator cannot
currently carry that setting. The pinned bridge preserves one-command plugin installation while
using Adspirer's hosted server and standards-based OAuth flow.

## Scheduled reviews

Hermes can run recurring advertising reviews through its `cronjob` tool. Attach the relevant
Adspirer skill and use a project work directory so scheduled runs can read `BRAND.md` and
`STRATEGY.md`. A scheduled run consumes Adspirer tool calls like an interactive session; weekly is
the recommended default for performance reviews.

## Development

This repository is generated. The source is `plugins/hermes` in
[amekala/ads-mcp](https://github.com/amekala/ads-mcp), where the skills are built from the same
shared templates as every other Adspirer host, and a scheduled workflow here copies it over. Send
changes to ads-mcp; edits made directly here are overwritten by the next sync.


Validate the package with the same admission command used by the Hermes catalog:

```bash
hermes plugins validate .
```

Before releasing, test installation from a clean Hermes profile, complete the browser login triggered
by the first MCP connection, confirm all twenty-four skills load, and run at least one read-only MCP call.

## Support and security

- Website: [adspirer.com](https://www.adspirer.com)
- Documentation: [adspirer.com/docs](https://www.adspirer.com/docs)
- Issues: [GitHub Issues](https://github.com/Adspirer/adspirer-hermes-plugin/issues)
- Security reports: [SECURITY.md](SECURITY.md)

Licensed under the [MIT License](LICENSE).
