---
name: adspirer-performance-review
description: Run a cross-platform performance review for this brand. Use when the user asks for a performance report, weekly review, or wants to see how campaigns are doing across all platforms.
---

Run a full cross-platform performance review:

1. Read `BRAND.md` for KPI targets (if it exists)
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
