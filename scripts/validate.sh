#!/usr/bin/env bash
set -euo pipefail

# scripts/validate.sh
# Validates skill consistency, frontmatter, install scripts, and optionally MCP endpoint.
#
# Usage:
#   ./scripts/validate.sh          # Run all offline checks
#   ./scripts/validate.sh --live   # Also test MCP endpoint connectivity

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

ERRORS=0
CHECKS=0
PASSED=0

check() {
    local name="$1"
    CHECKS=$((CHECKS + 1))
    echo -n "  [$CHECKS] $name... "
}

pass() {
    PASSED=$((PASSED + 1))
    echo "OK"
}

fail() {
    ERRORS=$((ERRORS + 1))
    echo "FAIL"
    if [ $# -gt 0 ]; then
        echo "       $1"
    fi
}

echo "=== Skill Validation ==="
echo ""

# --------------------------------------------------------------------------
# Check 1: Sync consistency (templates generate files matching committed ones)
# --------------------------------------------------------------------------
echo "--- Sync Consistency ---"
check "Templates generate files matching committed skills"
if ./scripts/sync-skills.sh --check > /dev/null 2>&1; then
    pass
else
    fail "Run './scripts/sync-skills.sh --diff' to see differences"
fi

# --------------------------------------------------------------------------
# Check 2: Frontmatter validation
# --------------------------------------------------------------------------
echo ""
echo "--- Frontmatter Validation ---"

for skill_file in \
    plugins/cursor/adspirer/.cursor/skills/*/SKILL.md \
    plugins/codex/adspirer/skills/*/SKILL.md \
    skills/*/SKILL.md; do

    rel_path="${skill_file#$REPO_ROOT/}"
    check "Frontmatter in $rel_path"

    # Check for --- delimiters
    first_line=$(head -1 "$skill_file")
    if [ "$first_line" != "---" ]; then
        fail "Missing opening --- delimiter"
        continue
    fi

    # Check for name: field
    if ! sed -n '2,/^---$/p' "$skill_file" | grep -q '^name:'; then
        fail "Missing 'name:' field"
        continue
    fi

    # Check for description: field
    if ! sed -n '2,/^---$/p' "$skill_file" | grep -q '^description:'; then
        fail "Missing 'description:' field"
        continue
    fi

    pass
done

# --------------------------------------------------------------------------
# Check 3: Skill inventory (all expected skills exist)
# --------------------------------------------------------------------------
echo ""
echo "--- Skill Inventory ---"

CURSOR_SKILLS="adspirer-ads adspirer-setup adspirer-performance-review adspirer-write-ad-copy adspirer-wasted-spend"
CODEX_SKILLS="adspirer-ads adspirer-setup adspirer-performance-review adspirer-write-ad-copy adspirer-wasted-spend"

for skill in $CURSOR_SKILLS; do
    check "Cursor: $skill"
    if [ -f "plugins/cursor/adspirer/.cursor/skills/$skill/SKILL.md" ]; then
        pass
    else
        fail "File not found"
    fi
done

for skill in $CODEX_SKILLS; do
    check "Codex: $skill"
    if [ -f "plugins/codex/adspirer/skills/$skill/SKILL.md" ]; then
        pass
    else
        fail "File not found"
    fi
done

check "Claude Code: ad-campaign-management"
if [ -f "skills/ad-campaign-management/SKILL.md" ]; then
    pass
else
    fail "File not found"
fi

# --------------------------------------------------------------------------
# Check 4: Context file correctness
# --------------------------------------------------------------------------
echo ""
echo "--- Context File Correctness ---"

check "Cursor skills only reference BRAND.md (not AGENTS.md or CLAUDE.md)"
cursor_bad=$(grep -rl 'AGENTS\.md\|CLAUDE\.md' plugins/cursor/adspirer/.cursor/skills/*/SKILL.md 2>/dev/null || true)
if [ -z "$cursor_bad" ]; then
    pass
else
    fail "Found wrong context file in: $cursor_bad"
fi

check "Codex skills only reference AGENTS.md (not BRAND.md or CLAUDE.md)"
codex_bad=$(grep -rl 'BRAND\.md\|CLAUDE\.md' plugins/codex/adspirer/skills/*/SKILL.md 2>/dev/null || true)
if [ -z "$codex_bad" ]; then
    pass
else
    fail "Found wrong context file in: $codex_bad"
fi

check "Claude Code skill only references CLAUDE.md (not BRAND.md or AGENTS.md)"
claude_bad=$(grep -l 'BRAND\.md\|AGENTS\.md' skills/ad-campaign-management/SKILL.md 2>/dev/null || true)
if [ -z "$claude_bad" ]; then
    pass
else
    fail "Found wrong context file in: $claude_bad"
fi

# --------------------------------------------------------------------------
# Check 5: No leaked template markers
# --------------------------------------------------------------------------
echo ""
echo "--- Template Marker Leak Check ---"

check "No {{...}} markers in Cursor skills"
cursor_leak=$(grep -rl '{{' plugins/cursor/adspirer/.cursor/skills/*/SKILL.md 2>/dev/null || true)
if [ -z "$cursor_leak" ]; then
    pass
else
    fail "Found leaked markers in: $cursor_leak"
fi

check "No {{...}} markers in Codex skills"
codex_leak=$(grep -rl '{{' plugins/codex/adspirer/skills/*/SKILL.md 2>/dev/null || true)
if [ -z "$codex_leak" ]; then
    pass
else
    fail "Found leaked markers in: $codex_leak"
fi

check "No {{...}} markers in Claude Code skills"
claude_leak=$(grep -l '{{' skills/ad-campaign-management/SKILL.md 2>/dev/null || true)
if [ -z "$claude_leak" ]; then
    pass
else
    fail "Found leaked markers in: $claude_leak"
fi

check "No <!-- BEGIN: markers in generated skills"
begin_leak=$(grep -rl '<!-- BEGIN:' \
    plugins/cursor/adspirer/.cursor/skills/*/SKILL.md \
    plugins/codex/adspirer/skills/*/SKILL.md \
    skills/ad-campaign-management/SKILL.md 2>/dev/null || true)
if [ -z "$begin_leak" ]; then
    pass
else
    fail "Found leaked markers in: $begin_leak"
fi

# --------------------------------------------------------------------------
# Check 6: Codex extras preserved
# --------------------------------------------------------------------------
echo ""
echo "--- Codex Extras ---"

check "Codex openai.yaml preserved"
if [ -f "plugins/codex/adspirer/skills/adspirer-ads/agents/openai.yaml" ]; then
    pass
else
    fail "File missing — sync may have deleted it"
fi

# --------------------------------------------------------------------------
# Check 7: OpenClaw skill files
# --------------------------------------------------------------------------
echo ""
echo "--- OpenClaw ---"

check "OpenClaw claw.json exists"
if [ -f "plugins/openclaw/claw.json" ]; then
    pass
else
    fail "File not found"
fi

check "OpenClaw SKILL.md exists"
if [ -f "plugins/openclaw/SKILL.md" ]; then
    pass
else
    fail "File not found"
fi

check "OpenClaw claw.json has valid name field"
if grep -q '"name"' plugins/openclaw/claw.json 2>/dev/null; then
    pass
else
    fail "Missing 'name' field in claw.json"
fi

# --------------------------------------------------------------------------
# Check 8: Shared templates exist
# --------------------------------------------------------------------------
echo ""
echo "--- Shared Templates ---"

for skill in adspirer-ads adspirer-setup adspirer-performance-review adspirer-write-ad-copy adspirer-wasted-spend; do
    check "Template: shared/skills/$skill/SKILL.md"
    if [ -f "shared/skills/$skill/SKILL.md" ]; then
        pass
    else
        fail "Template not found"
    fi
done

# --------------------------------------------------------------------------
# Check 9 (optional): MCP endpoint connectivity
# --------------------------------------------------------------------------
if [ "${1:-}" = "--live" ]; then
    echo ""
    echo "--- MCP Endpoint ---"

    check "https://mcp.adspirer.com/mcp responds"
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "https://mcp.adspirer.com/mcp" 2>/dev/null || echo "000")
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "401" ] || [ "$HTTP_CODE" = "405" ]; then
        pass
        echo "       (HTTP $HTTP_CODE)"
    else
        fail "Got HTTP $HTTP_CODE (expected 200, 401, or 405)"
    fi
fi

# --------------------------------------------------------------------------
# Summary
# --------------------------------------------------------------------------
echo ""
echo "=== Results: $PASSED/$CHECKS passed, $ERRORS failed ==="
if [ $ERRORS -eq 0 ]; then
    echo "All checks passed."
else
    echo "$ERRORS check(s) failed."
fi
exit $ERRORS
