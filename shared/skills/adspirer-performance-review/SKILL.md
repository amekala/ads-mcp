---
name: adspirer-performance-review
<!-- BEGIN:CURSOR_CLAUDE -->
description: Run a cross-platform performance review for this brand. Use when the user asks for a performance report, weekly review, or wants to see how campaigns are doing across all platforms.
<!-- END:CURSOR_CLAUDE -->
<!-- BEGIN:CODEX -->
description: Run a cross-platform performance review for this brand. Use when the user asks for a performance review, weekly review, or wants to see how campaigns are doing across all platforms.
<!-- END:CODEX -->
---

<!-- BEGIN:CURSOR_CLAUDE -->
Run a full cross-platform performance review:

1. Read `{{CONTEXT_FILE}}` for KPI targets (if it exists)
2. Call `get_connections_status` to identify active platforms
3. For each connected platform, pull last 30 days of performance data
4. For each platform, pull wasted spend analysis
5. Present a unified scorecard comparing actuals vs targets
6. Highlight top performers, underperformers, and wasted spend
7. Recommend top 3 actions across all platforms
<!-- END:CURSOR_CLAUDE -->
<!-- BEGIN:CODEX -->
Run a full cross-platform performance review for $ARGUMENTS (default: last 30 days).

1. Read {{CONTEXT_FILE}} for KPI targets and brand context
2. Pull live data from all connected platforms via Adspirer MCP tools: `get_campaign_performance`, `get_linkedin_campaign_performance`, `get_meta_campaign_performance`
3. Compare actuals vs KPI targets from {{CONTEXT_FILE}}
4. Present a unified scorecard table with all platforms
5. Highlight top problems and recommend top 3 actions
<!-- END:CODEX -->
