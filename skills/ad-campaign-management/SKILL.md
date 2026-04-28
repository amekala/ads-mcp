---
name: ad-campaign-management
description: Manage ad campaigns across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads. Use when the user wants to analyze campaign performance, research keywords, create campaigns, optimize budgets, or manage ad accounts via the Adspirer MCP server.
---

Manage advertising campaigns across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads using the Adspirer MCP server (175+ tools across Google Search/PMax/Display/Demand Gen/YouTube, Meta image/video/carousel/lead-gen, LinkedIn sponsored content/carousel/lead-gen with campaign groups, and TikTok in-feed/Spark/Carousel/App Promotion).

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
- If the target platform is not connected, direct the user to https://adspirer.ai/connections

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
| Understand audiences | Audience Analysis | `get_meta_audience_insights`, `get_linkedin_audience_insights`, `search_audiences` |
| Manage PMax search themes | PMax Search Themes | `add_pmax_search_themes`, `get_pmax_search_themes`, `remove_pmax_search_themes` |
| Manage PMax audience signals | PMax Audience Signals | `add_pmax_audience_signal`, `get_pmax_audience_signals`, `remove_pmax_audience_signal`, `search_audiences` |
| Create Demand Gen campaign | Demand Gen Creation | `discover_existing_assets`, `search_audiences`, `create_demandgen_campaign` |
| Create YouTube campaign | YouTube Creation | `discover_existing_assets`, `validate_video`, `search_audiences`, `create_youtube_campaign` |
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
   - TikTok: `get_tiktok_campaign_performance`
3. For each platform, pull waste analysis:
   - Google: `analyze_wasted_spend`
   - LinkedIn: `analyze_linkedin_wasted_spend`
   - Meta: `analyze_meta_wasted_spend`
   - TikTok: `analyze_tiktok_wasted_spend`
4. Present a unified scorecard:

| Platform | Campaigns | Spend | CTR | CPA | ROAS | Waste | Health |
|----------|-----------|-------|-----|-----|------|-------|--------|
| Google   | ...       | ...   | ... | ... | ...  | ...   | ...    |
| LinkedIn | ...       | ...   | ... | ... | ...  | ...   | ...    |
| Meta     | ...       | ...   | ... | ... | ...  | ...   | ...    |
| TikTok   | ...       | ...   | ... | ... | ...  | ...   | ...    |
| **Total**| ...       | ...   |     |     |      | ...   |        |

5. Highlight:
   - Best performing platform and campaign
   - Worst performing platform and campaign
   - Total wasted spend and top waste sources
   - Budget pacing (on track, under, over)
6. Recommend top 3 actions across all platforms

## Campaign Research (run before creating ANY new campaign)

Before creating a campaign on any platform, research the brand's market position and competitive landscape. This combines web research (native tools) with ad platform data (Adspirer MCP) to inform every campaign decision — targeting, messaging, differentiation, and bidding.

### Step 0: Load Strategy Directives
Read STRATEGY.md — `## Active Directives` and skim `## Decision Log`. If directives exist, note them
as context that will inform (not skip) the research steps that follow. Directives shape
which competitors to focus on and what positioning angles to explore.

Do NOT skip Campaign Research just because directives exist. Directives may be stale,
incomplete, or based on exploratory conversations. Fresh research validates and enriches
them. However, avoid fully redundant research — if a comprehensive analysis was done
recently (check Decision Log dates), tell the user: "Strategy directives from [date]
are available. I'll use them as a starting point and validate with fresh data. Want me
to do a full re-analysis instead?"

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
- **Strategy directive filter (MANDATORY):** After `research_keywords` returns results,
  cross-reference against STRATEGY.md > Google Ads directives:
  - Deprioritize keywords matching AVOID directives. Note these to the user.
  - Highlight keywords matching PREFER directives.
  - Apply CONSTRAINT directives (match type rules, budget caps).
  - Flag conflicts: "Keyword '[term]' returned by research but conflicts with active
    directive: '[text]'. Deprioritizing it."

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
1.5. **Apply strategy directives** — load STRATEGY.md. Use as context for keyword selection,
     bidding, targeting, and ad copy throughout this creation flow.
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
9. Run post-create verification on this campaign using `get_campaign_structure`:
   - confirm ad groups exist
   - confirm keywords exist with expected match-type profile
   - confirm at least one RSA exists
10. If any required asset is missing, run one targeted remediation pass for the missing asset class only, then re-verify.
11. Do not report success until this campaign passes Launch Definition of Done.

**Google Ads Performance Max:**
1. Campaign Research — crawl brand + competitor websites via `WebFetch`/`WebSearch`, present research brief
1.5. **Apply strategy directives** — load STRATEGY.md. Use as context for bidding,
     targeting, and creative direction throughout this creation flow.
2. Discuss bidding strategy with user (see Bidding Strategy section above)
3. `discover_existing_assets` — check existing assets
4. `validate_and_prepare_assets` — validate creative assets (see PMax Asset Limits below)
5. `validate_video` — validate YouTube videos if user provides them (see PMax Asset Limits)
6. `create_pmax_campaign` — create the campaign
7. Add ad extensions (same as Search — sitelinks, callouts, snippets)
8. `list_campaign_extensions` — verify all extensions were added
9. **Add search themes (recommended)** — see PMax Search Themes & Audience Signals section below:
   - Ask user for search themes or derive from keyword research + brand context
   - `add_pmax_search_themes` — add up to 50 themes per asset group
   - `get_pmax_search_themes` — verify themes were added
10. **Add audience signals (recommended)** — see PMax Search Themes & Audience Signals section below:
    - `search_audiences` — find relevant in-market, affinity, and custom audiences
    - Present audience recommendations to user for approval
    - `add_pmax_audience_signal` — add audience signal combining selected segments

**Google Ads Demand Gen (exact order):**

Demand Gen campaigns run across YouTube (In-Feed, In-Stream, Shorts), Gmail, Discover, and Display. They support two ad formats: **multi_asset** (image ads) and **video_responsive** (video ads). Demand Gen is ideal for awareness and consideration campaigns with visual, entertainment-focused creatives.

1. Campaign Research — crawl brand + competitor websites via `WebFetch`/`WebSearch`, present research brief
2. Discuss bidding strategy with user:
   - **Maximize Clicks** (default, no conversion tracking needed)
   - **Target CPA** (requires conversion tracking)
   - **Maximize Conversions** (requires conversion tracking)
   - **Target ROAS** (requires conversion value tracking)
3. `discover_existing_assets` — check existing images, logos, videos
4. For multi_asset format: need landscape (1.91:1) OR square (1:1) images + logo
5. For video_responsive format: need YouTube video IDs (validate with `validate_video`) + logo
6. `search_audiences` — find relevant in-market, affinity audiences for `audience_segments` parameter
7. `create_demandgen_campaign` — create the campaign with:
   - `target_locations`: supports countries, states, cities globally (e.g., `["India"]`, `["Bangalore, India"]`)
   - `audience_segments`: `{"in_market_audience_ids": [80463], "affinity_audience_ids": [92913]}`
   - `channels`: optional channel controls (e.g., `{"display": false}` for YouTube + Gmail + Discover only)
   - `call_to_action`: e.g., `"LEARN_MORE"`, `"SIGN_UP"`, `"SHOP_NOW"`
   - `existing_images`: reuse from `discover_existing_assets` (preferred)
8. Add ad extensions (sitelinks, callouts, snippets)
9. `list_campaign_extensions` — verify extensions added

**Key Demand Gen details:**
- Budget: minimum ~$20/day recommended
- All campaigns created PAUSED
- Location and audience targeting are set at the **ad group level** (not campaign level)
- Audience targeting uses grouped Audience resources with in-market, affinity, and remarketing segments
- Channel controls: all channels ON by default. Disable specific channels via `channels` parameter

**Google Ads YouTube Video (exact order):**

YouTube campaigns are Demand Gen campaigns with YouTube-only channel controls (Gmail, Discover, Display disabled). They require at least one YouTube video.

1. Get user's YouTube video URL or ID
2. `validate_video` — validate the video (must be public or unlisted)
3. `discover_existing_assets` — find existing logos
4. `search_audiences` — find relevant audiences
5. `create_youtube_campaign` — create with:
   - `youtube_video_id`: primary video (11 chars)
   - `target_locations`: city/state/country level
   - `audience_segments`: in-market + affinity targeting
   - `logo_asset_id` OR `asset_bundle_id` for logo
   - `additional_video_ids`: up to 4 more videos
6. Add ad extensions (sitelinks, callouts, snippets)

**YouTube placements enabled:** In-Feed, In-Stream, Shorts
**YouTube placements disabled:** Gmail, Discover, Display

**Google Ads Display (Standard + Smart Display):**
1. Campaign Research — crawl brand + competitor sites; identify visual positioning angles
1.5. **Apply strategy directives** — load STRATEGY.md. Use for targeting and creative direction.
2. Discuss bidding strategy with user
3. `select_google_campaign_type` — confirm "display" branch (Standard vs Smart Display)
4. `resolve_google_locations` + `list_google_languages` — resolve geo + language inputs (rejects ambiguous strings)
5. `discover_existing_assets` + `validate_and_prepare_assets`
6. `create_display_campaign` — created PAUSED by default; single-flag toggle to launch live
7. `add_display_ad_group` — add ad groups (with optional schedule + frequency caps)
8. Targeting via per-surface ADD tools — audiences, topics, placements, keywords, demographics. Use `remove_display_criteria` for removals.
9. `add_display_ad` — Responsive Display Ads (RDA). Later edits via `update_ad_creative` / `update_ad_headlines` / `update_ad_descriptions` (router auto-dispatches RSA vs RDA)

**Meta Ads:**
1. Campaign Research — crawl brand + competitor websites, understand audience positioning
1.5. **Apply strategy directives** — load STRATEGY.md > Meta Ads and Cross-Platform sections.
     Use as context for audience targeting and creative direction.
2. `get_connections_status` — verify Meta account connected
3. `select_meta_campaign_type` — pick objective (TRAFFIC, OUTCOME_LEADS, OUTCOME_ENGAGEMENT, CONVERSIONS, app)
4. `search_meta_targeting` / `browse_meta_targeting` — find interest, behavior, demographic, geo (city-level supported), language; `list_meta_custom_audiences` for retargeting / lookalikes
5. `discover_meta_assets` + `validate_and_prepare_meta_assets` — validate creative
6. Create campaign — pick format:
   - `create_meta_image_campaign` — single-image; supports placement-specific creatives (Feed / Stories / Reels) and emoji headlines
   - `create_meta_video_campaign` — video creative (DCO supported)
   - `create_meta_carousel_campaign` — carousel cards
   - For OUTCOME_LEADS: pass `lead_form_id` (auto-fetched via `list_meta_lead_forms` if omitted)
   - App campaigns: `app_link_spec` is wired end-to-end
7. Optional: `add_meta_ad_set` for additional ad sets — supports lifetime budgets, end_time, granular placements (publisher_platforms, facebook_positions, instagram_positions), multi_advertiser, custom_conversion_id, Advantage+ Audience and Advantage+ Creative opt-outs (`degrees_of_freedom_spec`)

**LinkedIn Ads:**
1. Campaign Research — crawl brand + competitor websites, understand B2B positioning
1.5. **Apply strategy directives** — load STRATEGY.md > LinkedIn Ads and Cross-Platform sections.
     Use as context for targeting, messaging, and budget allocation.
2. `get_linkedin_organizations` — get linked company pages
3. `search_linkedin_targeting` (typeahead) or `research_business_for_linkedin_targeting` — 14 facets (job functions, seniority, industries, company size, skills, member groups)
4. `discover_linkedin_assets` — check existing creatives (paginated for 22k+ creatives, deduped)
5. `validate_and_prepare_linkedin_assets` — validate single-image, video, or carousel assets
6. Create campaign — pick format:
   - `create_linkedin_image_campaign` — single-image sponsored content
   - `create_linkedin_video_campaign` — video sponsored content
   - `create_linkedin_carousel_campaign` — carousel; build cards via `add_linkedin_carousel_creative`
   - For lead gen: pass `lead_gen_form_id`
7. Optional: campaign groups via `campaign_group_id` / `campaign_group_name` or `add_linkedin_campaign_to_group`. `list_linkedin_campaigns` filters by group.

**TikTok Ads:**
1. Campaign Research — crawl brand website, research competitor video ad strategies via `WebSearch`
1.5. **Apply strategy directives** — load STRATEGY.md > TikTok Ads and Cross-Platform sections.
     Use as context for creative direction and audience targeting.
2. `discover_tiktok_assets` — check existing video / image assets
3. `validate_and_prepare_tiktok_assets` — validate creative assets
4. `search_tiktok_targeting` — find interests, behaviors, geo (city-level)
5. Create campaign — pick objective:
   - `create_tiktok_campaign` — flexible objective; pass `tiktok_item_id` or `card_id` for Spark Ads (boost organic)
   - `create_tiktok_video_campaign` — in-feed video
   - APP_PROMOTION objective for app installs
   - For carousel: `create_tiktok_carousel_card` then `add_tiktok_ad`
6. Optional: CBO via `budget_optimize_on` (default true). `add_tiktok_ad_group` for additional ad groups; `update_tiktok_*` to adjust live campaigns
7. CTAs are server-validated (defaults to LEARN_MORE if `landing_page_url` provided without `call_to_action`). `optimization_event` accepts the full event taxonomy: FORM, ON_WEB_CART, ON_WEB_DETAIL, ON_WEB_REGISTER, COMPLETE_PAYMENT, CONVERSION_LEADS, PAGE_VISIT, etc.

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
   - Brand docs (CLAUDE.md if it exists)
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

If `list_campaign_extensions` fails:
1. Retry once with a corrected payload or narrower scope.
2. Cross-check extension state with `get_campaign_structure`.
3. If extension state is still unverifiable, report `PARTIAL_SUCCESS` and explicitly list what could not be confirmed.

## Launch Definition of Done (Required before reporting success)

For each created campaign, all checks below must pass:

1. Campaign exists and status is `PAUSED` (unless user explicitly approved activation).
2. Expected ad group count exists.
3. Expected keywords exist, with the planned match-type profile (EXACT/PHRASE/BROAD as specified).
4. At least one RSA exists with expected headline/description counts.
5. Required extensions exist (sitelinks, callouts, structured snippets for Google Ads campaigns).
6. Requested-vs-actual bidding strategy matches, or any drift is explicitly called out.

### Status protocol (mandatory)

- `SUCCESS`: all Launch Definition of Done checks pass for all targeted campaigns.
- `PARTIAL_SUCCESS`: campaign shell exists, but one or more required assets are missing/unverifiable after one targeted remediation pass.
- `FAILED`: campaign creation itself failed.

Never report `SUCCESS` when any verification check failed or could not be confirmed.

### Per-campaign action ledger (mandatory)

For every campaign you create or edit, log and return:
- campaign name + campaign_id
- ad_group_id values touched
- keyword add/update counts
- RSA counts (headlines/descriptions)
- extension counts (sitelinks/callouts/snippets)
- verification result per campaign (`PASS`/`FAIL`)

## Ad Quality Guardrails (Google Ads)

### Keyword-to-headline coverage

For each ad group, include unique high-intent target keywords in RSA headlines. At minimum:
- cover top 3-5 keyword themes from the ad group's keyword list
- avoid generic headline sets that omit core search intent terms
- when competitive terms are targeted, keep competitor names in keywords only if required by strategy and avoid naming competitors in ad copy unless user explicitly approves

### Asset length validation checklist (before submission)

- RSA headline: <= 30 characters
- RSA description: <= 90 characters
- Path fields: <= 15 characters each
- Sitelink text: <= 25 characters
- Sitelink description lines: <= 35 characters each
- Callout text: <= 25 characters
- Structured snippet values: follow platform limits and keep concise

Validate lengths before `create_*` or `add_*` calls. If limits are exceeded, rewrite and re-validate before submitting.

## PMax Asset Limits (CRITICAL — enforce before every PMax campaign)

Google Ads Performance Max enforces strict asset limits per asset group. Exceeding these limits causes campaign creation to fail with `ENABLED_IMAGE_ASSET_LINKS_PER_ASSET_GROUP` or similar errors. **The agent MUST enforce these limits before calling `validate_and_prepare_assets` or `create_pmax_campaign`.**

### Image Asset Limits

| Asset type | Minimum | Maximum | Notes |
|------------|---------|---------|-------|
| Landscape images (1.91:1) | 1 | 20 | Required — at least 1 |
| Square images (1:1) | 1 | 20 | Required — at least 1 |
| Portrait images (4:5) | 0 | 20 | Optional |
| **TOTAL marketing images** | **2** | **20** | **Across ALL ratios combined** |
| Square logos (1:1) | 1 | 5 | Required — at least 1 |
| Landscape logos (4:1) | 0 | 5 | Optional |

**CRITICAL**: The 20-image limit is TOTAL across landscape + square + portrait, NOT 20 per ratio. If a user provides 10 landscape + 15 square + 13 portrait = 38 images, you must reduce to 20 total.

**When user provides more than 20 total marketing images:**
1. Inform the user: "Google Ads allows max 20 marketing images total per PMax asset group across all ratios. You provided [N]. I'll select the best 20."
2. Distribute proportionally across ratios while respecting minimums (at least 1 landscape, at least 1 square)
3. Prefer keeping variety across ratios over loading up one ratio
4. `validate_and_prepare_assets` handles this automatically, but you should inform the user proactively

**When user provides fewer than minimums:**
- Missing landscape images: Ask the user to provide at least 1 landscape image (1.91:1 ratio, 1200x628px recommended)
- Missing square images: Ask the user to provide at least 1 square image (1:1 ratio, 1200x1200px recommended)
- Missing square logo: Ask the user to provide at least 1 square logo (1:1 ratio, 128x128px minimum)
- Do NOT proceed with campaign creation until minimums are met

### Text Asset Limits

| Asset type | Minimum | Maximum | Max characters |
|------------|---------|---------|---------------|
| Headlines | 3 | 15 | 30 chars each |
| Long headlines | 1 | 5 | 90 chars each |
| Descriptions | 2 | 5 | 90 chars each |
| Business name | 1 | 1 | 25 chars |

**When user provides more than the maximum:**
- Truncate to the limit, keeping the first N items
- Inform the user: "PMax allows max [N] [asset type]. Using the first [N]."

**When user provides fewer than minimums:**
- Ask for the missing assets. Example: "PMax requires at least 3 headlines. You provided 1. Please provide 2 more headlines (max 30 characters each)."
- Do NOT proceed until minimums are met

### Video Asset Limits

| Asset type | Minimum | Maximum | Requirements |
|------------|---------|---------|-------------|
| YouTube videos | 0 | 5 | Must be YouTube video IDs/URLs |

**Video validation workflow:**
1. Call `validate_video` with `platform="pmax"` for each video
2. This validates the YouTube video ID format only (11 chars, alphanumeric)
3. Google Ads API will verify the video exists, is public/unlisted, and embeddable during campaign creation
4. If user provides more than 5 videos, use only the first 5 and inform them
5. Videos are optional — campaigns can be created without them (Google will auto-generate video ads from images)

### Asset Limit Enforcement Checklist (before calling create_pmax_campaign)

Before creating any PMax campaign, verify:
- [ ] At least 1 landscape image provided
- [ ] At least 1 square image provided
- [ ] Total marketing images (landscape + square + portrait) <= 20
- [ ] At least 1 square logo provided
- [ ] At least 3 headlines (max 30 chars each)
- [ ] At least 1 long headline (max 90 chars)
- [ ] At least 2 descriptions (max 90 chars each)
- [ ] Business name provided (max 25 chars)
- [ ] Videos (if any) validated via `validate_video`
- [ ] Videos count <= 5

If any check fails, ask the user for the missing/corrected assets before proceeding.

## PMax Search Themes & Audience Signals

Search themes and audience signals are **PMax-only** features — they do not apply to Search, Display, or other campaign types. Both are configured at the asset group level.

### Search Themes

Search themes are short phrases (max 50 per asset group) that tell Google which search queries your PMax campaign should target. They supplement Google's automated targeting with explicit intent signals.

**When to add search themes:**
- During PMax campaign creation (step 9 above)
- When user wants to refine PMax targeting ("add search themes to my PMax campaign")
- When search term analysis reveals high-performing queries not yet covered
- When expanding into new market segments

**Workflow:**
1. `get_pmax_search_themes` — check existing themes on the campaign (requires `campaign_id`)
2. Derive theme candidates from:
   - Keyword research results (`research_keywords`)
   - Search term reports (`analyze_search_terms`)
   - Brand context and product categories
   - Competitive research findings
3. Present candidate themes to user for approval
4. `add_pmax_search_themes` — add approved themes (params: `campaign_id`, `search_themes` list)
5. `get_pmax_search_themes` — verify themes were added

**Limits and rules:**
- Max **50 search themes** per asset group (Google's limit)
- Duplicates are filtered automatically (case-insensitive)
- Empty/whitespace themes are filtered automatically
- Search themes only support **add** and **remove** — no update (remove + re-add instead)
- To remove: `remove_pmax_search_themes` with the theme resource names from `get_pmax_search_themes`

### Audience Signals

Audience signals tell Google which audience segments are most likely to convert. They are **signals, not hard targeting** — Google uses them as starting points and expands from there. Only **one audience signal** is allowed per asset group (containing multiple segments).

**When to add audience signals:**
- During PMax campaign creation (step 10 above)
- When user wants to add targeting to a PMax campaign
- When audience analysis reveals high-value segments
- When launching PMax for a specific product/audience niche

**Supported segment types:**
| Type | Tool parameter | Description |
|------|---------------|-------------|
| In-market audiences | `in_market_audience_ids` | Users actively researching/comparing products in a category |
| Affinity audiences | `affinity_audience_ids` | Users with sustained interests and habits |
| Custom audiences | `custom_audience_ids` | Account-level custom audience segments |
| User lists (remarketing) | `user_list_ids` | First-party data — website visitors, customer lists, CRM uploads |

**Workflow:**
1. `get_pmax_audience_signals` — check existing signals on the campaign (requires `campaign_id`)
2. Discover available audiences:
   - `search_audiences` — search by keyword across all audience types (in-market, affinity, custom)
   - Use brand context and competitive research to inform search terms
3. Present audience recommendations organized by type with rationale
4. Get user approval for segment selection
5. `add_pmax_audience_signal` — add signal with selected segment IDs
6. `get_pmax_audience_signals` — verify signal was added

**Limits and rules:**
- Only **one audience signal** per asset group — it must combine all desired segments
- To change: `remove_pmax_audience_signal` (with resource name), then `add_pmax_audience_signal` with updated segments
- Audience signals only support **add** and **remove** — no update
- Use `search_audiences` to find audience IDs — do not guess or hardcode IDs

## Conversion Tracking Limitation

Adspirer MCP currently does not configure Google Ads conversion action settings (primary vs secondary) directly.

When campaign goals depend on conversion action priority:
1. create campaigns in PAUSED status
2. tell the user exact Google Ads UI path to configure conversion actions manually
3. report campaign creation as complete only after clarifying this manual step

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

### Step 1: Identify competitors
- Read CLAUDE.md for known competitors (check Competitors section)
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
- Update CLAUDE.md Competitors section with findings

## Safety Rules

These tools create REAL campaigns that spend REAL money.

1. **Always confirm with the user** before creating campaigns or changing spend
2. **Never retry campaign creation automatically** on error
3. **Never modify live budgets** without explicit user approval
4. All campaigns created in **PAUSED status** when possible
5. When in doubt about any spend-affecting action, **ask the user first**

## Critical: Input Format Requirements

Follow these rules EXACTLY when calling Adspirer tools to avoid validation errors:

### IDs Must Be Strings
All IDs (campaign_id, ad_account_id, video_id, image_hash, ad_group_id, keyword_id, organization_id, creative_id) MUST be passed as quoted strings, never as bare integers.

- ✅ `"existing_video_id": "1333064875515942"`
- ❌ `"existing_video_id": 1333064875515942`

### Never Modify IDs
Copy IDs exactly as returned by list/discover tools. Do not round, truncate, or change any digits. If `list_campaigns` returns `campaign_id: "120240129373510507"`, use that exact value.

### Always Call List/Discover Before Create/Update
Many tools require IDs from prior tool calls:
- `list_campaigns` → get `campaign_id` before update/pause/structure
- `get_campaign_structure` → get `ad_group_id` before keyword operations
- `discover_existing_assets` → get `image_hash`, `video_id` before campaign creation
- `get_linkedin_organizations` → get `organization_id` and `account_id`

### Text Length Limits
Respect character limits — the server will reject text that's too long:
- Google Ads headline: max 30 characters
- Google Ads description: max 90 characters
- Google Ads sitelink text: max 25 characters
- Google Ads callout: max 25 characters
- Meta primary_text: max 125 characters (supports emojis, line breaks, bullet points)
- Meta headline: max 40 characters

### Meta Ad Copy Formatting
Meta primary_text supports rich formatting for higher engagement:
- Use emojis strategically: 🔥 ✅ 🎯 💰 ⚡ 🚀 👉 ⭐
- Use line breaks (\n) and bullet points (•, ✅, ▸) for readability
- Example: "🔥 Limited Time Offer!\n\n✅ Free Shipping\n✅ 30-Day Returns\n\n👉 Shop now!"
- Bold/italic/HTML are NOT supported — plain text with emojis only

### Enum Values Are Case-Insensitive
The server auto-normalizes casing, but these are the expected values:
- **status:** ENABLED, PAUSED, ACTIVE, ARCHIVED
- **objective:** OUTCOME_TRAFFIC, OUTCOME_SALES, OUTCOME_LEADS, etc.
- **match_type:** EXACT, PHRASE, BROAD
- **call_to_action:** LEARN_MORE, SHOP_NOW, SIGN_UP, etc.
- **date_range:** last_7_days, last_30_days, last_90_days, etc.
- **campaign_type:** search, pmax, image, video, carousel, etc.

### Budgets Are Numbers
Pass budget fields (`budget_daily`, `budget_amount`, `target_cpa`) as numbers, not strings:
- ✅ `"budget_daily": 50`
- ❌ `"budget_daily": "50"`

Budget is in the account's local currency (not cents). Meta minimum varies by currency.

### Keywords Format
For `add_negative_keywords`, each keyword must be an object:
- ✅ `"keywords": [{"text": "free", "match_type": "BROAD"}]`
- ❌ `"keywords": ["free", "cheap"]`

## Platform Guidance

| Platform | Min Daily | Recommended | Best for |
|----------|-----------|-------------|----------|
| Google Ads Search | $10 | $50+ | High-intent search traffic |
| Google Ads PMax | $10 | $50+ | Broad reach with automation across Search, Display, YouTube, Gmail, Discover |
| Google Ads Display | $5 | $20+ | Image / responsive display ads across the Google Display Network |
| Google Ads Demand Gen | $10 | $20+ | YouTube, Gmail, Discover — visual awareness + consideration |
| Google Ads YouTube | $10 | $20+ | YouTube-only video ads (In-Feed, In-Stream, Shorts) |
| Meta Ads | $5/ad set | $20+ | Image, video, carousel, OUTCOME_LEADS — awareness, retargeting, lead gen |
| LinkedIn Ads | $10 | $50+ | B2B targeting (job titles, industries); image, video, carousel, lead-gen |
| TikTok Ads | $20 | $50+ | In-feed video, Spark Ads (boost organic), Carousel, App Promotion |

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
- `create_display_campaign` — create Google Display campaign (Standard or Smart Display); created PAUSED by default
- `add_display_ad_group` — add ad group to Display campaign (with optional schedule + frequency caps)
- `add_display_ad` — add Responsive Display Ad (RDA) to a Display ad group
- `remove_display_criteria` — unified removal for audiences / topics / placements / keywords / demographics
- `update_ad_creative` / `update_ad_headlines` / `update_ad_descriptions` — router auto-dispatches RSA vs RDA based on ad type
- `resolve_google_locations` — resolve geo inputs (rejects ambiguous strings)
- `list_google_languages` — list supported language codes

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

**Performance & Analytics:**
- `get_tiktok_campaign_performance` — campaign metrics. Params: `lookback_days` (default 30)
- `get_tiktok_ad_performance` — ad-level performance breakdown
- `analyze_tiktok_wasted_spend` — find underperforming campaigns burning budget
- `optimize_tiktok_budget` — budget reallocation recommendations
- `detect_tiktok_creative_fatigue` — identify ads losing effectiveness over time
- `explain_tiktok_anomaly` — explain sudden metric changes
- `get_tiktok_audience_insights` — audience composition and CPA breakdowns
- `analyze_tiktok_geo_performance` — geo-level performance breakdown

**Campaign Creation:**
- `discover_tiktok_assets` — check existing video / image assets
- `validate_and_prepare_tiktok_assets` — validate creative assets
- `upload_tiktok_images` — upload static image assets
- `search_tiktok_targeting` — find interests, behaviors, geo
- `create_tiktok_campaign` — flexible objective (TRAFFIC, CONVERSIONS, APP_PROMOTION, etc.); pass `tiktok_item_id` or `card_id` for Spark Ads
- `create_tiktok_video_campaign` — in-feed video
- `create_tiktok_carousel_card` — build carousel cards before adding via `add_tiktok_ad`

**Campaign Lifecycle:**
- `list_tiktok_campaigns` — list all campaigns
- `get_tiktok_campaign` — campaign details
- `pause_tiktok_campaign` / `resume_tiktok_campaign` — toggle live state
- `update_tiktok_campaign` — update campaign settings (CBO via `budget_optimize_on`, etc.)
- `add_tiktok_ad_group` — add ad groups (with placement, audience, budget)
- `update_tiktok_ad_group` / `pause_tiktok_ad_group` / `resume_tiktok_ad_group` — ad group lifecycle
- `add_tiktok_ad` / `update_tiktok_ad` / `pause_tiktok_ad` / `resume_tiktok_ad` — ad lifecycle

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

### Research (native)
- `WebSearch` — search the web for competitors, market data, trends
- `WebFetch` — crawl websites for pricing, messaging, sitelink URLs, value props

## Output Formatting

- **Performance:** Table with impressions, clicks, CTR, spend, conversions, CPC, ROAS. Order by spend descending.
- **Keywords:** Group by intent, show search volume and CPC ranges.
- **Campaign creation:** Confirm all settings with user before execution, show campaign ID after.
- **Cross-platform:** Side-by-side comparison table.
- **Errors:** Report full error message. Never retry creation tools automatically.

## Troubleshooting

### Connection Issues (Nothing Works)

If **no tools work at all** — even `get_connections_status` or `echo_test` fails — guide the user through these steps in order:

1. **Check tool permissions:** The user's AI client may be blocking Adspirer tools. Read tools (performance, research, status) should be set to **Always allow**. Write tools (campaign creation, budget changes) should be set to **Custom** (ask each time). If tools are blocked or set to "Never allow," nothing will execute.

2. **Disconnect and reconnect the Adspirer connector:**
   - **Claude (web/desktop):** Customize → Connectors → Disconnect Ads MCP → Connect again → Complete OAuth
   - **ChatGPT:** Settings → Connectors → Remove Adspirer-MCP → Re-add with URL `https://mcp.adspirer.com/mcp` → Complete OAuth
   - **Claude Code:** `claude mcp remove adspirer` → `claude mcp add --transport http adspirer https://mcp.adspirer.com/mcp` → Restart → `/mcp` to authenticate
   - **Cursor:** Re-connect via MCP settings

3. **Refresh Adspirer session:** If reconnecting doesn't fix it, the user's login session may have expired. Direct them to go to https://adspirer.ai, log out, log back in, then return to their AI client and try again.

**Claude and ChatGPT web connectors** may disconnect every 1–2 weeks. This is normal behavior — users just need to re-enable and re-authenticate when it happens.

**Important:** These steps apply only when *nothing* works. If some ad platforms work but one doesn't (e.g., Google works but LinkedIn fails), that is NOT a connection issue — the MCP server is reachable. In that case, have the user reconnect just that platform at https://adspirer.ai/connections.

### Other Issues

- **Auth errors:** Reconnect via your AI assistant's connector settings
- **No data:** Verify ad platform is connected at https://adspirer.ai/connections. Try longer lookback (60/90 days).
- **Raw data needed:** Pass `raw_data: true` to any performance / analytics tool — returns compact JSON of metrics only (impressions, spend, conversions, CPA, CPC, CTR, CVR, ROAS by campaign/date) without recommendations or commentary. Useful for own attribution, dashboards, or token-efficient pipelines.
- **Wrong account:** Use `switch_primary_account` to change active account
- **Rate limits:** Adspirer enforces tool call quotas by tier (Free: 15/mo, Plus: 150/mo, Pro: 600/mo, Max: 3,000/mo)
