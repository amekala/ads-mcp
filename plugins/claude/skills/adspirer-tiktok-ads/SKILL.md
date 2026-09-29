---
name: adspirer-tiktok-ads
description: Create and manage TikTok Ads through Adspirer — in-feed video, Spark Ads, carousel, app promotion, and conversions campaigns. Use for anything on TikTok. Covers the pixel-placement rule that causes most TikTok failures, the unsupported single-image ad, and per-currency budget floors.
---

# TikTok Ads

Everything on TikTok goes through the `tiktok_ads` router. Follow `adspirer-mcp` for the two-step.

Account parameter: `advertiser_id`, as a **string**. Budgets are in the account's currency.

TikTok rejects invalid combinations of objective, optimization goal, and tracking rather than
correcting them. **Check `references/validity-matrix.md` before you build an ad group.** A rejected
call fails the same way on retry.

## The pixel rule — read this before anything else

Where the pixel goes depends on the objective:

- Objective is `CONVERSIONS`, `WEB_CONVERSIONS`, `PRODUCT_SALES`, or `SHOP_PURCHASES` →
  set `pixel_id` on the **ad group**, and `optimization_event` becomes required.
- **Any other objective** → the pixel goes on the **ad** as `tracking_pixel_id`. An ad-group
  `pixel_id` is rejected with `PIXEL_ID_NOT_ALLOWED_FOR_OBJECTIVE`.

This single rule is the most common TikTok error we see. A traffic campaign with a pixel on the ad
group fails every time.

## There is no single-image in-feed ad

TikTok does not support one static image as an in-feed ad. It returns error 40002. Use:

- a **video** ad (`create_tiktok_video_campaign`),
- a **Spark Ad** boosting an existing organic post (`tiktok_item_id`), or
- a **carousel**, 2–10 images with music (`create_tiktok_carousel_card`).

If the user only has one image, say so and offer the carousel or a video.

## Uploads fail quietly

After uploading a video, check `video_id`. If it comes back as the **string `"None"`**, the upload
failed — it is not null and it will not error. Re-upload. Never create an ad with `video_id: "None"`.

## Budgets have per-currency floors

USD 20 · EUR 20 · GBP 15 · CAD 25 · AUD 30 · SGD 25 · BRL 100 · HKD 150 · MXN 350 · ZAR 500 ·
TWD 600 · PHP 1000 · INR 1500 · JPY 2500. Lifetime budgets floor at roughly 7× the daily figure.
The full table is in the reference. Below the floor TikTok replies "Your budget setting must not be
less than X."

## Objectives

Valid: `REACH`, `RF_REACH`, `VIDEO_VIEWS`, `ENGAGEMENT`, `TRAFFIC`, `APP_INSTALL`, `APP_PROMOTION`,
`LEAD_GENERATION`, `CONVERSIONS`, `WEB_CONVERSIONS`, `PRODUCT_SALES`, `SHOP_PURCHASES`,
`CATALOG_SALES`.

Some accounts lack the permission scope for a given objective and get a generic "objective isn't
supported." Run `explain_tiktok_objective` to check before building.

Dependencies worth knowing up front:

- `promotion_type` is required unless the objective is `REACH`, `RF_REACH`, `VIDEO_VIEWS`, or `ENGAGEMENT`.
- `REACH` and `RF_REACH` require `frequency` and `frequency_schedule` (3 impressions / 7 days is a sane start).
- `APP_INSTALL` and `APP_PROMOTION` require `app_id` and `operating_systems` — one OS per ad group.
- `secondary_optimization_event` is only valid when `optimization_goal` is `INSTALL` or `VALUE`.

## Call-to-action

`LEARN`, `VISIT`, and `GO` are rejected. Use `LEARN_MORE`, `SHOP_NOW`, `DOWNLOAD_NOW`, `SIGN_UP`,
`GET_QUOTE`, `BOOK_NOW`, or `INSTALL_NOW`.

## Build order

Campaign → `add_tiktok_ad_group` → `add_tiktok_ad`. Campaigns are created **paused**.

You need an identity (the account the ad posts as) — `list_tiktok_identities`. Without one, the ad
has no author and creation fails.

## References

- `references/validity-matrix.md` — the full objective × pixel × optimization matrix, currency
  floors, and CTA list. Read it before building an ad group.
