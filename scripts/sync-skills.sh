#!/usr/bin/env bash
set -euo pipefail

# Fans shared/skills/ out to every harness target.
#
#   shared/skills/platform/   -> every target, including ChatGPT
#   shared/skills/workspace/  -> every target EXCEPT ChatGPT (no filesystem there)
#
# Each SKILL.md may contain conditional blocks:
#   <!-- BEGIN:CODEX --> ... <!-- END:CODEX -->
# A block survives only if its family is in the target's keep-set. Families in use:
#   CODEX  CURSOR_CLAUDE  CLAUDE  CHATGPT  GROK  HAS_MEMORY  NO_MEMORY  HAS_FS  NO_FS
#
# CLAUDE is narrower than CURSOR_CLAUDE: artifacts exist in Claude Code and the Claude
# desktop app, not in Cursor. CHATGPT gates Sites. Cursor/Codex/Gemini/Grok get neither.
#
# GROK is its own family rather than a CURSOR_CLAUDE member: Grok Build installs the
# MCP server from the plugin's own .mcp.json, so its connect instructions share nothing
# with Cursor's settings-panel flow.
#
# MULTIHOST wraps prose that compares the Claude/ChatGPT/Codex surfaces to each other.
# Every target carries it except Grok, which has no artifact or scheduler surface of its
# own — there, that comparison is noise the agent would be tempted to act on.
#
# references/*.md take the same template pass; non-markdown files under references/,
# and everything under agents/, are copied verbatim.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SHARED_PLATFORM="$REPO_ROOT/shared/skills/platform"
SHARED_WORKSPACE="$REPO_ROOT/shared/skills/workspace"
SHARED_AGENTS="$REPO_ROOT/shared/agents"
SHARED_COMMANDS="$REPO_ROOT/shared/commands"

CURSOR_SKILLS="$REPO_ROOT/plugins/cursor/adspirer/.cursor/skills"
CODEX_SKILLS="$REPO_ROOT/plugins/codex/adspirer/skills"
CLAUDE_SKILLS="$REPO_ROOT/skills"
GEMINI_SKILLS="$REPO_ROOT/plugins/gemini/skills"
CHATGPT_SKILLS="$REPO_ROOT/plugins/chatgpt/adspirer/skills"
GROK_SKILLS="$REPO_ROOT/plugins/grok/skills"

CURSOR_AGENT="$REPO_ROOT/plugins/cursor/adspirer/.cursor/agents/performance-marketing-agent.md"
CODEX_AGENT="$REPO_ROOT/plugins/codex/adspirer/agents/performance-marketing-agent.toml"
CLAUDE_AGENT="$REPO_ROOT/agents/performance-marketing-agent.md"
GROK_AGENT="$REPO_ROOT/plugins/grok/agents/performance-marketing-agent.md"

# Slash commands are templated the same way skills are, but only two harnesses take
# them in this format: Claude Code (repo root) and Grok Build (plugins/grok). Gemini
# has its own .toml commands under commands/adspirer/, hand-maintained.
CLAUDE_COMMANDS="$REPO_ROOT/commands"
GROK_COMMANDS="$REPO_ROOT/plugins/grok/commands"

# ---------------------------------------------------------------------------
# Target table: name | context file | auth message | keep-set | websearch | workspace skills | commands
# ---------------------------------------------------------------------------
# ChatGPT runs in a sandbox with no filesystem, no memory, and no guaranteed
# web fetch, so it takes NO_FS/NO_MEMORY and gets the platform skills only.
#
# Grok Build reads the AGENTS.md rules family natively and has a filesystem, but no
# documented cross-session memory — so NO_MEMORY, same as Codex and Gemini. WEBSEARCH
# is "no" because `WebSearch`/`WebFetch` are Claude Code tool names; the stripped
# phrasing reads correctly whatever Grok's own web tooling is called.

target_config() {
  case "$1" in
    cursor)  CONTEXT_FILE="BRAND.md";  AUTH="Reconnect via your AI assistant's connector settings"; KEEP="CURSOR_CLAUDE HAS_MEMORY HAS_FS MULTIHOST"; WEBSEARCH="yes"; WANT_WORKSPACE="yes"; WANT_COMMANDS="no" ;;
    codex)   CONTEXT_FILE="AGENTS.md"; AUTH='Run `codex mcp login adspirer` to re-authenticate';     KEEP="CODEX NO_MEMORY HAS_FS MULTIHOST";        WEBSEARCH="no";  WANT_WORKSPACE="yes"; WANT_COMMANDS="no" ;;
    claude)  CONTEXT_FILE="CLAUDE.md"; AUTH="Reconnect via your AI assistant's connector settings"; KEEP="CURSOR_CLAUDE CLAUDE HAS_MEMORY HAS_FS MULTIHOST"; WEBSEARCH="yes"; WANT_WORKSPACE="yes"; WANT_COMMANDS="yes" ;;
    gemini)  CONTEXT_FILE="GEMINI.md"; AUTH="Run the mcp auth command to re-authenticate";          KEEP="CURSOR_CLAUDE NO_MEMORY HAS_FS MULTIHOST"; WEBSEARCH="no";  WANT_WORKSPACE="yes"; WANT_COMMANDS="no" ;;
    chatgpt) CONTEXT_FILE="";          AUTH="Reconnect Adspirer in ChatGPT under Settings then Connectors"; KEEP="CHATGPT NO_MEMORY NO_FS MULTIHOST"; WEBSEARCH="no"; WANT_WORKSPACE="no"; WANT_COMMANDS="no" ;;
    grok)    CONTEXT_FILE="AGENTS.md"; AUTH='Open `/mcp`, select **adspirer**, and re-authenticate'; KEEP="GROK NO_MEMORY HAS_FS";        WEBSEARCH="no";  WANT_WORKSPACE="yes"; WANT_COMMANDS="yes" ;;
    *) echo "unknown target: $1" >&2; return 1 ;;
  esac
}

target_dir() {
  case "$1" in
    cursor)  echo "$CURSOR_SKILLS" ;;
    codex)   echo "$CODEX_SKILLS" ;;
    claude)  echo "$CLAUDE_SKILLS" ;;
    gemini)  echo "$GEMINI_SKILLS" ;;
    chatgpt) echo "$CHATGPT_SKILLS" ;;
    grok)    echo "$GROK_SKILLS" ;;
  esac
}

target_commands_dir() {
  case "$1" in
    claude) echo "$CLAUDE_COMMANDS" ;;
    grok)   echo "$GROK_COMMANDS" ;;
  esac
}

TARGETS="cursor codex claude gemini chatgpt grok"
COMMAND_TARGETS="claude grok"

# ---------------------------------------------------------------------------
# Template processing
# ---------------------------------------------------------------------------

strip_websearch() {
  sed 's/Use `WebFetch` to crawl/Crawl/g' \
    | sed 's/use `WebFetch` to crawl/crawl/g' \
    | sed 's/use `WebFetch` on each candidate URL to confirm it loads/confirm it loads/g' \
    | sed 's/Use `WebSearch` to search for:/Search for:/g' \
    | sed 's/Use `WebSearch` to search/Search for/g' \
    | sed 's/Use `WebSearch` to find review\/comparison sites:/Search for review\/comparison sites:/g' \
    | sed 's/Use `WebSearch` to find/Find/g' \
    | sed 's/Then use `WebFetch` to crawl/Then crawl/g' \
    | sed "s/Crawl user's website with \`WebFetch\`/Crawl user's website/g" \
    | sed 's/(crawled via `WebFetch`)/(crawled)/g' \
    | sed 's/Validate each URL with `WebFetch` (no 404s)/Validate that each URL loads (no 404s)/g' \
    | sed 's/ via `WebFetch`\/`WebSearch`//g' \
    | sed 's/ via `WebSearch`//g' \
    | sed 's/web research (native tools)/web research/g' \
    | sed 's/`WebSearch`, `WebFetch` + Adspirer tools/Web search + Adspirer tools/g' \
    | sed 's/`WebSearch`, `WebFetch`, `analyze_search_terms`/Web search, `analyze_search_terms`/g'
}

# process_template <src> <keep-set> <context_file> <auth_msg> <websearch>
process_template() {
  local src="$1" keep="$2" context_file="$3" auth_msg="$4" keep_websearch="$5"
  local content families fam
  content="$(cat "$src")"

  # 1. Placeholders
  content="$(printf '%s\n' "$content" | sed "s|{{CONTEXT_FILE}}|$context_file|g")"
  content="$(printf '%s\n' "$content" | sed "s|{{AUTH_TROUBLESHOOT}}|$auth_msg|g")"

  # 2. Drop every conditional block whose family is not in the keep-set
  families="$(printf '%s\n' "$content" | grep -oE '<!-- BEGIN:[A-Z_]+ -->' | sed 's/<!-- BEGIN://; s/ -->//' | sort -u || true)"
  for fam in $families; do
    case " $keep " in
      *" $fam "*) ;;  # keep
      *) content="$(printf '%s\n' "$content" | sed "/<!-- BEGIN:$fam -->/,/<!-- END:$fam -->/d")" ;;
    esac
  done

  # 3. Strip surviving markers
  content="$(printf '%s\n' "$content" | sed '/<!-- BEGIN:[A-Z_]* -->/d; /<!-- END:[A-Z_]* -->/d')"

  # 4. Strip web-tool instructions where the harness has none
  if [ "$keep_websearch" = "no" ]; then
    content="$(printf '%s\n' "$content" | strip_websearch)"
  fi

  printf '%s\n' "$content"
}

# emit_skill <src_dir> <dest_dir> <target>
emit_skill() {
  local src_dir="$1" dest_dir="$2" target="$3"
  [ -f "$src_dir/SKILL.md" ] || return 0
  mkdir -p "$dest_dir"
  process_template "$src_dir/SKILL.md" "$KEEP" "$CONTEXT_FILE" "$AUTH" "$WEBSEARCH" > "$dest_dir/SKILL.md"

  # references/*.md go through the same template pass as SKILL.md, so a reference can
  # gate host-specific sections the same way. Everything else under references/, and
  # all of agents/, is copied verbatim — those are data files, not prose.
  if [ -d "$src_dir/references" ]; then
    rm -rf "$dest_dir/references"
    mkdir -p "$dest_dir/references"
    local ref
    for ref in "$src_dir/references"/*; do
      [ -e "$ref" ] || continue
      case "$ref" in
        *.md) process_template "$ref" "$KEEP" "$CONTEXT_FILE" "$AUTH" "$WEBSEARCH" > "$dest_dir/references/$(basename "$ref")" ;;
        *)    cp -R "$ref" "$dest_dir/references/$(basename "$ref")" ;;
      esac
    done
  fi

  if [ -d "$src_dir/agents" ]; then
    rm -rf "$dest_dir/agents"
    cp -R "$src_dir/agents" "$dest_dir/agents"
  fi
}

# emit_command <src_file> <dest_dir>
# Commands go through the same template pass as skills, so {{CONTEXT_FILE}} and the
# host-conditional blocks resolve identically in both.
emit_command() {
  local src="$1" dest_dir="$2"
  [ -f "$src" ] || return 0
  mkdir -p "$dest_dir"
  process_template "$src" "$KEEP" "$CONTEXT_FILE" "$AUTH" "$WEBSEARCH" > "$dest_dir/$(basename "$src")"
}

# process_agent_prompt <src> <context_file> <keep-set> <websearch>
# The agent prompt takes the same template pass as skills so it can gate host-specific
# prose. Cursor/Codex/Claude deliberately pass websearch="yes": their shipped agent files
# are pinned byte-for-byte by live marketplace entries, and stripping the web-tool names
# there is a separate change from adding Grok.
process_agent_prompt() {
  process_template "$1" "$3" "$2" "" "$4"
}

generate_agents() {
  local out_root="${1:-}"
  local src="$SHARED_AGENTS/performance-marketing-agent/PROMPT.md"
  [ -f "$src" ] || return 0

  local cursor_dest codex_dest claude_dest grok_dest
  if [ -n "${out_root:-}" ]; then
    cursor_dest="$out_root/cursor-agent.md"
    codex_dest="$out_root/codex-agent.toml"
    claude_dest="$out_root/claude-agent.md"
    grok_dest="$out_root/grok-agent.md"
  else
    cursor_dest="$CURSOR_AGENT"; codex_dest="$CODEX_AGENT"; claude_dest="$CLAUDE_AGENT"; grok_dest="$GROK_AGENT"
  fi
  mkdir -p "$(dirname "$cursor_dest")" "$(dirname "$codex_dest")" "$(dirname "$claude_dest")" "$(dirname "$grok_dest")"

  {
    cat <<'EOF'
---
name: performance-marketing-agent
description: |
  Brand-specific performance marketing agent. Connects to Adspirer MCP for live
  ad platform data, bootstraps brand workspaces, and manages campaigns across
  Google Ads, Meta Ads, Amazon Ads, ChatGPT Ads, LinkedIn Ads, and TikTok Ads
  with brand awareness and persistent memory.
# tools deliberately not restricted — this agent needs the Adspirer MCP tools, and a
# `tools:` allowlist would exclude every MCP tool (plugin install method changes the
# prefix, so no allowlist entry can name them reliably). Omitted = inherit everything.
maxTurns: 25
memory: project
# Preload only the two skills every session needs: agent behavior + the MCP call
# contract. `skills:` injects FULL content at startup (~1k tokens each) — the 12
# platform/workflow skills load on demand via the Skill tool when relevant.
skills:
  - adspirer-agent
  - adspirer-mcp
---

EOF
    process_agent_prompt "$src" "CLAUDE.md" "CURSOR_CLAUDE CLAUDE HAS_MEMORY HAS_FS MULTIHOST" "yes"
  } > "$claude_dest"

  {
    cat <<'EOF'
---
name: performance-marketing-agent
description: |
  Brand-specific performance marketing agent. Use proactively when the user asks about
  ad campaigns, campaign performance, budget optimization, keyword research, ad copy,
  audience targeting, or anything related to Google Ads, Meta Ads, Amazon Ads, ChatGPT
  Ads, LinkedIn Ads, or TikTok Ads. Also use when the user wants to create campaigns,
  write ad copy, or analyze advertising data for their brand.
model: inherit
---

EOF
    process_agent_prompt "$src" "BRAND.md" "CURSOR_CLAUDE HAS_MEMORY HAS_FS MULTIHOST" "yes"
  } > "$cursor_dest"

  {
    cat <<'EOF'
---
name: performance-marketing-agent
description: |
  Brand-specific performance marketing agent. Use proactively when the user asks about
  ad campaigns, campaign performance, budget optimization, keyword research, ad copy,
  audience targeting, or anything related to Google Ads, Meta Ads, Amazon Ads, ChatGPT
  Ads, LinkedIn Ads, or TikTok Ads. Also use when the user wants to create campaigns,
  write ad copy, or analyze advertising data for their brand.
---

EOF
    process_agent_prompt "$src" "AGENTS.md" "GROK NO_MEMORY HAS_FS" "no"
  } > "$grok_dest"

  {
    cat <<'EOF'
# Performance Marketing Agent -- Role Configuration
# Copy this file to ~/.codex/agents/performance-marketing-agent.toml

model = "o3"
model_reasoning_effort = "high"
sandbox_mode = "workspace-write"

developer_instructions = """
EOF
    process_agent_prompt "$src" "AGENTS.md" "CODEX NO_MEMORY HAS_FS MULTIHOST" "yes"
    cat <<'EOF'
"""
EOF
  } > "$codex_dest"
}

# ---------------------------------------------------------------------------
# Generate
# ---------------------------------------------------------------------------

generate_all() {
  local out_root="${1:-}"
  local target skill_dir skill_name dest_root dest_dir

  for target in $TARGETS; do
    target_config "$target"

    if [ -n "${out_root:-}" ]; then
      dest_root="$out_root/$target"
    else
      dest_root="$(target_dir "$target")"
    fi
    mkdir -p "$dest_root"

    for skill_dir in "$SHARED_PLATFORM"/adspirer-*; do
      [ -d "$skill_dir" ] || continue
      skill_name="$(basename "$skill_dir")"
      emit_skill "$skill_dir" "$dest_root/$skill_name" "$target"
    done

    if [ "$WANT_WORKSPACE" = "yes" ]; then
      for skill_dir in "$SHARED_WORKSPACE"/adspirer-*; do
        [ -d "$skill_dir" ] || continue
        skill_name="$(basename "$skill_dir")"
        emit_skill "$skill_dir" "$dest_root/$skill_name" "$target"
      done
    fi

    if [ "$WANT_COMMANDS" = "yes" ] && [ -d "$SHARED_COMMANDS" ]; then
      local cmd_root cmd_file
      if [ -n "${out_root:-}" ]; then
        cmd_root="$out_root/$target-commands"
      else
        cmd_root="$(target_commands_dir "$target")"
      fi
      for cmd_file in "$SHARED_COMMANDS"/*.md; do
        [ -f "$cmd_file" ] || continue
        emit_command "$cmd_file" "$cmd_root"
      done
    fi

  done

  generate_agents "$out_root"
}

compare_commands() {
  local target="$1" tmp="$2" rc=0
  local expected_root actual_root cmd expected
  expected_root="$(target_commands_dir "$target")"
  actual_root="$tmp/$target-commands"
  [ -d "$actual_root" ] || return 0
  for cmd in "$actual_root"/*.md; do
    [ -f "$cmd" ] || continue
    expected="$expected_root/$(basename "$cmd")"
    if [ -f "$expected" ]; then
      diff -q "$expected" "$cmd" >/dev/null 2>&1 || { echo "DIFF: $expected"; rc=1; }
    else
      echo "MISSING: $expected"; rc=1
    fi
  done
  return $rc
}

compare_tree() {
  local target="$1" tmp="$2" rc=0
  local expected_root actual_root skill_dir skill_name expected actual
  expected_root="$(target_dir "$target")"
  actual_root="$tmp/$target"
  for skill_dir in "$actual_root"/*; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    expected="$expected_root/$skill_name/SKILL.md"
    actual="$skill_dir/SKILL.md"
    if [ -f "$expected" ]; then
      diff -q "$expected" "$actual" >/dev/null 2>&1 || { echo "DIFF: $expected"; rc=1; }
    else
      echo "MISSING: $expected"; rc=1
    fi
  done
  return $rc
}

MODE="${1:-generate}"

case "$MODE" in
  --check)
    TMPDIR="$(mktemp -d)"; trap 'rm -rf "$TMPDIR"' EXIT
    generate_all "$TMPDIR"
    rc=0
    for t in $TARGETS; do compare_tree "$t" "$TMPDIR" || rc=1; done
    for t in $COMMAND_TARGETS; do compare_commands "$t" "$TMPDIR" || rc=1; done
    for pair in "$CURSOR_AGENT:cursor-agent.md" "$CODEX_AGENT:codex-agent.toml" "$CLAUDE_AGENT:claude-agent.md" "$GROK_AGENT:grok-agent.md"; do
      expected="${pair%%:*}"; actual="$TMPDIR/${pair##*:}"
      if [ -f "$expected" ]; then
        diff -q "$expected" "$actual" >/dev/null 2>&1 || { echo "DIFF: $expected"; rc=1; }
      else
        echo "MISSING: $expected"; rc=1
      fi
    done
    [ "$rc" -eq 0 ] && echo "All generated files match committed files."
    exit "$rc"
    ;;

  --diff)
    TMPDIR="$(mktemp -d)"; trap 'rm -rf "$TMPDIR"' EXIT
    generate_all "$TMPDIR"
    for t in $TARGETS; do
      expected_root="$(target_dir "$t")"
      for skill_dir in "$TMPDIR/$t"/*; do
        [ -d "$skill_dir" ] || continue
        expected="$expected_root/$(basename "$skill_dir")/SKILL.md"
        [ -f "$expected" ] && diff --color=always -u "$expected" "$skill_dir/SKILL.md" || true
      done
    done
    ;;

  *)
    generate_all ""
    echo "Sync complete. Generated skills for: $TARGETS"
    ;;
esac
