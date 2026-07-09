# Error catalog

Known failures, what they mean, and the fix. Check here before retrying anything — most of these
fail identically on retry.

## Call-shape errors

**`action: "execute"` returned "tool_name is required"**
You sent `execute` with no `tool_name`. Do not retry. Call `{"action": "list_tools"}` on the same
router, read the real tool name, then execute.

**"Tool not found" for a name you're sure exists**
You called a platform tool at the top level. Only the ten direct tools can be called by name;
everything else goes through its router with `action: "execute"`. See the tool table in `SKILL.md`.

**`search_tools` or `get_tool_schema` returned "Tool not found"**
You wrapped them in `action: "execute"`. Both are top-level. Call them directly.

## Account errors

**400, `multi_account`**
The user has two or more active accounts on that platform and none was named. The error lists the
accounts and the exact parameter to pass. Ask the user which one, then resend with e.g.
`customer_id` (Google) or `ad_account_id` (Meta).

**403 on an account id you passed**
That account is not connected, or was deactivated. Adspirer will *not* silently fall back to
another account, because that would report the wrong account's numbers. Do not retry without the
id. Call `get_connections_status`, show the user what is actually connected, and let them pick or
reconnect at `https://adspirer.ai/connections`.

**"No account found" / "connect your account"**
Nothing is connected for that platform, or the token expired. Point the user at
`https://adspirer.ai/connections`. Don't attempt the operation.

## Budget errors

**Meta campaign booked at 100× the intended budget**
You sent dollars where Meta expects cents. `daily_budget` is an integer in cents: `$50/day` is
`5000`. Worse, any value **below 100** is treated as dollars and multiplied by 100, so `50` books
$50/day and looks correct until you compare it with `500`, which also books $5.00/day. Always send
cents, always ≥ 100.

**TikTok: "Your budget setting must not be less than X"**
Below TikTok's per-currency daily floor. USD 20, EUR 20, GBP 15, CAD 25, AUD 30, SGD 25, BRL 100,
HKD 150, MXN 350, ZAR 500, TWD 600, PHP 1000, INR 1500, JPY 2500. Lifetime floor is roughly 7× the
daily floor. See `adspirer-tiktok-ads/references/validity-matrix.md`.

## TikTok

**Error 40002 on a single-image in-feed ad**
TikTok does not support single-image in-feed ads. Use a video ad, a Spark Ad
(`tiktok_item_id`), or a carousel (2–10 images, via `create_tiktok_carousel_card`).

**`pixel_id` rejected — `PIXEL_ID_NOT_ALLOWED_FOR_OBJECTIVE`**
An ad-group `pixel_id` is only valid for `CONVERSIONS`, `WEB_CONVERSIONS`, `PRODUCT_SALES`, and
`SHOP_PURCHASES`. For every other objective the pixel goes on the **ad** as `tracking_pixel_id`.
This is the most frequent TikTok error. When you do set an ad-group `pixel_id`,
`optimization_event` becomes required.

**`video_id` comes back as the string `"None"`**
The upload silently failed. The value is literally `"None"`, not null. Re-upload the video; do not
create the ad with it.

**CTA rejected**
`LEARN`, `VISIT`, and `GO` are not valid. Use `LEARN_MORE`, `SHOP_NOW`, `DOWNLOAD_NOW`, `SIGN_UP`,
`GET_QUOTE`, `BOOK_NOW`, or `INSTALL_NOW`.

## Meta

**Ad creation rejected — missing page**
Meta requires a Facebook `page_id` and an `http(s)` landing URL on every ad. Call
`list_meta_pixels` / the account's pages first if you don't have one.

**Objective rejected**
Meta uses ODAX objectives: `OUTCOME_AWARENESS`, `OUTCOME_TRAFFIC`, `OUTCOME_ENGAGEMENT`,
`OUTCOME_LEADS`, `OUTCOME_APP_PROMOTION`, `OUTCOME_SALES`. Legacy names (`CONVERSIONS`,
`LINK_CLICKS`, `LEAD_GENERATION`) are auto-mapped, but prefer the ODAX name.

**Write blocked / rate limited**
Meta campaign creation is rate-guarded per user (100/hr, 300/day). Updates and pauses are not
limited. If a write is blocked, stop — do not retry in a loop.

## Google

**"Asset bundle expired"**
Bundles from `validate_and_prepare_assets` live for **1 hour**. Re-run it and use the fresh bundle.

**Keyword or ad tool rejects a missing `ad_group_id`**
Run `get_campaign_structure` first to get the ad group ids. Keywords and ads attach to ad groups,
not campaigns.

**PMax campaign has no assets**
Call `discover_existing_assets` before creating any Performance Max campaign.

## LinkedIn

**Campaign creation rejected — no campaign group**
Every LinkedIn campaign belongs to a campaign group. Pass an existing `campaign_group_id`, or a new
`campaign_group_name` to have one created.

## Quota

**Quota exceeded**
Show the user the full error message — it contains their upgrade link. Do not route around it, do
not switch to another tool to get the same data, and never fabricate the numbers. `list_tools`,
`get_usage_status`, `get_connections_status`, and `start_here` remain free.
