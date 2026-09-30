---
name: get-started
description: First steps with Adspirer Search Ads. Use when the user has just installed the plugin, asks what it can do, or has no Google Ads or Microsoft Advertising account connected yet.
---

# Get started with Adspirer Search Ads

1. Call `start_here`. It shows a getting-started card based on what the user has connected and
   already done. It is free.
2. Call `get_connections_status` to see which Google Ads and Microsoft Advertising accounts are
   connected.
3. If neither platform is connected, tell the user to connect Google Ads or Microsoft Advertising at
   https://www.adspirer.ai/connections, then come back. Don't call other tools until an account is
   connected.
4. If the user has more than one account on a platform, ask which one to work on before running
   anything account-specific.
5. Offer three first tasks the user can pick from:
   - Pull Google Ads performance for the last 90 days, by campaign.
   - Find the keywords that spent the most with zero conversions.
   - Compare Google Ads and Microsoft Ads cost per conversion for the last 30 days.

For how to use the tools after this, follow the `adspirer-search-ads` skill.
