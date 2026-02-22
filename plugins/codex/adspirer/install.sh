#!/bin/bash
# Adspirer Performance Marketing Agent — One-Command Installer for Codex
# Usage: bash <(curl -s https://raw.githubusercontent.com/amekala/ads-mcp/main/plugins/codex/adspirer/install.sh)

set -e

echo ""
echo "=== Adspirer Performance Marketing Agent for Codex ==="
echo ""

# Step 1: Clone repo to temp directory
echo "[1/4] Downloading Adspirer plugin..."
TMPDIR=$(mktemp -d)
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

# Step 3: Install agent config + safety rules
echo "[3/4] Installing agent configuration and safety rules..."
mkdir -p ~/.codex/agents
mkdir -p ~/.codex/rules
cp "$PLUGIN_DIR/agents/performance-marketing-agent.toml" ~/.codex/agents/
cp "$PLUGIN_DIR/rules/campaign-safety.rules" ~/.codex/rules/

# Step 4: Write config.toml (MCP server + agent role + features)
echo "[4/4] Configuring Codex (MCP server, agent role, features)..."
CONFIG_FILE="$HOME/.codex/config.toml"

# Check if config.toml already exists
if [ -f "$CONFIG_FILE" ]; then
    # Check if adspirer is already configured
    if grep -q "mcp_servers.adspirer" "$CONFIG_FILE" 2>/dev/null; then
        echo "  Adspirer MCP server already in config.toml — skipping"
    else
        echo "  Appending Adspirer config to existing config.toml..."
        cat >> "$CONFIG_FILE" << 'TOML'

# --- Adspirer Performance Marketing Agent ---

[mcp_servers.adspirer]
url = "https://mcp.adspirer.com/mcp"
tool_timeout_sec = 120

[features]
multi_agent = true

[agents.performance-marketing-agent]
description = "Brand-specific performance marketing agent. Use for ad campaigns, performance, keywords, ad copy, budgets."
config_file = "agents/performance-marketing-agent.toml"
TOML
    fi
else
    echo "  Creating ~/.codex/config.toml..."
    cat > "$CONFIG_FILE" << 'TOML'
# Adspirer Performance Marketing Agent configuration

[mcp_servers.adspirer]
url = "https://mcp.adspirer.com/mcp"
tool_timeout_sec = 120

[features]
multi_agent = true

[agents.performance-marketing-agent]
description = "Brand-specific performance marketing agent. Use for ad campaigns, performance, keywords, ad copy, budgets."
config_file = "agents/performance-marketing-agent.toml"
TOML
fi

# Cleanup
rm -rf "$TMPDIR"

echo ""
echo "=== Installation complete! ==="
echo ""
echo "Installed:"
echo "  Skills:  ~/.agents/skills/adspirer-*  (5 skills)"
echo "  Agent:   ~/.codex/agents/performance-marketing-agent.toml"
echo "  Rules:   ~/.codex/rules/campaign-safety.rules"
echo "  Config:  ~/.codex/config.toml (MCP server + agent role)"
echo ""
echo "Next steps:"
echo "  1. Restart Codex (close and reopen)"
echo "  2. Open your brand folder in Codex"
echo "  3. Say: 'Set up my brand workspace'"
echo ""
echo "  First time? A browser window will open for Adspirer authentication."
echo "  Sign in at adspirer.com to connect your ad accounts."
echo ""
