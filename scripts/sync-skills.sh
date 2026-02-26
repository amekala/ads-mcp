#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SHARED="$REPO_ROOT/shared/skills"
SHARED_AGENTS="$REPO_ROOT/shared/agents"

# Target directories
CURSOR_SKILLS="$REPO_ROOT/plugins/cursor/adspirer/.cursor/skills"
CODEX_SKILLS="$REPO_ROOT/plugins/codex/adspirer/skills"
CLAUDE_SKILLS="$REPO_ROOT/skills"

# Target agent files (generated from shared agent prompts)
CURSOR_AGENT="$REPO_ROOT/plugins/cursor/adspirer/.cursor/agents/performance-marketing-agent.md"
CODEX_AGENT="$REPO_ROOT/plugins/codex/adspirer/agents/performance-marketing-agent.toml"
CLAUDE_AGENT="$REPO_ROOT/agents/performance-marketing-agent.md"

# ---------------------------------------------------------------------------
# Per-IDE configuration
# ---------------------------------------------------------------------------
# Cursor: CONTEXT_FILE=BRAND.md, AUTH=reconnect msg, keep_websearch=yes, keep_memory=yes, keep=CURSOR_CLAUDE
# Codex:  CONTEXT_FILE=AGENTS.md, AUTH=codex mcp login, keep_websearch=no, keep_memory=no, keep=CODEX
# Claude: CONTEXT_FILE=CLAUDE.md, AUTH=reconnect msg, keep_websearch=yes, keep_memory=yes, keep=CURSOR_CLAUDE

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# process_template <template_file> <ide> <context_file> <auth_msg> <keep_block> <keep_websearch> <keep_memory>
process_template() {
  local src="$1"
  local ide="$2"
  local context_file="$3"
  local auth_msg="$4"
  local keep_block="$5"       # CURSOR_CLAUDE or CODEX
  local keep_websearch="$6"   # yes or no
  local keep_memory="$7"      # yes or no

  local content
  content="$(cat "$src")"

  # 1. Replace placeholders
  content="$(echo "$content" | sed "s/{{CONTEXT_FILE}}/$context_file/g")"
  content="$(echo "$content" | sed "s/{{AUTH_TROUBLESHOOT}}/$auth_msg/g")"

  # 2. Conditional block processing
  #    Keep blocks matching $keep_block, remove the other
  if [ "$keep_block" = "CURSOR_CLAUDE" ]; then
    # Remove CODEX blocks (markers + content)
    content="$(echo "$content" | sed '/<!-- BEGIN:CODEX -->/,/<!-- END:CODEX -->/d')"
  else
    # Remove CURSOR_CLAUDE blocks (markers + content)
    content="$(echo "$content" | sed '/<!-- BEGIN:CURSOR_CLAUDE -->/,/<!-- END:CURSOR_CLAUDE -->/d')"
  fi

  # 3. Memory blocks
  if [ "$keep_memory" = "yes" ]; then
    # Keep HAS_MEMORY content, remove NO_MEMORY blocks
    content="$(echo "$content" | sed '/<!-- BEGIN:NO_MEMORY -->/,/<!-- END:NO_MEMORY -->/d')"
  else
    # Remove HAS_MEMORY blocks, keep NO_MEMORY content
    content="$(echo "$content" | sed '/<!-- BEGIN:HAS_MEMORY -->/,/<!-- END:HAS_MEMORY -->/d')"
  fi

  # 4. Strip all remaining marker lines
  content="$(echo "$content" | sed '/<!-- BEGIN:[A-Z_]* -->/d; /<!-- END:[A-Z_]* -->/d')"

  # 5. WebSearch/WebFetch stripping for Codex
  if [ "$keep_websearch" = "no" ]; then
    content="$(echo "$content" \
      | sed 's/Use `WebFetch` to crawl/Crawl/g' \
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
      | sed 's/`WebSearch`, `WebFetch`, `analyze_search_terms`/Web search, `analyze_search_terms`/g' \
      | sed '/^| Research (native)/d' \
      | sed '/^4\. Useful for SaaS, services with tiered pricing, or e-commerce with featured products$/d' \
      | sed 's/ (use Google forwarding number or direct?)//g' \
      | sed 's/ (e\.g\., "50% cheaper than \[competitor\]", "No setup fee unlike \[competitor\]")//g' \
      | sed 's/ (e\.g\., "\[competitor\] login" — existing customers, not prospects)//g' \
    )"
  fi

  echo "$content"
}

process_agent_prompt() {
  local src="$1"
  local context_file="$2"
  local codex_mode="${3:-no}"  # yes or no

  local content
  content="$(cat "$src")"
  content="$(echo "$content" | sed "s/{{CONTEXT_FILE}}/$context_file/g")"

  if [ "$codex_mode" = "yes" ]; then
    # Codex MCP tools are exposed without the mcp__adspirer__ prefix.
    content="$(echo "$content" | sed 's/mcp__adspirer__//g')"
  fi

  echo "$content"
}

generate_agents() {
  local out_root="${1:-}"  # If empty, write to actual target dirs
  local src="$SHARED_AGENTS/performance-marketing-agent/PROMPT.md"
  [ -f "$src" ] || return 0

  local cursor_dest codex_dest claude_dest
  if [ -n "${out_root:-}" ]; then
    cursor_dest="$out_root/cursor-agent.md"
    codex_dest="$out_root/codex-agent.toml"
    claude_dest="$out_root/claude-agent.md"
  else
    cursor_dest="$CURSOR_AGENT"
    codex_dest="$CODEX_AGENT"
    claude_dest="$CLAUDE_AGENT"
  fi

  mkdir -p "$(dirname "$cursor_dest")" "$(dirname "$codex_dest")" "$(dirname "$claude_dest")"

  # Claude Code agent
  {
    cat <<'EOF'
---
name: performance-marketing-agent
description: |
  Brand-specific performance marketing agent. Connects to Adspirer MCP for live
  ad platform data, bootstraps brand workspaces, and manages campaigns across
  Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads with brand awareness and
  persistent memory.
tools: Read, Write, Edit, Grep, Glob, Bash, WebFetch, WebSearch, Task
model: sonnet
memory: project
skills:
  - ad-campaign-management
mcpServers:
  adspirer: {}
---

EOF
    process_agent_prompt "$src" "CLAUDE.md" "no"
  } > "$claude_dest"

  # Cursor agent
  {
    cat <<'EOF'
---
name: performance-marketing-agent
description: |
  Brand-specific performance marketing agent. Use proactively when the user asks about
  ad campaigns, campaign performance, budget optimization, keyword research, ad copy,
  audience targeting, or anything related to Google Ads, Meta Ads, LinkedIn Ads, or
  TikTok Ads. Also use when the user wants to create campaigns, write ad copy, or
  analyze advertising data for their brand.
model: inherit
---

EOF
    process_agent_prompt "$src" "BRAND.md" "no"
  } > "$cursor_dest"

  # Codex agent (TOML wrapper with shared prompt body)
  {
    cat <<'EOF'
# Performance Marketing Agent -- Role Configuration
# Copy this file to ~/.codex/agents/performance-marketing-agent.toml

model = "o3"
model_reasoning_effort = "high"
sandbox_mode = "workspace-write"

developer_instructions = """
EOF
    process_agent_prompt "$src" "AGENTS.md" "yes"
    cat <<'EOF'
"""
EOF
  } > "$codex_dest"
}

# ---------------------------------------------------------------------------
# Generate all files
# ---------------------------------------------------------------------------

generate_all() {
  local out_root="${1:-}"  # If empty, write to actual target dirs

  # -- Cursor --
  local cursor_out
  if [ -n "$out_root" ]; then
    cursor_out="$out_root/cursor"
    mkdir -p "$cursor_out"
  fi

  for skill_dir in "$SHARED"/adspirer-*; do
    local skill_name
    skill_name="$(basename "$skill_dir")"
    local src="$skill_dir/SKILL.md"
    [ -f "$src" ] || continue

    local dest_dir
    if [ -n "${out_root:-}" ]; then
      dest_dir="$cursor_out/$skill_name"
    else
      dest_dir="$CURSOR_SKILLS/$skill_name"
    fi
    mkdir -p "$dest_dir"

    process_template "$src" "cursor" "BRAND.md" \
      "Reconnect via your AI assistant's connector settings" \
      "CURSOR_CLAUDE" "yes" "yes" > "$dest_dir/SKILL.md"
  done

  # -- Codex --
  local codex_out
  if [ -n "${out_root:-}" ]; then
    codex_out="$out_root/codex"
    mkdir -p "$codex_out"
  fi

  for skill_dir in "$SHARED"/adspirer-*; do
    local skill_name
    skill_name="$(basename "$skill_dir")"
    local src="$skill_dir/SKILL.md"
    [ -f "$src" ] || continue

    local dest_dir
    if [ -n "${out_root:-}" ]; then
      dest_dir="$codex_out/$skill_name"
    else
      dest_dir="$CODEX_SKILLS/$skill_name"
    fi
    mkdir -p "$dest_dir"

    process_template "$src" "codex" "AGENTS.md" \
      'Run `codex mcp login adspirer` to re-authenticate' \
      "CODEX" "no" "no" > "$dest_dir/SKILL.md"
  done

  # -- Claude Code (only adspirer-ads) --
  local claude_out
  if [ -n "${out_root:-}" ]; then
    claude_out="$out_root/claude"
    mkdir -p "$claude_out/ad-campaign-management"
  fi

  local ads_src="$SHARED/adspirer-ads/SKILL.md"
  if [ -f "$ads_src" ]; then
    local dest_dir
    if [ -n "${out_root:-}" ]; then
      dest_dir="$claude_out/ad-campaign-management"
    else
      dest_dir="$CLAUDE_SKILLS/ad-campaign-management"
    fi
    mkdir -p "$dest_dir"

    local result
    result="$(process_template "$ads_src" "claude" "CLAUDE.md" \
      "Reconnect via your AI assistant's connector settings" \
      "CURSOR_CLAUDE" "yes" "yes")"

    # Change frontmatter name
    result="$(echo "$result" | sed 's/^name: adspirer-ads$/name: ad-campaign-management/')"

    echo "$result" > "$dest_dir/SKILL.md"
  fi

  # -- Agents (Claude/Cursor/Codex) --
  generate_agents "$out_root"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

MODE="${1:-generate}"

case "$MODE" in
  --check)
    TMPDIR="$(mktemp -d)"
    trap 'rm -rf "$TMPDIR"' EXIT
    generate_all "$TMPDIR"

    rc=0
    # Compare Cursor
    for skill_dir in "$TMPDIR/cursor"/adspirer-*; do
      skill_name="$(basename "$skill_dir")"
      expected="$CURSOR_SKILLS/$skill_name/SKILL.md"
      actual="$skill_dir/SKILL.md"
      if [ -f "$expected" ]; then
        diff -q "$expected" "$actual" >/dev/null 2>&1 || { echo "DIFF: $expected"; rc=1; }
      else
        echo "MISSING: $expected"; rc=1
      fi
    done
    # Compare Codex
    for skill_dir in "$TMPDIR/codex"/adspirer-*; do
      skill_name="$(basename "$skill_dir")"
      expected="$CODEX_SKILLS/$skill_name/SKILL.md"
      actual="$skill_dir/SKILL.md"
      if [ -f "$expected" ]; then
        diff -q "$expected" "$actual" >/dev/null 2>&1 || { echo "DIFF: $expected"; rc=1; }
      else
        echo "MISSING: $expected"; rc=1
      fi
    done
    # Compare Claude
    expected="$CLAUDE_SKILLS/ad-campaign-management/SKILL.md"
    actual="$TMPDIR/claude/ad-campaign-management/SKILL.md"
    if [ -f "$expected" ]; then
      diff -q "$expected" "$actual" >/dev/null 2>&1 || { echo "DIFF: $expected"; rc=1; }
    else
      echo "MISSING: $expected"; rc=1
    fi

    # Compare agents
    expected="$CURSOR_AGENT"
    actual="$TMPDIR/cursor-agent.md"
    if [ -f "$expected" ]; then
      diff -q "$expected" "$actual" >/dev/null 2>&1 || { echo "DIFF: $expected"; rc=1; }
    else
      echo "MISSING: $expected"; rc=1
    fi

    expected="$CODEX_AGENT"
    actual="$TMPDIR/codex-agent.toml"
    if [ -f "$expected" ]; then
      diff -q "$expected" "$actual" >/dev/null 2>&1 || { echo "DIFF: $expected"; rc=1; }
    else
      echo "MISSING: $expected"; rc=1
    fi

    expected="$CLAUDE_AGENT"
    actual="$TMPDIR/claude-agent.md"
    if [ -f "$expected" ]; then
      diff -q "$expected" "$actual" >/dev/null 2>&1 || { echo "DIFF: $expected"; rc=1; }
    else
      echo "MISSING: $expected"; rc=1
    fi

    if [ "$rc" -eq 0 ]; then
      echo "All generated files match committed files."
    fi
    exit "$rc"
    ;;

  --diff)
    TMPDIR="$(mktemp -d)"
    trap 'rm -rf "$TMPDIR"' EXIT
    generate_all "$TMPDIR"

    # Diff Cursor
    for skill_dir in "$TMPDIR/cursor"/adspirer-*; do
      skill_name="$(basename "$skill_dir")"
      expected="$CURSOR_SKILLS/$skill_name/SKILL.md"
      actual="$skill_dir/SKILL.md"
      if [ -f "$expected" ]; then
        diff --color=always -u "$expected" "$actual" || true
      fi
    done
    # Diff Codex
    for skill_dir in "$TMPDIR/codex"/adspirer-*; do
      skill_name="$(basename "$skill_dir")"
      expected="$CODEX_SKILLS/$skill_name/SKILL.md"
      actual="$skill_dir/SKILL.md"
      if [ -f "$expected" ]; then
        diff --color=always -u "$expected" "$actual" || true
      fi
    done
    # Diff Claude
    expected="$CLAUDE_SKILLS/ad-campaign-management/SKILL.md"
    actual="$TMPDIR/claude/ad-campaign-management/SKILL.md"
    if [ -f "$expected" ]; then
      diff --color=always -u "$expected" "$actual" || true
    fi

    # Diff agents
    expected="$CURSOR_AGENT"
    actual="$TMPDIR/cursor-agent.md"
    if [ -f "$expected" ]; then
      diff --color=always -u "$expected" "$actual" || true
    fi

    expected="$CODEX_AGENT"
    actual="$TMPDIR/codex-agent.toml"
    if [ -f "$expected" ]; then
      diff --color=always -u "$expected" "$actual" || true
    fi

    expected="$CLAUDE_AGENT"
    actual="$TMPDIR/claude-agent.md"
    if [ -f "$expected" ]; then
      diff --color=always -u "$expected" "$actual" || true
    fi
    ;;

  *)
    generate_all ""
    echo "Sync complete. Generated all skill files."
    ;;
esac
