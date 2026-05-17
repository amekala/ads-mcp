---
name: adspirer-performance-review
description: Run a cross-platform performance review for this brand. Use when the user asks for a performance review, weekly review, or wants to see how campaigns are doing across all platforms.
---

Run a full cross-platform performance review for $ARGUMENTS (default: last 30 days).

1. Read AGENTS.md for KPI targets and brand context
1.5. Read STRATEGY.md (if it exists). Flag campaigns that conflict with active directives as "Strategy Drift" items.
2. Pull live data from all connected platforms via Adspirer MCP tools: `get_campaign_performance`, `get_linkedin_campaign_performance`, `get_meta_campaign_performance`
3. Compare actuals vs KPI targets from AGENTS.md
4. Present a unified scorecard table with all platforms
5. Highlight top problems and recommend top 3 actions
6. If requested, include Campaign Integrity Audit fields (status, ad groups, ads, keywords, extensions, bidding drift).
