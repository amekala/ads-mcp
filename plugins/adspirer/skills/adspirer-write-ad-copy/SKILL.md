---
name: adspirer-write-ad-copy
description: Write brand-voice-compliant ad copy for a specific platform. Use when the user wants new headlines, descriptions, or ad creative.
---

Write ad copy for $ARGUMENTS.

1. Read AGENTS.md for brand voice rules and audience info
1.5. Read STRATEGY.md (if it exists) — apply Creative Direction and Competitive Positioning directives.
2. Call `get_campaign_structure` to see current ads and keywords
3. Call `analyze_search_terms` to see what users actually search
4. Call `suggest_ad_content` for AI-generated suggestions based on real data
5. Generate 5+ headline/description options that follow brand guidelines and are informed by real performance data
6. Present options for user approval
7. Include a validation table with character counts and keyword-theme coverage for the proposed headlines/descriptions.
