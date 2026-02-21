---
name: ad-campaign-management
description: Manage ad campaigns across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads. Use when the user wants to analyze campaign performance, research keywords, create campaigns, optimize budgets, or manage ad accounts via the Adspirer MCP server.
---

Manage advertising campaigns across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads using the Adspirer MCP server (100+ tools).

## When to Use This Skill

Activate when the user:

- Asks about ad campaign performance ("How are my Google Ads doing?")
- Wants to research keywords ("Find keywords for my plumbing business")
- Needs to create campaigns ("Launch a Google Search campaign for...")
- Wants budget optimization ("Where am I wasting ad spend?")
- Mentions advertising platforms (Google Ads, Meta, LinkedIn, TikTok)
- Asks about ad accounts or connections ("Which ad platforms are connected?")

## Required Workflow

**Follow these steps in order. Do not skip steps.**

### Step 1: Check Connected Platforms

Always start here before any ad operation:

- Call `get_connections_status`
- Shows connected platforms, primary/secondary accounts, account IDs
- If the target platform is not connected, direct the user to https://www.adspirer.com

### Step 2: Identify the Task

| User goal | Workflow | Key tools |
|-----------|----------|-----------|
| View campaign metrics | Performance Analysis | `get_campaign_performance`, `get_meta_campaign_performance`, `get_linkedin_campaign_performance` |
| Cross-platform overview | Cross-Platform Dashboard | See Cross-Platform section below |
| Find keywords | Keyword Research | `research_keywords` |
| Create a campaign | Campaign Creation | See platform-specific flows below |
| Reduce wasted spend | Budget Optimization | `optimize_budget_allocation`, `analyze_wasted_spend`, `analyze_search_terms` |
| Switch accounts | Account Management | `switch_primary_account` |
| Compare platforms | Cross-Platform | Call each platform's performance tool, present side-by-side |
| Check ad fatigue | Creative Management | `detect_meta_creative_fatigue`, `analyze_linkedin_creative_performance` |
| Understand audiences | Audience Analysis | `get_meta_audience_insights`, `get_linkedin_audience_insights` |
| Set up alerts | Monitoring | `create_monitor`, `list_monitors` |
| Schedule reports | Reporting | `schedule_brief`, `generate_report_now` |

### Step 3: Execute Tools

Follow the workflow patterns below. Always read first (performance, status), then act (create, optimize).

### Step 4: Summarize and Recommend

Present results in tables with key metrics. Highlight top and underperforming items. Propose actionable next steps.

## Performance Analysis

- **Google Ads:** `get_campaign_performance` — params: `lookback_days` (7/30/60/90, default 30), optional `customer_id`
- **Meta Ads:** `get_meta_campaign_performance` — params: `lookback_days`, optional `ad_account_id`
- **LinkedIn Ads:** `get_linkedin_campaign_performance` — params: `lookback_days`
- **TikTok Ads:** `get_tiktok_campaign_performance` — params: `lookback_days`

Present: impressions, clicks, CTR, spend, conversions, cost/conversion, ROAS. Default to 30-day lookback.

## Cross-Platform Performance Dashboard

When the user asks for overall performance, a weekly review, or cross-platform comparison:

1. Call `get_connections_status` to identify active platforms
2. For each connected platform, pull performance:
   - Google: `get_campaign_performance`
   - LinkedIn: `get_linkedin_campaign_performance`
   - Meta: `get_meta_campaign_performance`
3. For each platform, pull waste analysis:
   - Google: `analyze_wasted_spend`
   - LinkedIn: `analyze_linkedin_wasted_spend`
   - Meta: `analyze_meta_wasted_spend`
4. Present a unified scorecard:

| Platform | Campaigns | Spend | CTR | CPA | ROAS | Waste | Health |
|----------|-----------|-------|-----|-----|------|-------|--------|
| Google   | ...       | ...   | ... | ... | ...  | ...   | ...    |
| LinkedIn | ...       | ...   | ... | ... | ...  | ...   | ...    |
| Meta     | ...       | ...   | ... | ... | ...  | ...   | ...    |
| **Total**| ...       | ...   |     |     |      | ...   |        |

5. Highlight:
   - Best performing platform and campaign
   - Worst performing platform and campaign
   - Total wasted spend and top waste sources
   - Budget pacing (on track, under, over)
6. Recommend top 3 actions across all platforms

## Keyword Research (Google Ads)

Always run before creating Search campaigns. Never use generic SEO keywords.

- Tool: `research_keywords`
- Params: `business_description` or `seed_keywords`, optional `website_url`, `target_location`
- Group results by intent (high/medium/low), show search volume, CPC ranges, competition

## Campaign Creation

**Google Ads Search (exact order):**
1. `research_keywords` — mandatory, never skip
2. `discover_existing_assets` — check for existing ad assets
3. `validate_and_prepare_assets` — validate before creation
4. `create_search_campaign` — create the campaign

**Google Ads Performance Max:**
1. `discover_existing_assets` — check existing assets
2. `validate_and_prepare_assets` — validate creative assets
3. `create_pmax_campaign` — create the campaign

**Meta Ads:**
1. `get_connections_status` — verify Meta account connected
2. `search_meta_targeting` or `browse_meta_targeting` — find audiences
3. Create campaign — created in PAUSED status

**LinkedIn Ads:**
1. `get_linkedin_organizations` — get linked company pages
2. `discover_linkedin_assets` — check existing assets
3. `validate_and_prepare_linkedin_assets` — validate assets
4. `create_linkedin_image_campaign` — create the campaign

## Budget Optimization (Google Ads)

- `optimize_budget_allocation` — suggest budget reallocations
- `analyze_wasted_spend` — find underperforming keywords and ad groups
- `analyze_search_terms` — review search terms for negative keyword opportunities

## Creative Fatigue Detection & Refresh

When reviewing creative performance or user asks about ad fatigue:

1. Meta: Call `detect_meta_creative_fatigue` for fatigue scores
2. LinkedIn: Call `analyze_linkedin_creative_performance` for per-creative metrics
3. Google: Call `get_campaign_structure` to see ad-level performance
4. Identify ads with:
   - High frequency + declining CTR (fatigued)
   - More than 30 days running with no refresh
   - Below-average CTR for their campaign
5. For fatigued ads:
   - Call `suggest_ad_content` for new headline/description ideas
   - Call `generate_linkedin_ad_creatives` for LinkedIn variations
   - Present new creative options (filtered through brand voice if CLAUDE.md exists)
   - On approval: update via `update_ad_headlines`, `update_ad_descriptions`, `add_linkedin_creative`, etc.

## A/B Testing Workflow

When creating new ad variations for testing:

1. Read current top-performing ad copy (from campaign structure)
2. Generate 3-5 variations testing ONE variable:
   - Headline variation (keep description same)
   - Description variation (keep headline same)
   - CTA variation
   - Audience variation (same ad, different targeting)
3. Present test plan with hypothesis:
   "Testing: 'Headline A' vs 'Headline B'
    Hypothesis: [why we think one may outperform]
    Duration: 2 weeks, split budget 50/50
    Success metric: CTR and conversion rate"
4. On approval, create test variants via platform-specific tools
5. Log test for follow-up analysis

## Audience Analysis & Optimization

When analyzing or optimizing audiences:

1. Pull audience data:
   - Meta: `get_meta_audience_insights` + `analyze_meta_audiences`
   - LinkedIn: `get_linkedin_audience_insights`
   - Google: Review campaign targeting from `get_campaign_structure`
2. Identify:
   - Which audience segments convert best (by age, gender, job title, interest)
   - Audience overlap/saturation
   - Underperforming segments (high spend, low conversion)
3. For LinkedIn B2B specifically:
   - Call `research_business_for_linkedin_targeting` with brand's website
   - Compare AI-recommended targeting vs current targeting
   - Identify gaps (seniority levels, industries, company sizes not covered)
4. For Meta:
   - Call `optimize_meta_placements` for placement-level performance
   - Identify which placements to scale/reduce
5. Present findings with recommendations:
   - Segments to expand (high ROAS, low spend)
   - Segments to cut (low ROAS, high spend)
   - New segments to test

## Monitoring & Alerts

When user wants alerts or ongoing monitoring:

1. Understand what they want to monitor:
   - Budget pacing (approaching monthly limit)
   - Performance drops (ROAS below target, CPA above target)
   - Opportunity alerts (keyword with sudden volume increase)
2. Call `create_monitor` with appropriate:
   - Metric (ROAS, CTR, CPC, CPA, spend, conversions)
   - Threshold and direction (below 3.0, above $150)
   - Delivery (email, Slack, SMS)
3. Call `list_monitors` to confirm setup
4. To modify: `manage_scheduled_task` with monitor ID

## Reporting

When user wants performance reports:

1. Ask: frequency (one-time, weekly, monthly) and format preference
2. For one-time: Call `generate_report_now`
3. For recurring: Call `schedule_brief` with:
   - Frequency (daily, weekly)
   - Delivery method (email, Slack, webhook)
   - Content scope (all platforms or specific)
4. Call `list_scheduled_tasks` to confirm

## Competitive Intelligence

When analyzing competitors or adjusting competitive strategy:

1. Read brand docs for known competitors (if CLAUDE.md exists, check Competitors section)
2. For Google Ads:
   - Review search term data via `analyze_search_terms` for competitor brand terms
   - Check if competitors bid on our brand terms
   - Call `research_keywords` for competitor brand + product terms
3. Assess:
   - Are competitors bidding on our brand terms? (defensive strategy needed)
   - Which competitor keywords have high volume + reasonable CPC?
   - Where do we overlap vs differentiate?
4. Recommend:
   - Brand defense campaigns (exact match on own brand terms)
   - Competitor conquest campaigns (with brand voice from docs)
   - Negative keywords to avoid irrelevant competitor traffic

## Safety Rules

These tools create REAL campaigns that spend REAL money.

1. **Always confirm with the user** before creating campaigns or changing spend
2. **Never retry campaign creation automatically** on error
3. **Never modify live budgets** without explicit user approval
4. All campaigns created in **PAUSED status** when possible
5. When in doubt about any spend-affecting action, **ask the user first**

## Platform Guidance

| Platform | Min Daily | Recommended | Best for |
|----------|-----------|-------------|----------|
| Google Ads Search | $10 | $50+ | High-intent search traffic |
| Google Ads PMax | $10 | $50+ | Broad reach with automation |
| Meta Ads | $5/ad set | $20+ | Awareness and retargeting |
| LinkedIn Ads | $10 | $50+ | B2B targeting (job titles, industries) |
| TikTok Ads | $20 | $50+ | Younger demographics, video-first |

## Available Tools (100+)

| Platform | Key Tools |
|----------|-----------|
| Google Ads | `get_campaign_performance`, `research_keywords`, `create_search_campaign`, `create_pmax_campaign`, `optimize_budget_allocation`, `analyze_wasted_spend`, `analyze_search_terms`, `suggest_ad_content`, `get_campaign_structure`, `discover_existing_assets` |
| LinkedIn Ads | `get_linkedin_campaign_performance`, `create_linkedin_image_campaign`, `get_linkedin_organizations`, `analyze_linkedin_creative_performance`, `get_linkedin_audience_insights`, `research_business_for_linkedin_targeting`, `generate_linkedin_ad_creatives` |
| Meta Ads | `get_meta_campaign_performance`, `search_meta_targeting`, `browse_meta_targeting`, `detect_meta_creative_fatigue`, `get_meta_audience_insights`, `analyze_meta_audiences`, `optimize_meta_placements`, `analyze_meta_wasted_spend` |
| TikTok Ads | `create_tiktok_campaign`, `create_tiktok_video_campaign`, `discover_tiktok_assets`, `validate_and_prepare_tiktok_assets` |
| Account | `get_connections_status`, `switch_primary_account`, `get_business_profile`, `get_usage_status` |
| Monitoring | `create_monitor`, `list_monitors`, `schedule_brief`, `generate_report_now`, `list_scheduled_tasks` |

## Output Formatting

- **Performance:** Table with impressions, clicks, CTR, spend, conversions, CPC, ROAS. Order by spend descending.
- **Keywords:** Group by intent, show search volume and CPC ranges.
- **Campaign creation:** Confirm all settings with user before execution, show campaign ID after.
- **Cross-platform:** Side-by-side comparison table.
- **Errors:** Report full error message. Never retry creation tools automatically.

## Troubleshooting

- **Auth errors:** Reconnect via your AI assistant's connector settings
- **No data:** Verify ad platform is connected at https://www.adspirer.com. Try longer lookback (60/90 days).
- **Wrong account:** Use `switch_primary_account` to change active account
- **Rate limits:** Adspirer enforces tool call quotas by tier (Free: 10/mo, Plus: 50, Pro: 100, Enterprise: unlimited)
