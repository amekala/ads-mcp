# Adspirer Ads Agent — OpenClaw Skill

Manage ad campaigns across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads from [OpenClaw](https://openclaw.ai).

## Install

```bash
openclaw plugins install openclaw-adspirer
```

## Setup

```bash
openclaw adspirer login       # Authenticate
openclaw adspirer connect     # Connect ad platforms (opens adspirer.com)
openclaw adspirer status      # Verify connection
```

## Registry

This skill is listed on ClawHub: [amekala/adspirer-ads-agent](https://clawhub.ai/amekala/adspirer-ads-agent)

## Architecture

Unlike the Cursor and Codex plugins (which use shared skill templates from `shared/skills/`), the OpenClaw skill is **self-contained**. Its `SKILL.md` has a different structure — it combines agent instructions, setup commands, pricing, troubleshooting, and security documentation in a single file.

The TypeScript plugin code (OAuth, MCP client, tool registry) is published separately as the `openclaw-adspirer` npm package and installed via OpenClaw's package manager.

## Files

| File | Purpose |
|------|---------|
| `claw.json` | Registry manifest — name, version, keywords, install dependencies |
| `SKILL.md` | Complete skill definition (326 lines, standalone) |
| `README.md` | This file |

## Links

- **Adspirer:** https://www.adspirer.com
- **ClawHub listing:** https://clawhub.ai/amekala/adspirer-ads-agent
- **MCP server:** https://mcp.adspirer.com/mcp
- **Privacy policy:** https://www.adspirer.com/privacy
