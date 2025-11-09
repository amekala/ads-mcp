# Troubleshooting

## Authentication Issues

### "401 Unauthorized" error when calling MCP tools

**Solution:**
1. Check that your OAuth token hasn't expired - try reconnecting your account
2. Disconnect and reconnect your Google Ads/TikTok accounts in Claude/ChatGPT settings
3. Verify you've completed the OAuth flow successfully
4. Check server logs for specific authentication errors

### "No primary account found"

**Solution:**
1. Ensure you've connected at least one Google Ads or TikTok account
2. For Google Ads: Use the Adspirer web UI to set a primary account
3. Verify the account is active and accessible in your advertising platform
4. Try disconnecting and reconnecting the account

### OAuth redirect fails or loops indefinitely

**Solution:**
1. Clear your browser cookies and cache
2. Ensure you're using a supported browser (Chrome, Firefox, Safari, Edge)
3. Check that popups are not blocked for Claude.ai or ChatGPT.com
4. Try using an incognito/private browsing window

---

## Tool Execution Errors

### "Tool not found: create_pmax_campaign" or similar

**Solution:**
1. Verify you're connected to the correct MCP server (https://mcp.adspirer.com/)
2. Check the tool name spelling matches exactly (case-sensitive)
3. Call the tool via Claude/ChatGPT interface, not manually
4. Restart your Claude/ChatGPT session if tools disappeared

### Asset validation fails for Performance Max campaigns

**Solution:**
1. **Images must be HTTPS URLs** (not HTTP) - use services like postimages.org or imgbb.com
2. **Check image dimensions:** Google requires specific aspect ratios (1.91:1, 1:1, 4:5)
3. **Verify file size:** Images must be under 5MB
4. **Test image URLs:** Open URLs in browser to verify they're publicly accessible
5. Common fix: Re-upload images to a reliable hosting service with HTTPS

### "Asset bundle expired" error

**Solution:**
1. Asset bundles are valid for only 60 minutes after validation
2. Re-run `validate_and_prepare_assets` to get a fresh bundle ID
3. Complete campaign creation within 60 minutes of validation
4. If you need more time, validate assets right before creating the campaign

### Campaign creation succeeds but campaign is not visible

**Solution:**
1. Check Google Ads/TikTok Ads Manager directly (campaigns may take 1-2 minutes to appear)
2. Verify you're looking at the correct advertising account
3. Check if the campaign was created in PAUSED status (default for safety)
4. Look for the campaign ID in the MCP response and search by ID in your platform

---

## Performance and Timeout Issues

### "Request timeout" or operations take too long

**Solution:**
1. **Keyword research** typically takes 3-8 seconds - wait patiently
2. **Campaign creation** can take 15-30 seconds - don't retry immediately
3. **Asset validation** for 10 images takes 5-15 seconds
4. Check your internet connection if timeouts are frequent
5. For Claude/ChatGPT: Close and reopen the chat if it appears stuck

### "Too Many Requests" or rate limit errors

**Solution:**
1. Wait 60 seconds before retrying the operation
2. Avoid calling the same tool repeatedly in quick succession
3. Rate limits: 100 requests/hour for free tier (if applicable)
4. Contact support at abhi@adspirer.com if rate limits are blocking legitimate use

---

## Data and Results Issues

### Performance metrics show $0 or zero data

**Solution:**
1. Newly created campaigns may have no data yet (wait 24-48 hours)
2. Verify the date range includes days when campaigns were active
3. Check if campaigns are PAUSED or REMOVED in your advertising platform
4. Ensure your account has billing set up and campaigns have budget

### Keyword research returns no keywords or very few

**Solution:**
1. Provide a more detailed business description with specific products/services
2. Add seed keywords manually if auto-extraction isn't finding good terms
3. Try different target locations (some locations have limited data)
4. Verify your Google Ads account has Keyword Planner API access enabled

### Campaigns created successfully but not spending

**Solution:**
1. Check campaign status - may be created in PAUSED state for safety
2. Verify billing is set up correctly in Google Ads/TikTok
3. Check if ads were disapproved (review policy violations in platform)
4. Confirm budget is sufficient (minimum $10/day for Google, $20/day for TikTok)

---

## Integration Issues

### MCP server shows "Disconnected" in Claude/ChatGPT

**Solution:**
1. Check server status at https://mcp.adspirer.com/health
2. Verify MCP URL is correct: `https://mcp.adspirer.com/mcp` (use `/mcp` endpoint, not `/sse`)
3. Try removing and re-adding the MCP server connection
4. Check our status page or contact support for ongoing incidents

### Tools work in ChatGPT but not in Claude (or vice versa)

**Solution:**
1. Ensure you've authorized both platforms separately via OAuth
2. Each platform maintains separate OAuth sessions - reconnect if needed
3. Check that the tool is supported on the platform you're using
4. Try the `echo_test` tool first to verify basic connectivity

---

## Getting Help

**Still having issues?**

- **Email:** abhi@adspirer.com (Subject: "Ads MCP Support")
- **Response Time:** Within 24 hours on business days (Mon-Fri)
- **Bug Reports:** https://github.com/amekala/ads-mcp/issues
- **Status Page:** Check https://mcp.adspirer.com/health for service status

**When contacting support, please include:**
1. What you were trying to do (e.g., "Create a Performance Max campaign")
2. The exact error message you received
3. Which platform you're using (Claude or ChatGPT)
4. Approximate timestamp of the issue
5. Any relevant campaign IDs or tool parameters
