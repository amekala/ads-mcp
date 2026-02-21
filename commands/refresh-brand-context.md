---
description: Re-scan brand docs and update CLAUDE.md with latest info
---
Re-scan all files in the project folder and pull fresh data from Adspirer MCP. Update CLAUDE.md with any changes.

1. Scan folder for any new or updated brand docs (guidelines, media plans, audience profiles)
2. Call `mcp__adspirer__get_connections_status` to check current platform connections
3. Call `mcp__adspirer__get_campaign_performance`, `mcp__adspirer__get_linkedin_campaign_performance`, `mcp__adspirer__get_meta_campaign_performance` for latest metrics
4. Call `mcp__adspirer__get_business_profile` for any profile updates
5. Update CLAUDE.md with the refreshed data — merge new info, update performance numbers, note any changes
