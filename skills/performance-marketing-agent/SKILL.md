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

## What You Can Do

### Performance Marketing & PPC
- **Keyword Research** — Real search volumes, CPC ranges, and competition data from Google Ads
- **Campaign Creation** — Search, PMax, Display, Image, Video, Carousel campaigns across all platforms
- **Bid Optimization** — Adjust bidding strategies, manage keyword bids, optimize for target CPA/ROAS
- **Wasted Spend Analysis** — Find underperforming keywords and ad groups burning budget
- **Search Term Reports** — Review search terms, identify negative keyword opportunities

### Digital Marketing Automation
- **Cross-Platform Reporting** — Unified performance data across Google, Meta, LinkedIn, TikTok
- **Budget Optimization** — AI-powered budget allocation recommendations across campaigns
- **Automated Monitoring** — Set up alerts for metric thresholds, schedule recurring briefs
- **Ad Creative Management** — Update headlines, descriptions, creatives across platforms

### Paid Media & Media Buying
- **Google Ads** — Search campaigns, Performance Max, YouTube, keyword management, extensions
- **Meta Ads** — Facebook & Instagram image, video, carousel campaigns, audience targeting
- **LinkedIn Ads** — Sponsored content, lead gen, B2B targeting by job title and industry
- **TikTok Ads** — Video campaigns, spark ads, young demographic targeting

### Marketing Analytics
- **Live Performance Dashboards** — Impressions, clicks, CTR, spend, conversions, CPA, ROAS
- **Anomaly Detection** — Explain sudden changes in campaign metrics
- **Creative Fatigue Detection** — Identify ads losing effectiveness over time
- **Audience Insights** — Segment performance analysis across platforms

---

## Who Is This For?

| Role | Use Case |
|------|----------|
| **Performance Marketers** | Daily campaign monitoring, bid optimization, ROAS tracking |
| **Digital Marketing Managers** | Cross-platform reporting, budget allocation, campaign launches |
| **PPC Specialists** | Keyword research, search term analysis, negative keyword management |
| **Media Buyers** | Multi-platform campaign creation, budget optimization, targeting |
| **Marketing Agencies** | Multi-client management, automated reporting, creative management |
| **E-commerce Brands** | Product advertising, retargeting, conversion optimization |

---

## Safety

- All campaigns created in **PAUSED status** for review
- Write operations always require user confirmation
- Read operations (performance, research, analytics) are safe to run freely
- No local credential storage — OAuth 2.1 with PKCE

## Pricing

| Plan | Price | Tool Calls |
|------|-------|------------|
| **Free Forever** | $0/mo | 15/month |
| **Plus** | $49/mo | 150/month |
| **Pro** | $99/mo | 600/month |
| **Max** | $199/mo | 3,000/month |

All plans include all 4 ad platforms. Sign up at https://adspirer.ai/settings?tab=billing
