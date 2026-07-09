---
name: adspirer-chatgpt-ads
description: Create and manage ChatGPT Ads (OpenAI Ads) through Adspirer — ads that appear inside ChatGPT responses. Use for OpenAI Ads, ChatGPT advertising, chat card ads, or placing ads in ChatGPT. Covers the one-shot launch tool and irreversible archiving.
---

# ChatGPT Ads (OpenAI Ads)

Ads that appear inside ChatGPT responses. Everything goes through the `chatgpt_ads` router. Follow
`adspirer-mcp` for the two-step.

Account parameter: `account_id`, as a **string**. `list_chatgpt_accounts` enumerates them.
Budgets are in **dollars** — `$50/day` is `50.0`.

## Launching

`launch_chatgpt_ad` does the whole thing in one call: campaign, ad group, creative upload, and a
chat-card ad. Use it when the user hands you a headline, body, image, and destination.

Use the granular path — `create_chatgpt_campaign` → `create_chatgpt_ad_group` →
`upload_chatgpt_creative` → `create_chatgpt_ad` — when they want to review each level, or when
you're adding to a campaign that already exists.

Either way the campaign is created **paused**. Nothing serves and nothing spends until it is resumed.

## Locations

Don't pass a place name. `chatgpt_geo_lookup` resolves "United States" or "Greater London" to the
location ids OpenAI expects.

## Archiving is not pausing

`archive_chatgpt_campaign` is irreversible. `pause_chatgpt_campaign` is not. When the user says
"stop this campaign," they nearly always mean pause. Confirm explicitly before archiving anything,
and name what will be lost.

Pause and resume exist at all three levels — campaign, ad group, and ad. Pause the narrowest thing
that solves the problem.

## Creative

A chat card is a headline, a body, an image, and a destination URL. It is read inline in a
conversation, so the copy has to earn attention without a scroll: lead with the offer, keep the body
concrete, and make the destination match the promise. This is not the place for a slogan.

## Conversions

`set_chatgpt_conversions_config` wires conversion tracking; `list_chatgpt_conversion_events` shows
what's firing and `test_chatgpt_conversion` proves it end-to-end before the user trusts the numbers.
Optimizing toward conversions that were never verified is how budgets get wasted quietly.

## Reading performance

Through the router: `{"action": "execute", "tool_name": "get_chatgpt_performance", ...}`.
`get_chatgpt_insights` adds the qualitative breakdown.

This is a young surface — inventory and delivery are less predictable than Google or Meta. Set the
expectation before the user compares a first week here to a mature Search campaign.
