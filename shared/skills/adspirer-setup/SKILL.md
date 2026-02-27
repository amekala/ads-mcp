---
name: adspirer-setup
description: Set up your brand workspace — connect to Adspirer, scan brand docs, pull campaign data, and create {{CONTEXT_FILE}}. Use on first time in a new brand folder, or when the user wants to refresh brand context.
---

Run the full brand workspace setup. Follow these steps in order:

## Step 1: Connect to Adspirer

Call `get_connections_status` directly.

- **If it works**: continue to step 2.
- **If the MCP server is not found**: tell the user:
<!-- BEGIN:CURSOR_CLAUDE -->
  "The Adspirer MCP server isn't connected. Add it to your Cursor MCP config:
  1. Open Cursor Settings > MCP
  2. Add server with URL: `https://mcp.adspirer.com/mcp`
  3. Or add to `~/.cursor/mcp.json`:
     ```json
     {"mcpServers": {"adspirer": {"url": "https://mcp.adspirer.com/mcp"}}}
     ```
  4. Restart Cursor and run `/adspirer-setup` again."
<!-- END:CURSOR_CLAUDE -->
<!-- BEGIN:CODEX -->
  "The Adspirer MCP server isn't connected. Run:
  `codex mcp add adspirer --url https://mcp.adspirer.com/mcp`
  Then restart Codex, authenticate via `/mcp`, and run `$adspirer-setup` again."
<!-- END:CODEX -->
- **If OAuth is triggered**: tell the user a browser window is opening for authentication. Wait for them to confirm, then retry.
- **If no platforms are connected**: tell the user to connect ad accounts at https://www.adspirer.com, then run setup again.

## Step 2: Scan local folder

Search for brand documentation files: `**/*.md`, `**/*.txt`, `**/*.csv`, `**/*.yaml`, `**/*.json`, `**/*.pdf`

Read all discovered files. Extract:
- Brand name and industry
- Products/services
- Target audience descriptions
- Brand voice and tone indicators
- Competitor mentions
- Budget information
- KPI targets or performance goals
- Previous campaign strategies or results

If the folder is empty, that's fine — we'll build context from Adspirer data alone.

## Step 3: Pull live campaign data

Call these Adspirer MCP tools (in parallel where possible):

1. `get_connections_status` — which platforms are connected
2. `get_business_profile` — saved brand profile
3. `list_campaigns` — existing campaigns across all platforms
4. `get_campaign_performance` (lookback_days: 30) — Google Ads performance
5. `get_linkedin_campaign_performance` (lookback_days: 30) — LinkedIn performance
6. `get_meta_campaign_performance` (lookback_days: 30) — Meta performance
7. `get_benchmark_context` — industry benchmarks

If any tool errors (platform not connected), skip it and note the gap.

## Step 4: Create {{CONTEXT_FILE}}

Generate `{{CONTEXT_FILE}}` at the project root. Combine local files + Adspirer data:

```markdown
# [Brand Name] — Paid Media Workspace

## Brand Overview
[From docs + Adspirer: what they sell, who they sell to, industry, company size]

## Brand Voice
[From docs: tone, language style, prohibited words, preferred phrases]
[If not found: "No brand voice docs found — add guidelines to this folder to improve ad copy quality"]

## Target Audiences
[From docs + Adspirer campaign targeting data]
[List each audience with platform-specific targeting parameters if available]

## Active Platforms
[From get_connections_status]
- Google Ads: [connected/not connected] — [X active campaigns]
- Meta Ads: [connected/not connected] — [X active campaigns]
- LinkedIn Ads: [connected/not connected] — [X active campaigns]
- TikTok Ads: [connected/not connected] — [X active campaigns]

## Budget & Guardrails
[From docs if available, otherwise from Adspirer campaign data]
- Monthly total: [amount or "Not specified — ask user"]
- Platform allocation: [percentages or "Based on current spend: ..."]
- Max CPC: [if specified]
- Target CPA: [if specified]
- Min ROAS: [if specified]

## KPI Targets
[From docs if available]
- Primary goal: [leads/sales/awareness/traffic]
- Target metrics: [CTR, CPA, ROAS targets]

## Current Performance Snapshot
[From get_campaign_performance — most recent data]
| Platform | Campaigns | Monthly Spend | CTR | CPA | ROAS |
|----------|-----------|---------------|-----|-----|------|
| ...      | ...       | ...           | ... | ... | ...  |

## Key Findings from Existing Campaigns
[From analyze_search_terms + performance data]
- Top performing keywords: ...
- Top performing campaigns: ...
- Wasted spend areas: ...
- Recommendations: ...

## Competitors
[From docs if available]

## Seasonality
[From docs if available]

## Notes
[Anything else relevant found in docs]
[Gaps: "No brand voice guide found", "No budget specified", etc.]
[Known constraints:
- Conversion action primary/secondary setup is configured manually in Google Ads UI (not via Adspirer MCP)
- Campaign creation should be considered complete only after post-create verification of ads, keywords, and extensions]

## Strategy
Active strategy directives are maintained in `STRATEGY.md`. All skills and agents read
that file before campaign creation, keyword research, and ad copy generation.
```

Fill in every section with real data. Leave placeholders only for sections where no data was found — and note the gap.

### Step 4.5: Create STRATEGY.md

Create `STRATEGY.md` at the project root alongside {{CONTEXT_FILE}}:

```markdown
# [Brand Name] — Strategy Playbook

<!-- This file holds strategic decisions that guide campaign creation, keyword research,
     audience targeting, and budget allocation across all platforms. Skills and agents
     read this file before execution. Directives are guidance that informs research —
     not rigid rules that bypass validation. Only save directives the user has confirmed. -->

## Active Directives

### Cross-Platform Strategy
[No active directives yet — run a strategy analysis to populate]

### Google Ads
[No active directives]

### Meta Ads
[No active directives]

### LinkedIn Ads
[No active directives]

### TikTok Ads
[No active directives]

### Budget Allocation
[No active directives]

---

## Decision Log
[No decisions yet — this log will be populated as strategy sessions occur]

---

## Archived Directives
[No archived directives]
```

<!-- BEGIN:HAS_MEMORY -->
## Step 5: Create memory file

Create `.cursor/memory/performance-marketing-agent/MEMORY.md` with initial template:

```markdown
# Performance Marketing Agent — Memory

## Brand Learnings
[No learnings yet — will be populated as campaigns are managed]

## User Preferences
[Not yet determined — will learn from interactions]

## Decision Log
[No decisions yet]
```

## Step 6: Present summary
<!-- END:HAS_MEMORY -->
<!-- BEGIN:NO_MEMORY -->
## Step 5: Present summary
<!-- END:NO_MEMORY -->

Tell the user:
- Which platforms are connected and how many campaigns are active
- A quick performance snapshot (spend, CTR, CPA, ROAS)
- Key findings (top campaigns, wasted spend, opportunities)
- Any gaps ("No brand voice docs found — drop guidelines in this folder anytime")

End with:
"Your brand workspace is set up! I've saved everything to {{CONTEXT_FILE}}.
Here's what I can help with:
- Review campaign performance across all platforms
- Find and fix wasted ad spend
- Write brand-voice ad copy
- Create new campaigns
- Research keywords
- Set up monitoring and alerts

What would you like to start with?"
