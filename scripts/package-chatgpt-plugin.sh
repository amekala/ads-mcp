#!/usr/bin/env bash
set -euo pipefail

# Builds the ZIP you upload at platform.openai.com/plugins for one ChatGPT plugin.
#
#   ./scripts/package-chatgpt-plugin.sh adspirer-search-ads
#   -> dist/chatgpt/adspirer-search-ads-<version>.zip
#
# The plugin lives in plugins/chatgpt/<name>/ in the portable Agent Plugins layout
# (plugin.json, mcp.json, skills/, assets/ at the plugin root). This script validates
# it against OpenAI's published rules (scripts/validate-chatgpt-plugin.mjs, including
# a live check of the listing URLs), then zips it with plugin.json at the ZIP root.
# Portal-only material (reviewer credentials, domain verification, the demo video)
# is tracked in docs/chatgpt-plugins/<name>.md, never in the ZIP.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="${1:-}"
[ -n "$NAME" ] || { echo "usage: $0 <plugin-name>   (a folder under plugins/chatgpt/)" >&2; exit 2; }

SRC="$REPO_ROOT/plugins/chatgpt/$NAME"
[ -f "$SRC/plugin.json" ] || { echo "No plugin.json at $SRC" >&2; exit 1; }

echo "==> Validating $NAME"
node "$REPO_ROOT/scripts/validate-chatgpt-plugin.mjs" "$SRC" --check-urls

VERSION="$(node -p "require('$SRC/plugin.json').version")"
DIST="$REPO_ROOT/dist/chatgpt"
ZIP="$DIST/$NAME-$VERSION.zip"
mkdir -p "$DIST"
rm -f "$ZIP"

# Zip from inside the plugin root so plugin.json sits at the archive root.
# -X drops macOS extended attributes; hidden files and __MACOSX never ship.
( cd "$SRC" && zip -qrX "$ZIP" . -x '.*' -x '*/.*' -x '__MACOSX/*' )

echo "==> Built $ZIP"
unzip -Z1 "$ZIP" | grep -v '/$' | sed 's/^/  /'
echo "   $(unzip -l "$ZIP" | tail -1 | awk '{print $2}') files, $(du -h "$ZIP" | cut -f1)"
echo ""
echo "Next: upload at https://platform.openai.com/plugins and work through docs/chatgpt-plugins/$NAME.md"
