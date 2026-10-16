#!/usr/bin/env bash
# Scaffold a new feature spec from the templates.
# Usage: agent/scripts/new-spec.sh <area>-<feature-slug>
set -euo pipefail

name="${1:-}"
if [[ -z "$name" ]]; then
  echo "Usage: $0 <area>-<feature-slug>  (kebab-case, e.g. checkout-saved-cards)" >&2
  exit 1
fi

if [[ ! "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)+$ ]]; then
  echo "Error: '$name' should be kebab-case with at least an <area>-<feature> shape," >&2
  echo "       e.g. checkout-saved-cards or reports-csv-export." >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
templates_dir="$script_dir/../spec-templates"
repo_root="$(cd "$script_dir/../.." && pwd)"
target="$repo_root/specs/$name"

if [[ -d "$target" ]]; then
  echo "Error: $target already exists — refusing to overwrite." >&2
  exit 1
fi

mkdir -p "$target"
cp "$templates_dir/"*.md "$target/"

echo "Created spec: specs/$name/"
ls -1 "$target" | sed 's/^/  - /'
echo
echo "Next: read the constitution, then fill 01-requirements → 02-design → 03-tasks,"
echo "logging decisions in 04-decisions.md as you go."
