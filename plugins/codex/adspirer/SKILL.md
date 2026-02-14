---
name: adspirer-ads
description: Manage ad campaigns across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads. Use when the user wants to analyze campaign performance, research keywords, create campaigns, optimize budgets, or manage ad accounts via the Adspirer MCP server.
metadata:
  short-description: Manage ad campaigns across Google, Meta, LinkedIn & TikTok
---

Manage advertising campaigns across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads using the Adspirer MCP server (91 tools).

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
| View campaign metrics | Performance Analysis | `get_campaign_performance`, `get_meta_campaign_performance`, `get_linkedin_campaign_performance`, `get_tiktok_campaign_performance` |
| Find keywords | Keyword Research | `research_keywords` |
| Create a campaign | Campaign Creation | See platform-specific flows below |
| Reduce wasted spend | Budget Optimization | `optimize_budget_allocation`, `analyze_wasted_spend`, `analyze_search_terms` |
| Switch accounts | Account Management | `switch_primary_account` |
| Compare platforms | Cross-Platform | Call each platform's performance tool, present side-by-side |

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

## Available Tools (91 total)

| Platform | Count | Key Tools |
|----------|-------|-----------|
| Google Ads | 39 | `get_campaign_performance`, `research_keywords`, `create_search_campaign`, `create_pmax_campaign`, `optimize_budget_allocation`, `analyze_wasted_spend` |
| LinkedIn Ads | 28 | `get_linkedin_campaign_performance`, `create_linkedin_image_campaign`, `get_linkedin_organizations` |
| Meta Ads | 20 | `get_meta_campaign_performance`, `search_meta_targeting`, `browse_meta_targeting` |
| TikTok Ads | 4 | `get_tiktok_campaign_performance` |
| Account | 2 | `get_connections_status`, `switch_primary_account` |

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
