---
description: Set up your brand workspace — connect to Adspirer and pull campaign data
---
IMPORTANT: You may execute this workflow directly or delegate parts to the single `performance-marketing-agent` subagent. Keep responsibility for final output in this command and ensure all required checks are completed.

Run the full brand workspace setup. Follow these steps in order:

1. **Connect to Adspirer** — Call `get_connections_status`.
   - If it works: continue to step 2.
   - If the MCP server is not found: tell the user "Open `/plugin` and install **adspirer** from the xAI marketplace — the plugin ships its own MCP server config. Then open `/mcp`, select **adspirer**, and authenticate in the browser. After authenticating, run `/adspirer:setup` again."
   - If the MCP server is registered but not authenticated: tell the user "Open `/mcp`, select **adspirer**, and authenticate in the browser. Then run `/adspirer:setup` again."
2. **Scan local folder** for brand docs — search the project for files matching: `**/*.md`, `**/*.txt`, `**/*.csv`, `**/*.yaml`, `**/*.json`, `**/*.pdf`. Read any files found.
3. **Pull live campaign data** from the platforms that came back connected. Follow `adspirer-mcp` for the call contract.

   Direct calls:
   - `get_connections_status` — run this first; skip any platform it reports as not connected
   - `get_campaign_performance` (lookback_days: 30)
   - `get_meta_campaign_performance` (lookback_days: 30)

   Through a router, with `{"action": "execute", "tool_name": "...", "arguments": {...}}`:
   - `google_ads` → `list_campaigns`, `get_business_profile`, `get_benchmark_context`
   - `linkedin_ads` → `list_linkedin_campaigns`, `get_linkedin_campaign_performance` (lookback_days: 30)
4. **Create AGENTS.md** at the project root with: brand context from scanned docs, connected platforms and account info, performance snapshot with key metrics, KPI targets. **Existing-file guard:** if a AGENTS.md already exists and is not an Adspirer brand workspace (e.g. it's a software project's instructions), never overwrite or restructure it — ask the user whether to append a clearly-marked `## Adspirer Brand Context` section instead, and don't touch the file until they answer. If it's already a brand workspace, update it in place preserving user edits.
5. **Present a summary** of everything found — accounts connected, campaigns discovered, key metrics, and what you can help with
