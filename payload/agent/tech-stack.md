# Tech Stack

<!--
Drafted by the init-constitution step from the repo itself (package manifests,
config, CI, Docker, etc.). Anything marked TODO(verify) needs a human check.
-->

## Overview
<What the system is and how its main pieces fit together, in a short paragraph.>

## Language & Runtime
- <Language + version> (source: <manifest / Dockerfile / .tool-versions>)
- <Package manager + version>

## Framework
- <Framework and version — or "none / custom">

## Key Dependencies
- <Package> — <what it's used for>

## Data & Storage
- <Database engine + version, ORM / query layer, migrations tool>
- <Cache, queue, search, file storage>

## External Services & Integrations
- <Service> — <what for, where the integration code lives>

## Frontend
- <Templating or UI framework, build tooling, styling approach — or "none">

## Testing
- <Test framework(s), config file, where tests live>

## Tooling
- <Linters, static analysis, formatters, code generators>

## Environments & Deployment
- <Local dev setup, CI provider, hosting, how deploys happen>

---

## Architecture

### Request Flow
1. <Entry point → routing → handler → business logic → persistence → response>

### Environment Variables
- Required variables are listed in <`.env.example` or equivalent>. Never copy real
  values into docs.

### Key Points to Remember
- <Non-obvious things that would trip up a newcomer>
