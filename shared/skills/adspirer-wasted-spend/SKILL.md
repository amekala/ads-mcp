---
name: adspirer-wasted-spend
<!-- BEGIN:CURSOR_CLAUDE -->
description: Find and fix wasted ad spend across all connected platforms. Use when the user wants to reduce waste, find inefficiencies, or optimize budget allocation.
<!-- END:CURSOR_CLAUDE -->
<!-- BEGIN:CODEX -->
description: Find and fix wasted ad spend across all platforms. Use when the user wants to reduce wasted spend, find inefficiencies, or optimize budget.
<!-- END:CODEX -->
---

<!-- BEGIN:CURSOR_CLAUDE -->
Run a wasted spend analysis across all connected platforms:

1. Call `get_connections_status` to identify active platforms
1.5. Read STRATEGY.md (if it exists). Flag campaigns violating active directives as
     priority waste sources.
2. For each connected platform, call the appropriate waste analysis tool:
   - Google: `analyze_wasted_spend` + `analyze_search_terms`
   - LinkedIn: `analyze_linkedin_wasted_spend`
   - Meta: `analyze_meta_wasted_spend`
3. Call `optimize_budget_allocation` for reallocation suggestions
4. Present total wasted spend, top waste sources per platform, and potential monthly savings
5. Recommend specific fixes (negative keywords, audience exclusions, budget shifts)
6. Get user approval before making changes
7. Before optimization recommendations, verify campaign build integrity for target campaigns:
   - if ads count = 0 or keyword count = 0, flag as Build Integrity Issue
   - do not proceed with optimization recommendations until missing assets are fixed or explicitly excluded
<!-- END:CURSOR_CLAUDE -->
<!-- BEGIN:CODEX -->
Run a wasted spend analysis across $ARGUMENTS (default: all connected platforms).

1. Read STRATEGY.md (if it exists). Flag campaigns violating active directives as priority waste sources.
2. Call `analyze_wasted_spend` for Google Ads waste
3. Call `analyze_meta_wasted_spend` for Meta Ads waste
4. Call `analyze_linkedin_wasted_spend` for LinkedIn Ads waste
5. Call `analyze_search_terms` to find irrelevant search terms
6. Identify top sources of waste, calculate potential savings, and recommend specific fixes with expected impact
7. If campaigns have zero ads or zero keywords, report a build-integrity blocker before optimization advice.
<!-- END:CODEX -->
