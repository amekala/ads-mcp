#!/usr/bin/env bash
set -euo pipefail

# Builds the zip you upload to the ChatGPT app submission form (Plugins → Skills).
#
#   ./scripts/package-chatgpt-skills.sh
#   -> dist/adspirer-chatgpt-skills.zip
#
# Contents are the Family-P (platform) skills only: no workspace skills, no
# deprecation shim, no filesystem/memory/web-fetch instructions. Run sync first.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO_ROOT/plugins/chatgpt/adspirer/skills"
DIST="$REPO_ROOT/dist"
ZIP="$DIST/adspirer-chatgpt-skills.zip"

[ -d "$SRC" ] || { echo "No ChatGPT skills at $SRC — run ./scripts/sync-skills.sh first." >&2; exit 1; }

echo "==> Validating before packaging"
"$REPO_ROOT/scripts/validate.sh" > /dev/null || { echo "validate.sh failed — refusing to package." >&2; exit 1; }

mkdir -p "$DIST"
rm -f "$ZIP"

# Zip from inside SRC so the archive root holds the skill folders directly.
( cd "$SRC" && zip -qr "$ZIP" . -x '.*' -x '__MACOSX/*' )

echo "==> Built $ZIP"
echo ""
echo "Skills packaged:"
( cd "$SRC" && for d in */; do
    name=$(sed -n 's/^name:[[:space:]]*//p' "$d/SKILL.md" | head -1)
    refs=$([ -d "$d/references" ] && echo " (+$(ls "$d/references" | wc -l | tr -d ' ') refs)" || echo "")
    printf '  %-32s %s\n' "$name" "$refs"
  done )
echo ""
echo "Total: $(ls -1 "$SRC" | wc -l | tr -d ' ') skills, $(unzip -l "$ZIP" | tail -1 | awk '{print $2}') files, $(du -h "$ZIP" | cut -f1)"
