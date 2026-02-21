---
name: brand-workspace-setup
description: Bootstraps a brand workspace for paid media management. Scans local files, pulls live data from Adspirer MCP, and generates CLAUDE.md with brand context. Use when CLAUDE.md doesn't exist in the project root.
---

# Brand Workspace Setup

This skill bootstraps a brand workspace for paid media management.
Run this when CLAUDE.md doesn't exist in the project root.

## Step 1: Scan the project folder

Glob for all readable files:
- **/*.md, **/*.txt, **/*.csv, **/*.yaml, **/*.json
- **/*.pdf, **/*.docx (if readable)
- Look in common locations: docs/, brand/, assets/, campaigns/, reports/

Read everything you find. Extract:
- Brand name and industry
- Products/services
- Target audience descriptions
- Brand voice and tone indicators
- Competitor mentions
- Budget information
- KPI targets or performance goals
- Previous campaign strategies or results

## Step 2: Pull live data from Adspirer MCP

Call these tools to understand the brand's current ad landscape:

1. `get_connections_status` — Which platforms are connected?
2. `get_business_profile` — Does a brand profile already exist?
3. `list_campaigns` — What campaigns are running?
4. `get_campaign_performance` — How are they performing? (use lookback_days: 30)
5. `analyze_search_terms` — What do users search for? (Google Ads only)
6. `get_benchmark_context` — Industry benchmarks

If a tool returns an error (e.g., platform not connected), skip it and note it in the output.

## Step 3: Generate CLAUDE.md

Create CLAUDE.md at the project root with this structure:

```markdown
# [Brand Name] — Paid Media Workspace

## Brand Overview
[Extracted from docs + Adspirer data: what they sell, who they sell to, industry]

## Brand Voice
[Extracted from docs: tone, language style, prohibited words, preferred phrases]
[If not found: "No brand voice docs found — add guidelines to this folder to improve ad copy quality"]

## Target Audiences
[Extracted from docs + Adspirer campaign targeting data]
[List each audience with platform-specific targeting parameters if available]

## Active Platforms
[From Adspirer get_connections_status]
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
[From Adspirer get_campaign_performance — most recent 30-day data]
| Platform | Campaigns | Monthly Spend | CTR | CPA | ROAS |
|----------|-----------|---------------|-----|-----|------|
| ...      | ...       | ...           | ... | ... | ...  |

## Key Findings from Existing Campaigns
[From Adspirer analyze_search_terms + performance data]
- Top performing keywords: ...
- Top performing campaigns: ...
- Wasted spend areas: ...
- Recommendations: ...

## Competitors
[Extracted from docs if available]

## Seasonality
[Extracted from docs if available]

## Notes
[Anything else relevant found in docs]
[Gaps: "No brand voice guide found", "No budget specified", etc.]
```

## Step 4: Confirm with user

Tell the user:
"I've set up your brand workspace and created CLAUDE.md with what I found.
Here's a summary: [brief summary of brand, platforms, and key findings].
Please review CLAUDE.md and let me know if anything needs correcting or adding."
