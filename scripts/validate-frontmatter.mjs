// Validate YAML frontmatter in every tracked .md file.
//
// Why this exists: `claude plugin validate` does not parse the frontmatter of
// every skill/command/agent file, but Anthropic's community-marketplace CI
// does — and a single unparseable frontmatter block makes the nightly SHA-bump
// sweep silently skip the plugin (see anthropics/claude-plugins-community#964,
// where an unquoted `: ` in commands/wasted-spend.md froze our marketplace pin
// at an April commit for three months).
//
// Usage: node scripts/validate-frontmatter.mjs   (requires js-yaml)
import { readFileSync } from 'fs';
import { execSync } from 'child_process';
import { load } from 'js-yaml';

const files = execSync("git ls-files '*.md'", { encoding: 'utf8' })
  .trim()
  .split('\n')
  .filter(Boolean);

let bad = 0;
let checked = 0;
for (const f of files) {
  const text = readFileSync(f, 'utf8');
  const m = text.match(/^---\r?\n([\s\S]*?)\r?\n---(\r?\n|$)/);
  if (!m) continue;
  checked++;
  try {
    load(m[1]);
  } catch (e) {
    bad++;
    console.error(`✗ ${f}: ${String(e.message).split('\n')[0]}`);
  }
}

if (bad) {
  console.error(
    `\n${bad} file(s) with unparseable YAML frontmatter. ` +
      'Quote any value containing ": " or starting with <, [, or {.',
  );
  process.exit(1);
}
console.log(`✓ frontmatter parses in all ${checked} of ${files.length} tracked .md files`);
