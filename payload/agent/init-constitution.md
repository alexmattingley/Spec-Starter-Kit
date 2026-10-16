# Init Constitution

One-time setup: draft this repo's agent constitution by reading the codebase. Run it
right after spec-starter is installed, or later to refresh the docs when the stack
changes. (Tool-specific skills in `.claude/` and `.cursor/` just point here.)

**Goal:** turn the placeholder docs in `agent/` into an accurate description of how
*this* repo actually works, so every later spec and change starts from the truth.

## Rules
- **Read only.** Don't change any code, config, or dependencies — only edit files in
  `agent/`.
- **Describe what is, not what should be.** Document the patterns the code actually
  uses. If something looks wrong, list it under "Findings" in your summary instead
  of writing it into the docs as a rule.
- **Cite sources.** When a fact comes from a file, mention the file (e.g. "Node 22 —
  `.nvmrc`").
- **Mark uncertainty.** Anything you inferred rather than read gets
  `<!-- TODO(verify): … -->` next to it.
- **No secrets.** Never copy values from `.env*` files, config, or CI secrets —
  variable names only.
- **Don't invent business context.** Leave `mission.md` and `road-map.md`
  placeholders in place and ask the human instead (see step 7).
- Remove placeholder text (`<…>`) and the setup comments once a section is filled
  in. Delete sections that don't apply rather than leaving them empty.

## Steps

### 1. Survey the repo
Read, where they exist:
- **Package manifests and lockfiles** — e.g. `package.json`, `composer.json`,
  `pyproject.toml` / `requirements*.txt`, `Gemfile`, `go.mod`, `Cargo.toml`,
  `pom.xml` / `build.gradle`, `*.csproj`. Note language version, framework, key
  packages, and any defined scripts/tasks.
- **Runtime version hints** — `Dockerfile`, `docker-compose*.yml`, `.tool-versions`,
  `.nvmrc`, `.python-version`, `.php-version`, devcontainer config.
- **Framework markers** — the entry files and config directories that identify the
  framework (e.g. `next.config.*`, `manage.py`, `artisan`, `bin/console`,
  `config/routes.rb`).
- **Quality tooling** — linter, formatter, static analysis, and test runner configs.
- **Task runners** — `Makefile`, `justfile`, `Taskfile.yml`, manifest scripts.
- **CI** — `.github/workflows/`, `.gitlab-ci.yml`, `bitbucket-pipelines.yml`,
  `Jenkinsfile`, `.circleci/`.
- **Env templates** — `.env.example`, `.env.dist`, or equivalent.
- **Existing docs and agent rules** — `README*`, `docs/`, `CONTRIBUTING*`, any
  existing `CLAUDE.md`, `.cursorrules`, `.cursor/rules/`, or
  `.github/copilot-instructions.md` (fold useful rules into `conventions.md`).

Then walk the top two levels of the directory tree and open 3–5 representative
files per layer (entry point/handler, business logic, data access, migration, test).

### 2. Choose a language profile
Each file in `agent/profiles/` holds default rules for one language, and its
frontmatter lists the `markers` that identify that language. Compare them with what
you found in step 1, decide which case below applies, and **always tell the user
which one it was** before moving on.

**A. Clear match** — exactly one profile's markers are present, and that language
is clearly the main language of the repo. Tell the user, then continue:

> **Profile match: <Language>** — found <markers, e.g. `composer.json` and
> `src/**/*.php`>. I'm setting up the constitution with the <Language> profile's
> conventions.

**B. No clear match, but you can tell what the repo is** — e.g. markers for more
than one profile (a PHP backend with a JavaScript frontend), or a language that has
no profile yet. Deduce the best fit: the profile(s) for the language(s) that hold
most of the application code, or no profile if none fit. Tell the user what you
chose and why, then **stop and wait for them to confirm or correct it**:

> **Best match: <choice>** — <evidence, e.g. "`composer.json` plus a Vue frontend in
> `resources/js/`; most application code is PHP">. I'll set up the constitution with
> <the <Language> profile / no profile, drafting <Language> rules from the code>.
> Reply to confirm, or tell me what to use instead.

**C. Unclear** — no manifests, minimal or conflicting signals, or an unusual repo
(infrastructure, docs, data, generated code). Don't guess. Ask the user, then go
back to case A or B with their answers:

- What's the main language, and framework if any?
- What kind of repo is it — web app, API, library, CLI, infrastructure/config,
  monorepo, or something else?
- If it's a monorepo, which parts should the constitution cover?
- Is any of the code here generated, vendored, or not maintained by the team?

**Apply the choice:** in `agent/conventions.md`, replace the
`<!-- spec-starter:profile -->` line with the chosen profile's sections (everything
after its frontmatter). With more than one profile, add each. With none, delete the
line. Then delete `agent/profiles/` — `conventions.md` is now the source of truth.

### 3. Fill `agent/tech-stack.md`
Every section, from what you read. Include the request flow under Architecture.

### 4. Fill `agent/structure.md`
- Directory map and entry points.
- **Where New Code Goes:** for each row, pick a real, recent, clean file as the
  reference implementation. Prefer files that pass the checks and have tests.
- **Legacy / Don't Copy:** areas that use an older pattern than the rest of the code.

### 5. Fill `agent/conventions.md`
- **Commands:** the exact commands, preferring task-runner/manifest scripts or CI
  steps over guesses. Run each one once to confirm it works; if one fails or needs
  services (DB, Docker) you can't start, say so in the table. Delete rows that don't
  apply.
- **Default rules** (including any language section added in step 2): confirm each
  against the config and code, and edit any that don't match what the team actually
  does. Delete sections that don't apply (e.g. Data changes in a repo without a
  database). Add repo-specific rules you see consistently followed.
- **No profile used?** Add a section for the main language with the rules the code
  consistently follows — style config, typing, static analysis, package manager,
  framework idioms.
- Keep the general sections (DRY, don't reinvent the wheel, simple comments,
  secrets) unless the human says otherwise.

### 6. Check `AGENTS.md`
Make sure it links every file in `agent/` and that links resolve.

### 7. Report back
Reply with:
1. **Profile** — which profile(s) you applied, or that none fit.
2. **Summary** — one line per file you changed.
3. **Needs verification** — every `TODO(verify)` you left.
4. **Findings** — risks or inconsistencies noticed (untested areas, failing checks,
   outdated runtimes, security smells, etc.). Don't fix them.
5. **Questions for mission & road map** — a short list for the human to answer with
   the project's owners, e.g. who the users are, what the goal is, what's painful
   today, what's planned next, and where the backlog lives. When answered, fill in
   `agent/mission.md` and `agent/road-map.md`.
