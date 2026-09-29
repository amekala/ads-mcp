---
description: Run a cross-platform performance review for this brand
argument-hint: <time-period, e.g. "last 7 days", "this month">
---
Run a full cross-platform performance review for $ARGUMENTS (default: last 30 days).

1. Read CLAUDE.md for KPI targets and brand context
2. Pull live data from all connected platforms. Follow `adspirer-mcp` for the call contract: `get_campaign_performance` (Google) and `get_meta_campaign_performance` (Meta) are direct calls; LinkedIn, TikTok, Amazon, and ChatGPT Ads go through their router with `{"action": "execute", "tool_name": "..."}`
3. Compare actuals vs KPI targets from CLAUDE.md
4. Present a unified scorecard table with all platforms
5. Highlight top problems and recommend top 3 actions
