---
name: ad-campaign-management
description: Deprecated. Adspirer's ad-campaign skills were split by platform. Use adspirer-agent, adspirer-mcp, and the per-platform skills instead.
---

# Deprecated

This skill has been replaced. It described a tool surface that no longer exists — Adspirer's
platform tools now sit behind router tools, so the direct tool calls this skill taught will fail.

Use these instead:

- **`adspirer-mcp`** — how to call the hub. Read this before any tool call.
- **`adspirer-agent`** — how a paid media agent should behave.
- **`adspirer-google-ads`**, **`adspirer-meta-ads`**, **`adspirer-tiktok-ads`**,
  **`adspirer-linkedin-ads`**, **`adspirer-amazon-ads`**, **`adspirer-chatgpt-ads`** — per-platform rules.
- **`adspirer-launch`**, **`adspirer-performance-review`**, **`adspirer-optimize`**,
  **`adspirer-creative`** — cross-platform workflows.

If you are seeing this, update the Adspirer plugin.
