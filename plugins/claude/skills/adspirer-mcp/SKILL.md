---
name: adspirer-mcp
description: How to call the Adspirer MCP hub correctly — the router two-step (action "list_tools" then action "execute" with tool_name), the direct tools search_tools and get_tool_schema, per-platform account IDs, quota rules, and the budget unit (every platform takes the account's own currency as a decimal — never cents). Load this before making any Adspirer tool call.
---

# Calling the Adspirer MCP hub

Adspirer exposes a small set of **top-level tools**. Platform and product tools sit behind
*routers*. Calling a platform tool by its own name does not work — it is not in the tool list.
Read this before your first tool call. The live list wins over the names below: `list_tools` and
`get_tool_schema` are free.

## The tool surface

**Call these directly, by name:**

| Tool | Use it for |
|---|---|
| `start_here` | New or unsure user. Free. |
| `search_tools` | "Which tool does X?" Semantic search over every tool. |
| `get_tool_schema` | Exact parameters for a tool, before you call it. |
| `get_connections_status` | Which ad accounts are connected, and their health. Free. |
| `get_usage_status` | Plan, quota, usage this period. Free. |
| `switch_primary_account` | Change which account is active. |
| `get_campaign_performance` | Google Ads performance. |
| `get_meta_campaign_performance` | Meta (Facebook/Instagram) performance. |
| `audit_conversion_tracking` | Conversion-tracking health for Google, Meta, and LinkedIn. Not Microsoft. |
| `diagnose_funnel` | Where a conversion path breaks, read-only. Stops at the first broken step. |
| `competitor_ads_research` | Public competitor ads. Not on the Free plan. |
| `echo_test` | Connectivity check. Free. |

**These are routers.** Never call their inner tools by name:

`google_ads` · `meta_ads` · `linkedin_ads` · `tiktok_ads` · `amazon_ads` · `microsoft_ads` ·
`chatgpt_ads` · `monitoring_and_reporting` · `community_plugins`

These appear only when that product is connected:

`google_analytics` · `google_search_console` · `google_tag_manager` · `klaviyo`

Another product router may show up the same way. If you don't see it, it isn't connected — say so
and point the user at `https://adspirer.ai/connections`. Don't insist the tool exists.

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
| Microsoft Advertising | `account_id` |
| ChatGPT Ads | `account_id` |

Send IDs as **strings**, not numbers. Naming an account the user has not connected returns a 403 —
it never quietly falls back to another account, so do not treat 403 as "try again without the id."

Use `get_connections_status` to see what is connected.

### Conversion-tracking audit

`audit_conversion_tracking` is direct. Send `platform` and the account id as a string
(`customer_id` on Google). `lookback_days` is 7, 14, 30, 60, or 90. It covers Google, Meta, and
LinkedIn — not Microsoft. It looks back from today, not over whatever history a performance read
cached. If that window had no delivery, "no conversions" is not proof the tag is broken. Say the
window had no delivery.

With more than one Google Ads account connected, the tool can ignore `customer_id` and answer
"You have N google_ads accounts connected. Please specify..." anyway. Retry the same call once.
If it fails the same way, don't keep retrying. See the error catalog.

Switching the primary account (`switch_primary_account`) changes which account later calls treat
as active. That needs its own yes. It is not something you do silently to make an audit run.

## Quota

Every tool call against a platform costs one call from the user's monthly quota
(Free 15 · Plus 150 · Pro 600 · Max 3,000).

**Free — call these as much as you need:** `action: "list_tools"` on any router, `start_here`,
`get_connections_status`, `get_usage_status`, `echo_test`, and everything under `community_plugins`.

Because discovery is free, there is never a reason to guess a tool name to save quota.

When a user runs out: Plus/Pro/Max monthly plans keep working and bill per extra call; annual plans
stop at the cap. Show the error message you receive — it carries the upgrade link. Do not work
around a quota error or invent the data.

## Tools that may not be there

`google_analytics`, `google_search_console`, `google_tag_manager`, and `klaviyo` appear only when
that product is connected. If you don't see the router, the connection is missing — say so and
point them at `https://adspirer.ai/connections`. Don't insist the tool exists. `microsoft_ads` is
a platform router like Google and Meta; a missing performance or keyword tool *inside* it is a
catalog gap, not a missing connection. `adspirer-microsoft-ads` describes that gap.

## When something fails

Read `references/error-catalog.md` for the known error codes and their fixes before retrying
anything. Retrying an invalid call unchanged will fail the same way.
