---
name: adspirer-wasted-spend
description: Find and fix wasted ad spend across all connected platforms. Use when the user wants to reduce waste, find inefficiencies, or optimize budget allocation.
---

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
