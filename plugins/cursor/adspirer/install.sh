#!/bin/bash
# Adspirer Performance Marketing Agent — One-Command Installer for Cursor
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/amekala/ads-mcp/main/plugins/cursor/adspirer/install.sh)

set -e

echo ""
echo "=== Adspirer Performance Marketing Agent for Cursor ==="
echo ""

# Step 1: Download plugin files to temp directory
echo "[1/4] Downloading Adspirer plugin..."
# Use $HOME/tmp to avoid sandboxed /tmp dirs (e.g. Cursor's terminal)
TMPDIR="${HOME}/.adspirer-install-tmp"
rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"
trap "rm -rf '$TMPDIR'" EXIT

# Try zip download first (no .git directory, works in sandboxed terminals)
if curl -fsSL -o "$TMPDIR/plugin.zip" "https://github.com/amekala/ads-mcp/archive/refs/heads/main.zip" 2>/dev/null; then
    unzip -q "$TMPDIR/plugin.zip" -d "$TMPDIR"
    PLUGIN_DIR="$TMPDIR/ads-mcp-main/plugins/cursor/adspirer"
else
    # Fallback: shallow git clone without hooks
    echo "  Zip download failed, trying git clone..."
    git clone --quiet --depth 1 --config core.hooksPath=/dev/null https://github.com/amekala/ads-mcp.git "$TMPDIR/ads-mcp"
    PLUGIN_DIR="$TMPDIR/ads-mcp/plugins/cursor/adspirer"
fi

# Step 2: Install subagent
echo "[2/4] Installing subagent to ~/.cursor/agents/..."
mkdir -p ~/.cursor/agents
cp "$PLUGIN_DIR/.cursor/agents/performance-marketing-agent.md" ~/.cursor/agents/

# Step 3: Install skills
echo "[3/4] Installing skills to ~/.cursor/skills/..."
mkdir -p ~/.cursor/skills
cp -r "$PLUGIN_DIR/.cursor/skills/adspirer-ads" ~/.cursor/skills/
cp -r "$PLUGIN_DIR/.cursor/skills/adspirer-setup" ~/.cursor/skills/
cp -r "$PLUGIN_DIR/.cursor/skills/adspirer-performance-review" ~/.cursor/skills/
cp -r "$PLUGIN_DIR/.cursor/skills/adspirer-write-ad-copy" ~/.cursor/skills/
cp -r "$PLUGIN_DIR/.cursor/skills/adspirer-wasted-spend" ~/.cursor/skills/

# Step 4: Configure MCP server in ~/.cursor/mcp.json
echo "[4/4] Configuring Adspirer MCP server..."
MCP_FILE="$HOME/.cursor/mcp.json"

if [ ! -f "$MCP_FILE" ]; then
    echo "  Creating ~/.cursor/mcp.json..."
    cat > "$MCP_FILE" << 'JSON'
{
  "mcpServers": {
    "adspirer": {
      "url": "https://mcp.adspirer.com/mcp"
    }
  }
}
JSON
elif grep -q '"adspirer"' "$MCP_FILE" 2>/dev/null; then
    echo "  Adspirer already in mcp.json — skipping"
else
    echo "  Adding Adspirer to existing mcp.json..."
    # Use a temp file to safely modify JSON
    if command -v python3 &>/dev/null; then
        python3 -c "
import json, sys
with open('$MCP_FILE', 'r') as f:
    config = json.load(f)
if 'mcpServers' not in config:
    config['mcpServers'] = {}
config['mcpServers']['adspirer'] = {'url': 'https://mcp.adspirer.com/mcp'}
with open('$MCP_FILE', 'w') as f:
    json.dump(config, f, indent=2)
    f.write('\n')
"
        echo "  Added adspirer to mcpServers"
    else
        echo "  WARNING: python3 not found. Please manually add adspirer to $MCP_FILE:"
        echo '  {"mcpServers": {"adspirer": {"url": "https://mcp.adspirer.com/mcp"}}}'
    fi
fi

echo ""
echo "=== Installation complete! ==="
echo ""
echo "Installed:"
echo "  Subagent: ~/.cursor/agents/performance-marketing-agent.md"
echo "  Skills:   ~/.cursor/skills/adspirer-*  (5 skills)"
echo "  MCP:      ~/.cursor/mcp.json (Adspirer server)"
echo ""
echo "Next steps:"
echo "  1. Restart Cursor"
echo "  2. Open Cursor Settings > MCP and verify 'adspirer' appears"
echo "     If it shows a connection error, click to authenticate"
echo "  3. Open your brand folder in Cursor"
echo "  4. In Agent mode, say: 'Set up my brand workspace'"
echo "     If it doesn't trigger, type: /adspirer-setup"
echo ""
echo "NOTE: On first MCP use, a browser window will open for Adspirer"
echo "authentication. Sign in and return to Cursor."
echo ""
