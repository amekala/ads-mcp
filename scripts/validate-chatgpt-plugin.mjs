// Validate a ChatGPT plugin package (Agent Plugins format) against OpenAI's
// published submission rules, before it is zipped and uploaded.
//
// Sources for every rule below (re-check them when OpenAI changes the docs):
//   https://developers.openai.com/plugins/deploy/submission.md
//   https://developers.openai.com/plugins/deploy/submission-errors.md
//   https://developers.openai.com/plugins/plugin-guidelines.md
//
// Usage:
//   node scripts/validate-chatgpt-plugin.mjs plugins/chatgpt/<plugin> [--check-urls]
//
// Errors block packaging. Warnings are things the portal needs before final
// submission (demo video, screenshots) that may legitimately be missing from a draft.
// No dependencies: runs on stock Node 18+.

import { readFileSync, readdirSync, statSync, lstatSync, existsSync } from 'fs';
import { join, resolve, relative } from 'path';

const args = process.argv.slice(2);
const root = args.find((a) => !a.startsWith('--'));
const checkUrls = args.includes('--check-urls');
if (!root) {
  console.error('usage: node scripts/validate-chatgpt-plugin.mjs <plugin-dir> [--check-urls]');
  process.exit(2);
}
const ROOT = resolve(root);

const errors = [];
const warnings = [];
const err = (m) => errors.push(m);
const warn = (m) => warnings.push(m);

const PLUGIN_SCHEMA = 'https://agent-plugins.org/schemas/1.0.0/plugin.schema.json';
const MCP_SCHEMA = 'https://agent-plugins.org/schemas/1.0.0/mcp.schema.json';
const CATEGORIES = [
  'Productivity', 'Creativity', 'Developer Tools', 'Business & Operations',
  'Data & Analytics', 'Communication', 'Education & Research', 'Security',
  'Finance', 'Healthcare', 'Travel', 'Entertainment', 'Other',
];
const SEMVER = /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$/;
const FORBIDDEN_KEYS = ['test_credentials', 'reviewer_instructions'];

const isStr = (v) => typeof v === 'string';
const oneLine = (s) => !/[\r\n\u2028\u2029]/.test(s);
const blank = (s) => !isStr(s) || s.trim() === '';
const len = (s) => [...s].length;

function readJson(file) {
  try {
    return JSON.parse(readFileSync(join(ROOT, file), 'utf8'));
  } catch (e) {
    err(`${file}: ${existsSync(join(ROOT, file)) ? 'invalid JSON: ' + e.message : 'missing'}`);
    return null;
  }
}

function text(field, value, { max, required = true, single = true }) {
  if (value === undefined || value === null) {
    if (required) err(`${field} is required`);
    return;
  }
  if (blank(value)) return err(`${field} must be a non-empty string`);
  if (single && !oneLine(value)) err(`${field} must be one line`);
  if (max && len(value) > max) err(`${field} is ${len(value)} characters; the limit is ${max}`);
}

function httpsUrl(field, value, { required = true, max = 1024 } = {}) {
  if (value === undefined) {
    if (required) err(`${field} is required for an MCP plugin`);
    return;
  }
  let u;
  try { u = new URL(value); } catch { return err(`${field} is not a valid URL`); }
  if (u.protocol !== 'https:') err(`${field} must use HTTPS`);
  if (u.username || u.password) err(`${field} must not contain credentials`);
  if (value.length > max) err(`${field} is longer than ${max} characters`);
}

// ---------- images ----------
function pngSize(buf) {
  if (buf.length < 24 || buf.toString('ascii', 1, 4) !== 'PNG') return null;
  return { w: buf.readUInt32BE(16), h: buf.readUInt32BE(20) };
}
function jpegSize(buf) {
  if (buf[0] !== 0xff || buf[1] !== 0xd8) return null;
  let i = 2;
  while (i < buf.length) {
    if (buf[i] !== 0xff) return null;
    const marker = buf[i + 1];
    const size = buf.readUInt16BE(i + 2);
    if (marker >= 0xc0 && marker <= 0xcf && ![0xc4, 0xc8, 0xcc].includes(marker)) {
      return { w: buf.readUInt16BE(i + 7), h: buf.readUInt16BE(i + 5) };
    }
    i += 2 + size;
  }
  return null;
}
function svgSize(src) {
  const tag = src.match(/<svg\b[^>]*>/i);
  if (!tag) return null;
  const vb = tag[0].match(/viewBox\s*=\s*"([^"]+)"/i);
  if (vb) {
    const p = vb[1].trim().split(/[\s,]+/).map(Number);
    if (p.length === 4 && p.every(Number.isFinite)) return { w: p[2], h: p[3] };
  }
  const w = tag[0].match(/\bwidth\s*=\s*"([\d.]+)"/i);
  const h = tag[0].match(/\bheight\s*=\s*"([\d.]+)"/i);
  return w && h ? { w: Number(w[1]), h: Number(h[1]) } : null;
}

function assetPath(field, p) {
  if (!isStr(p) || !p.startsWith('./')) {
    err(`${field} must be a ./-prefixed path inside the plugin`);
    return null;
  }
  const abs = resolve(ROOT, p);
  if (relative(ROOT, abs).startsWith('..')) {
    err(`${field} points outside the plugin`);
    return null;
  }
  if (!existsSync(abs) || !statSync(abs).isFile()) {
    err(`${field}: ${p} does not exist`);
    return null;
  }
  return abs;
}

function checkIcon(field, p) {
  const abs = assetPath(field, p);
  if (!abs) return;
  const buf = readFileSync(abs);
  if (buf.length > 5 * 1024 * 1024) err(`${field}: ${p} is larger than 5 MiB`);
  const ext = p.toLowerCase().split('.').pop();
  let size = null;
  if (ext === 'png') size = pngSize(buf);
  else if (ext === 'jpg' || ext === 'jpeg') size = jpegSize(buf);
  else if (ext === 'svg') size = svgSize(buf.toString('utf8'));
  else if (ext === 'webp') return warn(`${field}: WebP dimensions are not checked here`);
  else return err(`${field}: ${p} must be .png, .jpg, .jpeg, .webp or .svg`);
  if (!size) return err(`${field}: could not read the dimensions of ${p} (or the extension does not match the content)`);
  if (size.w !== size.h) err(`${field}: ${p} is ${size.w}x${size.h}; it must be square`);
  if (Math.min(size.w, size.h) < 48) err(`${field}: ${p} is smaller than 48x48`);
  if (ext !== 'svg' && Math.max(size.w, size.h) > 4096) err(`${field}: ${p} is larger than 4096x4096`);
}

function checkScreenshot(field, p) {
  const abs = assetPath(field, p);
  if (!abs) return;
  const buf = readFileSync(abs);
  const ext = p.toLowerCase().split('.').pop();
  const size = ext === 'png' ? pngSize(buf) : ['jpg', 'jpeg'].includes(ext) ? jpegSize(buf) : null;
  if (!size) return err(`${field}: ${p} must be a PNG or JPEG`);
  if (size.w !== 706 || size.h < 400 || size.h > 860) {
    err(`${field}: ${p} is ${size.w}x${size.h}; screenshots must be exactly 706 wide and 400-860 tall`);
  }
}

// ---------- contrast ----------
function luminance(hex) {
  const c = [1, 3, 5].map((i) => parseInt(hex.slice(i, i + 2), 16) / 255)
    .map((v) => (v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4));
  return 0.2126 * c[0] + 0.7152 * c[1] + 0.0722 * c[2];
}
const contrast = (a, b) => {
  const [x, y] = [luminance(a), luminance(b)].sort((m, n) => n - m);
  return (x + 0.05) / (y + 0.05);
};

// ---------- walk ----------
function findForbiddenKeys(obj, path = '') {
  if (!obj || typeof obj !== 'object') return;
  for (const [k, v] of Object.entries(obj)) {
    if (FORBIDDEN_KEYS.includes(k)) err(`${path}${k} must not be in the package; enter it in the portal`);
    findForbiddenKeys(v, `${path}${k}.`);
  }
}

function walkFiles(dir, out = []) {
  for (const name of readdirSync(dir)) {
    const abs = join(dir, name);
    const st = lstatSync(abs);
    const rel = relative(ROOT, abs);
    if (st.isSymbolicLink()) err(`${rel} is a symlink; the ZIP must contain regular files only`);
    else if (st.isDirectory()) walkFiles(abs, out);
    else out.push(rel);
  }
  return out;
}

// ================= checks =================
if (!existsSync(join(ROOT, 'plugin.json'))) {
  console.error(`✗ ${root}: no plugin.json at the plugin root`);
  process.exit(1);
}

for (const bad of ['.app.json', 'hooks', 'hooks.json', '.codex-plugin', '.mcp.json']) {
  if (existsSync(join(ROOT, bad))) err(`${bad} must not be in a directory submission (portable format only; no app references or hooks)`);
}

const files = walkFiles(ROOT);
for (const f of files) {
  if (f.split('/').some((seg) => seg.startsWith('.'))) err(`${f} is a hidden file; remove it`);
  if (f.split('/').length > 20) err(`${f} is nested more than 20 levels deep`);
}

const m = readJson('plugin.json');
const mcp = readJson('mcp.json');

if (m) {
  findForbiddenKeys(m);
  if (m.$schema !== PLUGIN_SCHEMA) err(`plugin.json $schema must be ${PLUGIN_SCHEMA}`);
  const allowedRoot = ['$schema', 'name', 'version', 'description', 'author', 'homepage', 'repository', 'license', 'keywords', 'extensions'];
  for (const k of Object.keys(m)) if (!allowedRoot.includes(k)) err(`plugin.json: "${k}" is not allowed at the root of the portable schema`);

  if (!isStr(m.name) || !/^[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$/.test(m.name) || m.name.includes('--') || m.name.length > 64) {
    err('name must be kebab-case (lowercase letters, digits, single hyphens), at most 64 characters');
  }
  if (!isStr(m.version) || !SEMVER.test(m.version)) err('version must be a semantic version such as 1.0.0');
  text('description', m.description, { max: 1024, single: false });
  if (!m.author || blank(m.author.name)) err('author.name is required');
  if (m.author?.url) httpsUrl('author.url', m.author.url, { max: 2048 });
  if (m.homepage) httpsUrl('homepage', m.homepage, { max: 2048 });
  if (m.keywords && (!Array.isArray(m.keywords) || !m.keywords.every(isStr))) err('keywords must be an array of strings');

  const oa = m.extensions?.['com.openai'];
  if (!oa) err('extensions["com.openai"] is required for the listing');
  if (oa?.apps) err('extensions.com.openai.apps (app references) cannot be submitted');
  if (oa?.hooks) err('extensions.com.openai.hooks (lifecycle hooks) cannot be submitted');

  const i = oa?.interface ?? {};
  text('interface.displayName', i.displayName, { max: 30 });
  if (isStr(i.displayName) && /\b(mcp|plugin)\b/i.test(i.displayName)) err('interface.displayName must not include "MCP" or "Plugin"');
  text('interface.shortDescription', i.shortDescription, { max: 30 });
  text('interface.longDescription', i.longDescription, { max: 4000, single: false });
  text('interface.developerName', i.developerName, { max: 80 });
  if (!CATEGORIES.includes(i.category)) err(`interface.category must be one of: ${CATEGORIES.join(', ')}`);
  if (i.capabilities !== undefined) {
    if (!Array.isArray(i.capabilities) || i.capabilities.length > 20) err('interface.capabilities must be an array of at most 20 labels');
    else i.capabilities.forEach((c, n) => text(`interface.capabilities[${n}]`, c, { max: 120 }));
  }
  for (const f of ['websiteURL', 'supportURL', 'privacyPolicyURL', 'termsOfServiceURL']) httpsUrl(`interface.${f}`, i[f]);

  const prompts = i.defaultPrompt === undefined ? [] : [].concat(i.defaultPrompt);
  if (prompts.length > 3) err('interface.defaultPrompt allows at most 3 prompts');
  const seen = new Set();
  prompts.forEach((p, n) => {
    text(`interface.defaultPrompt[${n}]`, p, { max: 128 });
    if (isStr(p) && /@\S/.test(p)) err(`interface.defaultPrompt[${n}] must not contain an @mention`);
    const key = isStr(p) ? p.normalize('NFKC').replace(/\s+/g, ' ').trim().toLowerCase() : '';
    if (seen.has(key)) err(`interface.defaultPrompt[${n}] duplicates another prompt`);
    seen.add(key);
  });

  for (const [f, bg] of [['brandColor', '#FFFFFF'], ['brandColorDark', '#212121']]) {
    if (i[f] === undefined) continue;
    if (!/^#[0-9A-Fa-f]{6}$/.test(i[f])) err(`interface.${f} must be #RRGGBB`);
    else if (contrast(i[f], bg) < 2) err(`interface.${f} needs at least 2:1 contrast against ${bg}`);
  }

  if (!i.logo) err('interface.logo (primary app icon) is required for submission');
  else checkIcon('interface.logo', i.logo);
  if (!i.composerIcon) err('interface.composerIcon is required');
  else checkIcon('interface.composerIcon', i.composerIcon);
  for (const f of ['logoDark', 'composerIconDark']) if (i[f]) checkIcon(`interface.${f}`, i[f]);
  if (i.screenshots?.length) {
    i.screenshots.forEach((s, n) => checkScreenshot(`interface.screenshots[${n}]`, s));
    if (i.screenshots.length !== prompts.length) {
      err(`interface.screenshots has ${i.screenshots.length} images; provide exactly one per starter prompt (${prompts.length})`);
    }
    warn('screenshots are allowed only when the MCP scan reports a UI output template');
  }

  if (oa?.onboardingSkill) {
    const p = oa.onboardingSkill;
    if (!isStr(p) || !/^\.\/skills\/[^/]+\/SKILL\.md$/.test(p) || !existsSync(join(ROOT, p))) {
      err('onboardingSkill must point to an included ./skills/<name>/SKILL.md');
    }
  }

  const review = oa?.review;
  const tc = review?.test_cases;
  const pos = tc?.positive ?? [];
  const neg = tc?.negative ?? [];
  if (pos.length !== 5) err(`review.test_cases.positive has ${pos.length} cases; initial MCP review needs exactly 5`);
  if (neg.length !== 3) err(`review.test_cases.negative has ${neg.length} cases; initial MCP review needs exactly 3`);
  pos.forEach((c, n) => {
    for (const f of ['description', 'prompt', 'tools_triggered', 'expected_behavior']) {
      if (blank(c[f])) err(`review.test_cases.positive[${n}].${f} is required`);
    }
    if (isStr(c.description) && len(c.description) > 4000) err(`review.test_cases.positive[${n}].description is over 4000 characters`);
  });
  neg.forEach((c, n) => {
    for (const f of ['description', 'prompt']) if (blank(c[f])) err(`review.test_cases.negative[${n}].${f} is required`);
  });
  if (!review?.demo_recording_url) warn('review.demo_recording_url is missing; MCP review requires a video walkthrough URL (it can also be entered in the portal)');
  else httpsUrl('review.demo_recording_url', review.demo_recording_url);
  if (review && 'commerce_description' in (oa?.publication ?? {})) err('commerce_description belongs in review, not publication');
  if (blank(oa?.publication?.release_notes)) warn('publication.release_notes is missing; MCP review requires release notes');
  const countries = oa?.publication?.countries;
  if (countries !== undefined && (!Array.isArray(countries) || !countries.every((c) => /^[A-Z]{2}$/.test(c)))) {
    err('publication.countries must be uppercase two-letter country codes');
  }
  for (const [loc, t] of Object.entries(oa?.publication?.translations ?? {})) {
    if (t?.subtitle != null) text(`translations.${loc}.subtitle`, t.subtitle, { max: 30 });
    if (t?.description != null) text(`translations.${loc}.description`, t.description, { max: 4000, single: false });
  }
}

if (mcp) {
  if (mcp.$schema !== MCP_SCHEMA) err(`mcp.json $schema must be ${MCP_SCHEMA}`);
  const servers = Object.entries(mcp.mcpServers ?? {});
  if (servers.length !== 1) err(`mcp.json declares ${servers.length} servers; plugin-level review cases need exactly one`);
  for (const [name, s] of servers) {
    if (blank(name)) err('mcp.json server names must be non-empty');
    if (s.type !== 'streamable-http') err(`mcp.json ${name}: type must be "streamable-http" for a remote server`);
    httpsUrl(`mcp.json ${name}.url`, s.url);
    const extra = Object.keys(s).filter((k) => !['type', 'url', 'headers'].includes(k));
    if (extra.length) err(`mcp.json ${name}: unsupported keys ${extra.join(', ')}`);
  }
}

// ---------- skills ----------
const skillsDir = join(ROOT, 'skills');
const skillNames = new Set();
if (existsSync(skillsDir)) {
  for (const entry of readdirSync(skillsDir)) {
    const dir = join(skillsDir, entry);
    if (!statSync(dir).isDirectory()) {
      warn(`skills/${entry} is a file directly under skills/ and is ignored`);
      continue;
    }
    const f = join(dir, 'SKILL.md');
    if (!existsSync(f)) {
      err(`skills/${entry} has no SKILL.md`);
      continue;
    }
    const src = readFileSync(f, 'utf8');
    const fm = src.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/);
    if (!fm) {
      err(`skills/${entry}/SKILL.md must start with YAML front matter`);
      continue;
    }
    const field = (k) => fm[1].match(new RegExp(`^${k}:\\s*(.+)$`, 'm'))?.[1].trim().replace(/^["']|["']$/g, '');
    const name = field('name');
    const desc = field('description');
    if (!name) err(`skills/${entry}: name is required`);
    if (!desc) err(`skills/${entry}: description is required`);
    else if (len(desc) > 1024) err(`skills/${entry}: description is over 1024 characters`);
    if (name && name !== entry) warn(`skills/${entry}: front-matter name "${name}" differs from its folder name`);
    if (name && skillNames.has(name)) err(`skills/${entry}: skill name "${name}" is used twice`);
    if (name) skillNames.add(name);
    if (m?.name && name && `${m.name}:${name}`.length > 64) err(`skill identity ${m.name}:${name} is over 64 characters`);
    if (!fm[2].trim()) err(`skills/${entry}/SKILL.md has no instructions`);
    if (/^metadata:/m.test(fm[1])) warn(`skills/${entry}: "metadata" in SKILL.md is ignored; use agents/openai.yaml`);
  }
}

// ---------- optional URL liveness ----------
async function liveUrls() {
  const i = m?.extensions?.['com.openai']?.interface ?? {};
  const urls = ['websiteURL', 'supportURL', 'privacyPolicyURL', 'termsOfServiceURL']
    .map((f) => [f, i[f]])
    .concat([['demo_recording_url', m?.extensions?.['com.openai']?.review?.demo_recording_url]])
    .filter(([, u]) => u);
  for (const [f, u] of urls) {
    try {
      const r = await fetch(u, { redirect: 'follow' });
      const final = new URL(r.url);
      if (!r.ok) err(`${f} ${u} returned HTTP ${r.status}`);
      else if (/sign-?in|login/i.test(final.pathname)) err(`${f} ${u} redirects to a sign-in page (${r.url}); it must be public`);
    } catch (e) {
      err(`${f} ${u} could not be fetched: ${e.message}`);
    }
  }
}

if (checkUrls) await liveUrls();

// ---------- report ----------
const label = m?.name ? `${m.name}@${m.version}` : root;
for (const w of warnings) console.log(`  ! ${w}`);
for (const e of errors) console.error(`  ✗ ${e}`);
if (errors.length) {
  console.error(`\n✗ ${label}: ${errors.length} error(s), ${warnings.length} warning(s)`);
  process.exit(1);
}
console.log(`✓ ${label}: package checks passed (${warnings.length} warning(s)${checkUrls ? ', URLs checked' : ''}).`);
console.log('  This checks the ZIP contents only. Submission also needs a clean MCP scan, domain verification,');
console.log('  reviewer credentials, a demo video, and all test cases run for real. See docs/chatgpt-plugins/.');
