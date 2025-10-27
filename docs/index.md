# Ads MCP — Quickstart

**Remote URL (SSE):** `https://adspirer-mcp-596892545013.us-central1.run.app/`
**Registry ID:** `com.adspirer/ads`
**Auth:** OAuth 2.1 via Adspirer (paid tiers and rate limits enforced)

## Connect from ChatGPT

1. Settings → Connectors → Create
2. Name: **Ads MCP**
3. URL: `https://adspirer-mcp-596892545013.us-central1.run.app/`
4. Complete OAuth sign-in (Adspirer) and connect ad accounts

## Connect from Claude

1. Settings → Connectors → Add custom
2. Name: **Ads MCP**
3. URL: `https://adspirer-mcp-596892545013.us-central1.run.app/`
4. Complete OAuth sign-in

## Example: Verify Streaming Support

```bash
curl -i -N https://adspirer-mcp-596892545013.us-central1.run.app/mcp/tools/call \
  -H 'Content-Type: application/json' \
  -d '{
    "jsonrpc":"2.0",
    "id":2,
    "method":"tools/call",
    "params":{
      "name":"validate_and_prepare_assets",
      "_meta":{"progressToken":"tok-123"},
      "arguments":{
        "marketing_images_square":["https://i.postimg.cc/example.jpg"]
      }
    }
  }'
```

You should see several `event: message` progress frames followed by a final JSON-RPC `result` on the same stream.
