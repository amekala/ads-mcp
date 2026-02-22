#!/bin/bash
# Adspirer Performance Marketing Agent — One-Command Installer for Codex
# Usage: bash <(curl -s https://raw.githubusercontent.com/amekala/ads-mcp/main/plugins/codex/adspirer/install.sh)

set -e

echo ""
echo "=== Adspirer Performance Marketing Agent for Codex ==="
echo ""

# Step 1: Clone repo to temp directory
echo "[1/5] Downloading Adspirer plugin..."
TMPDIR=$(mktemp -d)
git clone --quiet --depth 1 https://github.com/amekala/ads-mcp.git "$TMPDIR/ads-mcp"
PLUGIN_DIR="$TMPDIR/ads-mcp/plugins/codex/adspirer"

# Step 2: Install skills
echo "[2/5] Installing skills to ~/.agents/skills/..."
mkdir -p ~/.agents/skills
cp -r "$PLUGIN_DIR/skills/adspirer-ads" ~/.agents/skills/
cp -r "$PLUGIN_DIR/skills/adspirer-setup" ~/.agents/skills/
cp -r "$PLUGIN_DIR/skills/adspirer-performance-review" ~/.agents/skills/
cp -r "$PLUGIN_DIR/skills/adspirer-write-ad-copy" ~/.agents/skills/
cp -r "$PLUGIN_DIR/skills/adspirer-wasted-spend" ~/.agents/skills/

# Step 3: Install agent config
echo "[3/5] Installing agent configuration..."
mkdir -p ~/.codex/agents
cp "$PLUGIN_DIR/agents/performance-marketing-agent.toml" ~/.codex/agents/

# Step 4: Install safety rules
echo "[4/5] Installing safety rules..."
mkdir -p ~/.codex/rules
cp "$PLUGIN_DIR/rules/campaign-safety.rules" ~/.codex/rules/

# Step 5: Add MCP server
echo "[5/5] Adding Adspirer MCP server..."
codex mcp add adspirer --url https://mcp.adspirer.com/mcp 2>/dev/null || echo "  (MCP server may already be registered — that's OK)"

# Cleanup
rm -rf "$TMPDIR"

echo ""
echo "=== Installation complete! ==="
echo ""
echo "Next steps:"
echo "  1. Add this to your ~/.codex/config.toml:"
echo ""
echo '     [features]'
echo '     multi_agent = true'
echo ''
echo '     [agents.performance-marketing-agent]'
echo '     description = "Brand-specific performance marketing agent. Use for ad campaigns, performance, keywords, ad copy, budgets."'
echo '     config_file = "agents/performance-marketing-agent.toml"'
echo ""
echo "  2. Restart Codex"
echo "  3. Navigate to your brand folder and run Codex:"
echo "     cd ~/Clients/YourBrand && codex"
echo "  4. Say: 'Set up my brand workspace'"
echo ""
echo "  First time? A browser window will open for Adspirer authentication."
echo "  Sign in at adspirer.com to connect your ad accounts."
echo ""
