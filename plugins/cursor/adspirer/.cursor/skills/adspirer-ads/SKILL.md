---
name: adspirer-ads
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
| Research before new campaign | Campaign Research | `WebSearch`, `WebFetch` + Adspirer tools (see Campaign Research section) |
| Research competitors | Competitive Intelligence | `WebSearch`, `WebFetch`, `analyze_search_terms`, `research_keywords` |
| Create a campaign | Campaign Creation | Campaign Research first, then platform-specific flows below |
| Reduce wasted spend | Budget Optimization | `optimize_budget_allocation`, `analyze_wasted_spend`, `analyze_search_terms` |
| Switch accounts | Account Management | `switch_primary_account` |
| Compare platforms | Cross-Platform | Call each platform's performance tool, present side-by-side |
| Check ad fatigue | Creative Management | `detect_meta_creative_fatigue`, `analyze_linkedin_creative_performance` |
| Understand audiences | Audience Analysis | `get_meta_audience_insights`, `get_linkedin_audience_insights` |
| Add ad extensions | Ad Extensions | `add_sitelinks`, `add_callout_extensions`, `add_structured_snippets`, `list_campaign_extensions` |
| Change bidding strategy | Bidding Strategy | `update_bid_strategy`, `get_campaign_structure` |
| Add/manage keywords | Keyword Management | `add_keywords`, `remove_keywords`, `update_keyword`, `add_negative_keywords`, `remove_negative_keywords` |
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

## Campaign Research (run before creating ANY new campaign)

Before creating a campaign on any platform, research the brand's market position and competitive landscape. This combines web research (native tools) with ad platform data (Adspirer MCP) to inform every campaign decision — targeting, messaging, differentiation, and bidding.

### Step 1: Understand the brand's own website
Use `WebFetch` to crawl the brand's website. Extract:
- What they sell (products, services, pricing tiers)
- Key value propositions and differentiators
- Target audience language (how they describe their customers)
- Pricing (plans, tiers, free trial availability)
- Trust signals (customer logos, testimonials, case studies, awards)
- CTAs used on the site (what actions they push visitors toward)

### Step 2: Research the competitive landscape
Use `WebSearch` to search for:
- `"[brand's product category] competitors"` — find who they compete with
- `"[competitor name] vs [brand name]"` — find comparison content
- `"[competitor name] pricing"` — understand competitor price points
- `"best [product category] [current year]"` — find review/comparison sites

Then use `WebFetch` to crawl the top 3-5 competitor websites. Extract:
- Their positioning and messaging (how they describe themselves)
- Their pricing (cheaper? more expensive? different model?)
- Their unique claims (what do they say they do better?)
- Their target audience (who are they speaking to?)

### Step 3: Identify differentiation
Combine brand website + competitor research to answer:
- What does this brand do that competitors don't? (unique features, approach, pricing)
- What language resonates in this market? (common pain points, desired outcomes)
- Where are the gaps? (underserved audiences, unaddressed pain points)
- What should ad copy emphasize to stand out?

### Step 4: Pull existing ad intelligence from Adspirer
- `get_campaign_performance` — what's already running and how it performs
- `analyze_search_terms` — what real users search for (Google Ads)
- `get_campaign_structure` — current ad copy and targeting
- `get_benchmark_context` — industry benchmarks for this vertical

### Step 5: Create a research brief
Present findings to the user before proceeding with campaign creation:
- Market overview (key competitors, price ranges, positioning)
- Recommended differentiation angles (what to emphasize in ads)
- Suggested audiences based on competitive gaps
- Messaging direction (informed by competitor weaknesses and brand strengths)

Get user input on the direction before proceeding to keyword research and campaign creation.

## Keyword Research (Google Ads)

Always run before creating Search campaigns. Never use generic SEO keywords.

- Tool: `research_keywords`
- Params: `business_description` or `seed_keywords`, optional `website_url`, `target_location`
- Group results by intent (high/medium/low), show search volume, CPC ranges, competition
- Use insights from Campaign Research to inform seed keywords — include competitor brand terms, differentiation keywords, and pain-point language discovered during research

## Bidding Strategy

**Before creating ANY Google Ads campaign, discuss bidding strategy with the user.**

1. Pull past performance: `get_campaign_performance` (lookback_days: 90)
2. Review existing strategies: `get_campaign_structure` to see what bidding strategies current campaigns use
3. Recommend a strategy based on data:

| Scenario | Recommended Strategy | Reasoning |
|----------|---------------------|-----------|
| New advertiser (no conversion data) | Maximize Clicks | Build traffic data first. Switch to Maximize Conversions after 30+ conversions. |
| Has conversion data (30+ conversions/month) | Maximize Conversions or Target CPA | Enough data for Smart Bidding to optimize. |
| Known target CPA | Target CPA | Set CPA at or slightly above historical average. |
| E-commerce with ROAS goals | Target ROAS | Set ROAS target based on margins and historical performance. |
| Brand campaign | Manual CPC or Maximize Clicks | Control spend on branded terms. Low CPCs expected. |
| High-value B2B leads | Target CPA | Long sales cycles need CPA control. Start 20% above current CPA, tighten over time. |

4. Present recommendation with reasoning to the user
5. Get explicit approval before setting the strategy
6. To change strategy on existing campaigns: `update_bid_strategy`

**Important:** Never silently pick a bidding strategy. Always explain the trade-offs and let the user decide.

## Campaign Creation

**For ALL new campaigns**: Run Campaign Research first (see section above) unless the user has already provided competitive context or this is a follow-up campaign for an existing brand workspace with research already done.

**Google Ads Search (exact order):**
1. Campaign Research — crawl brand + competitor websites via `WebFetch`/`WebSearch`, present research brief
2. `research_keywords` — mandatory, informed by competitive research
3. Discuss bidding strategy with user (see Bidding Strategy section above)
4. `discover_existing_assets` — check for existing ad assets
5. `validate_and_prepare_assets` — validate before creation (use differentiation angles from research in ad copy)
6. `create_search_campaign` — create the campaign (PAUSED status)
7. Add ad extensions (see Ad Extensions section below):
   - Crawl user's website with `WebFetch` to find real page URLs
   - `add_sitelinks` — add 10+ validated sitelinks
   - `add_callout_extensions` — add 4+ callouts (use value props from research)
   - `add_structured_snippets` — add relevant structured snippets
8. `list_campaign_extensions` — verify all extensions were added

**Google Ads Performance Max:**
1. Campaign Research — crawl brand + competitor websites via `WebFetch`/`WebSearch`, present research brief
2. Discuss bidding strategy with user (see Bidding Strategy section above)
3. `discover_existing_assets` — check existing assets
4. `validate_and_prepare_assets` — validate creative assets (use differentiation angles from research)
5. `create_pmax_campaign` — create the campaign
6. Add ad extensions (same as Search — sitelinks, callouts, snippets)
7. `list_campaign_extensions` — verify all extensions were added

**Meta Ads:**
1. Campaign Research — crawl brand + competitor websites, understand audience positioning
2. `get_connections_status` — verify Meta account connected
3. `search_meta_targeting` or `browse_meta_targeting` — find audiences (informed by competitive gaps)
4. Create campaign — created in PAUSED status

**LinkedIn Ads:**
1. Campaign Research — crawl brand + competitor websites, understand B2B positioning
2. `get_linkedin_organizations` — get linked company pages
3. `discover_linkedin_assets` — check existing assets
4. `validate_and_prepare_linkedin_assets` — validate assets
5. `create_linkedin_image_campaign` — create the campaign

**TikTok Ads:**
1. Campaign Research — crawl brand website, research competitor video ad strategies via `WebSearch`
2. `discover_tiktok_assets` — check existing assets
3. `validate_and_prepare_tiktok_assets` — validate video assets
4. `create_tiktok_campaign` or `create_tiktok_video_campaign` — create the campaign

## Ad Extensions (Google Ads)

Ad extensions improve Quality Score, increase ad real estate, and boost CTR. **Always add extensions after creating a Google Ads campaign.**

### Before Adding Extensions

Call `list_campaign_extensions` to check what already exists on the campaign. Never duplicate existing extensions.

### Sitelinks (`add_sitelinks`)

Sitelinks are the most impactful extension. Target **10+ sitelinks** (more is better — Google rotates the best performers).

**Workflow:**
1. Use `WebFetch` to crawl the user's website homepage — extract all navigation links and key pages
2. Build a candidate list of pages to include:
   - Homepage, Pricing/Plans, About Us, Contact, Key product/service pages, Blog, Case Studies/Testimonials, FAQ/Help, Free Trial/Demo, Careers
3. **Validate each URL** — use `WebFetch` on each candidate URL to confirm it loads (no 404s, no redirects to error pages)
4. For each valid sitelink, prepare:
   - **Link text**: max 25 characters, descriptive (e.g., "View Pricing Plans")
   - **Description line 1**: max 35 characters (e.g., "Plans starting at $29/month")
   - **Description line 2**: max 35 characters (e.g., "Free 14-day trial included")
   - **Final URL**: the validated page URL
5. If fewer than 8 valid pages found → ask the user for additional URLs or pages to include
6. Present the full sitelink list to the user for review before adding
7. Call `add_sitelinks` with the approved list

### Callout Extensions (`add_callout_extensions`)

Callouts highlight value propositions. Target **8+ callouts** (minimum 4).

**Workflow:**
1. Extract value propositions from:
   - Website content (crawled via `WebFetch`)
   - Brand docs (BRAND.md if it exists)
   - Existing ad copy in the account
2. Each callout: max **25 characters**
3. Examples: "Free Shipping", "24/7 Support", "No Setup Fee", "Cancel Anytime", "Money-Back Guarantee", "Same-Day Delivery", "Award-Winning", "Trusted by 10K+"
4. Present to user for approval, then call `add_callout_extensions`

### Structured Snippets (`add_structured_snippets`)

Snippets show predefined categories of offerings. Pick headers relevant to the business.

**Available headers:** Brands, Courses, Destinations, Featured Hotels, Insurance Coverage, Models, Neighborhoods, Service Catalog, Shows, Styles, Types

**Workflow:**
1. Review the user's website and business type to pick relevant headers
2. Extract 3-10 values per header from website content
3. Example: SaaS company → Header "Types" with values "Analytics, Reporting, Dashboards, API Access"
4. Example: E-commerce → Header "Brands" with values "Nike, Adidas, Puma, New Balance"
5. Present to user, then call `add_structured_snippets`

### Price Extensions

If the user's website has a pricing page:
1. Use `WebFetch` to crawl the pricing page
2. Extract plan names, prices, and descriptions
3. Present to user for confirmation before adding
4. Useful for SaaS, services with tiered pricing, or e-commerce with featured products

### Call Extensions

If the business has a phone number:
1. Ask the user for their business phone number
2. Discuss call tracking preferences (use Google forwarding number or direct?)
3. Set call hours if business has limited availability

### Extension Verification

After adding all extensions, always call `list_campaign_extensions` to verify:
- All sitelinks were added and have correct URLs
- Callouts are present
- Structured snippets are showing
- Report back to the user what was added

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
   - Present new creative options (filtered through brand voice if BRAND.md exists)
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

### Step 1: Identify competitors
- Read BRAND.md for known competitors (check Competitors section)
- Use `WebSearch` to search `"[brand product category] competitors [current year]"` and `"[brand name] alternatives"`
- Use `WebSearch` to find review/comparison sites: `"best [product category] [current year]"`

### Step 2: Research competitor positioning
For each key competitor (top 3-5):
- Use `WebFetch` to crawl their website homepage — extract messaging, value props, positioning
- Use `WebFetch` to crawl their pricing page — extract plans, pricing model, free tier
- Use `WebSearch` to search `"[competitor] ads"` or `"[competitor] Google Ads"` — find their ad copy if visible
- Use `WebFetch` to crawl competitor landing pages found in search results — analyze their conversion approach

### Step 3: Analyze ad platform data
- `analyze_search_terms` — find competitor brand terms appearing in our search queries
- `research_keywords` — get search volume and CPC for competitor brand + product terms
- `get_campaign_structure` — check if we already bid on competitor terms

### Step 4: Assess competitive position
- Are competitors bidding on our brand terms? (defensive strategy needed)
- Which competitor keywords have high volume + reasonable CPC?
- Where do we differentiate? (pricing, features, audience, positioning)
- What messaging do competitors use that we should counter or avoid?
- Are there underserved niches competitors ignore?

### Step 5: Recommend actions
- **Brand defense campaigns**: exact match on own brand terms (if competitors are bidding on them)
- **Competitor conquest campaigns**: bid on competitor brand terms with ad copy emphasizing our differentiators
- **Differentiation messaging**: specific claims based on competitive gaps (e.g., "50% cheaper than [competitor]", "No setup fee unlike [competitor]")
- **Negative keywords**: exclude competitor terms where intent doesn't match (e.g., "[competitor] login" — existing customers, not prospects)
- Update BRAND.md Competitors section with findings

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
| Google Ads | `get_campaign_performance`, `research_keywords`, `create_search_campaign`, `create_pmax_campaign`, `optimize_budget_allocation`, `analyze_wasted_spend`, `analyze_search_terms`, `suggest_ad_content`, `get_campaign_structure`, `discover_existing_assets`, `add_sitelinks`, `add_callout_extensions`, `add_structured_snippets`, `list_campaign_extensions`, `update_bid_strategy`, `add_keywords`, `remove_keywords`, `update_keyword`, `add_negative_keywords`, `remove_negative_keywords` |
| LinkedIn Ads | `get_linkedin_campaign_performance`, `create_linkedin_image_campaign`, `get_linkedin_organizations`, `analyze_linkedin_creative_performance`, `get_linkedin_audience_insights`, `research_business_for_linkedin_targeting`, `generate_linkedin_ad_creatives` |
| Meta Ads | `get_meta_campaign_performance`, `search_meta_targeting`, `browse_meta_targeting`, `detect_meta_creative_fatigue`, `get_meta_audience_insights`, `analyze_meta_audiences`, `optimize_meta_placements`, `analyze_meta_wasted_spend` |
| TikTok Ads | `create_tiktok_campaign`, `create_tiktok_video_campaign`, `discover_tiktok_assets`, `validate_and_prepare_tiktok_assets` |
| Account | `get_connections_status`, `switch_primary_account`, `get_business_profile`, `get_usage_status` |
| Monitoring | `create_monitor`, `list_monitors`, `schedule_brief`, `generate_report_now`, `list_scheduled_tasks` |
| Research (native) | `WebSearch` (search the web for competitors, market data, trends), `WebFetch` (crawl websites for pricing, messaging, sitelink URLs, value props) |

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
