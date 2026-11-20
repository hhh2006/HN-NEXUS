---
layout: default
title: "Test Report V0.2.5"
---

# HN NEXUS test report — publishing candidate v0.2.5

## Environment and evidence

Target environment reported by the user: Kali GNU/Linux Rolling 2026.1, ZSH 5.9, XFCE/X11. The results below distinguish user-run tests from build-container checks.

## User-run Kali checks

- `bash tests/run-all.sh`: `FINAL TEST EXIT CODE: 0`.
- Static Bash safety and project feature checks: PASS.
- Color output checks: PASS.
- Theme asset and Bash syntax checks: PASS.
- Prompt geometry: 293 terminal widths; narrow widths 8–18; PASS.
- Installer rollback: prior config restored, unchanged new config removed, user-edited config preserved, `.zshrc` and `.zsh_history` preserved; PASS.
- XFCE rollback simulation: modified theme/GTK/README/XFConf state preserved and unchanged state restored; PASS.
- ZSH parser and runtime prompt-width/resize smoke tests: PASS.
- Core install/recovery in an isolated HOME: exit code 0; user customization and history preserved.
- Real XFCE/X11 visual apply: reported successful; backup and restore script created.
- Real XFCE/X11 restore: reported successful; 15 XFConf properties restored, previous XFWM theme and GTK CSS restored, generated HN GTK note restored; user confirmed previous appearance returned.

## Build-container checks

- ZIP integrity: PASS.
- SHA-256 manifest verification: PASS.
- `bash tests/run-all.sh`: exit code 0.
- ZSH parser/runtime: SKIP in build container because ZSH is not installed there. This does not negate the separate user-run Kali ZSH results above.
- ShellCheck: not run; executable was unavailable in the build container.
- GitHub Actions and deployed Pages site: not yet tested on GitHub.

## Remaining validation

- In-place upgrade test from a prior release.
- ShellCheck review.
- GitHub Actions CI and Pages deployment verification after repository upload.
