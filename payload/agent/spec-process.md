# Spec Process

Plan a non-trivial change before building it. This file is the single source of
truth for spec naming, the standard file set, the steps, and spec-writing
conventions. (Tool-specific skills in `.claude/` and `.cursor/` just point here.)

Specs are **living working plans**. They live in `specs/<area>-<feature-slug>/`,
separate from the `agent/` constitution. The constitution describes how the codebase
works today and what's planned; a spec is a plan for changing it. Once a spec is
complete it's a historical record — the constitution and the code are the source
of truth.

Use a spec for anything beyond a small, obvious change — it touches multiple
files/systems, changes stored data, has UX/architecture trade-offs, or is a
road-map item. Small fixes don't need one.

## Naming
Name folders after the **specific feature**, not the area — `<area>-<feature-slug>`,
kebab-case (e.g. `checkout-saved-cards`, `reports-csv-export`). Keeps names unique so
an area can have several specs over time. Avoid bare area names like `checkout`.

## Standard file set
| File | Contents | Answers |
| --- | --- | --- |
| `01-requirements.md` | Status header, context, goals/non-goals, user stories, MUST/SHOULD/COULD requirements, acceptance criteria | **Why + What** |
| `02-design.md` | Technical approach, affected code, data/interface changes, risks | **How** |
| `03-tasks.md` | Phased, checkboxed plan + AC verification table + Definition of Done | **Order + Done?** |
| `04-decisions.md` | Decision log (D-# · date · decision · rationale) + open questions | **Decided** |

Delete sections that don't apply rather than leaving them empty — a small spec
should look small.

## Steps
1. **Read the constitution first** ([`AGENTS.md`](../AGENTS.md) → mission,
   tech-stack, structure, conventions, road-map) and the existing code the change
   touches.
2. **Scaffold the file structure** — run the script below to copy the templates,
   which come pre-filled with section headers and placeholders. Do this *before*
   deciding anything — it gives a concrete shape to react to.
3. **Ask focused questions** (structured, one screen) covering scope, behavior, data,
   and tech. Log each answer in `04-decisions.md` as a dated decision with rationale.
4. **Reference existing patterns** — start from the reference implementations in
   [`structure.md`](structure.md) rather than inventing new ones.
5. **Flag conflicts with the road map / constitution explicitly** and note the doc
   that needs updating.
6. **Fill in** requirements → design → tasks (including the verification table) from
   the locked decisions.
7. **Keep it living:** new questions during implementation go into `04-decisions.md`,
   get answered, then promoted to the decision log and folded into the relevant file.
8. **On ship:** work through the Definition of Done in `03-tasks.md`, then
   [complete the spec](#completing-a-spec).

## Status
Set in the header of `01-requirements.md`:

| Status | Meaning |
| --- | --- |
| 🟡 Draft | Being planned; open questions remain |
| 🔵 In progress | Decisions locked; being built |
| ✅ Complete · YYYY-MM-DD | Shipped and verified — historical record from here on |
| ⛔ Abandoned · YYYY-MM-DD | Stopped; the reason is logged in `04-decisions.md` |

## Completing a spec
When the Definition of Done is met:

1. **Mark it complete** — set the status to `✅ Complete · <date>` and update
   **Last updated**.
2. **Update the constitution** if the change altered how the codebase works — new
   services or dependencies (`tech-stack.md`), new folders or reference
   implementations (`structure.md`), new rules or commands (`conventions.md`). This
   keeps the constitution current so nobody needs to read old specs to understand
   the code.
3. **Move the road-map item to Done** in `agent/road-map.md`, linking the spec.
4. **Move the spec to Completed** in [`specs/README.md`](../specs/README.md).

After that, **don't edit a completed spec**. Follow-up work on the same area gets a
new spec. Agents should treat completed and abandoned specs as history: useful for
the *why* behind past decisions, but never followed over the constitution or code.

## Scaffolding

```bash
agent/scripts/new-spec.sh <area>-<feature-slug>
```

Runs from anywhere (it finds the repo root itself). This creates
`specs/<area>-<feature-slug>/` with the four templated files and refuses to
overwrite an existing spec folder. If scripting isn't available, copy the files in
[`spec-templates/`](spec-templates/) into the new folder by hand.

## Conventions
- Requirement IDs (`FR-#`, `NFR-#`, `AC-#`, `D-#`) so tasks/tests can reference them.
- **Keep it DRY — say each thing once.** Rationale lives *only* in the decision log;
  requirements/design reference it instead of restating. Don't re-document the
  constitution — link to `agent/` instead. Keeps the token cost of building low.
- Every non-obvious choice gets a one-line rationale in the decision log.
- Follow [`conventions.md`](conventions.md), and run its
  [Commands](conventions.md#commands) before marking anything done.
