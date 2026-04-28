# Adspirer — Ad Campaign Management

Manage advertising campaigns across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads using the Adspirer MCP server (175+ tools across Google Search/PMax/Display/Demand Gen/YouTube, Meta image/video/carousel/lead-gen, LinkedIn sponsored content/carousel/lead-gen with campaign groups, and TikTok in-feed/Spark/Carousel/App Promotion).

## Quick Start

1. Call `get_connections_status` to see which ad platforms are connected
2. If no platforms connected, direct the user to https://adspirer.ai/connections to link accounts
3. For campaign performance, call the platform-specific performance tool
4. Present results in tables with key metrics

## When to Use These Tools

Activate when the user:

- Asks about ad campaign performance ("How are my Google Ads doing?")
- Wants to research keywords ("Find keywords for my plumbing business")
- Needs to create campaigns ("Launch a Google Search campaign for...")
- Wants budget optimization ("Where am I wasting ad spend?")
- Mentions advertising platforms (Google Ads, Meta, LinkedIn, TikTok)
- Asks about ad accounts or connections ("Which ad platforms are connected?")
- Wants to manage creatives, audiences, or ad extensions
- Asks about monitoring or scheduled reports

## Required Workflow

**Follow these steps in order. Do not skip steps.**

### Step 1: Check Connected Platforms

Always start here before any ad operation:

- Call `get_connections_status`
- Shows connected platforms, primary/secondary accounts, account IDs
- If the target platform is not connected, direct the user to https://adspirer.ai/connections

### Step 2: Identify the Task

| User goal | Key tools |
|-----------|-----------|
| View campaign metrics | `get_campaign_performance`, `get_meta_campaign_performance`, `get_linkedin_campaign_performance`, `get_tiktok_campaign_performance` |
| Cross-platform overview | Call each platform's performance tool, present side-by-side |
| Find keywords | `research_keywords`, `analyze_search_terms` |
| Create a campaign | Platform-specific creation tools (always PAUSED) |
| Reduce wasted spend | `analyze_wasted_spend`, `analyze_meta_wasted_spend`, `analyze_linkedin_wasted_spend` |
| Optimize budgets | `optimize_budget_allocation`, `optimize_meta_budget`, `optimize_linkedin_budget` |
| Switch accounts | `switch_primary_account` |
| Check ad fatigue | `detect_meta_creative_fatigue`, `analyze_linkedin_creative_performance` |
| Understand audiences | `get_meta_audience_insights`, `get_linkedin_audience_insights`, `search_audiences` |
| Manage ad extensions | `add_sitelinks`, `add_callout_extensions`, `add_structured_snippets` |
| Set up monitoring | `create_monitor`, `list_monitors` |
| Schedule reports | `schedule_brief`, `generate_report_now` |
| Explain anomalies | `explain_performance_anomaly`, `explain_meta_anomaly`, `explain_linkedin_anomaly` |

### Step 3: Execute Tools

Follow these workflow patterns. Always read first (performance, status), then act (create, optimize).

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
2. For each connected platform, pull performance data
3. For each platform, pull waste analysis
4. Present a unified scorecard:

| Platform | Campaigns | Spend | CTR | CPA | ROAS | Waste | Health |
|----------|-----------|-------|-----|-----|------|-------|--------|
| Google   | ...       | ...   | ... | ... | ...  | ...   | ...    |
| LinkedIn | ...       | ...   | ... | ... | ...  | ...   | ...    |
| Meta     | ...       | ...   | ... | ... | ...  | ...   | ...    |
| **Total**| ...       | ...   |     |     |      | ...   |        |

5. Highlight best and worst performing platforms and campaigns
6. Recommend top 3 actions across all platforms

## Keyword Research

1. `research_keywords` — get search volumes, CPC, competition data
2. `analyze_search_terms` — see what users actually search for
3. Use findings to inform campaign creation or optimization
4. Present keyword opportunities in a table with volume, CPC, and competition

## Campaign Creation

All campaigns are created in **PAUSED** status. Follow this order:

1. **Research:** keywords, competitors, audiences
2. **Assets:** Call `discover_existing_assets` (or platform equivalent) to find reusable images/videos
3. **Create:** Use the platform-specific creation tool
4. **Review:** Present the created campaign to user before any activation

### Google Ads Campaign Types
- `create_search_campaign` — Search campaigns
- `create_pmax_campaign` — Performance Max campaigns (with `add_pmax_search_themes` + `add_pmax_audience_signal`)
- `create_display_campaign` — Display campaigns (Standard + Smart Display); use `add_display_ad_group` + `add_display_ad`
- `create_youtube_campaign` — YouTube video campaigns
- `create_demandgen_campaign` — Demand Gen campaigns

### Meta Ads Campaign Types
- `create_meta_image_campaign` — Single-image campaigns
- `create_meta_video_campaign` — Video campaigns
- `create_meta_carousel_campaign` — Carousel campaigns

### LinkedIn Ads Campaign Types
- `create_linkedin_image_campaign` — Image campaigns
- `create_linkedin_video_campaign` — Video campaigns
- `create_linkedin_carousel_campaign` — Carousel campaigns
- `create_linkedin_text_campaign` — Text campaigns

### TikTok Ads Campaign Types
- `create_tiktok_campaign` — Flexible objective; pass `tiktok_item_id` or `card_id` for Spark Ads. APP_PROMOTION objective for app installs.
- `create_tiktok_video_campaign` — In-feed video
- `create_tiktok_carousel_card` then `add_tiktok_ad` — Carousel

## Budget Optimization

- `optimize_budget_allocation` — Rebalance Google Ads budgets across campaigns
- `optimize_meta_budget` — Optimize Meta Ads budget allocation
- `optimize_linkedin_budget` — Optimize LinkedIn Ads budget allocation
- `optimize_tiktok_budget` — Optimize TikTok Ads budget allocation
- `analyze_wasted_spend` / `analyze_meta_wasted_spend` / `analyze_linkedin_wasted_spend` / `analyze_tiktok_wasted_spend` — Find wasted spend across all four platforms
- `analyze_search_terms` — Find irrelevant search terms burning budget
- **Raw data mode:** Pass `raw_data: true` to any performance / analytics tool for compact JSON metrics only

## Monitoring and Reporting

- `create_monitor` — Set up 24/7 metric alerts
- `list_monitors` — View active monitors
- `schedule_brief` — Schedule daily/weekly performance reports
- `generate_report_now` — Generate on-demand report
- `list_scheduled_tasks` — View scheduled tasks

## Account Management

- `switch_primary_account` — Switch between multiple ad accounts
- `get_business_profile` — Get account/business details
- `get_usage_status` — Check Adspirer plan usage and remaining tool calls
- `get_connections_status` — View all connected platforms

## Safety Rules

- All new campaigns are created **PAUSED** — never auto-activate
- Cannot delete existing campaigns
- Cannot modify existing budgets without explicit user approval
- Always confirm before executing campaign changes
- Present changes for user review before taking action
