---
name: adspirer-docs
description: Answer questions about Adspirer itself — pricing, plans, quota and tool-call limits, what Adspirer can do, connecting an ad account, supported platforms and AI clients, security, and troubleshooting. Uses the official documentation at adspirer.com/docs rather than guessing.
---

# Adspirer product questions

Questions about Adspirer — what it costs, what's included, how to connect an account, what it can
do — are answered from the documentation, never from memory. Pricing and limits change.

## How to answer

1. **Look in `references/doc-map.md` first.** It maps topics to the exact doc URL and carries the
   answers to the most common questions. Most questions end here, with no fetch.

2. **If you need the page content and you can fetch,** retrieve the specific page. Every doc page
   has a plain-markdown twin: append `.md` to the URL.
   `https://www.adspirer.com/docs/knowledge-base/pricing.md`

   There is a full export at `https://www.adspirer.com/docs/llms-full.txt`. It is about 85,000
   characters. **Never pull it whole.** Fetch the specific page instead.

3. **If you cannot fetch anything**, answer from `references/doc-map.md` and link the user to the
   page. Say that you're working from a cached summary and that the docs are authoritative.

## Live account state is not a docs question

"What does Pro cost?" is documentation. "How much quota do *I* have left?" is `get_usage_status`.
"Is my Meta account connected?" is `get_connections_status`. Both are free calls. Use the tool for
anything about *this* user's account; use the docs for how the product works.

## Never quote a price from memory

Tiers, prices, included tool calls, and overage rates change often. **No price is written into
these skills, deliberately.** Read the live page or don't answer with a number.

- What a plan costs → fetch `https://www.adspirer.com/docs/knowledge-base/pricing.md`, or link it.
- How much quota *this user* has left → `get_usage_status`. Free, and authoritative for their
  account. Never infer it from a plan's advertised allowance.

If you cannot fetch, say you don't want to quote a stale price, and link the page. A confidently
wrong price is worse than a link.

The same applies to tool counts, supported platforms, and anything in a comparison table — those
move too. Point at the docs.

## Links

Only these:

- `https://adspirer.ai` — the web app
- `https://adspirer.ai/connections` — connect or reconnect an ad account
- `https://adspirer.ai/dashboards` — plural
- `https://www.adspirer.com/docs` — documentation, and any real page beneath it

Never `/billing`, `/settings`, `/pricing`, `/dashboard` (singular), or `app.adspirer.com`. Never
invent a subpath or an anchor — if you didn't read it in the doc map or fetch it, don't link it.

Do not send anyone to `llms.txt` or `llms-full.txt`. Those are machine indexes, not pages for
humans.

## References

- `references/doc-map.md` — topic → URL index, plus the common answers.
