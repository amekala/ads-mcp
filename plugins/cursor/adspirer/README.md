# Adspirer Plugin for Cursor

Manage advertising campaigns across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads — 91 tools for campaign creation, keyword research, performance analysis, and budget optimization.

## What's Included

- **MCP Server** — Connects Cursor to Adspirer's ad management service
- **Skills** — Auto-triggers ad workflows when you ask about campaigns, keywords, or performance

## Installation

Add to your `mcp.json` (global: `~/.cursor/mcp.json` or per-project: `.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "adspirer": {
      "url": "https://mcp.adspirer.com/mcp"
    }
  }
}
```

Then copy the skill to your skills directory:

```bash
cp -r plugins/cursor/adspirer/skills/ad-campaign-management ~/.cursor/skills/
```

Or install via Cursor Settings > Rules > Add Rule > Remote Rule (GitHub).

## Usage Examples

- "How are my Google Ads campaigns performing this month?"
- "Research keywords for my SaaS product targeting CTOs"
- "Create a LinkedIn campaign for lead generation with $100/day budget"
- "Where am I wasting ad spend across all platforms?"
