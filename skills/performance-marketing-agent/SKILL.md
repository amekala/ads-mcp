---
name: performance-marketing-agent
description: "AI performance marketing agent for paid media, PPC, SEM, and digital marketing. Manage Google Ads, Meta Ads (Facebook & Instagram), LinkedIn Ads, and TikTok Ads campaigns via natural language. Automate keyword research, budget optimization, ROAS tracking, wasted spend analysis, ad creative management, audience targeting, and cross-platform reporting. Powered by Adspirer — 100+ tools for campaign creation, bid optimization, CPA tracking, retargeting, and marketing automation across all major ad platforms."
homepage: https://www.adspirer.com
author: Adspirer
license: MIT
category: marketing
subcategory: performance-marketing
keywords:
  - marketing
  - performance-marketing
  - digital-marketing
  - paid-media
  - paid-social
  - ppc
  - sem
  - advertising
  - google-ads
  - meta-ads
  - facebook-ads
  - linkedin-ads
  - tiktok-ads
  - campaign-management
  - ad-optimization
  - keyword-research
  - budget-optimization
  - roas
  - cpa
  - media-buying
  - marketing-automation
  - retargeting
tags:
  - marketing
  - performance-marketing
  - paid-media
  - ppc
  - advertising
  - google-ads
  - meta-ads
  - linkedin-ads
  - tiktok-ads
  - digital-marketing
  - sem
  - campaign-management
metadata:
  openclaw:
    emoji: "📈"
    requires:
      env: []
      bins: []
    install:
      - id: openclaw-adspirer
        kind: node
        label: "Adspirer Ad Management Plugin"
---

# Performance Marketing Agent — Powered by Adspirer

AI agent for performance marketing, paid media, and digital advertising. Connects directly to ad platform APIs to create campaigns, pull live performance data, research keywords, optimize budgets, and manage ads across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads.

This skill installs the **Adspirer plugin** (`openclaw-adspirer`) — the same 100+ tools, same MCP server, same capabilities as the `adspirer-ads-agent` skill.

## Setup

```bash
# Install the plugin
openclaw plugins install openclaw-adspirer

# Authenticate
openclaw adspirer login

# Connect your ad platforms
openclaw adspirer connect

# Verify
openclaw adspirer status
```

Connect your ad accounts at https://adspirer.ai/connections

---

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
| Create a campaign | Campaign Creation | Platform-specific flows below |
| Reduce wasted spend | Budget Optimization | `optimize_budget_allocation`, `analyze_wasted_spend`, `analyze_search_terms` |
| Switch accounts | Account Management | `switch_primary_account` |
| Compare platforms | Cross-Platform | Call each platform's performance tool, present side-by-side |
| Check ad fatigue | Creative Management | `detect_meta_creative_fatigue`, `analyze_linkedin_creative_performance` |
| Understand audiences | Audience Analysis | `get_meta_audience_insights`, `get_linkedin_audience_insights`, `search_audiences` |
| Add ad extensions | Ad Extensions | `add_sitelinks`, `add_callout_extensions`, `add_structured_snippets`, `list_campaign_extensions` |
| Add/manage keywords | Keyword Management | `add_keywords`, `remove_keywords`, `update_keyword`, `add_negative_keywords`, `remove_negative_keywords` |

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
4. Present a unified scorecard
5. Recommend top 3 actions across all platforms

## Campaign Creation

**Google Ads Search:**
1. `research_keywords` — mandatory
2. Discuss bidding strategy with user
3. `discover_existing_assets` — check for existing ad assets
4. `validate_and_prepare_assets` — validate before creation
5. `create_search_campaign` — create the campaign (PAUSED status)
6. Add ad extensions:
   - `add_sitelinks` — add 10+ validated sitelinks
   - `add_callout_extensions` — add 4+ callouts
   - `add_structured_snippets` — add relevant structured snippets
7. `list_campaign_extensions` — verify all extensions were added

**Google Ads Performance Max:**
1. Discuss bidding strategy with user
2. `discover_existing_assets` — check existing assets
3. `validate_and_prepare_assets` — validate creative assets
4. `create_pmax_campaign` — create the campaign
5. Add ad extensions (same as Search)
6. `add_pmax_search_themes` — add up to 50 themes per asset group
7. `search_audiences` + `add_pmax_audience_signal` — add audience signals

**Google Ads Demand Gen:**
1. `discover_existing_assets` — check existing images, logos, videos
2. `search_audiences` — find relevant audiences for `audience_segments` parameter
3. `create_demandgen_campaign` — create the campaign

**Google Ads YouTube:**
1. `validate_video` — validate the YouTube video
2. `discover_existing_assets` — find existing logos
3. `search_audiences` — find relevant audiences
4. `create_youtube_campaign` — create the campaign

**LinkedIn Ads:**
1. `get_linkedin_organizations` — get linked company pages (**CALL FIRST**)
2. `discover_linkedin_assets` — check existing assets
3. `validate_and_prepare_linkedin_assets` — validate assets
4. `create_linkedin_image_campaign` (or video/carousel/text) — create the campaign

**Meta Ads:**
1. `get_connections_status` — verify Meta account connected
2. `discover_meta_assets` — check existing assets
3. `validate_and_prepare_meta_assets` — validate assets
4. `search_meta_targeting` or `browse_meta_targeting` — find audiences
5. `create_meta_image_campaign` (or video/carousel) — create the campaign

**TikTok Ads:**
1. `discover_tiktok_assets` — check existing assets
2. `validate_and_prepare_tiktok_assets` — validate video assets
3. `create_tiktok_campaign` or `create_tiktok_video_campaign` — create the campaign

## Critical: Input Format Requirements

Follow these rules EXACTLY when calling Adspirer tools to avoid validation errors:

### IDs Must Be Strings
All IDs (campaign_id, ad_account_id, video_id, image_hash, ad_group_id, keyword_id, organization_id, creative_id) MUST be passed as quoted strings, never as bare integers.

- OK: `"existing_video_id": "1333064875515942"`
- BAD: `"existing_video_id": 1333064875515942`

### Never Modify IDs
Copy IDs exactly as returned by list/discover tools. Do not round, truncate, or change any digits.

### Always Call List/Discover Before Create/Update
Many tools require IDs from prior tool calls:
- `list_campaigns` → get `campaign_id` before update/pause/structure
- `get_campaign_structure` → get `ad_group_id` before keyword operations
- `discover_existing_assets` → get `image_hash`, `video_id` before campaign creation
- `get_linkedin_organizations` → get `organization_id` and `account_id`

### Text Length Limits
- Google Ads headline: max 30 characters
- Google Ads description: max 90 characters
- Google Ads sitelink text: max 25 characters
- Google Ads callout: max 25 characters
- Meta primary_text: max 125 characters
- Meta headline: max 40 characters
- LinkedIn introductory_text: max 600 characters
- LinkedIn headline: max 70 characters

### Enum Values Are Case-Insensitive
- **status:** ENABLED, PAUSED, ACTIVE, ARCHIVED
- **objective:** OUTCOME_TRAFFIC, OUTCOME_SALES, OUTCOME_LEADS, etc.
- **match_type:** EXACT, PHRASE, BROAD
- **call_to_action:** LEARN_MORE, SHOP_NOW, SIGN_UP, etc.

### Budgets Are Numbers
Pass budget fields as numbers, not strings:
- OK: `"budget_daily": 50`
- BAD: `"budget_daily": "50"`

### Keywords Format
For `add_negative_keywords`, each keyword must be an object:
- OK: `"keywords": [{"text": "free", "match_type": "BROAD"}]`
- BAD: `"keywords": ["free", "cheap"]`

---

## Available Tools — Complete Reference

### Google Ads Tools

**Performance & Analytics:**
- `get_campaign_performance` — campaign metrics (impressions, clicks, CTR, spend, conversions, ROAS). Params: `lookback_days` (default 30), optional `customer_id`
- `analyze_wasted_spend` — find underperforming keywords and ad groups burning budget
- `optimize_budget_allocation` — suggest budget reallocations across campaigns
- `analyze_search_terms` — review search terms, identify negative keyword opportunities
- `explain_performance_anomaly` — explain sudden changes in campaign metrics
- `get_benchmark_context` — industry benchmarks for the vertical

**Campaign Creation:**
- `select_google_campaign_type` — interactive campaign type selection wizard
- `research_keywords` — keyword research with search volumes, CPC, competition. Params: `business_description` or `seed_keywords`, optional `website_url`, `target_location`
- `discover_existing_assets` — check existing images, videos, logos in the account
- `validate_and_prepare_assets` — validate creative assets before campaign creation
- `validate_video` — validate YouTube video IDs for PMax/YouTube campaigns
- `create_search_campaign` — create Google Search campaign (PAUSED)
- `create_pmax_campaign` — create Performance Max campaign
- `create_demandgen_campaign` — create Demand Gen campaign (YouTube, Gmail, Discover)
- `create_youtube_campaign` — create YouTube video campaign
- `add_demandgen_ad_group` — add ad group to existing Demand Gen campaign

**Campaign Management:**
- `list_campaigns` — list all campaigns with status, budget, performance summary
- `get_campaign_structure` — detailed campaign structure (ad groups, keywords, ads, extensions)
- `update_campaign` — update campaign settings
- `pause_campaign` — pause a campaign
- `resume_campaign` — resume a paused campaign
- `update_bid_strategy` — change bidding strategy (Maximize Clicks, Target CPA, Target ROAS, etc.)

**Keyword Management:**
- `add_keywords` — add keywords to ad group. Params: `campaign_id`, `ad_group_id`, `keywords` (array of `{"text": "...", "match_type": "EXACT|PHRASE|BROAD"}`)
- `remove_keywords` — remove keywords from ad group
- `update_keyword` — update keyword bid, match type, or status
- `add_negative_keywords` — add negative keywords. Params: `campaign_id`, `keywords` (array of `{"text": "...", "match_type": "BROAD|PHRASE|EXACT"}`)
- `remove_negative_keywords` — remove negative keywords

**Ad Management:**
- `suggest_ad_content` — AI-generated headline/description suggestions from real data
- `create_ad` — create new responsive search ad
- `update_ad_headlines` — update RSA headlines
- `update_ad_descriptions` — update RSA descriptions
- `update_ad_content` — update ad content (headlines + descriptions)
- `pause_ad` — pause an ad
- `resume_ad` — resume a paused ad

**Ad Extensions:**
- `add_sitelinks` — add sitelink extensions (target 10+). Params: `campaign_id`, `sitelinks` (array of `{"link_text": "...", "final_url": "...", "description1": "...", "description2": "..."}`)
- `add_callout_extensions` — add callout extensions (target 8+). Params: `campaign_id`, `callouts` (array of strings, max 25 chars each)
- `add_structured_snippets` — add structured snippet extensions. Params: `campaign_id`, `snippets` (array of `{"header": "...", "values": ["...", "..."]}`)
- `list_campaign_extensions` — verify extensions on a campaign

**PMax Search Themes & Audience Signals:**
- `add_pmax_search_themes` — add search themes (max 50 per asset group). Params: `campaign_id`, `search_themes` (array of strings)
- `get_pmax_search_themes` — list existing search themes
- `remove_pmax_search_themes` — remove search themes by resource name
- `add_pmax_audience_signal` — add audience signal with segment IDs
- `get_pmax_audience_signals` — list existing audience signals
- `remove_pmax_audience_signal` — remove audience signal by resource name
- `search_audiences` — search for in-market, affinity, and custom audiences by keyword

**Business Profile:**
- `get_business_profile` — saved brand profile
- `infer_business_profile` — AI-inferred profile from ad data
- `save_business_profile` — save/update brand profile
- `help_user_upload` — help user upload creative assets

### LinkedIn Ads Tools

**Performance & Analytics:**
- `get_linkedin_campaign_performance` — campaign metrics. Params: `lookback_days` (default 30)
- `get_linkedin_engagement_metrics` — engagement metrics (likes, shares, comments, follows)
- `get_linkedin_audience_insights` — audience demographics and segment performance
- `analyze_linkedin_wasted_spend` — find underperforming campaigns burning budget
- `optimize_linkedin_budget` — budget reallocation recommendations
- `explain_linkedin_anomaly` — explain sudden metric changes
- `analyze_linkedin_creative_performance` — per-creative performance metrics

**Campaign Creation:**
- `select_linkedin_campaign_type` — interactive campaign type selection wizard
- `get_linkedin_organizations` — get linked company pages and account IDs (**CALL FIRST** before any LinkedIn operation)
- `discover_linkedin_assets` — check existing images/videos in the account. Params: `account_id` (from `get_linkedin_organizations`)
- `validate_and_prepare_linkedin_assets` — validate/upload assets before campaign creation
- `create_linkedin_image_campaign` — create image ad campaign. Params: `campaign_name`, `daily_budget` (min $10), `organization_id`, `introductory_text` (max 600 chars), `landing_page_url` (HTTPS), `locations` (array of location URNs), plus optional targeting (`industries`, `seniorities`, `job_titles`, `company_sizes`)
- `create_linkedin_video_campaign` — create video ad campaign
- `create_linkedin_carousel_campaign` — create carousel ad campaign
- `create_linkedin_text_campaign` — create text ad campaign
- `explain_linkedin_objectives` — explain available campaign objectives and when to use each

**Campaign Management:**
- `list_linkedin_campaigns` — list all campaigns with status and metrics
- `get_linkedin_campaign_structure` — detailed campaign structure (creatives, targeting, settings). Params: `campaign_id`
- `pause_linkedin_campaign` — pause a campaign. Params: `campaign_id`
- `resume_linkedin_campaign` — resume a paused campaign. Params: `campaign_id`
- `update_linkedin_campaign` — update campaign settings (name, status, objective, etc.)
- `update_linkedin_campaign_budget` — update daily/total budget. Params: `campaign_id`, `daily_budget` and/or `total_budget`
- `update_linkedin_campaign_schedule` — update start/end dates. Params: `campaign_id`, `start_date`, `end_date`
- `update_linkedin_campaign_targeting` — update targeting criteria. Params: `campaign_id`, plus targeting facets (`locations`, `industries`, `seniorities`, `job_titles`, `company_sizes`, etc.)
- `clone_linkedin_campaign` — clone a campaign with optional modifications. Params: `campaign_id`, optional overrides
- `batch_update_linkedin_campaigns` — bulk update multiple campaigns at once

**Creative Management:**
- `list_linkedin_creatives` — list all creatives for a campaign. Params: `campaign_id`
- `add_linkedin_creative` — add image creative to campaign
- `add_linkedin_text_creative` — add text creative to campaign
- `add_linkedin_video_creative` — add video creative to campaign
- `update_linkedin_creative` — update creative content. Params: `creative_id`
- `delete_linkedin_creative` — delete a creative. Params: `creative_id`
- `pause_linkedin_creative` — pause a creative. Params: `creative_id`
- `resume_linkedin_creative` — resume a paused creative. Params: `creative_id`
- `generate_linkedin_ad_creatives` — AI-generated ad creative variations

**Targeting & Audiences:**
- `get_linkedin_campaign_targeting` — get current targeting for a campaign. Params: `campaign_id`
- `search_linkedin_targeting` — search for targeting facets. Params: `query`, `facet_type` (e.g., `"job_titles"`, `"industries"`, `"seniorities"`, `"company_sizes"`, `"skills"`)
- `research_business_for_linkedin_targeting` — AI-recommended targeting based on business website

**Campaign Groups & Conversions:**
- `list_linkedin_campaign_groups` — list campaign groups (folders). Params: `account_id`
- `update_linkedin_campaign_group` — update campaign group settings
- `list_linkedin_conversions` — list conversion tracking rules. Params: `account_id`
- `associate_linkedin_conversion` — link conversion to campaign. Params: `campaign_id`, `conversion_id`
- `manage_linkedin_conversions` — create/update/delete conversion tracking rules

### Meta Ads Tools

**Performance & Analytics:**
- `get_meta_campaign_performance` — campaign metrics. Params: `lookback_days` (default 30), optional `ad_account_id`
- `analyze_meta_ad_performance` — ad-level performance breakdown
- `get_meta_audience_insights` — audience demographics and segment performance
- `analyze_meta_wasted_spend` — find underperforming ads/ad sets burning budget
- `optimize_meta_budget` — budget reallocation recommendations
- `detect_meta_creative_fatigue` — identify ads losing effectiveness over time
- `optimize_meta_placements` — placement-level performance analysis (Feed, Stories, Reels, etc.)
- `explain_meta_anomaly` — explain sudden metric changes
- `analyze_meta_audiences` — audience segment performance analysis

**Campaign Creation:**
- `select_meta_campaign_type` — interactive campaign type selection wizard
- `discover_meta_assets` — check existing images/videos in the account
- `validate_and_prepare_meta_assets` — validate/upload assets before campaign creation
- `create_meta_image_campaign` — create image ad campaign
- `create_meta_video_campaign` — create video ad campaign
- `create_meta_carousel_campaign` — create carousel ad campaign
- `add_meta_ad_set` — add ad set to existing campaign

**Campaign Management:**
- `list_meta_campaigns` — list all campaigns with status and metrics
- `get_meta_campaign_details` — detailed campaign structure
- `update_meta_campaign` — update campaign settings
- `pause_meta_campaign` — pause a campaign
- `resume_meta_campaign` — resume a paused campaign
- `duplicate_meta_campaign` — duplicate a campaign with optional modifications
- `list_meta_ad_sets` — list ad sets in a campaign
- `update_meta_ad_set` — update ad set targeting, budget, schedule
- `list_meta_ads` — list ads in an ad set
- `update_meta_ad` — update ad creative/content
- `add_meta_ad` — add new ad to ad set
- `get_meta_ad_creatives` — get creative details for ads

**Targeting & Audiences:**
- `search_meta_targeting` — search for targeting options (interests, behaviors, demographics). Params: `query`, optional `target_type`
- `browse_meta_targeting` — browse targeting categories
- `list_meta_instagram_accounts` — list connected Instagram accounts
- `list_meta_pixels` — list Meta pixels for conversion tracking

**Lead Forms:**
- `list_meta_lead_forms` — list lead gen forms
- `get_meta_lead_form_submissions` — get lead form submissions

### TikTok Ads Tools
- `discover_tiktok_assets` — check existing assets
- `validate_and_prepare_tiktok_assets` — validate video assets
- `create_tiktok_campaign` — create campaign
- `create_tiktok_video_campaign` — create video campaign

### Account & Utility Tools
- `get_connections_status` — show connected platforms, account IDs
- `switch_primary_account` — change active ad account
- `get_usage_status` — check tool call quota and subscription tier
- `echo_test` — test MCP connectivity

### Monitoring & Reporting Tools
- `create_monitor` — set up metric alerts (ROAS, CPA, CTR thresholds)
- `list_monitors` — list active monitors
- `schedule_brief` — schedule recurring performance reports
- `generate_report_now` — generate one-time performance report
- `list_scheduled_tasks` — list all scheduled tasks
- `manage_scheduled_task` — update/delete scheduled tasks
- `start_research` — start async research task
- `get_research_status` — check research task status
- `audit_conversion_tracking` — audit conversion tracking setup

---

## Safety

- All campaigns created in **PAUSED status** for review
- Write operations always require user confirmation
- Read operations (performance, research, analytics) are safe to run freely
- No local credential storage — OAuth 2.1 with PKCE

## Platform Guidance

| Platform | Min Daily | Recommended | Best for |
|----------|-----------|-------------|----------|
| Google Ads Search | $10 | $50+ | High-intent search traffic |
| Google Ads PMax | $10 | $50+ | Broad reach with automation |
| Google Ads Demand Gen | $10 | $20+ | YouTube, Gmail, Discover |
| Meta Ads | $5/ad set | $20+ | Awareness and retargeting |
| LinkedIn Ads | $10 | $50+ | B2B targeting (job titles, industries) |
| TikTok Ads | $20 | $50+ | Younger demographics, video-first |

## Pricing

| Plan | Price | Tool Calls |
|------|-------|------------|
| **Free Forever** | $0/mo | 15/month |
| **Plus** | $49/mo | 150/month |
| **Pro** | $99/mo | 600/month |
| **Max** | $199/mo | 3,000/month |

All plans include all 4 ad platforms. Sign up at https://adspirer.ai/settings?tab=billing
