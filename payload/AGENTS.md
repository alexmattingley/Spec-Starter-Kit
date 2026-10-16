# AGENTS.md

Entry point for AI agents working in this repository. Read the documents below
before making changes — they define the project's purpose, technical foundation,
and how we plan work.

<!-- spec-starter:begin -->
## Agent Constitution
- [Mission](agent/mission.md) — what {{PROJECT_NAME}} is, who it's for, and why it exists
- [Tech Stack](agent/tech-stack.md) — languages, frameworks, services, and infrastructure
- [Structure](agent/structure.md) — where code lives and which existing patterns to copy
- [Conventions](agent/conventions.md) — coding standards and the commands that define "done"
- [Road Map](agent/road-map.md) — planned work with priority and complexity ratings
- [Spec Process](agent/spec-process.md) — how we plan a non-trivial change before building it (see `specs/`)

## Working rules
- Anything beyond a small, obvious change gets a spec first — see [Spec Process](agent/spec-process.md).
- Completed specs are history. For how the code works today, trust the constitution
  and the code over any ✅ Complete spec.
- Before calling work done, run every check in [Conventions → Commands](agent/conventions.md#commands).
- Never commit secrets or copy values out of `.env` files.
<!-- spec-starter:end -->
