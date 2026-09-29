# Changelog

## 1.0.2 - 2026-09-29

- `adspirer-mcp` skill: stop asking for the user's request as `intent` (the Adspirer MCP server no longer takes it), and call `get_tool_schema` through a platform router when a client doesn't list it.

## 1.0.1 - 2026-09-28

- Replace the listing icon with the Adspirer brand square logo (640×640; was a 146×146 image).

## 1.0.0 - 2026-09-12

- Initial Cursor Marketplace package for Cursor and Grok Bot.
- Connects to Adspirer's hosted MCP server using OAuth.
- Includes paid-media skills and a performance-marketing subagent.
