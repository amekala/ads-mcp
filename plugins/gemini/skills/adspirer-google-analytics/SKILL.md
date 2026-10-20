---
name: adspirer-google-analytics
description: Read Google Analytics 4 through Adspirer to inform paid-media decisions — acquisition, landing pages, engagement, and key events. Use when the user wants GA4 alongside ad performance. GA4 numbers stay separate from ad-platform conversions.
---

# Google Analytics 4

The router is `google_analytics`. It appears only when GA4 is connected. Follow `adspirer-mcp`: `{"action": "list_tools"}` first, then execute an exact name from that list. `get_tool_schema` before you execute.

If the router is missing, or it says GA4 isn't connected, say so and point the user at `https://adspirer.ai/connections`. Don't insist the tool exists.

Typical reads, using whatever the live list actually calls them: list property options, then run a report with `property` set to `properties/<id>`. Send an `account_id` only when several GA accounts are connected and the schema asks for it.

## Pick the property out loud

If several properties come back, show the list (name and id) and let the user choose. Never guess a property id. If they say "all", warn that it costs one call per property and confirm before you loop.

Confirm the dates, the timezone, the currency, and that the dimensions and metrics you chose are valid together.

## What to pull for a paid-media question

Acquisition (session source and medium, paid versus organic), landing page, engagement, and key events. That is enough for most "is paid sending the right traffic?" questions.

Keep users, sessions, events, and key events separate. Never add incompatible metrics together. Explain that GA4 attribution and reporting lag differ from the ad platform. If the response says it was sampled or thresholded, say that.

## Don't mix it into the ad totals

GA4 key events are not Google Ads conversions and not Meta results. Report them beside the ad numbers, labeled as GA4. Never add them to ad conversions, and never use a GA4 count to fill a missing ad conversion.

A key event that doesn't appear in one report doesn't prove the ad tag is broken. Tracking method is `adspirer-ads-manager-browser`. Tag configuration is `adspirer-tag-manager`.

Start read-only. A configuration change needs its own yes, and only if the live tool list even offers one. Follow `adspirer-agent` on evidence and on not retrying a write you haven't read back.
