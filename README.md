# spec-starter

A drop-in kit for **spec-driven development with AI coding agents**. One command
adds two things to any repository:

1. **A constitution** (`agent/`) — short, durable docs every agent reads before
   touching code: mission, tech stack, structure, conventions, and road map.
2. **A spec process** (`specs/`) — a four-file format for planning a change before
   building it, plus a script to scaffold new specs.

Everything is plain Markdown, so it works with any agent that reads `AGENTS.md`.
Claude Code and Cursor also get thin skill wrappers so the process loads
automatically.

## Quick start

```bash
git clone <this-repo-url> ~/spec-starter
~/spec-starter/install.sh --name "My Project" /path/to/your-repo
```

Then, in your repo:

1. **Review** what was added: `git status && git diff`.
2. **Draft the constitution** — run the `init-constitution` skill
   (`/init-constitution` in Claude Code), or ask any agent to follow
   `agent/init-constitution.md`. The agent reads the codebase, tells you which
   [language profile](#profiles) it's using (or asks), fills in `tech-stack.md`,
   `structure.md`, and `conventions.md`, runs your check commands, and reports
   back with items to verify, findings, and questions.
3. **Finish it yourself** — review the drafts, then fill in `mission.md` and
   `road-map.md`. Those can't be read from code.
4. **Commit** the constitution so the team can review it like any other change.
5. **Plan your first feature** — ask the agent to spec it (the `spec-process`
   skill), or scaffold one by hand:
   ```bash
   agent/scripts/new-spec.sh <area>-<feature-slug>
   ```

## Installer options

| Option | Default | Purpose |
| --- | --- | --- |
| `--name` | target folder name | Project name used in the docs |
| `--tools` | `claude,cursor` | Which agent tools get skill wrappers |

The installer **never overwrites a file**. An existing `AGENTS.md` or `CLAUDE.md`
gets a section appended; anything else that already exists is skipped. It's safe to
re-run.

## What gets installed

```
AGENTS.md                      Entry point linking the constitution (created or appended)
CLAUDE.md                      Imports AGENTS.md for Claude Code (with --tools claude)
agent/
  mission.md                   What the project is and why — filled in by people
  road-map.md                  Planned work with priority/complexity — filled in by people
  tech-stack.md                Languages, frameworks, services — drafted by init-constitution
  structure.md                 Where code lives + reference files to copy — drafted by init-constitution
  conventions.md               Rules + the commands that define "done" — drafted by init-constitution
  spec-process.md              How to write a spec (single source of truth)
  init-constitution.md         The one-time setup prompt
  profiles/                    Language rule sets — used and then removed by init-constitution
  spec-templates/              The four spec templates
  scripts/new-spec.sh          Spec scaffolder
specs/README.md                Index of specs
.claude/skills/, .cursor/skills/   Thin wrappers pointing at agent/*.md
```

## The spec format

Each spec lives in `specs/<area>-<feature-slug>/`:

| File | Answers |
| --- | --- |
| `01-requirements.md` | **Why + what** — context, goals, requirements (`FR-#`), acceptance criteria (`AC-#`) |
| `02-design.md` | **How** — approach, affected code, data/interface changes, risks |
| `03-tasks.md` | **Order + done?** — phased checklist, AC verification table, Definition of Done |
| `04-decisions.md` | **Decided** — dated decision log (`D-#`) and open questions |

IDs link the files together: tasks reference `FR-#`, the verification table proves
each `AC-#`, and rationale lives only in the decision log. See
[`payload/agent/spec-process.md`](payload/agent/spec-process.md) for the full
process.

## Profiles

Profiles are language-specific default rules for `conventions.md`. The installer
copies them all into `agent/profiles/`. During `init-constitution`, the agent
compares each profile's markers with the repo and always tells you what it decided:

| Situation | What the agent does |
| --- | --- |
| **Clear match** — one profile's markers, clearly the main language | Says which profile matched and why, then continues |
| **No clear match** — several profiles match, or the language has no profile | Picks the best fit, explains its reasoning, and **waits for you to confirm or correct it** |
| **Unclear** — no manifests or mixed signals | **Asks you** about the language, framework, and kind of repo before choosing |

The chosen rules go into `conventions.md`, the agent checks each one against the
repo's real config, and `agent/profiles/` is deleted.

To add a profile, create `payload/agent/profiles/<name>.md`:

```markdown
---
profile: <name>
language: <Language>
markers: <files or patterns that identify it, e.g. package.json; *.ts source files>
---

## <Language>

- **<Rule>:** <default rule>
```

Available: [`php`](payload/agent/profiles/php.md).

## Design principles

- **Plain Markdown, any agent.** Instructions live in `agent/`; tool-specific files
  only point there.
- **Describe the repo as it is.** The constitution is drafted from the actual code
  and config, not from ideal practices.
- **Say each thing once.** Specs link to the constitution instead of restating it,
  and rationale lives only in the decision log. Less duplication means fewer
  tokens and fewer docs drifting out of sync.
- **Commands define done.** Agents follow concrete commands more reliably than
  written advice, so `conventions.md` lists the exact checks to run.
- **Small specs stay small.** Delete sections that don't apply.
