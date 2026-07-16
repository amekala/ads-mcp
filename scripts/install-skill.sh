#!/usr/bin/env bash
# Adspirer get-started skill installer.
#
# Intended to be served at https://www.adspirer.com/install.sh so users can run:
#   curl -fsSL https://www.adspirer.com/install.sh | bash
# Also works directly from the repo:
#   curl -fsSL https://raw.githubusercontent.com/amekala/ads-mcp/main/scripts/install-skill.sh | bash
#
# Installs the skill into ~/.claude/skills/adspirer-get-started/ where Claude
# Code and Claude Cowork auto-discover it. Users with npm can instead run:
#   npx skills add amekala/ads-mcp --skill adspirer-get-started -g
# which also installs for other agents (Cursor, Codex, ...).
set -euo pipefail

SKILL_NAME="adspirer-get-started"
SKILL_DIR="${HOME}/.claude/skills/${SKILL_NAME}"
REPO_BASE="https://raw.githubusercontent.com/amekala/ads-mcp/main/skills/${SKILL_NAME}"

die() {
  echo "error: $1" >&2
  exit 1
}

command -v curl >/dev/null 2>&1 || die "requires curl"
command -v mktemp >/dev/null 2>&1 || die "requires mktemp"

atomic_download() {
  local url="$1" destination="$2" tmp
  tmp="$(mktemp "${destination}.tmp.XXXXXX")"
  curl -fsSL "$url" -o "$tmp" || { rm -f "$tmp"; die "download failed: $url"; }
  mv "$tmp" "$destination"
}

echo "Installing the Adspirer get-started skill..."

mkdir -p "$SKILL_DIR"
atomic_download "${REPO_BASE}/SKILL.md" "${SKILL_DIR}/SKILL.md"

echo ""
echo "done — installed to ${SKILL_DIR}"
echo ""

# Hand off straight into setup: if Claude Code is installed and we can attach
# a terminal, launch it with the setup prompt so the skill takes over
# immediately. Set ADSPIRER_NO_LAUNCH=1 to install the skill only.
if [[ -z "${ADSPIRER_NO_LAUNCH:-}" ]] && command -v claude >/dev/null 2>&1 && [[ -t 1 && -r /dev/tty ]]; then
  echo "Launching Claude Code to finish setup..."
  echo ""
  exec claude "Set up Adspirer for me — use the adspirer-get-started skill." </dev/tty
fi

echo "Next: open Claude Code (or Cowork) and say: \"set up adspirer\""
echo "Your agent handles the rest — plugin install, account sign-in, and"
echo "connecting your ad platforms."
