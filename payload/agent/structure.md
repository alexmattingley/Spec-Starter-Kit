# Structure

Where code lives and which existing patterns to copy. When adding something new,
find the closest reference implementation below and follow it.

<!--
Drafted by the init-constitution step. Reference implementations should be real
files that represent how the team *wants* code written — confirm with the team.
-->

## Directory Map
| Path | What lives there |
| --- | --- |
| `<path>/` | <application code> |
| `<path>/` | <tests> |
| `<path>/` | <configuration> |
| `<path>/` | <schema migrations, seed data> |

## Entry Points
- <Web server / app bootstrap, CLI commands, scheduled jobs, queue workers>

## Where New Code Goes
| Adding a… | Put it in | Reference implementation |
| --- | --- | --- |
| Endpoint / page / screen | <path> | <file> |
| Business logic | <path> | <file> |
| Data / schema change | <path> | <file> |
| Background job / command | <path> | <file> |
| Test | <path> | <file> |

## Legacy / Don't Copy
- <Areas that work but shouldn't be used as a pattern, and what to use instead>

## Don't Edit
- <Generated, vendored, or third-party directories>
