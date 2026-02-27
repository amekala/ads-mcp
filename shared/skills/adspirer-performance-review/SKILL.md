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
1.5. Read STRATEGY.md (if it exists). Note where campaigns align or conflict with active
     directives. Flag "Strategy Drift" items in the scorecard.
2. Call `get_connections_status` to identify active platforms
3. For each connected platform, pull last 30 days of performance data
4. For each platform, pull wasted spend analysis
5. Present a unified scorecard comparing actuals vs targets
6. Highlight top performers, underperformers, and wasted spend
7. Recommend top 3 actions across all platforms
8. If the user asks for launch QA or campaign integrity, run a Campaign Integrity Audit:
   - campaign status
   - ad group count
   - ads count
   - keyword count and match-type mix
   - extension counts
   - bidding strategy requested vs actual
<!-- END:CURSOR_CLAUDE -->
<!-- BEGIN:CODEX -->
Run a full cross-platform performance review for $ARGUMENTS (default: last 30 days).

1. Read {{CONTEXT_FILE}} for KPI targets and brand context
1.5. Read STRATEGY.md (if it exists). Flag campaigns that conflict with active directives as "Strategy Drift" items.
2. Pull live data from all connected platforms via Adspirer MCP tools: `get_campaign_performance`, `get_linkedin_campaign_performance`, `get_meta_campaign_performance`
3. Compare actuals vs KPI targets from {{CONTEXT_FILE}}
4. Present a unified scorecard table with all platforms
5. Highlight top problems and recommend top 3 actions
6. If requested, include Campaign Integrity Audit fields (status, ad groups, ads, keywords, extensions, bidding drift).
<!-- END:CODEX -->
