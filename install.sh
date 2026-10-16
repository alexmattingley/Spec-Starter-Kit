#!/usr/bin/env bash
# Install spec-starter (agent constitution + spec process) into a target repository.
# Never overwrites existing files: existing AGENTS.md / CLAUDE.md get a section
# appended, everything else that already exists is skipped. Safe to re-run.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: install.sh [--name "Project Name"] [--tools claude,cursor] <target-repo>

  --name   Project name used in the docs (default: target folder name)
  --tools  Comma-separated agent tools to add skill wrappers for:
           claude, cursor (default: claude,cursor)

Language profiles are chosen later by the agent, during init-constitution.
EOF
}

name=""
tools="claude,cursor"
target=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name) name="${2:?--name needs a value}"; shift 2 ;;
    --tools) tools="${2:?--tools needs a value}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    *) target="$1"; shift ;;
  esac
done

if [[ -z "$target" ]]; then
  usage >&2
  exit 1
fi
if [[ ! -d "$target" ]]; then
  echo "Error: $target is not a directory." >&2
  exit 1
fi
target="$(cd "$target" && pwd)"
name="${name:-$(basename "$target")}"
payload="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/payload"

if ! git -C "$target" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Warning: $target is not a git repo — you won't get a diff to review." >&2
fi

created=""
updated=""
skipped=""
note() { printf -v "$1" '%s  %s\n' "${!1}" "$2"; }

# Escape the name for use as a sed replacement.
name_sed="$(printf '%s' "$name" | sed 's/[&|\\]/\\&/g')"
render() { sed "s|{{PROJECT_NAME}}|$name_sed|g"; }

# 1. Copy payload files that don't exist yet.
while IFS= read -r rel; do
  dest="$target/$rel"
  if [[ -e "$dest" ]]; then
    [[ "$rel" == "AGENTS.md" ]] || note skipped "$rel (already exists)"
    continue
  fi
  mkdir -p "$(dirname "$dest")"
  render < "$payload/$rel" > "$dest"
  note created "$rel"
done < <(cd "$payload" && find . -type f | sed 's|^\./||' | sort)

chmod +x "$target/agent/scripts/new-spec.sh" 2>/dev/null || true

# 2. Existing AGENTS.md: append the spec-starter section once.
agents="$target/AGENTS.md"
if ! grep -q 'spec-starter:begin' "$agents"; then
  { printf '\n'; sed -n '/spec-starter:begin/,/spec-starter:end/p' "$payload/AGENTS.md" | render; } >> "$agents"
  note updated "AGENTS.md (appended constitution section)"
elif [[ "$created" != *"AGENTS.md"* ]]; then
  note skipped "AGENTS.md (section already present)"
fi

# 3. Thin per-tool skill wrappers that point at the canonical docs in agent/.
write_skill() { # <skills-dir> <name> <description> <doc>
  local file="$target/$1/$2/SKILL.md"
  local rel="${file#"$target"/}"
  if [[ -e "$file" ]]; then
    note skipped "$rel (already exists)"
    return
  fi
  mkdir -p "$(dirname "$file")"
  cat > "$file" <<EOF
---
name: $2
description: >-
  $3
---

Read and follow [\`$4\`](../../../$4). It is the single source of truth for this
process — don't duplicate its contents here.
EOF
  note created "$rel"
}

spec_desc="Plan a non-trivial change before building it by scaffolding and filling a structured spec in specs/<area>-<feature-slug>/. Use when asked to plan, spec, or design a feature, or before implementing anything beyond a small, obvious change."
init_desc="Draft this repo's agent constitution (agent/tech-stack.md, structure.md, conventions.md) by reading the codebase. Use right after spec-starter is installed, or when asked to (re)generate the constitution."

IFS=',' read -r -a tool_list <<< "$tools"
for tool in "${tool_list[@]}"; do
  case "$tool" in
    claude)
      write_skill .claude/skills spec-process "$spec_desc" agent/spec-process.md
      write_skill .claude/skills init-constitution "$init_desc" agent/init-constitution.md
      # Claude Code reads CLAUDE.md, not AGENTS.md — import it.
      claude_md="$target/CLAUDE.md"
      if [[ ! -e "$claude_md" ]]; then
        printf '@AGENTS.md\n' > "$claude_md"
        note created "CLAUDE.md (imports AGENTS.md)"
      elif ! grep -q '@AGENTS.md' "$claude_md"; then
        printf '\n@AGENTS.md\n' >> "$claude_md"
        note updated "CLAUDE.md (added @AGENTS.md import)"
      fi
      ;;
    cursor)
      write_skill .cursor/skills spec-process "$spec_desc" agent/spec-process.md
      write_skill .cursor/skills init-constitution "$init_desc" agent/init-constitution.md
      ;;
    *) echo "Warning: unknown tool '$tool' — skipped (supported: claude, cursor)." >&2 ;;
  esac
done

# 4. Summary.
echo "spec-starter installed into $target (project name: $name)"
[[ -n "$created" ]] && printf '\nCreated:\n%s' "$created"
[[ -n "$updated" ]] && printf '\nUpdated:\n%s' "$updated"
[[ -n "$skipped" ]] && printf '\nSkipped:\n%s' "$skipped"
cat <<'EOF'

Next steps:
  1. Review the changes:   git status && git diff
  2. Open the repo in Claude Code or Cursor and run the init-constitution skill
     (Claude Code: /init-constitution) — or ask the agent to follow
     agent/init-constitution.md. It picks a language profile (and tells you which,
     so you can correct it), then drafts tech-stack, structure, and conventions.
  3. Review its TODO(verify) items, then fill mission.md and road-map.md with the
     project's owners.
  4. First feature: agent/scripts/new-spec.sh <area>-<feature-slug>
EOF
