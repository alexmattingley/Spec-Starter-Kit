# Conventions

Coding standards and conventions for this repository.

<!--
Rules here start as sensible defaults. The init-constitution step adds language
rules from a profile in agent/profiles/ at the marker below, then confirms each rule
against the repo's actual config and code and edits any that don't match what the
team really does.
-->

## Match the existing code first

When the codebase already has a consistent way of doing something, follow it —
even if it differs from a general best practice below. If an existing pattern looks
harmful, raise it rather than silently diverging. See
[structure.md](structure.md) for reference implementations.

## Commands

Work isn't done until all of these pass locally.

| Purpose | Command |
| --- | --- |
| Install dependencies | `<command>` |
| Run tests | `<command>` |
| Lint / static analysis | `<command>` |
| Format check | `<command>` |
| Format fix | `<command>` |

<!-- spec-starter:profile -->
## Dependencies

Don't add a new dependency without asking. Never edit third-party or generated
code (vendored packages, build output, lockfiles by hand).

## Data changes

- Every schema change is a new migration. Never edit a migration that has already
  run in any shared environment.
- Prefer backward-compatible changes (add, then backfill, then remove) so deploys
  can roll back.

## Tests

- New behavior gets a test; bug fixes get a test that fails before the fix.
- Use the existing test framework and helpers rather than introducing new ones.
- Don't add ignores, suppressions, or baseline entries to get a check passing. If
  one is truly needed, explain why in the PR.

## Follow DRY

Don't duplicate logic, config, or content. Extract shared code, reference a single
source of truth, and avoid restating the same information in multiple places.

## Don't reinvent the wheel

For well-established problems (auth, queues, validation, HTTP clients, date
handling, UI patterns like modals and carousels, etc.), use the framework or an
existing, maintained library instead of building it from scratch.

**Always ask before creating custom functionality for these.** Surface the
library/framework options as choices rather than hand-rolling it without checking
first.

## Keep code and comments simple

Write code and comments that are easy to understand. Comments should explain the
non-obvious "why" in plain language — if a comment is confusing or just restates
the code, leave it out.

## Secrets

Never commit secrets, and never copy values from `.env` files into code, docs, or
specs. Reference the variable name instead.
