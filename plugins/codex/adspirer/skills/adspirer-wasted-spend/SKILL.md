---
name: adspirer-wasted-spend
description: Find and fix wasted ad spend across all platforms. Use when the user wants to reduce wasted spend, find inefficiencies, or optimize budget.
---

Run a wasted spend analysis across $ARGUMENTS (default: all connected platforms).

1. Call `analyze_wasted_spend` for Google Ads waste
2. Call `analyze_meta_wasted_spend` for Meta Ads waste
3. Call `analyze_linkedin_wasted_spend` for LinkedIn Ads waste
4. Call `analyze_search_terms` to find irrelevant search terms
5. Identify top sources of waste, calculate potential savings, and recommend specific fixes with expected impact
6. If campaigns have zero ads or zero keywords, report a build-integrity blocker before optimization advice.
