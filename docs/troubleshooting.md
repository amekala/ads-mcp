# Troubleshooting

## OAuth Cannot Complete

- Verify `issuer` and endpoints in `/.well-known/oauth-authorization-server`
- Check `/.well-known/oauth-protected-resource` for authorization server discovery
- Confirm redirect URIs are registered and exact (scheme/host/path)

## No Visible Progress During Long Calls

- Some clients decide per-call whether to request a progress token
- The operation will complete and a final result will be delivered even if no progress frames are displayed
- Use polling tools (`jobs.start_*`, `jobs.get_status`) if your client doesn't stream

## Media URL Rejected

- Use HTTPS URLs that resolve to the actual media file (not an HTML share page)
- Supported hosts: postimages.org, postimg.cc, imgur.com, or direct CDN links
- Very large files (>10MB) or unusual formats may be declined
- Try standard web formats (PNG/JPEG/MP4) with valid `Content-Type` headers

## False Success Messages

- If you see "Campaign ID: None" or similar, the campaign was not created
- Check backend error messages in the tool response
- Common issues: budget too low (<$50/day), invalid targeting, policy violations

## Image Download Errors (404)

- Some CDNs return 404 on first request; the server retries automatically
- If persistent, verify URL is accessible in a browser
- Ensure URL is a direct link, not a share page
