---
description: Re-scan brand docs and update CLAUDE.md with latest info
---
Re-scan all files in the project folder and pull fresh data from Adspirer MCP. Update CLAUDE.md with any changes.

1. Scan folder for any new or updated brand docs (guidelines, media plans, audience profiles)
2. Call `get_connections_status` to check current platform connections
3. Pull latest metrics: `get_campaign_performance` and `get_meta_campaign_performance` are direct calls; other platforms go through their router (`{"action": "execute", "tool_name": "..."}`). See `adspirer-mcp`.
4. Call `get_business_profile` for any profile updates
5. Update CLAUDE.md with the refreshed data — merge new info, update performance numbers, note any changes
