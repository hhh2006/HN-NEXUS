---
layout: default
title: "Test Report V0.2.7"
---

# HN NEXUS test report — publishing candidate v0.2.7

## Candidate changes and validation

- Corrected the final literal-source assertion in `tests/static-check.sh` to avoid the remaining `SC2016` ShellCheck finding without expanding the searched variables.
- User-run on Kali GNU/Linux Rolling 2026.1 with ZSH 5.9: `bash tests/run-all.sh` completed with `EXIT CODE: 0`. Static safety/feature checks, color output, theme assets and syntax, 293-width prompt geometry, installer rollback, theme rollback, ZSH parser and ZSH runtime/resize smoke tests all passed.
- User-run isolated upgrade simulation: `setup.sh --core` installed over seeded previous HN configuration in a disposable HOME; user `.zshrc` content and `.zsh_history` survived; previous configuration was backed up; rollback restored all three prior configuration files and preserved user content/history. The test ended with `UPGRADE AND ROLLBACK TEST COMPLETED`.
- Earlier user-run on Kali: XFCE theme apply and restore returned the desktop to its prior appearance; the restore summary reported 15 restored items.
- Archive integrity and SHA256 verification passed in the build environment for the v0.2.7 candidate archive.

## ShellCheck status

The user invoked `find ... -print0 | xargs -0 -r shellcheck`, but the supplied result did not include the command's exit status or a separate ShellCheck summary. Therefore this report does not claim an independently confirmed clean ShellCheck run. Confirm with `echo $?` immediately after the pipeline, or use `set -o pipefail` before running it.

## Remaining before public release

- Confirm ShellCheck's exit status on Kali (and resolve any findings).
- Publish to the intended GitHub repository and verify the CI and GitHub Pages workflows in GitHub Actions.
- Replace repository-owner placeholders/links if applicable and inspect the live Pages rendering.
- Capture genuine screenshots from the target environment only if desired, with private data redacted.
- Confirm the `v4.4.2` source baseline is the intended baseline before creating a tagged release.

This is a validated publishing candidate, not a final tagged release. Rollback is not a full-system snapshot and cannot reverse arbitrary external changes. Keep independent backups.
