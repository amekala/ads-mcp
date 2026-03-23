---
description: Set up your brand workspace — connect to Adspirer and pull campaign data
---
IMPORTANT: You may execute this workflow directly or delegate parts to the single `performance-marketing-agent` subagent. Keep responsibility for final output in this command and ensure all required checks are completed.

Run the full brand workspace setup. Follow these steps in order:

1. **Connect to Adspirer** — Call `get_connections_status`.
   - If it works: continue to step 2.
   - If the MCP server is not found: tell the user "Run `/mcp` and find **plugin:adspirer:adspirer** — click to authenticate. If you don't see it, run `/plugin marketplace add amekala/ads-mcp` then `/plugin install adspirer`. After authenticating, run `/adspirer:setup` again."
   - As a fallback: run `claude mcp add --transport http adspirer https://mcp.adspirer.com/mcp` via Bash, then tell the user to restart Claude Code, run `/mcp` to authenticate, then run `/adspirer:setup` again.
   - If the MCP server is registered but not authenticated: tell the user "Run `/mcp`, find the Adspirer server, and authenticate it. Then run `/adspirer:setup` again."
2. **Scan local folder** for brand docs — use Glob to find files: `**/*.md`, `**/*.txt`, `**/*.csv`, `**/*.yaml`, `**/*.json`, `**/*.pdf`. Read any files found.
3. **Pull live campaign data** from all connected platforms — call these Adspirer MCP tools directly (in parallel where possible):
   - `get_connections_status`
   - `get_business_profile`
   - `list_campaigns`
   - `get_campaign_performance` (lookback_days: 30)
   - `list_linkedin_campaigns`
   - `get_linkedin_campaign_performance` (lookback_days: 30)
   - `get_meta_campaign_performance` (lookback_days: 30)
   - `get_benchmark_context`
4. **Create CLAUDE.md** at the project root with: brand context from scanned docs, connected platforms and account info, performance snapshot with key metrics, KPI targets
5. **Present a summary** of everything found — accounts connected, campaigns discovered, key metrics, and what you can help with
