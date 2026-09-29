# TikTok validity matrix

TikTok rejects invalid combinations rather than correcting them, and a rejected call fails
identically on retry. Check the combination here before you build the ad group.

## Valid objectives

`REACH` · `RF_REACH` · `VIDEO_VIEWS` · `ENGAGEMENT` · `TRAFFIC` · `APP_INSTALL` · `APP_PROMOTION` ·
`LEAD_GENERATION` · `CONVERSIONS` · `WEB_CONVERSIONS` · `PRODUCT_SALES` · `SHOP_PURCHASES` ·
`CATALOG_SALES`

Anything else returns 40002, "This campaign objective isn't supported." Some accounts also lack the
permission scope for an objective they'd otherwise be allowed — the error looks the same. Run
`explain_tiktok_objective` first to tell the two apart.

## Where the pixel goes

| Objective | Pixel placement |
|---|---|
| `CONVERSIONS`, `WEB_CONVERSIONS`, `PRODUCT_SALES`, `SHOP_PURCHASES` | **Ad group**: `pixel_id`. `optimization_event` then becomes **required**. |
| Every other objective | **Ad**: `tracking_pixel_id`. An ad-group `pixel_id` is rejected. |

Setting `pixel_id` on the ad group for, say, `TRAFFIC` returns
`PIXEL_ID_NOT_ALLOWED_FOR_OBJECTIVE`. This is the most frequent TikTok failure.

## Field dependencies

| Field | Required when |
|---|---|
| `promotion_type` | Objective is **not** `REACH`, `RF_REACH`, `VIDEO_VIEWS`, or `ENGAGEMENT` |
| `frequency` + `frequency_schedule` | Objective is `REACH` or `RF_REACH`. Try 3 impressions / 7 days. |
| `app_id` + `operating_systems` | Objective is `APP_INSTALL` or `APP_PROMOTION`. One OS per ad group. |
| `optimization_event` | An ad-group `pixel_id` is set |
| `secondary_optimization_event` | Only valid when `optimization_goal` is `INSTALL` or `VALUE`. Invalid otherwise. |

## Ad formats

Single static image as an in-feed ad is **not supported** — error 40002. The options are:

- **Video** — the default.
- **Spark Ad** — boost an existing organic post; pass `tiktok_item_id`.
- **Carousel** — 2 to 10 images plus music, via `create_tiktok_carousel_card`.

## Upload failure

`video_id` returned as the literal string `"None"` means the upload silently failed. It is not
null and raises no error. Re-upload; never build an ad with it.

## Call-to-action

Rejected: `LEARN`, `VISIT`, `GO`.

Valid: `LEARN_MORE` · `SHOP_NOW` · `DOWNLOAD_NOW` · `SIGN_UP` · `GET_QUOTE` · `BOOK_NOW` · `INSTALL_NOW`

## Minimum daily budget by currency

Below these, TikTok replies "Your budget setting must not be less than X." Lifetime budgets floor at
roughly **7× the daily** figure.

| | | | | | |
|---|---|---|---|---|---|
| USD 20 | EUR 20 | GBP 15 | CAD 25 | AUD 30 | SGD 25 |
| BRL 100 | HKD 150 | MXN 350 | ZAR 500 | TWD 600 | PHP 1,000 |
| INR 1,500 | JPY 2,500 | MYR 80 | THB 700 | VND 470,000 | IDR 280,000 |
| AED 70 | SAR 80 | ILS 70 | PLN 80 | TRY 600 | EGP 600 |

Any currency not listed defaults to a floor of 50.

Never convert the user's currency to USD. Send the number in the account's own currency.
