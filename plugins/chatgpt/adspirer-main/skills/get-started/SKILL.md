---
name: get-started
description: First steps with Adspirer. Use when the user has just installed Adspirer, asks what it can do, or has no ad account connected yet.
---

# Get started with Adspirer

1. Call `start_here`. It shows a getting-started card based on what the user has connected and
   already done. It is free.
2. Call `get_connections_status` to see which ad accounts are connected: Google Ads, Meta Ads,
   LinkedIn Ads, TikTok Ads, Amazon Ads, ChatGPT Ads and Microsoft Advertising, plus Google Analytics,
   Search Console, Tag Manager and Klaviyo.
3. If no ad account is connected, tell the user to connect one at https://adspirer.ai/connections,
   then come back. Don't call platform tools until an account is connected.
4. If the user has more than one account on a platform, ask which one to work on before running
   anything account-specific.
5. Offer three first tasks, using the platforms they actually connected:
   - Show performance for the last 30 days, by campaign.
   - Audit conversion tracking across every connected platform.
   - Check the funnel for the first thing that's stopping ads from producing sales.

For how to call the tools after this, follow the `adspirer-mcp` skill.
