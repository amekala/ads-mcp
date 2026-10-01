---
name: adspirer-mcp
description: How to call the Adspirer MCP hub correctly — the router two-step (action "list_tools" then action "execute" with tool_name), the direct tools search_tools and get_tool_schema, per-platform account IDs, quota rules, and the budget unit (every platform takes the account's own currency as a decimal — never cents). Load this before making any Adspirer tool call.
---

# Calling the Adspirer MCP hub

Adspirer exposes **23 top-level tools**. Twelve of them are *routers* that stand in front of
hundreds of platform tools. Calling a platform tool by its own name does not work — it is not in
the tool list. Read this before your first tool call.

## The tool surface

**Call these directly, by name:**

| Tool | Use it for |
|---|---|
| `start_here` | New or unsure user. Free. |
| `search_tools` | "Which tool does X?" Semantic search over every tool. |
| `get_tool_schema` | Exact parameters for a tool, before you call it. |
| `get_connections_status` | Which ad accounts are connected, and their health. Free. |
| `get_usage_status` | Tool calls used and left this period, and when it resets. Free. |
| `switch_primary_account` | Change which account is active. |
| `get_campaign_performance` | Google Ads performance. |
| `get_meta_campaign_performance` | Meta (Facebook/Instagram) performance. |
| `audit_conversion_tracking` | Conversion-tracking health across platforms. |
| `diagnose_funnel` | "Why aren't my ads selling?" Checks the funnel in order and stops at the first broken step. |
| `competitor_ads_research` | A competitor's live ads, by website domain (ask for the domain; never guess it). |

**These are routers.** Never call their inner tools by name:

`google_ads` · `meta_ads` · `linkedin_ads` · `tiktok_ads` · `amazon_ads` · `chatgpt_ads` ·
`microsoft_ads` · `monitoring_and_reporting` · `google_analytics` · `google_search_console` ·
`google_tag_manager` · `klaviyo`

## The router two-step

Every router takes the same three fields: `action`, `tool_name`, `arguments`.

**Step 1 — discover.** Always first. Never costs quota.

```json
{ "action": "list_tools" }
```

Returns every tool on that platform with its full parameter schema.

**Step 2 — execute.** Use an exact `tool_name` from step 1.

```json
{
  "action": "execute",
  "tool_name": "list_tiktok_campaigns",
  "arguments": { "advertiser_id": "7012345678901234567" }
}
```

### Rules

- `action: "execute"` without a `tool_name` is **invalid**. It returns an error. **Do not retry
  the same call** — go back to `list_tools` and read the real tool name.
- Never pass a platform tool name as `action`. `action` is only ever `"list_tools"` or `"execute"`.
- `search_tools` and `get_tool_schema` are **top-level**. Call them directly when they are in
  your tool list. If your client does not list `get_tool_schema`, call it through any platform
  router: `google_ads` with `action: "execute"`, `tool_name: "get_tool_schema"`,
  `arguments: {"tool_names": [...]}`. It returns the same schema. Never stop because it is missing.
- Never guess a tool name or a parameter. If you are unsure, call `list_tools` or `get_tool_schema`.

## Finding the right tool

When you don't know which tool does the job:

1. `search_tools` with a natural-language description of the task.
2. `get_tool_schema` with the candidate names to get their exact parameters. Not in your tool
   list? Call it through a router (see Rules above).
3. Call the tool: directly if it's in the direct list above, otherwise through its router with
   `action: "execute"`.

## Budgets: the unit differs per platform

This is the single most common error. **Read the row before you send a budget.**

| Platform | Unit | `$50/day` becomes |
|---|---|---|
| Google Ads | account currency (decimal) | `50.0` |
| Meta Ads | account currency (decimal) | `50.0` |
| TikTok Ads | account currency (decimal) | `50.0` |
| LinkedIn Ads | account currency (decimal) | `50.0` |
| Amazon Ads | account currency (decimal) | `50.0` |
| ChatGPT Ads | account currency (decimal) | `50.0` |
| Microsoft Advertising | account currency (decimal) | `50.0` |

**Every platform takes the budget in the account's own currency as a plain decimal — never
cents, never multiplied by anything.** For a `$20/day` budget send `20`, not `2000`. For
`$50/day` send `50`. The tools convert to each platform's internal unit for you; if you send
`2000` meaning `$20` you will book **`$2,000/day`** — a 100× overspend.

Never convert the user's currency to USD. Send the number in the account's own currency.

## Accounts

One connected account is selected automatically. With two or more *active* accounts you must name
one — the call fails with a `multi_account` error that lists them.

The parameter name differs per platform:

| Platform | Parameter |
|---|---|
| Google Ads | `customer_id` |
| Meta Ads | `ad_account_id` |
| TikTok Ads | `advertiser_id` |
| LinkedIn Ads | `account_id` |
| Amazon Ads | `profile_id` |
| ChatGPT Ads | `account_id` |
| Microsoft Advertising | `account_id` (from `list_microsoft_accounts`) |

Send IDs as **strings**, not numbers. Naming an account the user has not connected returns a 403 —
it never quietly falls back to another account, so do not treat 403 as "try again without the id."

Use `get_connections_status` to see what is connected.

## Quota

Most platform tool calls count toward the user's monthly allowance of tool calls.

**Free, call these as much as you need:** `action: "list_tools"` on any router, `start_here`,
`get_connections_status` and `get_usage_status`.

Because discovery is free, there is never a reason to guess a tool name to save calls.

If a call is refused because the user's allowance is used up, tell the user plainly that they've
reached their limit for this period and when it resets (`get_usage_status` shows both). Don't work
around it, don't switch to another tool to get the same data, and never invent the numbers.

## Tools for services the user hasn't connected

`google_analytics`, `google_search_console`, `google_tag_manager`, `klaviyo` and the ad-platform
routers are always listed, even before the user connects that service. Calling one that isn't
connected returns a message asking the user to connect it. Relay that and point them at
`https://adspirer.ai/connections`; don't treat it as an error to retry.

## When something fails

Read `references/error-catalog.md` for the known error codes and their fixes before retrying
anything. Retrying an invalid call unchanged will fail the same way.
