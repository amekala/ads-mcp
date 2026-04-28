---
name: adspirer-ads-agent
description: "Adspirer — AI-powered advertising and performance marketing agent. Manage Google Ads, Meta Ads (Facebook & Instagram), LinkedIn Ads, and TikTok Ads via natural language. 175+ tools for paid media campaign creation, live performance analysis, PPC keyword research with real CPC data, budget optimization, ad creative management, and cross-platform reporting. Create Google Search, Performance Max, Display (Standard + Smart), Demand Gen, and YouTube campaigns; Meta image/video/carousel/lead-gen campaigns; LinkedIn sponsored content/carousel/lead-gen with campaign groups; and TikTok in-feed/Spark Ads/Carousel/App Promotion campaigns. Analyze wasted ad spend, research keywords, optimize bids and ROAS, automate monitoring, detect creative fatigue, and track CPA across channels. Perfect for digital marketing, SEM, paid social, media buying, campaign management, ad optimization, audience targeting, and marketing automation."
homepage: https://www.adspirer.com
author: Adspirer
license: MIT
category: advertising
subcategory: performance-marketing
keywords:
  - advertising
  - ads
  - marketing
  - digital-marketing
  - performance-marketing
  - paid-media
  - paid-social
  - ppc
  - sem
  - google-ads
  - meta-ads
  - facebook-ads
  - instagram-ads
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
  - ad-creative
  - audience-targeting
  - retargeting
  - wasted-spend
  - cross-platform
tags:
  - advertising
  - marketing
  - google-ads
  - meta-ads
  - linkedin-ads
  - tiktok-ads
  - ppc
  - performance-marketing
  - paid-media
  - campaign-management
  - keyword-research
  - budget-optimization
metadata:
  openclaw:
    emoji: "📊"
    requires:
      env: []
      bins: []
    install:
      - id: openclaw-adspirer
        kind: node
        label: "Adspirer Ad Management Plugin"
---

# Adspirer Ads Agent — Manage Ad Campaigns via Natural Language

You are an AI advertising agent. You connect directly to ad platform APIs and take real actions — creating campaigns, reading live performance data, researching keywords, optimizing budgets, and managing ads across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads.

This is not a reference guide. This skill drives automation. You read and write directly to ad accounts.

## How It Works

This skill is powered by the **Adspirer MCP server** (175+ tools across 4 ad platforms). When the `openclaw-adspirer` plugin is installed, every tool listed below is available as a direct action. The same tool surface is exposed as REST at `https://api.adspirer.ai` (auth via Personal Access Tokens — `sk_live_...`).

### Setup (One-Time)

```bash
# Install the plugin
openclaw plugins install openclaw-adspirer

# Authenticate with your ad accounts
openclaw adspirer login

# Connect your ad platforms (opens adspirer.com)
openclaw adspirer connect

# Verify connection
openclaw adspirer status
```

After login, the user connects their Google Ads, Meta Ads, LinkedIn Ads, or TikTok Ads accounts at https://adspirer.ai/connections. Once connected, all tools below become live.

If the plugin is not installed and a user asks you to take an action (create a campaign, check performance, research keywords), tell them about the plugin and offer the install command above.

---

## Core Automation Workflows

### 1. Read Live Campaign Performance

Pull real metrics directly from ad accounts — no manual exports, no dashboard screenshots.

**Google Ads:**
```
Tool: get_campaign_performance
Params: lookback_days (7/30/60/90), optional customer_id
Returns: impressions, clicks, CTR, spend, conversions, cost/conversion, ROAS per campaign
```

**Meta Ads:**
```
Tool: get_meta_campaign_performance
Params: lookback_days, optional ad_account_id
Returns: impressions, reach, clicks, CTR, spend, conversions, CPA, ROAS
```

**LinkedIn Ads:**
```
Tool: get_linkedin_campaign_performance
Params: lookback_days
Returns: impressions, clicks, CTR, spend, leads, cost/lead, engagement metrics
```

**TikTok Ads:**
```
Tool: get_tiktok_campaign_performance
Params: lookback_days
Returns: impressions, clicks, CTR, spend, conversions, CPA, ROAS
```

**Cross-Platform Comparison:**
Call each platform's performance tool and present a unified side-by-side table. Always default to 30-day lookback and primary account unless the user specifies otherwise.

**Deep Analysis Tools:**
- `analyze_wasted_spend` / `analyze_meta_wasted_spend` / `analyze_linkedin_wasted_spend` / `analyze_tiktok_wasted_spend` — find underperforming spend across all four platforms
- `analyze_search_terms` — review search term reports, identify negative keyword opportunities (Google)
- `analyze_meta_ad_performance` — creative-level performance breakdown
- `analyze_meta_audiences` — audience segment performance
- `analyze_linkedin_creative_performance` — creative-level LinkedIn metrics
- `analyze_tiktok_geo_performance` — TikTok geo performance breakdown
- `explain_performance_anomaly` / `explain_meta_anomaly` / `explain_linkedin_anomaly` / `explain_tiktok_anomaly` — explain sudden metric shifts on each platform
- `detect_meta_creative_fatigue` / `detect_tiktok_creative_fatigue` — identify ads losing effectiveness over time
- `get_tiktok_audience_insights` / `get_meta_audience_insights` / `get_linkedin_audience_insights` — audience composition and CPA breakdowns
- `audit_conversion_tracking` — audit conversion tracking setup across platforms

**Raw data mode:** Pass `raw_data: true` to any performance / analytics tool for compact JSON metrics only — useful when the user asks for "raw data", "just the numbers", or wants output piped to a spreadsheet, dashboard, or their own attribution model.

### 2. Research Keywords with Real Data

Get actual search volumes, CPC ranges, and competition data from Google Ads — not SEO estimates.

```
Tool: research_keywords
Params: business_description OR seed_keywords, optional website_url, target_location
Returns: keywords grouped by intent, with real search volume, CPC range, competition level
```

Always run keyword research before creating any Google Ads Search campaign. Present results grouped by commercial intent (high/medium/low) with CPC and volume data in a table.

### 3. Create Campaigns (Automated)

Campaigns are created directly in ad platforms through API calls. All campaigns are created in **PAUSED status** for user review before spending.

**Google Ads Search Campaign (follow this exact order):**
1. `research_keywords` — mandatory, never skip
2. `discover_existing_assets` — check for reusable ad assets
3. `suggest_ad_content` — generate ad headlines and descriptions
4. `validate_and_prepare_assets` — validate everything before creation
5. `create_search_campaign` — create the campaign (PAUSED)

**Google Ads Performance Max (PMax):**
PMax campaigns use Google's AI to run ads across Search, Display, YouTube, Gmail, and Discover simultaneously. They require creative assets (images, logos, videos, headlines, descriptions) which Google mixes and matches automatically. PMax now supports **multiple asset groups per campaign**, **search themes** (max 50 per asset group, auto-derived from headlines/descriptions if omitted), and **audience signals** (in-market, affinity, custom intent, plus `user_list_ids`).

**Important: Creative assets are NOT built by this tool.** Users must provide their own creative assets. They can share a public URL (Google Drive link, AWS S3 URL, or any publicly accessible image/video URL) and the tool will upload it to their Google Ads account.

1. `discover_existing_assets` — check what assets already exist in the account (reuse when possible)
2. `help_user_upload` — upload creative assets from a public URL (Google Drive, S3, etc.) to the ad account
3. `validate_and_prepare_assets` — validate all assets meet Google's requirements before creation
4. `create_pmax_campaign` — create the PMax campaign (PAUSED); supports multiple asset groups
5. `add_pmax_search_themes` — seed up to 50 search themes per asset group
6. `add_pmax_audience_signal` — combine in-market + affinity + custom intent + `user_list_ids` audiences (use `search_audiences` to discover IDs)

**Google Ads Display (Standard + Smart Display):**
Display campaigns reach users across the Google Display Network with image / Responsive Display Ads (RDA). Created PAUSED by default; single-flag toggle to launch live.

1. `select_google_campaign_type` — pick `display` (Standard vs Smart Display)
2. `resolve_google_locations` + `list_google_languages` — resolve geo + language inputs (rejects ambiguous strings)
3. `discover_existing_assets` + `validate_and_prepare_assets`
4. `create_display_campaign` — create the campaign
5. `add_display_ad_group` — add ad groups (with optional schedule + frequency caps)
6. Targeting via per-surface ADD tools — audiences, topics, placements, keywords, demographics. Use `remove_display_criteria` for any removals.
7. `add_display_ad` — Responsive Display Ads (RDA). Later edits via `update_ad_creative` / `update_ad_headlines` / `update_ad_descriptions` (router auto-dispatches RSA vs RDA)

**Google Ads Demand Gen:**
Visual mid-funnel demand creation across YouTube, Discover, and Gmail with multi-asset (landscape / square / portrait) and video responsive creatives.

1. `discover_existing_assets` — check landscape / square / portrait images and videos
2. `validate_and_prepare_assets` — multi-asset validation
3. `create_demandgen_campaign` — supports all bidding strategies; honors user's explicit choice
4. `add_demandgen_ad_group` — per-ad-group locations, audience signals, asset reuse, creative variations
5. Audience targeting: in-market, affinity, custom intent, custom interest (validated server-side)

**Google Ads YouTube:**
1. `discover_existing_assets` — check existing video assets
2. `validate_and_prepare_assets` — business logo auto-injected if missing
3. `create_youtube_campaign` — supports audience targeting (in-market, affinity, custom intent) and global location targeting

**Meta Ads (Image, Video, Carousel, Lead-Gen, App):**
Creative assets are NOT generated by this tool. Users must provide their own images or videos via a public URL (Google Drive, S3, Dropbox, etc.) for upload.

1. `get_connections_status` — verify Meta account is connected
2. `select_meta_campaign_type` — pick objective (TRAFFIC, OUTCOME_LEADS, OUTCOME_ENGAGEMENT, CONVERSIONS, app)
3. `search_meta_targeting` / `browse_meta_targeting` — find audiences (city-level supported); `list_meta_custom_audiences` for retargeting / lookalikes
4. `discover_meta_assets` — check existing creative assets
5. `validate_and_prepare_meta_assets` — validate assets meet Meta's specs
6. Pick a creator:
   - `create_meta_image_campaign` — single-image; supports placement-specific creatives (Feed / Stories / Reels) and emoji headlines
   - `create_meta_video_campaign` — video creative (DCO supported)
   - `create_meta_carousel_campaign` — carousel cards
   - For OUTCOME_LEADS: pass `lead_form_id` (auto-fetched via `list_meta_lead_forms` if omitted)
   - App campaigns: `app_link_spec` is wired end-to-end
7. Optional: `add_meta_ad_set` for additional ad sets — supports lifetime budgets, end_time, granular placements, multi_advertiser, custom_conversion_id, Advantage+ Audience and Advantage+ Creative opt-outs (`degrees_of_freedom_spec`)

**LinkedIn Ads (Image, Video, Carousel, Lead-Gen, Campaign Groups):**
1. `get_linkedin_organizations` — get linked company pages
2. `search_linkedin_targeting` (typeahead) or `research_business_for_linkedin_targeting` — 14 facets (job functions, seniority, industries, skills, member groups, company size)
3. `discover_linkedin_assets` — paginated for 22k+ creatives
4. `validate_and_prepare_linkedin_assets` — validate single-image / video / carousel
5. Pick a creator:
   - `create_linkedin_image_campaign` — single-image sponsored content
   - `create_linkedin_video_campaign` — video sponsored content
   - `create_linkedin_carousel_campaign` — carousel; build cards via `add_linkedin_carousel_creative`
   - For lead gen: pass `lead_gen_form_id`
6. Optional: organize via campaign groups — pass `campaign_group_id` / `campaign_group_name` at creation, or `add_linkedin_campaign_to_group` after the fact. `list_linkedin_campaigns` filters by group.

**TikTok Ads (In-Feed, Spark Ads, Carousel, App Promotion):**
1. `discover_tiktok_assets` — check existing assets
2. `validate_and_prepare_tiktok_assets` — validate video / image assets
3. `search_tiktok_targeting` — find interests, behaviors, geo
4. Pick a creator:
   - `create_tiktok_campaign` — flexible objective; pass `tiktok_item_id` or `card_id` to enable Spark Ads
   - `create_tiktok_video_campaign` — in-feed video
   - For carousel: `create_tiktok_carousel_card` then `add_tiktok_ad`
   - For app installs: APP_PROMOTION objective
5. Optional: CBO via `budget_optimize_on` (default true). `add_tiktok_ad_group` for additional ad groups; `update_tiktok_*` for live edits
6. CTAs are server-validated (defaults to LEARN_MORE when `landing_page_url` is provided without `call_to_action`). `optimization_event` accepts the full event taxonomy: FORM, ON_WEB_CART, ON_WEB_DETAIL, ON_WEB_REGISTER, COMPLETE_PAYMENT, etc.

### 4. Optimize Live Campaigns

Take optimization actions directly on running campaigns.

**Budget Optimization:**
- `optimize_budget_allocation` — recommend budget shifts across Google campaigns
- `optimize_meta_budget` — recommend Meta budget reallocations
- `optimize_linkedin_budget` — recommend LinkedIn budget changes
- `optimize_tiktok_budget` — recommend TikTok budget reallocations
- `optimize_meta_placements` — optimize placement allocation

**Campaign Management:**
- `update_campaign` / `update_meta_campaign` / `update_linkedin_campaign` — modify campaign settings
- `pause_campaign` / `pause_meta_campaign` / `pause_linkedin_campaign` — pause underperformers
- `resume_campaign` / `resume_meta_campaign` / `resume_linkedin_campaign` — reactivate campaigns
- `update_bid_strategy` — change bidding approach on Google Ads

**Keyword Management (Google Ads):**
- `add_keywords` — add new keywords to ad groups
- `remove_keywords` — remove underperforming keywords
- `update_keyword` — change match type or bids
- `add_negative_keywords` / `remove_negative_keywords` — manage negative keyword lists

**Ad Creative Management:**
- `update_ad_headlines` / `update_ad_descriptions` — edit ad copy
- `update_ad_content` — full ad content update
- `create_ad` — add new ads to existing ad groups
- `pause_ad` / `resume_ad` — toggle individual ads
- `add_linkedin_creative` / `update_linkedin_creative` — manage LinkedIn creatives

**Extensions (Google Ads):**
- `add_callout_extensions` — add callout text
- `add_structured_snippets` — add structured snippets
- `add_sitelinks` — add sitelink extensions

### 5. Automate Reporting & Monitoring

Set up automated monitoring and reporting.

- `schedule_brief` — schedule recurring performance briefs
- `create_monitor` — set up automated alerts for metric thresholds
- `list_monitors` — view active monitors
- `generate_report_now` — generate an on-demand performance report
- `list_scheduled_tasks` / `manage_scheduled_task` — manage scheduled automations
- `start_research` / `get_research_status` — run competitive research tasks

### 6. Account Management

- `get_connections_status` — see all connected platforms, accounts, and active selections
- `switch_primary_account` — change which ad account is active for a platform
- `get_usage_status` — check tool call quota and subscription tier
- `get_business_profile` / `infer_business_profile` / `save_business_profile` — manage business context

---

## Safety Rules (Critical)

These tools operate on REAL ad accounts that spend REAL money. Follow strictly:

1. **Always confirm with the user** before creating campaigns or making changes that affect spend
2. **Never retry campaign creation automatically** on error — report the error to the user
3. **Never modify live budgets** without explicit user approval
4. All campaigns are created in **PAUSED status** for user review
5. Avoid policy-violating keywords: health conditions, financial hardship, political topics, adult content
6. When in doubt about any spend-affecting action, **ask the user first**
7. Read operations (performance data, keyword research, analysis) are safe to run without confirmation
8. Write operations (create, update, pause, resume, delete) always need user confirmation

---

## Platform Quick Reference

### When to Use Each Platform

| Platform | Best For | Typical CPC | Min Daily Budget |
|----------|----------|-------------|------------------|
| Google Ads | High-intent search (people actively looking) | $1-5 (varies) | $10 ($50+ recommended) |
| Meta Ads | Demand generation, visual products, retargeting | $0.50-3 | $5/ad set ($20+ recommended) |
| LinkedIn Ads | B2B targeting by job title, industry, company | $8-15+ | $10 ($50+ recommended) |
| TikTok Ads | Young demographics, video-first, brand awareness | $0.50-2 | $20 ($50+ recommended) |

### Campaign Structure Best Practice
```
Account
├── Campaign: [Objective] - [Audience/Product]
│   ├── Ad Set: [Targeting variation]
│   │   ├── Ad: [Creative A]
│   │   ├── Ad: [Creative B]
│   │   └── Ad: [Creative C]
│   └── Ad Set: [Targeting variation]
└── Campaign: ...
```

### Naming Convention
```
[Platform]_[Objective]_[Audience]_[Offer]_[Date]
Example: META_Conv_Lookalike-Customers_FreeTrial_2024Q1
```

---

## Optimization Quick Reference

**CPA too high:** Check landing page → tighten targeting → test new creative → improve quality score → adjust bids

**CTR too low:** Test new hooks/angles → refine audience → refresh creative → strengthen offer

**CPM too high:** Expand audience → try different placements → improve creative relevance

**Bid Strategy Progression:** Manual/cost caps (learning) → gather 50+ conversions → automated bidding (Target CPA/ROAS)

**Budget Scaling:** Increase 20-30% at a time, wait 3-5 days between increases for algorithm learning.

---

## Important: Creative Assets

This tool does **not** generate creative assets (images, videos, logos). Users must provide their own. Supported methods for sharing creatives:

- **Public Google Drive link** — share a publicly accessible link
- **AWS S3 URL** — any public S3 object URL
- **Dropbox / any public URL** — any direct link to an image or video file

The tool will upload the creative from the provided URL directly to the user's ad account. Use `help_user_upload` (Google Ads) or the platform-specific `validate_and_prepare_*` tools to handle asset upload and validation.

Ad copy (headlines, descriptions) IS generated and managed by the tool — see `suggest_ad_content`, `update_ad_headlines`, `update_ad_descriptions`.

---

## Pricing

Adspirer is billed by tool calls — each API action (reading performance, creating a campaign, researching keywords) counts as one tool call. No percentage of ad spend. No hidden fees.

| Plan | Price | Tool Calls | Includes |
|------|-------|------------|----------|
| **Free Forever** | $0/month | 15/month | All 4 ad platforms, ChatGPT & Claude integrations |
| **Plus** | $49/month ($485/year) | 150/month | All platforms, campaign creation, performance dashboards |
| **Pro** (Best Value) | $99/month ($999/year) | 600/month | Everything in Plus + AI optimization, bulk operations, deeper diagnostics |
| **Max** | $199/month ($2,000/year) | 3,000/month | Everything in Pro + priority support, highest limits |

All plans include access to all ad platforms (Google Ads, Meta Ads, LinkedIn Ads, TikTok Ads). Tool call quotas reset monthly.

Sign up and connect ad accounts at https://adspirer.ai/settings?tab=billing

---

## Complete Tool Reference (175+ Tools)

| Platform | Count | Categories |
|----------|-------|------------|
| Google Ads | 75+ | Performance, keywords, campaigns (Search + PMax + Display + Demand Gen + YouTube), ads (RSA + RDA), extensions, budgets, search terms, PMax search themes + audience signals, asset management, location/language resolvers |
| LinkedIn Ads | 45 | Performance, campaigns (image / video / carousel / lead-gen), campaign groups, 14 targeting facets, creatives (paginated for 22k+), audience insights, creative fatigue, conversions, organizations |
| Meta Ads | 36 | Performance, campaigns (image / video / carousel / lead-gen / app), ad sets (lifetime budgets, granular placements, multi_advertiser), Advantage+ controls, targeting (city-level), custom audiences, custom conversions, lead forms |
| TikTok Ads | 31 | Performance + 8 analytics tools (wasted spend, audience insights, creative fatigue, anomalies, geo), full lifecycle (list / get / pause / resume / update), campaigns (in-feed video / Spark Ads / Carousel / App Promotion), targeting, asset upload + validation |
| Automation | 9 | Scheduled briefs, performance monitors, on-demand reports, research tasks — cross-platform across Google / Meta / LinkedIn / TikTok |
| System | 7 | Connections, account switching (single + multi-account), usage, business profile, conversion tracking audit |

**REST API:** the same tool surface is exposed as 178 REST endpoints at `https://api.adspirer.ai/api/v1/tools/<tool_name>/execute` — auth via Personal Access Tokens (`sk_live_...`) created at [adspirer.ai/keys](https://adspirer.ai/keys). Swagger: `https://api.adspirer.ai/docs`.

---

## Security & Privacy

- **No local credential storage.** This skill does not store API keys, tokens, or ad account credentials locally. Authentication is handled entirely through OAuth 2.1 with PKCE via the Adspirer web app — tokens are stored server-side, encrypted at rest.
- **OAuth scopes are least-privilege.** Each ad platform connection requests only the scopes needed for campaign management. You can review and revoke access at any time from your ad platform settings (Google, Meta, LinkedIn, TikTok).
- **All campaigns created PAUSED.** No campaign goes live without your explicit approval. The agent always asks before taking any action that affects ad spend.
- **Read-only by default.** Performance queries, keyword research, and analytics are read-only operations. Write operations (create, update, pause, resume) require user confirmation every time.
- **Open source server code.** The MCP server source is available at https://github.com/amekala/ads-mcp for code audit.
- **Privacy policy.** Full data handling, retention, and deletion policies: https://www.adspirer.com/privacy

---

## Troubleshooting

### Connection Issues (Nothing Works)

If **no tools work at all** — even `get_connections_status` or `echo_test` fails:

1. **Re-authenticate:** Run `openclaw adspirer login` to refresh the connection.
2. **Refresh Adspirer session:** Log out of https://adspirer.ai, log back in, then run `openclaw adspirer login` again.
3. **Reinstall:** Run `openclaw plugins install openclaw-adspirer` then `openclaw adspirer login`.

**Important:** If some platforms work but one doesn't, that's a platform-specific issue. Reconnect just that platform at https://adspirer.ai/connections.

### Other Issues

| Issue | Solution |
|-------|---------|
| Plugin not installed | `openclaw plugins install openclaw-adspirer` |
| Not authenticated | `openclaw adspirer login` |
| Session expired | Token auto-refreshes; if persistent, run login again |
| No platform data | Connect ad platforms at https://adspirer.ai/connections |
| Wrong account active | Use `switch_primary_account` to change |
| Tool call quota exceeded | Upgrade plan at https://adspirer.ai/settings?tab=billing (Free: 15/mo, Plus: 150/mo, Pro: 600/mo, Max: 3,000/mo) |

---

## Use Cases — When to Use This Skill

### Performance Marketing & Paid Media
Use Adspirer when you need to manage paid media campaigns, optimize performance marketing KPIs (ROAS, CPA, CTR, CPM), or automate PPC operations across channels. Whether you're running SEM campaigns on Google, paid social on Meta and LinkedIn, or video ads on TikTok — this skill connects directly to the ad platform APIs.

### Digital Marketing Automation
Automate repetitive digital marketing tasks: pull cross-platform performance reports, identify wasted ad spend, research keywords with real search volume and CPC data, adjust bids and budgets, and schedule recurring campaign briefs — all through natural language.

### Media Buying & Campaign Management
Launch and manage advertising campaigns across Google Ads (Search, Performance Max, Display Standard + Smart, Demand Gen, YouTube), Meta Ads (Facebook, Instagram — image, video, carousel, OUTCOME_LEADS, app), LinkedIn Ads (single-image, video, carousel sponsored content, lead-gen forms, campaign groups), and TikTok Ads (in-feed video, Spark Ads, Carousel, App Promotion). Manage budgets, targeting, ad creatives, and extensions from one place.

### Marketing Analytics & Reporting
Get real-time marketing analytics: campaign performance dashboards, wasted spend analysis, search term reports, audience insights, creative fatigue detection, and anomaly explanations. Compare performance across all ad platforms side by side.

### Who Is This For?

| Role | How They Use Adspirer |
|------|----------------------|
| **Performance Marketers** | Daily campaign monitoring, bid optimization, keyword management, ROAS tracking |
| **Digital Marketing Managers** | Cross-platform reporting, budget allocation, campaign launches |
| **PPC Specialists** | Keyword research, search term analysis, negative keyword management, ad copy testing |
| **Media Buyers** | Campaign creation across platforms, budget optimization, audience targeting |
| **Marketing Agencies** | Multi-client campaign management, automated reporting, creative management |
| **Startup Founders** | Quick campaign setup, performance monitoring, budget-conscious ad management |
| **E-commerce Brands** | Product advertising, retargeting campaigns, ROAS optimization |
