# Ads MCP

Remote Model Context Protocol (MCP) server for cross-platform ad management. Create, analyze, and optimize campaigns across **Google Ads, Meta Ads, TikTok Ads, and LinkedIn Ads** from any MCP-compatible AI assistant.

## Quick Links

- **MCP Remote URL:** `https://mcp.adspirer.com/mcp`
- **Transport:** Streamable HTTP
- **Registry ID:** [`com.adspirer/ads`](https://registry.modelcontextprotocol.io)
- **Authentication:** OAuth 2.1 with PKCE (dynamic client registration supported)
- **Website:** https://www.adspirer.com
- **Support:** abhi@adspirer.com

## What It Does

- **100+ tools** across 4 ad platforms for campaign creation, performance analysis, and optimization
- Plan and validate campaigns using structured prompts
- Research keywords with real CPC data and competitive analysis
- Create Google Ads Search and Performance Max campaigns end-to-end
- Launch Meta, TikTok, and LinkedIn ad campaigns
- Analyze performance with actionable optimization recommendations
- Manage multiple ad accounts across platforms

## Platforms & Tools

| Platform | Tools | Capabilities |
|----------|-------|-------------|
| Google Ads | 39 | Search campaigns, Performance Max, keyword research, performance analysis, asset management, ad extensions |
| LinkedIn Ads | 28 | Sponsored content, lead gen forms, audience targeting, campaign analytics |
| Meta Ads | 20 | Image campaigns, carousel campaigns, audience targeting, performance tracking |
| TikTok Ads | 4 | In-feed video/image campaigns, asset validation |
| **Total** | **100+** | Plus 2 resources and 6 prompts |

## How to Connect

See [CONNECTING.md](CONNECTING.md) for detailed setup instructions for each platform.

### Claude (Recommended)

1. Open **Settings > Connectors > Add custom connector**
2. Name: **Ads MCP**
3. URL: `https://mcp.adspirer.com/mcp`
4. Complete OAuth 2.1 sign-in
5. Link your ad accounts on first use

### Claude Code

Install the full Adspirer plugin (agent + skills + commands + MCP server):

1. Open Claude Code
2. Run `/plugin marketplace add amekala/ads-mcp`
3. Run `/plugin install adspirer`
4. Run `/mcp` — find **plugin:adspirer:adspirer** and click to authenticate
5. Run `/adspirer:setup` to pull your campaign data and create your brand workspace

This gives you a brand-aware performance marketing agent with persistent memory, competitive research via web search, campaign creation with ad extensions, and slash commands for common workflows.
Enabling subagent usage does not change this installation flow.

**MCP-only (no plugin):** If you just want the raw MCP tools without the agent:

```bash
claude mcp add --transport http adspirer https://mcp.adspirer.com/mcp
```

### ChatGPT

1. Open **Settings > Connectors > Add custom connector**
2. Name: **Ads MCP**
3. URL: `https://mcp.adspirer.com/mcp`
4. Follow OAuth 2.1 sign-in flow

### Cursor

Add to `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "adspirer": {
      "url": "https://mcp.adspirer.com/mcp"
    }
  }
}
```

### OpenAI Codex

Add to `~/.codex/config.toml`:

```toml
[mcp_servers.adspirer]
url = "https://mcp.adspirer.com/mcp"
```

### OpenClaw

```bash
openclaw plugins install openclaw-adspirer
openclaw adspirer login
openclaw adspirer connect
```

Or install from [ClawHub](https://clawhub.ai/amekala/adspirer-ads-agent).

## Example Prompts

**Keyword Research:**
```
Research keywords for my emergency plumbing business in Chicago.
Show me high-intent keywords with real CPC data and budget recommendations.
```

**Performance Analysis:**
```
Show me campaign performance for the last 30 days across all platforms.
Which campaigns are converting best and what should I optimize?
```

**Campaign Creation:**
```
Create a Google Performance Max campaign for luxury watches targeting
New York with a $50/day budget.
```

**Multi-Platform Strategy:**
```
I want to advertise my handmade jewelry business across Google and LinkedIn.
Research keywords for Google Ads and create a LinkedIn sponsored content campaign
targeting small business owners.
```

## Technical Details

- **Protocol:** MCP 2025-03-26 (with fallback to 2024-11-05)
- **Transport:** Streamable HTTP
- **OAuth:** RFC 8252 (Authorization Code + PKCE) with RFC 7591 (Dynamic Client Registration) and RFC 9728 (Protected Resource Metadata)
- **Tool Annotations:** All tools include MCP safety metadata (`readOnlyHint`, `destructiveHint`)

## Security

- HTTPS/TLS for all data transmission
- OAuth 2.1 with PKCE for authentication
- Dynamic client registration for CLI tools (Claude Code, Cursor, Codex)
- Encrypted token storage
- No conversation logging -- only tool requests are processed

See [SECURITY.md](SECURITY.md) for vulnerability reporting.

## Documentation

- [Connecting Guide](CONNECTING.md)
- [Privacy Policy](PRIVACY.md)
- [Terms of Service](TERMS.md)
- [Security](SECURITY.md)
- [Support](SUPPORT.md)

## Support

- **Email:** abhi@adspirer.com
- **Issues:** https://github.com/amekala/ads-mcp/issues
- **Website:** https://www.adspirer.com
- **Server Status:** https://mcp.adspirer.com/health

## Supported Plugins

This repo distributes plugins for 4 AI platforms from a single monorepo:

| Platform | Directory | Skills | Install Method |
|----------|-----------|--------|----------------|
| **Claude Code** | Repo root | 1 generated + 5 slash commands | `/plugin marketplace add` |
| **Cursor** | `plugins/cursor/adspirer/` | 5 generated from templates | `install.sh` (one-command) |
| **Codex** | `plugins/codex/adspirer/` | 5 generated from templates | `install.sh` (one-command) |
| **OpenClaw** | `plugins/openclaw/` | 1 standalone (self-contained) | `openclaw plugins install` |

Skills for Claude Code, Cursor, and Codex are authored once in `shared/skills/` as templates, then compiled into IDE-specific versions by `scripts/sync-skills.sh`.
The performance marketing agent prompt is also authored once in `shared/agents/performance-marketing-agent/PROMPT.md` and compiled into Claude Code, Cursor, and Codex agent files by the same sync script.
OpenClaw uses its own standalone skill. See [Architecture](monorepo-restructure-plan.md) for the full design.

## Developer Guide

If you're contributing to this repo or adding new ad platforms/IDE support:

- [Architecture](monorepo-restructure-plan.md) — Shared skills model, template system, what's done and what's remaining
- [Template Syntax & Sync Workflow](docs/architecture.md) — Variable substitution, conditional blocks, validation checks
- [Adding Ad Platforms](docs/adding-platforms.md) — How to add a new ad platform (e.g., Snapchat, Pinterest, YouTube)
- [Adding IDEs](docs/adding-ides.md) — How to add support for a new IDE (e.g., Windsurf, Cline)

### Quick reference

```bash
./scripts/sync-skills.sh          # Generate IDE-specific skills from templates
./scripts/sync-skills.sh --check  # Verify generated files match committed (CI mode)
./scripts/validate.sh             # Run all 39 offline validation checks
./scripts/validate.sh --live      # Also test MCP endpoint connectivity
```

Never edit files in `plugins/*/skills/`, `skills/`, `agents/`, or `plugins/*/agents/` directly — they will be overwritten by the sync script. Edit templates in `shared/skills/` and shared prompts in `shared/agents/` instead.

## License

Proprietary -- See [Terms of Service](TERMS.md) for usage terms.
