---
description: Run a cross-platform performance review for this brand
argument-hint: <time-period, e.g. "last 7 days", "this month">
---
Run a full cross-platform performance review for $ARGUMENTS (default: last 30 days).

1. Read CLAUDE.md for KPI targets and brand context
2. Pull live data from all connected platforms via Adspirer MCP tools: `mcp__adspirer__get_campaign_performance`, `mcp__adspirer__get_linkedin_campaign_performance`, `mcp__adspirer__get_meta_campaign_performance`
3. Compare actuals vs KPI targets from CLAUDE.md
4. Present a unified scorecard table with all platforms
5. Highlight top problems and recommend top 3 actions
