#!/usr/bin/env bash
set -uo pipefail

# scripts/validate.sh — offline checks over the generated skill trees.
#   ./scripts/validate.sh          all offline checks
#   ./scripts/validate.sh --live   also probe the MCP endpoint

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

ERRORS=0; CHECKS=0; PASSED=0
check() { CHECKS=$((CHECKS+1)); printf '  [%d] %s... ' "$CHECKS" "$1"; }
pass()  { PASSED=$((PASSED+1)); echo "OK"; }
fail()  { ERRORS=$((ERRORS+1)); echo "FAIL"; [ $# -gt 0 ] && echo "       $1"; }

TARGET_ROOTS="
plugins/cursor/adspirer/.cursor/skills
plugins/codex/adspirer/skills
skills
plugins/gemini/skills
plugins/chatgpt/adspirer/skills
"

# The only tools callable by name. Everything else lives behind a router.
DIRECT_TOOLS="start_here echo_test search_tools get_tool_schema get_campaign_performance get_usage_status get_meta_campaign_performance audit_conversion_tracking get_connections_status switch_primary_account"

echo "=== Skill Validation ==="

# ---------------------------------------------------------------------------
echo ""; echo "--- Sync consistency ---"
check "Generated files match committed files"
if ./scripts/sync-skills.sh --check > /dev/null 2>&1; then pass; else fail "run ./scripts/sync-skills.sh --diff"; fi

# ---------------------------------------------------------------------------
echo ""; echo "--- Frontmatter ---"
for root in $TARGET_ROOTS; do
  for f in "$root"/*/SKILL.md; do
    [ -f "$f" ] || continue
    check "$f"
    if [ "$(head -1 "$f")" != "---" ]; then fail "missing opening ---"; continue; fi
    fm="$(sed -n '2,/^---$/p' "$f")"
    if ! printf '%s' "$fm" | grep -q '^name:'; then fail "missing name:"; continue; fi
    if ! printf '%s' "$fm" | grep -q '^description:'; then fail "missing description:"; continue; fi
    pass
  done
done

# ---------------------------------------------------------------------------
echo ""; echo "--- Discovery budget (name + description, per target) ---"
for root in $TARGET_ROOTS; do
  [ -d "$root" ] || continue
  check "Budget: $root"
  total=$(python3 - "$root" <<'PY'
import sys, glob, re
total = 0
for f in glob.glob(f"{sys.argv[1]}/*/SKILL.md"):
    m = re.match(r'^---\n(.*?)\n---\n', open(f).read(), re.S)
    if not m: continue
    fm = m.group(1)
    n = re.search(r'^name:\s*(.+)$', fm, re.M)
    d = re.search(r'^description:\s*(.+)$', fm, re.M)
    total += len(n.group(1).strip() if n else "") + len(d.group(1).strip() if d else "")
print(total)
PY
)
  if [ "$total" -gt 8000 ]; then fail "$total chars exceeds the 8000 discovery budget"
  elif [ "$total" -gt 6000 ]; then PASSED=$((PASSED+1)); echo "WARN ($total chars, ceiling 8000)"
  else pass; fi
done

# ---------------------------------------------------------------------------
echo ""; echo "--- Tool-call contract ---"

check "No skill claims a routed tool can be called directly"
bad=""
for root in $TARGET_ROOTS; do
  for f in "$root"/*/SKILL.md; do
    [ -f "$f" ] || continue
    # "call `X` directly" / "X — call it directly" where X is not a direct tool
    while IFS= read -r tool; do
      case " $DIRECT_TOOLS " in *" $tool "*) ;; *) bad="$bad $f:$tool" ;; esac
    done < <(grep -oE '`[a-z_]+`[^.]{0,40}call (it|them) directly|call `[a-z_]+` directly' "$f" 2>/dev/null \
             | grep -oE '`[a-z_]+`' | tr -d '`' | sort -u)
  done
done
[ -z "$bad" ] && pass || fail "routed tool advertised as direct:$bad"

check "search_tools / get_tool_schema never wrapped in action:execute"
if grep -rEq '"tool_name":\s*"(search_tools|get_tool_schema)"' $TARGET_ROOTS 2>/dev/null; then
  fail "found a routed call to a top-level discovery tool"
else pass; fi

# The regression this guards against: the retired `adspirer-ads` skill named routed
# tools (get_linkedin_campaign_performance, ...) as if they were callable, and never
# mentioned a router at all. So key off the ROUTED TOOL NAMES, not the word "router" —
# a file that names one must teach the two-step or defer to `adspirer-mcp`.
ROUTED_SENTINELS="get_linkedin_campaign_performance get_tiktok_campaign_performance get_amazon_campaign_performance get_chatgpt_performance create_search_campaign add_meta_ad_set"

check "Skills naming a routed tool teach list_tools or defer to adspirer-mcp"
bad=""
for root in $TARGET_ROOTS; do
  for f in "$root"/*/SKILL.md; do
    [ -f "$f" ] || continue
    for sentinel in $ROUTED_SENTINELS; do
      if grep -q "$sentinel" "$f" 2>/dev/null; then
        grep -qE 'list_tools|`adspirer-mcp`' "$f" || bad="$bad $f"
        break
      fi
    done
  done
done
[ -z "$bad" ] && pass || fail "routed tool named without the two-step or a protocol reference:$bad"

# ---------------------------------------------------------------------------
# Skills were not the only place the stale contract hid. commands/ and agents/ and the
# hand-maintained OpenClaw skill all name routed tools too, and none of them are SKILL.md.
echo ""; echo "--- Tool-call contract: commands, agents, hand-maintained skills ---"
EXTRA_CONTRACT_FILES="commands/*.md agents/*.md plugins/openclaw/SKILL.md skills/performance-marketing-agent/SKILL.md"

check "Non-skill files naming a routed tool teach list_tools or defer to adspirer-mcp"
bad=""
for f in $EXTRA_CONTRACT_FILES; do
  [ -f "$f" ] || continue
  for sentinel in $ROUTED_SENTINELS; do
    if grep -q "$sentinel" "$f" 2>/dev/null; then
      grep -qE 'list_tools|adspirer-mcp|"action": "execute"' "$f" || bad="$bad $f"
      break
    fi
  done
done
[ -z "$bad" ] && pass || fail "routed tool named without the contract:$bad"

echo ""; echo "--- URL allowlist ---"
check "No forbidden URLs"
# Only an actual linkable URL is a violation. Naming a forbidden path inside a
# prohibition ("never link /billing") must not trip the lint.
FORBIDDEN='https?://(adspirer\.ai/(billing|settings|pricing)([^a-z]|$)|adspirer\.ai/dashboard([^s]|$)|app\.adspirer\.com)'
if grep -rEq "$FORBIDDEN" $TARGET_ROOTS 2>/dev/null; then
  grep -rEn "$FORBIDDEN" $TARGET_ROOTS 2>/dev/null | head -5
  fail "forbidden URL found"
else pass; fi

# ---------------------------------------------------------------------------
# Artifacts are Claude-only; Sites are ChatGPT-only. A skill that advertises the wrong
# host's surface tells the user to use something that isn't there. references/ are exempt:
# they ship verbatim to every target and describe all surfaces neutrally.
echo ""; echo "--- Host surfaces gated to the right target ---"

check "Artifact guidance appears only in the Claude build"
bad=""
for root in plugins/chatgpt/adspirer/skills plugins/cursor/adspirer/.cursor/skills plugins/codex/adspirer/skills plugins/gemini/skills; do
  [ -d "$root" ] || continue
  hits=$(grep -rlio 'artifact' "$root"/*/SKILL.md 2>/dev/null || true)
  [ -n "$hits" ] && bad="$bad $hits"
done
[ -z "$bad" ] && pass || fail "artifact guidance leaked to a non-Claude target:$bad"

# Case-sensitive word match: the ChatGPT feature is "Site"/"Sites". Bold markers are not a
# reliable anchor — the source bolds whole sentences, so `**Site**` may never appear.
SITES_RE='\bSites?\b'

check "Sites guidance appears only in the ChatGPT build"
bad=""
for root in skills plugins/cursor/adspirer/.cursor/skills plugins/codex/adspirer/skills plugins/gemini/skills; do
  [ -d "$root" ] || continue
  hits=$(grep -rlE "$SITES_RE" "$root"/*/SKILL.md 2>/dev/null || true)
  [ -n "$hits" ] && bad="$bad $hits"
done
[ -z "$bad" ] && pass || fail "Sites guidance leaked to a non-ChatGPT target:$bad"

check "Claude build actually kept its artifact guidance"
if grep -liq 'artifact' skills/adspirer-agent/SKILL.md 2>/dev/null; then pass; else fail "CLAUDE block was dropped from the claude target"; fi

check "ChatGPT build actually kept its Sites guidance"
if grep -qE "$SITES_RE" plugins/chatgpt/adspirer/skills/adspirer-agent/SKILL.md 2>/dev/null; then pass; else fail "CHATGPT block was dropped from the chatgpt target"; fi

check "Codex build kept its scheduled-tasks guidance"
if grep -qi 'scheduled task' plugins/codex/adspirer/skills/adspirer-agent/SKILL.md 2>/dev/null; then pass; else fail "CODEX block was dropped from the codex target"; fi

# Codex hooks are event handlers, not a scheduler. Flag a line that pairs them with recurring
# work — unless the line is telling the agent NOT to (the skill says so explicitly).
check "Codex build never offers hooks as a scheduler"
if grep -hiE 'hook.{0,40}(recurring|schedule|report)' plugins/codex/adspirer/skills/*/SKILL.md 2>/dev/null \
   | grep -qivE 'never|not a scheduler|do not|don.t'; then
  fail "a hook is being offered as a scheduling mechanism"
else pass; fi

check "Every host-gated skill kept the right block for its target"
bad=""
for s in adspirer-agent adspirer-performance-review adspirer-optimize adspirer-creative adspirer-launch; do
  f="plugins/chatgpt/adspirer/skills/$s/SKILL.md"
  [ -f "$f" ] && grep -qi 'artifact' "$f" && bad="$bad chatgpt/$s(artifact)"
  f="skills/$s/SKILL.md"
  [ -f "$f" ] && grep -qE "$SITES_RE" "$f" && bad="$bad claude/$s(Sites)"
done
[ -z "$bad" ] && pass || fail "wrong host's surface survived:$bad"

echo ""; echo "--- No hardcoded Adspirer pricing ---"
# Plans and prices change; skills must point at the docs, never carry a number.
# Ad *budget* examples ($50/day) are fine — this targets Adspirer's own plan prices.
check "No plan prices baked into skills or references"
if grep -rEqi '\$(49|99|199|485|999|2,?000)\b|\$0\.(50|30|20) per|per additional call' $TARGET_ROOTS 2>/dev/null; then
  grep -rEni '\$(49|99|199|485|999|2,?000)\b|\$0\.(50|30|20) per|per additional call' $TARGET_ROOTS 2>/dev/null | head -5
  fail "a plan price is hardcoded — point at /docs/knowledge-base/pricing instead"
else pass; fi

check "No per-plan tool-call allowances baked in"
if grep -rEq '\b(15|150|600|3,?000|1,?800|7,?200|50,?000)\s+(tool )?calls?\b' $TARGET_ROOTS 2>/dev/null; then
  grep -rEn '\b(15|150|600|3,?000|1,?800|7,?200|50,?000)\s+(tool )?calls?\b' $TARGET_ROOTS 2>/dev/null | head -5
  fail "a quota allowance is hardcoded — use get_usage_status or link the docs"
else pass; fi

echo ""; echo "--- ChatGPT variant is sandbox-safe ---"
CG="plugins/chatgpt/adspirer/skills"

check "No filesystem/memory/web-tool instructions"
if grep -rEq '\bGlob\b|MEMORY\.md|WebFetch|WebSearch|BRAND\.md|CLAUDE\.md|AGENTS\.md|GEMINI\.md' "$CG" --include=SKILL.md 2>/dev/null; then
  grep -rEn '\bGlob\b|MEMORY\.md|WebFetch|WebSearch|BRAND\.md|CLAUDE\.md|AGENTS\.md|GEMINI\.md' "$CG" --include=SKILL.md | head -5
  fail "harness-specific instruction leaked into the ChatGPT variant"
else pass; fi

check "No workspace skills shipped to ChatGPT"
if [ -d "$CG/adspirer-setup" ]; then fail "adspirer-setup must not ship to ChatGPT"; else pass; fi

check "No deprecation shim shipped to ChatGPT"
if [ -d "$CG/ad-campaign-management" ]; then fail "shim must not ship to ChatGPT"; else pass; fi

# ---------------------------------------------------------------------------
echo ""; echo "--- Template markers ---"
check "No {{...}} or <!-- BEGIN: markers survived"
if grep -rq '{{' $TARGET_ROOTS --include=SKILL.md 2>/dev/null || grep -rq '<!-- BEGIN:' $TARGET_ROOTS --include=SKILL.md 2>/dev/null; then
  fail "leaked template markers"
else pass; fi

# ---------------------------------------------------------------------------
echo ""; echo "--- references/ shipped ---"
for skill in adspirer-mcp adspirer-google-ads adspirer-meta-ads adspirer-tiktok-ads adspirer-docs; do
  check "references present: $skill"
  missing=""
  for root in $TARGET_ROOTS; do
    [ -d "$root/$skill" ] || continue
    [ -d "$root/$skill/references" ] || missing="$missing $root"
  done
  [ -z "$missing" ] && pass || fail "missing references in:$missing"
done

check "Codex agents/openai.yaml preserved"
if [ -f "plugins/codex/adspirer/skills/adspirer-agent/agents/openai.yaml" ]; then pass; else fail "not generated"; fi

# ---------------------------------------------------------------------------
echo ""; echo "--- Context file correctness ---"
check "Cursor uses BRAND.md only"
if grep -rlq 'AGENTS\.md\|CLAUDE\.md' plugins/cursor/adspirer/.cursor/skills/*/SKILL.md 2>/dev/null; then fail "wrong context file"; else pass; fi
check "Codex uses AGENTS.md only"
if grep -rlq 'BRAND\.md\|CLAUDE\.md' plugins/codex/adspirer/skills/*/SKILL.md 2>/dev/null; then fail "wrong context file"; else pass; fi

# ---------------------------------------------------------------------------
echo ""; echo "--- Agents + Gemini extension ---"
for f in shared/agents/performance-marketing-agent/PROMPT.md agents/performance-marketing-agent.md \
         plugins/cursor/adspirer/.cursor/agents/performance-marketing-agent.md \
         plugins/codex/adspirer/agents/performance-marketing-agent.toml gemini-extension.json GEMINI.md; do
  check "exists: $f"; [ -f "$f" ] && pass || fail "not found"
done

check "gemini-extension.json is valid JSON with production MCP URL"
if jq -e '.name and .version' gemini-extension.json >/dev/null 2>&1 \
   && [ "$(jq -r '.mcpServers.adspirer.url // .mcpServers.adspirer.httpUrl' gemini-extension.json 2>/dev/null)" = "https://mcp.adspirer.com/mcp" ]; then
  pass
else fail "bad name/version or MCP url"; fi

check "OpenClaw claw.json + SKILL.md exist"
if [ -f "plugins/openclaw/claw.json" ] && [ -f "plugins/openclaw/SKILL.md" ]; then pass; else fail "missing"; fi

# ---------------------------------------------------------------------------
if [ "${1:-}" = "--live" ]; then
  echo ""; echo "--- MCP endpoint ---"
  check "https://mcp.adspirer.com/mcp responds"
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 https://mcp.adspirer.com/mcp 2>/dev/null || echo 000)
  case "$code" in 200|401|405) pass; echo "       (HTTP $code)";; *) fail "HTTP $code";; esac
fi

echo ""
echo "=== Results: $PASSED/$CHECKS passed, $ERRORS failed ==="
[ "$ERRORS" -eq 0 ] && echo "All checks passed." || echo "$ERRORS check(s) failed."
exit "$ERRORS"
