#!/bin/bash
# Adspirer Performance Marketing Agent — One-Command Installer for Codex
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/amekala/ads-mcp/main/plugins/codex/adspirer/install.sh)

set -e

echo ""
echo "=== Adspirer Performance Marketing Agent for Codex ==="
echo ""

# Step 1: Clone repo to temp directory
echo "[1/4] Downloading Adspirer plugin..."
TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT
git clone --quiet --depth 1 https://github.com/amekala/ads-mcp.git "$TMPDIR/ads-mcp"
PLUGIN_DIR="$TMPDIR/ads-mcp/plugins/codex/adspirer"

# Step 2: Install skills
echo "[2/4] Installing skills to ~/.agents/skills/..."
mkdir -p ~/.agents/skills
cp -r "$PLUGIN_DIR/skills/adspirer-ads" ~/.agents/skills/
cp -r "$PLUGIN_DIR/skills/adspirer-setup" ~/.agents/skills/
cp -r "$PLUGIN_DIR/skills/adspirer-performance-review" ~/.agents/skills/
cp -r "$PLUGIN_DIR/skills/adspirer-write-ad-copy" ~/.agents/skills/
cp -r "$PLUGIN_DIR/skills/adspirer-wasted-spend" ~/.agents/skills/

# Step 3: Install agent config
echo "[3/4] Installing agent configuration..."
mkdir -p ~/.codex/agents
cp "$PLUGIN_DIR/agents/performance-marketing-agent.toml" ~/.codex/agents/

# Step 4: Write config.toml (MCP server + agent role + features)
echo "[4/4] Configuring Codex (MCP server, agent role, features)..."
CONFIG_FILE="$HOME/.codex/config.toml"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "  Creating ~/.codex/config.toml..."
    cat > "$CONFIG_FILE" << 'TOML'
# Adspirer Performance Marketing Agent configuration
TOML
fi

# Idempotent: only add each section if not already present
if ! grep -q "mcp_servers.adspirer" "$CONFIG_FILE" 2>/dev/null; then
    echo "  Adding [mcp_servers.adspirer]..."
    cat >> "$CONFIG_FILE" << 'TOML'

[mcp_servers.adspirer]
url = "https://mcp.adspirer.com/mcp"
tool_timeout_sec = 120
TOML
else
    echo "  [mcp_servers.adspirer] already present — skipping"
fi

if ! grep -q '\[features\]' "$CONFIG_FILE" 2>/dev/null; then
    echo "  Adding [features]..."
    cat >> "$CONFIG_FILE" << 'TOML'

[features]
multi_agent = true
TOML
else
    # Ensure multi_agent is set even if [features] exists
    if ! grep -q 'multi_agent' "$CONFIG_FILE" 2>/dev/null; then
        # Insert multi_agent = true after [features] line
        sed -i.bak '/\[features\]/a\
multi_agent = true' "$CONFIG_FILE" && rm -f "${CONFIG_FILE}.bak"
        echo "  Added multi_agent = true to existing [features]"
    else
        echo "  [features] already present — skipping"
    fi
fi

if ! grep -q 'agents.performance-marketing-agent' "$CONFIG_FILE" 2>/dev/null; then
    echo "  Adding [agents.performance-marketing-agent]..."
    cat >> "$CONFIG_FILE" << 'TOML'

[agents.performance-marketing-agent]
description = "Brand-specific performance marketing agent. Use for ad campaigns, performance, keywords, ad copy, budgets."
config_file = "agents/performance-marketing-agent.toml"
TOML
else
    echo "  [agents.performance-marketing-agent] already present — skipping"
fi

echo ""
echo "=== Installation complete! ==="
echo ""
echo "Installed:"
echo "  Skills:  ~/.agents/skills/adspirer-*  (5 skills)"
echo "  Agent:   ~/.codex/agents/performance-marketing-agent.toml"
echo "  Config:  ~/.codex/config.toml (MCP server + agent role)"
echo ""
echo "IMPORTANT — OAuth authentication:"
echo "  On first use, a browser window will open for Adspirer login."
echo "  Complete the sign-in in your browser, then return to Codex."
echo "  If it opens during install, complete it immediately."
echo ""
echo "Next steps:"
echo "  1. Restart Codex (close and reopen)"
echo "  2. Verify MCP is registered:"
echo "     codex mcp list"
echo "     (should show: adspirer ... enabled)"
echo "  3. Open your brand folder in Codex"
echo "  4. Say: 'Set up my brand workspace'"
echo "     If it doesn't trigger, run: \$adspirer-setup"
echo ""
