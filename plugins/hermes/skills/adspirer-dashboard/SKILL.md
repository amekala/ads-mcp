---
name: adspirer-dashboard
description: Build a visual paid-media dashboard from Adspirer data across Google, Microsoft, Meta, TikTok, LinkedIn, Amazon, and ChatGPT Ads, with GA4 and Search Console only as context. Read-only. Every number comes from a tool result. Never totals across currencies.
---

# Paid-media dashboard

Follow `adspirer-mcp` and the evidence rules in `adspirer-agent`. This skill only reads. It never calls a write tool.

Use it when the user wants charts, or at the end of a performance review when a picture will do more than another table. The scorecard itself is `adspirer-performance-review`. Don't rebuild numbers the review already pulled in this conversation — reuse them, and say so.

## What to include

Per connected platform the user cares about, for an explicit date range:

- Account totals from that platform's performance tool. Google uses `get_campaign_performance` directly. Meta uses `get_meta_campaign_performance` directly. TikTok, LinkedIn, Amazon, and ChatGPT Ads use the performance tool their router lists. `get_tool_schema` before you execute.
- Ask for raw data when you need to compute. Record `freshness_state`. The chart's range is the range that actually has data, labeled next to the range the user asked for.
- Derived CTR, CPC, CPM, CPA, and ROAS come from those totals and are labeled derived. If a breakdown doesn't add up to the account total, mark that breakdown unverified and don't chart it as fact.
- Google per-campaign clicks and impressions: take them from `analyze_wasted_spend` when the performance payload doesn't include them. If neither source has them, the chart says "not available". Don't back into them.
- Microsoft: campaigns, status, and budgets from `adspirer-microsoft-ads`. Performance is "not available" unless `list_tools` has grown a report. Don't draw a zero.
- GA4 (`adspirer-google-analytics`) and Search Console (`adspirer-search-console`) only if connected, and only as context. Never add them to ad conversions.

Check `get_usage_status` before a wide pull. Don't assume every lookup is free. If quota stops you, chart what you have and list what you didn't read.

## How to draw it

Header: platforms, account names and ids, currencies, requested range, range with data, and "account data".

One spend chart per currency. Conversions sit side by side per platform. Never sum conversions across platforms as if they were deduplicated, and never total spend across currencies.

Per platform: a short KPI strip, spend over time if a daily series exists and sums to the total, spend by campaign, and a campaign table (objective, status, spend, conversions, derived CPA, CTR, ROAS). Google can add impression share and the top search terms, with the count and the real window.

Missing fields say "not available". Never 0, and never a smoothed or backfilled point. A footer lists what you could not read and why (no-data ranges, inactive accounts, unpaged rows, missing tools).



If they want a file, write one self-contained HTML page in the project and tell them the path. Embed the figures. Don't fetch a chart library from a third-party host unless they asked for that. Don't invent a screenshot you didn't take.

On hosts with none of those surfaces, the dashboard is the table and the few comparisons above, in the conversation.

Sending it by email or Slack is `adspirer-digest`, after a yes. The dashboard skill itself doesn't send anything.
