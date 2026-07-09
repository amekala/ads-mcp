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
#   CODEX  CURSOR_CLAUDE  CLAUDE  CHATGPT  HAS_MEMORY  NO_MEMORY  HAS_FS  NO_FS
#
# CLAUDE is narrower than CURSOR_CLAUDE: artifacts exist in Claude Code and the Claude
# desktop app, not in Cursor. CHATGPT gates Sites. Cursor/Codex/Gemini get neither.
#
# references/ subfolders are copied verbatim — never template-processed.

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SHARED_PLATFORM="$REPO_ROOT/shared/skills/platform"
SHARED_WORKSPACE="$REPO_ROOT/shared/skills/workspace"
SHARED_AGENTS="$REPO_ROOT/shared/agents"

CURSOR_SKILLS="$REPO_ROOT/plugins/cursor/adspirer/.cursor/skills"
CODEX_SKILLS="$REPO_ROOT/plugins/codex/adspirer/skills"
CLAUDE_SKILLS="$REPO_ROOT/skills"
GEMINI_SKILLS="$REPO_ROOT/plugins/gemini/skills"
CHATGPT_SKILLS="$REPO_ROOT/plugins/chatgpt/adspirer/skills"

CURSOR_AGENT="$REPO_ROOT/plugins/cursor/adspirer/.cursor/agents/performance-marketing-agent.md"
CODEX_AGENT="$REPO_ROOT/plugins/codex/adspirer/agents/performance-marketing-agent.toml"
CLAUDE_AGENT="$REPO_ROOT/agents/performance-marketing-agent.md"

# ---------------------------------------------------------------------------
# Target table: name | context file | auth message | keep-set | websearch | workspace skills
# ---------------------------------------------------------------------------
# ChatGPT runs in a sandbox with no filesystem, no memory, and no guaranteed
# web fetch, so it takes NO_FS/NO_MEMORY and gets the platform skills only.

target_config() {
  case "$1" in
    cursor)  CONTEXT_FILE="BRAND.md";  AUTH="Reconnect via your AI assistant's connector settings"; KEEP="CURSOR_CLAUDE HAS_MEMORY HAS_FS"; WEBSEARCH="yes"; WANT_WORKSPACE="yes" ;;
    codex)   CONTEXT_FILE="AGENTS.md"; AUTH='Run `codex mcp login adspirer` to re-authenticate';     KEEP="CODEX NO_MEMORY HAS_FS";        WEBSEARCH="no";  WANT_WORKSPACE="yes" ;;
    claude)  CONTEXT_FILE="CLAUDE.md"; AUTH="Reconnect via your AI assistant's connector settings"; KEEP="CURSOR_CLAUDE CLAUDE HAS_MEMORY HAS_FS"; WEBSEARCH="yes"; WANT_WORKSPACE="yes" ;;
    gemini)  CONTEXT_FILE="GEMINI.md"; AUTH="Run the mcp auth command to re-authenticate";          KEEP="CURSOR_CLAUDE NO_MEMORY HAS_FS"; WEBSEARCH="no";  WANT_WORKSPACE="yes" ;;
    chatgpt) CONTEXT_FILE="";          AUTH="Reconnect Adspirer in ChatGPT under Settings then Connectors"; KEEP="CHATGPT NO_MEMORY NO_FS"; WEBSEARCH="no"; WANT_WORKSPACE="no" ;;
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
  esac
}

TARGETS="cursor codex claude gemini chatgpt"

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

  # references/ and agents/ are copied verbatim — no templating, no conditional blocks
  local sub
  for sub in references agents; do
    if [ -d "$src_dir/$sub" ]; then
      rm -rf "$dest_dir/$sub"
      cp -R "$src_dir/$sub" "$dest_dir/$sub"
    fi
  done
}

# The published plugin shipped `ad-campaign-management`. That skill is gone; leave a
# pointer for one release so existing installs don't silently emit broken tool calls.
emit_deprecation_shim() {
  local dest_dir="$1"
  mkdir -p "$dest_dir"
  cat > "$dest_dir/SKILL.md" <<'EOF'
---
name: ad-campaign-management
description: Deprecated. Adspirer's ad-campaign skills were split by platform. Use adspirer-agent, adspirer-mcp, and the per-platform skills instead.
---

# Deprecated

This skill has been replaced. It described a tool surface that no longer exists — Adspirer's
platform tools now sit behind router tools, so the direct tool calls this skill taught will fail.

Use these instead:

- **`adspirer-mcp`** — how to call the hub. Read this before any tool call.
- **`adspirer-agent`** — how a paid media agent should behave.
- **`adspirer-google-ads`**, **`adspirer-meta-ads`**, **`adspirer-tiktok-ads`**,
  **`adspirer-linkedin-ads`**, **`adspirer-amazon-ads`**, **`adspirer-chatgpt-ads`** — per-platform rules.
- **`adspirer-launch`**, **`adspirer-performance-review`**, **`adspirer-optimize`**,
  **`adspirer-creative`** — cross-platform workflows.

If you are seeing this, update the Adspirer plugin.
EOF
}

process_agent_prompt() {
  sed "s|{{CONTEXT_FILE}}|$2|g" "$1"
}

generate_agents() {
  local out_root="${1:-}"
  local src="$SHARED_AGENTS/performance-marketing-agent/PROMPT.md"
  [ -f "$src" ] || return 0

  local cursor_dest codex_dest claude_dest
  if [ -n "${out_root:-}" ]; then
    cursor_dest="$out_root/cursor-agent.md"
    codex_dest="$out_root/codex-agent.toml"
    claude_dest="$out_root/claude-agent.md"
  else
    cursor_dest="$CURSOR_AGENT"; codex_dest="$CODEX_AGENT"; claude_dest="$CLAUDE_AGENT"
  fi
  mkdir -p "$(dirname "$cursor_dest")" "$(dirname "$codex_dest")" "$(dirname "$claude_dest")"

  {
    cat <<'EOF'
---
name: performance-marketing-agent
description: |
  Brand-specific performance marketing agent. Connects to Adspirer MCP for live
  ad platform data, bootstraps brand workspaces, and manages campaigns across
  Google Ads, Meta Ads, Amazon Ads, ChatGPT Ads, LinkedIn Ads, and TikTok Ads
  with brand awareness and persistent memory.
tools: Read, Write, Edit, Grep, Glob, Bash, WebFetch, WebSearch, Task
model: sonnet
memory: project
skills:
  - adspirer-agent
  - adspirer-mcp
  - adspirer-launch
  - adspirer-performance-review
  - adspirer-optimize
  - adspirer-creative
  - adspirer-google-ads
  - adspirer-meta-ads
  - adspirer-tiktok-ads
  - adspirer-linkedin-ads
  - adspirer-amazon-ads
  - adspirer-chatgpt-ads
  - adspirer-docs
  - adspirer-setup
---

EOF
    process_agent_prompt "$src" "CLAUDE.md"
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
    process_agent_prompt "$src" "BRAND.md"
  } > "$cursor_dest"

  {
    cat <<'EOF'
# Performance Marketing Agent -- Role Configuration
# Copy this file to ~/.codex/agents/performance-marketing-agent.toml

model = "o3"
model_reasoning_effort = "high"
sandbox_mode = "workspace-write"

developer_instructions = """
EOF
    process_agent_prompt "$src" "AGENTS.md"
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

    # Deprecation shim: harnesses that shipped the old name. Not ChatGPT (new surface).
    if [ "$target" != "chatgpt" ]; then
      emit_deprecation_shim "$dest_root/ad-campaign-management"
    fi
  done

  generate_agents "$out_root"
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
    for pair in "$CURSOR_AGENT:cursor-agent.md" "$CODEX_AGENT:codex-agent.toml" "$CLAUDE_AGENT:claude-agent.md"; do
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
