# Adspirer docs map

A snapshot of the documentation index, so common questions can be answered without a fetch. Append
`.md` to any URL to get plain markdown.

> Regenerated from `https://www.adspirer.com/docs/llms.txt` by `scripts/gen-doc-map.sh`.
> **The live page always wins.** If a figure here disagrees with the page, the page is right.

## Start here

| Question | Page |
|---|---|
| What is Adspirer? | `/docs/introduction` |
| How do I get started? | `/docs/quickstart` |
| How does it actually work? | `/docs/how-it-works` |
| What's new? | `/docs/changelog` |
| What is the MCP server? | `/docs/mcp` |

## Plans, quota, billing

| Question | Page |
|---|---|
| **Pricing, plans, tool-call limits, overage** | `/docs/knowledge-base/pricing` |
| What can Adspirer do? | `/docs/knowledge-base/capabilities` |
| Common questions | `/docs/knowledge-base/faq` |
| Enterprise, pooled quota, many seats | `/docs/knowledge-base/enterprise` |
| Several ad accounts on one login | `/docs/knowledge-base/multi-account` |
| Agencies with several clients | `/docs/knowledge-base/multi-client` |
| Security, data handling | `/docs/knowledge-base/security` |
| Getting help | `/docs/knowledge-base/support` |
| Jargon | `/docs/knowledge-base/glossary` |

### Pricing

**No prices are recorded here, on purpose.** Plans, prices, included tool calls, and overage rates
change, and a stale number quoted confidently is worse than no number.

Only these facts are stable enough to state without checking:

- Billing is per **tool call** — a task the assistant performs — not per dollar of ad spend.
- There are four self-serve plans (Free, Plus, Pro, Max) plus Enterprise.
- Annual plans use a single pooled yearly allowance instead of monthly caps.

For anything else — what a plan costs, how many calls it includes, whether overage applies:

- **The live page**: `https://www.adspirer.com/docs/knowledge-base/pricing` (append `.md` for markdown).
- **This user's own quota and plan**: call `get_usage_status`. It's free and it's authoritative for
  their account. Never read a plan's allowance out of the docs when the user is asking about
  *their* remaining calls.

If you cannot reach the page, say so and link it. Do not reconstruct the table from memory.

## Ad platforms

| Platform | Page |
|---|---|
| Google Ads | `/docs/ad-platforms/google-ads` |
| Google Display | `/docs/ad-platforms/google-display-ads` |
| YouTube | `/docs/ad-platforms/youtube-ads` |
| Meta (Facebook, Instagram) | `/docs/ad-platforms/meta-ads` |
| TikTok | `/docs/ad-platforms/tiktok-ads` |
| LinkedIn | `/docs/ad-platforms/linkedin-ads` |
| Amazon | `/docs/ad-platforms/amazon-ads` |
| ChatGPT Ads (OpenAI Ads) | `/docs/ad-platforms/chatgpt-ads` |

## Connecting an AI client

| Client | Page |
|---|---|
| ChatGPT | `/docs/ai-clients/chatgpt` |
| Claude | `/docs/ai-clients/claude` |
| Claude Code | `/docs/ai-clients/claude-code` |
| Claude Cowork | `/docs/ai-clients/claude-cowork` |
| Codex | `/docs/ai-clients/codex` |
| Cursor | `/docs/ai-clients/cursor` |
| Gemini CLI | `/docs/ai-clients/gemini-cli` |
| OpenClaw | `/docs/ai-clients/openclaw` |
| Perplexity | `/docs/ai-clients/perplexity` |
| Windsurf | `/docs/ai-clients/windsurf` |
| Manus | `/docs/ai-clients/manus` |

To connect or reconnect an **ad account**, send users to `https://adspirer.ai/connections`.

## Agent and skills

| Topic | Page |
|---|---|
| Overview | `/docs/agent-skills/overview` |
| The skills | `/docs/agent-skills/skills` |
| The marketing agent | `/docs/agent-skills/agent` |
| The tools | `/docs/agent-skills/tools` |
| Workflows | `/docs/agent-skills/workflows` |
| Autonomous ad-ops agents | `/docs/agent-skills/ad-ops-agents` |
| Community plugins | `/docs/agent-skills/community-plugins` |
| Diagnostic tools | `/docs/agent-skills/diagnostic-helper-tools` |

## Integrations

Google Analytics `/docs/integrations/google-analytics` · Klaviyo `/docs/integrations/klaviyo`

Both appear as tools **only** once the user has connected them.

## Guides

`/docs/guides/` — `ai-advertising`, `automate-google-ads`, `automate-facebook-ads`,
`tiktok-ads-guide`, `marketing-agency-automation`, `chatgpt-google-ads-keywords`,
`claude-cowork-ad-ops`, `perplexity-computer-ads`, `deploy-paid-media-agent-hostinger`

## API reference

Per-tool pages at `/docs/api-reference/<platform>/<tool-name>`, e.g.
`/docs/api-reference/google-ads/create-search-campaign`. Around 180 pages covering Google, Meta,
TikTok, LinkedIn, Amazon, ChatGPT Ads, monitoring, and the general tools.

For a tool's *live* signature, prefer `get_tool_schema` over the docs — it reads the running
definition and cannot be stale.

## Stable facts

These don't change and can be stated without a fetch:

- Campaigns are **created paused** on every platform. Nothing spends until it is resumed.
- Billing is per tool call, not per dollar of ad spend.
- Adspirer never posts a change the user hasn't approved.
- Connect and reconnect ad accounts at `https://adspirer.ai/connections`.
