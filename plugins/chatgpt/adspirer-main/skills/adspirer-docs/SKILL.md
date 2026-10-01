---
name: adspirer-docs
description: Answer questions about Adspirer itself — what Adspirer can do, tool-call limits, connecting an ad account, supported platforms and AI clients, security, and troubleshooting. Uses the official documentation at adspirer.com/docs rather than guessing.
---

# Adspirer product questions

Questions about Adspirer — how to connect an account, what it can do, how limits work — are
answered from the documentation, never from memory. Features and limits change.

## How to answer

1. **Look in `references/doc-map.md` first.** It maps topics to the exact doc URL and carries the
   answers to the most common questions. Most questions end here, with no fetch.

2. **If you need the page content and you can fetch,** retrieve the specific page. Every doc page
   has a plain-markdown twin: append `.md` to the URL.
   `https://www.adspirer.com/docs/knowledge-base/capabilities.md`

   There is a full export at `https://www.adspirer.com/docs/llms-full.txt`. It is about 85,000
   characters. **Never pull it whole.** Fetch the specific page instead.

3. **If you cannot fetch anything**, answer from `references/doc-map.md` and link the user to the
   page. Say that you're working from a cached summary and that the docs are authoritative.

## Live account state is not a docs question

"How many tool calls do *I* have left?" is `get_usage_status`. "Is my Meta account connected?" is
`get_connections_status`. Both are free calls. Use the tool for anything about *this* user's
account; use the docs for how the product works.

## Plans and prices

Don't quote prices or recommend a plan. If the user asks what plans exist or what they cost, link
the informational page `https://www.adspirer.com/docs/knowledge-base/pricing` and let them read it.
Never link a checkout or payment page.

Tool counts, supported platforms and anything in a comparison table change too. Point at the docs
rather than quoting them from memory.

## Links

Only these:

- `https://adspirer.ai` — the web app
- `https://adspirer.ai/connections` — connect or reconnect an ad account
- `https://adspirer.ai/dashboards` — plural
- `https://www.adspirer.com/docs` — documentation, and any real page beneath it

Never `/billing`, `/settings`, `/pricing`, `/dashboard` (singular), `app.adspirer.com`, or a checkout link. Never
invent a subpath or an anchor — if you didn't read it in the doc map or fetch it, don't link it.

Do not send anyone to `llms.txt` or `llms-full.txt`. Those are machine indexes, not pages for
humans.

## References

- `references/doc-map.md` — topic → URL index, plus the common answers.
