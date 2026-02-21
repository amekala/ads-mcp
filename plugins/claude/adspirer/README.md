# Adspirer Plugin for Claude Code

Brand-specific paid media management across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads — 100+ tools for campaign creation, keyword research, performance analysis, budget optimization, and more.

## What's Included

- **Brand Media Manager Agent** — AI agent that learns your brand (voice, audiences, budgets) and manages campaigns with brand awareness
- **MCP Server** — Connects Claude Code to Adspirer's ad management API
- **Skills** — Ad campaign workflows and brand workspace setup
- **Commands** — Quick-access shortcuts for common tasks

## Setup

### 1. Create an Adspirer account
Go to [adspirer.com](https://www.adspirer.com) and connect your ad accounts (Google Ads, Meta, LinkedIn, TikTok).

### 2. Install the plugin in Claude Code
```
/install adspirer/ads-mcp/plugins/claude/adspirer
```

That's it. The plugin is now available in every Claude Code session.

## Usage

### Per-brand folders
Create a folder for each brand you manage, then start Claude Code:

```bash
cd ~/Brands/Acme
claude
```

On first use, the brand media manager agent will:
1. Scan any docs in the folder (brand guidelines, media plans, etc.)
2. Pull live data from your connected ad accounts
3. Create a CLAUDE.md with brand context
4. Answer your question

### Example prompts
- "How are my Google Ads campaigns performing this month?"
- "Research keywords for my SaaS product targeting CTOs"
- "Create a LinkedIn campaign for lead generation with $100/day budget"
- "Where am I wasting ad spend across all platforms?"
- "Write new ad headlines for our top campaign"

### Slash commands
- `/performance-review` — Cross-platform performance scorecard
- `/write-ad-copy` — Brand-voice ad copy generation
- `/wasted-spend` — Find and fix wasted spend
- `/refresh-brand-context` — Re-scan docs and update brand context

## Plugin Structure

```
adspirer/
├── .claude-plugin/plugin.json      — Plugin manifest
├── .mcp.json                       — Adspirer MCP server connection
├── agents/
│   └── brand-media-manager.md      — Brand-aware AI media manager
├── skills/
│   ├── ad-campaign-management/     — 100+ tool workflow skill
│   └── brand-workspace-setup/      — First-time workspace bootstrap
├── commands/                       — Slash command shortcuts
└── README.md
```

## How It Works

The **brand media manager agent** combines two knowledge sources:

1. **Brand knowledge** (local files) — CLAUDE.md, brand docs, creative guidelines, media plans
2. **Live ad data** (Adspirer MCP) — campaign performance, keywords, search terms, budgets, benchmarks

It uses persistent memory to learn what works for each brand over time.

## Supported Platforms

| Platform | Capabilities |
|----------|-------------|
| Google Ads | Performance, keywords, Search campaigns, PMax campaigns, budget optimization, wasted spend analysis |
| Meta Ads | Performance, targeting, audience insights, creative fatigue detection, placement optimization |
| LinkedIn Ads | Performance, B2B targeting, creative management, audience insights |
| TikTok Ads | Performance, campaign creation, video campaigns |
