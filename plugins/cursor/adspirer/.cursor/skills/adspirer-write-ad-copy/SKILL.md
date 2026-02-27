---
name: adspirer-write-ad-copy
description: Write brand-voice-compliant ad copy for a specific platform. Use when the user wants new headlines, descriptions, or ad creative text for Google Ads, Meta, LinkedIn, or TikTok campaigns.
---

Write ad copy informed by brand voice and real performance data:

1. Read `BRAND.md` for brand voice rules and target audiences
1.5. Read STRATEGY.md (if it exists) — check `Cross-Platform Strategy` for competitive
     positioning and the target platform's section for creative/messaging directives.
2. Call `get_campaign_structure` to see current ad copy and keywords
3. Call `analyze_search_terms` to understand what users search for
4. Call `suggest_ad_content` for AI-powered suggestions from real data
5. Filter all suggestions through brand voice rules from BRAND.md
6. Present 5+ headline/description options with reasoning
7. Get user approval before applying changes
8. Include a validation table in the response with:
   - headline/description text
   - character count
   - pass/fail vs platform limits
   - target keyword theme mapped to each headline
9. Ensure top ad group keyword themes are represented in the headline set before finalizing.
