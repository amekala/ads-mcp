# How AI Agents Are Replacing the Slowest Part of Paid Media

> **What you'll build:** A complete advertising campaign across Google Ads and Meta Ads — keyword research, ad groups, 8+ creative variants with distinct messaging angles, targeting, extensions, and monitoring — all through natural language in a single chat session.
>
> **Time:** ~15 minutes
>
> **What this replaces:** 4-8 hours of switching between Google Ads Manager, Meta Business Suite, spreadsheets, and creative tools.

---

## Why This Matters

The slowest part of paid media isn't strategy. It's execution.

Your team knows which audiences to target and what messaging to test. But translating that brief into live campaigns — navigating Google Ads Manager, switching to Meta Business Suite, building ad sets, uploading creatives, writing 15 headline variations, configuring extensions — that's where the day goes. Not on thinking. On clicking.

AI agents change this. Instead of operating five dashboards, your channel managers describe what they need in plain language. The agent handles the execution: keyword research, campaign structure, creative variants, targeting, extensions, monitoring — across platforms, in minutes.

Here's what this looks like in practice, from real paid media teams using Adspirer:

- A **DTC brand** created 174 ad creative operations in 10 days — testing 15 distinct messaging angles (authority, social proof, risk reversal, retargeting). In Meta's Ads Manager, each variant takes 5-10 minutes to build. Via an AI agent: about 30 seconds each.

- A **performance marketing agency** launched 64 campaigns across 5 formats (Performance Max, Demand Gen, Meta Image, Meta Video, Meta Carousel) for clients in Dubai and Delhi. Multiple languages. Multiple budget tiers. All from one chat window — no dashboard switching.

- A **travel advertiser** managed three $60-$6,000/day destination campaigns — running 42 performance checks and 99 ad updates in a single billing period. The kind of throughput that normally requires a dedicated media buyer.

The pattern: **strategy stays human, execution becomes instant.**

---

## Prerequisites

- An [Adspirer](https://www.adspirer.com) account (free tier available — 15 tool calls/month)
- At least one connected ad platform (Google Ads and/or Meta Ads)
- Any MCP-compatible AI client

### Supported AI Clients

| Client | Setup |
|--------|-------|
| **ChatGPT** | Settings → Connectors → Add Connector → URL: `https://mcp.adspirer.com/mcp` |
| **Claude** | Settings → Connectors → Add Custom Connector → URL: `https://mcp.adspirer.com/mcp` |
| **Claude Code** | `/plugin marketplace add amekala/ads-mcp` then `/plugin install adspirer` |
| **Gemini CLI** | `gemini extensions install github.com/amekala/ads-mcp` |
| **Cursor** | Add `"adspirer": {"url": "https://mcp.adspirer.com/mcp"}` to `mcp.json` |

After connecting, you'll complete a one-time OAuth sign-in to link your ad accounts.

---

## The Scenario

You're launching ads for a **direct-to-consumer skincare brand** that sells a Vitamin C serum. You want:

- A **Google Search campaign** capturing people actively searching for vitamin C serums
- A **Meta Ads campaign** with multiple creative variants testing different messaging angles
- **Monitoring** to catch problems early

Let's build all of it in one session.

---

## Step 1: Check Your Connected Platforms

Before creating anything, verify which ad platforms are linked.

**Prompt:**

```
What ad platforms do I have connected? Show me the account details.
```

**What happens:** The AI calls `get_connections_status`, which returns your connected platforms, account names, and IDs.

**Expected output:**

```
Connected Platforms:
┌─────────────┬──────────────────────────┬────────────────┬─────────┐
│ Platform    │ Account Name             │ Account ID     │ Status  │
├─────────────┼──────────────────────────┼────────────────┼─────────┤
│ Google Ads  │ My Skincare Brand        │ 123-456-7890   │ Active  │
│ Meta Ads    │ Skincare-Ads-Account     │ 1299711684...  │ Active  │
└─────────────┴──────────────────────────┴────────────────┴─────────┘
```

> **If a platform isn't connected:** Go to [adspirer.com](https://www.adspirer.com) → Connections to link your ad accounts.

---

## Step 2: Research Your Market

Good campaigns start with data, not guesses. Let's research both sides: what people search for (Google) and who they are (Meta).

### Keyword Research

**Prompt:**

```
Research keywords for a vitamin C serum brand. I want to see search volumes,
average CPC, and competition level. Focus on high-intent commercial keywords —
people ready to buy, not just browsing.
```

**What happens:** The AI calls `research_keywords` with your terms, pulling real data from the Google Keyword Planner API.

**Expected output:**

```
Keyword Research Results:
┌──────────────────────────────────┬─────────┬──────────┬──────────────┐
│ Keyword                          │ Volume  │ Avg CPC  │ Competition  │
├──────────────────────────────────┼─────────┼──────────┼──────────────┤
│ best vitamin c serum             │ 90,500  │ $2.41    │ High         │
│ vitamin c serum for face         │ 49,500  │ $1.87    │ High         │
│ buy vitamin c serum              │ 12,100  │ $3.12    │ Medium       │
│ vitamin c serum before and after │ 33,100  │ $1.53    │ Medium       │
│ vitamin c serum for dark spots   │ 27,100  │ $2.08    │ Medium       │
│ vitamin c serum sensitive skin   │ 8,100   │ $1.95    │ Low          │
│ affordable vitamin c serum       │ 6,600   │ $1.72    │ Low          │
└──────────────────────────────────┴─────────┴──────────┴──────────────┘
```

### Audience Research for Meta

**Prompt:**

```
Search for Meta targeting options related to skincare, anti-aging, and beauty
routines. I'm targeting women aged 25-45 interested in premium skincare products.
```

**What happens:** The AI calls `search_meta_targeting`, returning interest categories, audience sizes, and targeting suggestions.

**Expected output:**

```
Meta Targeting Options:
┌──────────────────────────────────┬──────────────────┬─────────────────┐
│ Interest / Behavior              │ Audience Size    │ Type            │
├──────────────────────────────────┼──────────────────┼─────────────────┤
│ Skincare                         │ 234M             │ Interest        │
│ Anti-aging                       │ 89M              │ Interest        │
│ Vitamin C (ingredient)           │ 12M              │ Interest        │
│ Sephora                          │ 45M              │ Interest        │
│ Clean beauty                     │ 18M              │ Interest        │
│ Online shopping (beauty)         │ 156M             │ Behavior        │
└──────────────────────────────────┴──────────────────┴─────────────────┘
```

---

## Step 3: Create a Google Search Campaign

Now let's build the search campaign. One prompt creates the campaign, ad groups, keywords, and ad copy.

**Prompt:**

```
Create a Google Search campaign for my Vitamin C serum brand. Here's what I need:

- Campaign name: "Search - Vitamin C Serum - US"
- Budget: $50/day
- Location: United States
- Keywords: "best vitamin c serum", "vitamin c serum for face", "buy vitamin c serum",
  "vitamin c serum for dark spots", "vitamin c serum sensitive skin"
- Write 5 headline variations and 3 descriptions
- Bidding: maximize conversions
```

**What happens:** The AI calls `create_search_campaign` with your specifications. The campaign is created in **PAUSED** status — it won't spend money until you explicitly activate it.

**Expected output:**

```
✅ Campaign created (PAUSED):

Campaign: Search - Vitamin C Serum - US
├── Budget: $50.00/day
├── Bidding: Maximize Conversions
├── Location: United States
│
├── Ad Group: Vitamin C Serum
│   ├── Keywords:
│   │   ├── "best vitamin c serum" (phrase match)
│   │   ├── "vitamin c serum for face" (phrase match)
│   │   ├── "buy vitamin c serum" (phrase match)
│   │   ├── "vitamin c serum for dark spots" (phrase match)
│   │   └── "vitamin c serum sensitive skin" (phrase match)
│   │
│   └── Ad:
│       ├── Headlines:
│       │   ├── "Best Vitamin C Serum 2026"
│       │   ├── "Brighter Skin in 14 Days"
│       │   ├── "Dermatologist-Recommended"
│       │   ├── "20% Vitamin C + Hyaluronic Acid"
│       │   └── "Free Shipping on All Orders"
│       └── Descriptions:
│           ├── "Clinically proven to reduce dark spots & fine lines. Pure 20% L-ascorbic acid formula. Shop now."
│           ├── "Join 50,000+ customers who transformed their skin. 30-day money-back guarantee."
│           └── "Lightweight, fast-absorbing serum for all skin types. Vegan & cruelty-free."
│
└── Status: PAUSED (activate when ready)
```

### Add Ad Extensions

Extensions make your ads more prominent and clickable. Let's add sitelinks and callouts.

**Prompt:**

```
Add sitelink extensions for these pages:
- "Shop Serums" → /collections/serums
- "Before & After Results" → /results
- "Our Ingredients" → /ingredients
- "Reviews" → /reviews

Also add callout extensions: "Free Shipping", "30-Day Guarantee",
"Dermatologist Tested", "Vegan & Cruelty-Free"
```

**What happens:** The AI calls `add_sitelinks` and `add_callout_extensions`.

---

## Step 4: Create Meta Ads with Multiple Creative Variants

This is where the time savings are most dramatic. In Meta's Ads Manager, creating each ad variant means navigating the creative builder, uploading assets, writing copy, and configuring the CTA — 5-10 minutes per variant. Via conversation, you describe the angles and they're all created at once.

**Prompt:**

```
Create a Meta image campaign for my Vitamin C serum. Here's the setup:

- Campaign name: "Meta - Vitamin C Serum - Prospecting"
- Budget: $30/day
- Objective: Sales
- Targeting: Women 25-45 in the US interested in skincare, anti-aging, clean beauty
- Image: use my existing product photo (discover from my assets)

Create 5 ad variants, each with a different messaging angle:

1. SOCIAL PROOF: "Join 50,000+ customers who transformed their skin.
   Visible results in 14 days."

2. RISK REVERSAL: "Not sure if it'll work for you? Try it risk-free
   with our 30-day money-back guarantee."

3. SCIENCE/AUTHORITY: "20% L-Ascorbic Acid — the gold standard
   concentration recommended by dermatologists."

4. PAIN POINT: "Dark spots? Uneven skin tone? Our Vitamin C serum
   fades hyperpigmentation at the cellular level."

5. BEFORE/AFTER: "Real results from real customers. See the
   transformation in just 2 weeks."
```

**What happens:** The AI first calls `discover_meta_assets` to find your existing images, then `create_meta_image_campaign` with all 5 ad variants in a single operation.

**Expected output:**

```
✅ Meta campaign created (PAUSED):

Campaign: Meta - Vitamin C Serum - Prospecting
├── Objective: Sales
├── Budget: $30.00/day
├── Targeting: Women 25-45, US, Interests: skincare + anti-aging + clean beauty
│
├── Ad Set: Prospecting - Skincare Enthusiasts
│   ├── Ad 1 (Social Proof): "Join 50,000+ customers who transformed their skin..."
│   ├── Ad 2 (Risk Reversal): "Not sure if it'll work for you?..."
│   ├── Ad 3 (Science): "20% L-Ascorbic Acid — the gold standard..."
│   ├── Ad 4 (Pain Point): "Dark spots? Uneven skin tone?..."
│   └── Ad 5 (Before/After): "Real results from real customers..."
│
└── Status: PAUSED
```

### Add Retargeting Variants

People who visited your site but didn't buy need different messaging. Let's add a retargeting layer.

**Prompt:**

```
Add 3 more ad variants to my Meta campaign, but for retargeting —
people who visited my site but didn't purchase:

1. "You were looking at our Vitamin C serum. Still thinking about it?
   Your skin isn't going to wait. Free shipping today."

2. "You did your research. Now try the real thing — 30-day guarantee,
   no risk."

3. "Still on the fence? Here's what 50,000+ customers say about their
   results after just 14 days."
```

**What happens:** The AI calls `add_meta_ad` for each variant.

---

## Step 5: Set Up Monitoring

Don't wait for problems to find you. Set up automated alerts.

**Prompt:**

```
Set up monitoring for both campaigns:
- Alert me if CPA exceeds $25 on either platform
- Alert me if CTR drops below 1% on Google or 0.5% on Meta
- Send a weekly performance summary every Monday
```

**What happens:** The AI calls `create_monitor` for the alerts and `schedule_brief` for the weekly summary.

---

## Step 6: Review Everything You Built

**Prompt:**

```
Give me a complete summary of everything we created in this session —
campaigns, ad variants, targeting, budgets, keywords, and extensions.
```

**Expected output:**

```
Session Summary
═══════════════

GOOGLE ADS
├── Campaign: Search - Vitamin C Serum - US
│   ├── Budget: $50/day | Bidding: Max Conversions
│   ├── Keywords: 5 (phrase match)
│   ├── Headlines: 5 | Descriptions: 3
│   ├── Sitelinks: 4 | Callouts: 4
│   └── Status: PAUSED

META ADS
├── Campaign: Meta - Vitamin C Serum - Prospecting
│   ├── Budget: $30/day | Objective: Sales
│   ├── Targeting: Women 25-45, US, skincare interests
│   ├── Ad Variants: 8 (5 prospecting + 3 retargeting)
│   │   ├── Social Proof
│   │   ├── Risk Reversal
│   │   ├── Science / Authority
│   │   ├── Pain Point
│   │   ├── Before / After
│   │   ├── Retargeting: Urgency
│   │   ├── Retargeting: Research validation
│   │   └── Retargeting: Social proof reminder
│   └── Status: PAUSED

MONITORING
├── CPA alert: > $25 (both platforms)
├── CTR alert: < 1% Google, < 0.5% Meta
└── Weekly brief: Every Monday

Total: 2 campaigns, 8 ad variants, 5 keywords, 8 extensions, 3 monitors
All campaigns created PAUSED — activate when ready.
```

---

## What You Just Skipped

Here's what this conversation replaced:

| Without AI | With Adspirer |
|-----------|---------------|
| Open Google Ads → navigate to campaign builder → select campaign type → configure settings → create ad group → add keywords one by one → write ads in the responsive ad builder → save → go to extensions → add sitelinks → add callouts | One prompt |
| Open Meta Business Suite → navigate to Ads Manager → create campaign → select objective → configure ad set → set targeting → upload creative → write primary text → write headline → set CTA → duplicate 7 more times with different copy | Two prompts |
| Open Google Ads → navigate to rules → create automated rules for CPA and CTR thresholds | One prompt |
| Open a spreadsheet → manually log everything you created | One prompt |

**Estimated time saved: 4-6 hours.**

---

## What Comes Next

Your campaigns are created in PAUSED status. Here's the recommended timeline:

| When | Action | Prompt |
|------|--------|--------|
| **Now** | Review and activate campaigns in each platform's UI | — |
| **Day 3** | Check early performance signals | "How are my campaigns performing? Show me the first 3 days of data." |
| **Day 7** | First performance review | "Run a cross-platform performance review for the last 7 days." |
| **Day 14** | Wasted spend check | "Analyze wasted spend across both platforms. Which keywords or placements are burning budget?" |
| **Day 14** | Creative fatigue check | "Check my Meta ads for creative fatigue. Which variants have declining CTR?" |
| **Day 21** | Optimization round | "Based on 3 weeks of data, what should I change? Pause underperformers, scale winners." |

---

## Tools Used in This Cookbook

| Tool | Purpose | Type |
|------|---------|------|
| `get_connections_status` | Check connected platforms | Read |
| `research_keywords` | Keyword volumes, CPC, competition | Read |
| `search_meta_targeting` | Find Meta audience interests | Read |
| `discover_meta_assets` | Find existing images/videos | Read |
| `create_search_campaign` | Create Google Search campaign | Write |
| `add_sitelinks` | Add sitelink extensions | Write |
| `add_callout_extensions` | Add callout extensions | Write |
| `create_meta_image_campaign` | Create Meta campaign with ads | Write |
| `add_meta_ad` | Add additional ad variants | Write |
| `create_monitor` | Set up performance alerts | Write |
| `schedule_brief` | Schedule weekly reports | Write |

All write operations create campaigns in **PAUSED** status. Nothing spends money until you activate it.

---

## About Adspirer

[Adspirer](https://www.adspirer.com) is an MCP server that connects AI assistants to advertising platforms. 100+ tools across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads. Works with ChatGPT, Claude, Gemini CLI, Cursor, Codex, and any MCP-compatible client.

- **Free tier:** 15 tool calls/month
- **Docs:** [docs.adspirer.com](https://docs.adspirer.com)
- **GitHub:** [github.com/amekala/ads-mcp](https://github.com/amekala/ads-mcp)
