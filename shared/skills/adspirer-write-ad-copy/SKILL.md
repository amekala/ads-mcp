---
name: adspirer-write-ad-copy
<!-- BEGIN:CURSOR_CLAUDE -->
description: Write brand-voice-compliant ad copy for a specific platform. Use when the user wants new headlines, descriptions, or ad creative text for Google Ads, Meta, LinkedIn, or TikTok campaigns.
<!-- END:CURSOR_CLAUDE -->
<!-- BEGIN:CODEX -->
description: Write brand-voice-compliant ad copy for a specific platform. Use when the user wants new headlines, descriptions, or ad creative.
<!-- END:CODEX -->
---

<!-- BEGIN:CURSOR_CLAUDE -->
Write ad copy informed by brand voice and real performance data:

1. Read `{{CONTEXT_FILE}}` for brand voice rules and target audiences
2. Call `get_campaign_structure` to see current ad copy and keywords
3. Call `analyze_search_terms` to understand what users search for
4. Call `suggest_ad_content` for AI-powered suggestions from real data
5. Filter all suggestions through brand voice rules from {{CONTEXT_FILE}}
6. Present 5+ headline/description options with reasoning
7. Get user approval before applying changes
8. Include a validation table in the response with:
   - headline/description text
   - character count
   - pass/fail vs platform limits
   - target keyword theme mapped to each headline
9. Ensure top ad group keyword themes are represented in the headline set before finalizing.
<!-- END:CURSOR_CLAUDE -->
<!-- BEGIN:CODEX -->
Write ad copy for $ARGUMENTS.

1. Read {{CONTEXT_FILE}} for brand voice rules and audience info
2. Call `get_campaign_structure` to see current ads and keywords
3. Call `analyze_search_terms` to see what users actually search
4. Call `suggest_ad_content` for AI-generated suggestions based on real data
5. Generate 5+ headline/description options that follow brand guidelines and are informed by real performance data
6. Present options for user approval
7. Include a validation table with character counts and keyword-theme coverage for the proposed headlines/descriptions.
<!-- END:CODEX -->
