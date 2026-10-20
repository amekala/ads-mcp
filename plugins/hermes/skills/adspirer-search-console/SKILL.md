---
name: adspirer-search-console
description: Read Google Search Console through Adspirer to inform paid search — organic queries, pages, clicks, impressions, CTR, and position. Submitting a URL for indexing is a separate yes. Organic numbers are not paid conversions.
---

# Google Search Console

The router is `google_search_console`. It appears only when Search Console is connected. Follow `adspirer-mcp`: `{"action": "list_tools"}` first, then execute an exact name from that list.

If it isn't connected, say so and point the user at `https://adspirer.ai/connections`.

Usual tools, under whatever names the live list returns: list properties, retrieve performance, and submit a URL for indexing. The last one is a write.

## Pick the property

Show the user the properties (domain property or URL-prefix property) and let them choose when there is more than one. Never guess the property URL.

Confirm dates, country, device, search type, and dimensions (query, page, country, device, date). Use the row limit the schema documents, and say if the result was truncated.

## What this data is

Query and page clicks, impressions, CTR, and average position, for the connected property's own organic search. Use it to find paid opportunities: high-impression low-CTR queries, commercial queries ranking poorly, and pages that already earn organic clicks and could be landing pages.

It is not competitor rankings, market keyword volume, paid CPC, a backlink index, or a crawl of the website. Say so if the user asks for one of those. Competitor ads are `adspirer-competitors`. Keyword volume is `adspirer-keywords`.

Mention any aggregation or privacy limits the response itself reports.

Recommend a paid test. Don't create a campaign from this skill.

## Indexing is a write

Submitting a URL for indexing needs a yes for the exact URLs and the action (updated or deleted). Don't promise that Google will index them. Read the result back. One acceptance is not proof the URL is in the index.

Organic clicks are not ad conversions. Never add them to a platform's conversion total.
