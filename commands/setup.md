---
description: Set up your brand workspace — connect to Adspirer and pull campaign data
---
Run the full brand workspace setup. Follow these steps in order:

1. **Connect to Adspirer** — Check connection status using `mcp__adspirer__get_connections_status`. If OAuth is needed, guide the user through it. If the MCP server is not found, register it with `claude mcp add --transport http adspirer https://mcp.adspirer.com/mcp` and tell the user to restart.
2. **Scan local folder** for brand docs (guidelines, media plans, audience profiles, any existing CLAUDE.md or brand context files)
3. **Pull live campaign data** from all connected platforms (Google Ads, Meta Ads, LinkedIn Ads, TikTok Ads) — use `mcp__adspirer__list_campaigns`, `mcp__adspirer__get_campaign_performance`, `mcp__adspirer__list_linkedin_campaigns`, `mcp__adspirer__get_linkedin_campaign_performance`, `mcp__adspirer__get_meta_campaign_performance`, `mcp__adspirer__get_business_profile`, `mcp__adspirer__get_benchmark_context`, and any other relevant tools to get a full snapshot.
4. **Create CLAUDE.md** at the project root with: brand context, connected platforms and account info, performance snapshot with key metrics from each platform, KPI targets (if found in docs, otherwise note as TBD)
5. **Present a summary** of everything found — accounts connected, campaigns discovered, key metrics, and what you can help with going forward.

Important: Pull data from ALL connected platforms. Call multiple tools in parallel where possible for speed.
