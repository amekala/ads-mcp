# Adspirer Plugin for Claude Code

Manage advertising campaigns across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads — 91 tools for campaign creation, keyword research, performance analysis, and budget optimization.

## What's Included

- **MCP Server** — Connects Claude Code to Adspirer's ad management service
- **Skills** — Auto-triggers ad workflows when you ask about campaigns, keywords, or performance

## Installation

```bash
claude mcp add --transport http adspirer https://mcp.adspirer.com/mcp
```

Then copy the skill to your skills directory:

```bash
cp -r plugins/claude/adspirer/skills/ad-campaign-management ~/.claude/skills/
```

## Available Tools

### Performance Analysis
- `get_campaign_performance` — Google Ads metrics
- `get_meta_campaign_performance` — Meta Ads metrics
- `get_linkedin_campaign_performance` — LinkedIn Ads metrics
- `get_tiktok_campaign_performance` — TikTok Ads metrics

### Campaign Creation
- `research_keywords` — Google keyword research with real CPC data
- `create_search_campaign` — Google Search campaigns
- `create_pmax_campaign` — Google Performance Max campaigns
- `create_linkedin_image_campaign` — LinkedIn sponsored content

### Budget Optimization
- `optimize_budget_allocation` — Reallocation suggestions
- `analyze_wasted_spend` — Underperforming keywords
- `analyze_search_terms` — Negative keyword opportunities

## Usage Examples

- "How are my Google Ads campaigns performing this month?"
- "Research keywords for my SaaS product targeting CTOs"
- "Create a LinkedIn campaign for lead generation with $100/day budget"
- "Where am I wasting ad spend across all platforms?"
