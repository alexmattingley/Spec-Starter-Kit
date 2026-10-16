---
profile: php
language: PHP
markers: composer.json; *.php source files; artisan, bin/console, wp-config.php, or web/core
---

## PHP

- **Style:** PSR-12 unless the repo's style config (PHP-CS-Fixer, PHP_CodeSniffer)
  says otherwise — the config file wins. Run the fixer rather than hand-formatting.
- **Types:** add parameter, return, and property types to new code. Use
  `declare(strict_types=1);` in new files if the codebase already does.
- **Static analysis:** keep PHPStan/Psalm at the configured level. Don't add
  baseline entries for new code.
- **Composer:** never edit `vendor/`. Add packages with `composer require`, not by
  editing `composer.lock`.
- **Framework idioms:** use the framework's built-in way (container, validation,
  ORM, config, events, queues) before writing a custom one.
