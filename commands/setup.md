---
description: Set up your brand workspace — connect to Adspirer and pull campaign data
---
IMPORTANT: Do NOT use the Task tool or spawn any subagents. Do NOT use Explore agents. Run ALL steps yourself directly in this conversation. Subagents cannot access MCP tools.

Run the full brand workspace setup. Follow these steps in order:

1. **Connect to Adspirer** — Call `mcp__adspirer__get_connections_status` directly (do NOT delegate this to a subagent).
   - If it works: continue to step 2.
   - If the MCP server is not found: run `claude mcp add --transport http adspirer https://mcp.adspirer.com/mcp` via Bash, then tell the user to restart Claude Code and run /setup again.
   - If the MCP server is registered but not authenticated: tell the user "Type `/mcp`, find the Adspirer server, and authenticate it. Then run /setup again."
2. **Scan local folder** for brand docs — use Glob yourself (not an Explore agent) to find files: `**/*.md`, `**/*.txt`, `**/*.csv`, `**/*.yaml`, `**/*.json`, `**/*.pdf`. Read any files found.
3. **Pull live campaign data** from all connected platforms — call these MCP tools directly (in parallel where possible):
   - `mcp__adspirer__get_connections_status`
   - `mcp__adspirer__get_business_profile`
   - `mcp__adspirer__list_campaigns`
   - `mcp__adspirer__get_campaign_performance` (lookback_days: 30)
   - `mcp__adspirer__list_linkedin_campaigns`
   - `mcp__adspirer__get_linkedin_campaign_performance` (lookback_days: 30)
   - `mcp__adspirer__get_meta_campaign_performance` (lookback_days: 30)
   - `mcp__adspirer__get_benchmark_context`
4. **Create CLAUDE.md** at the project root with: brand context from scanned docs, connected platforms and account info, performance snapshot with key metrics, KPI targets
5. **Present a summary** of everything found — accounts connected, campaigns discovered, key metrics, and what you can help with
