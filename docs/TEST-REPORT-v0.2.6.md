# HN NEXUS test report — publishing candidate v0.2.6

## Changes under validation

- Hardened negative grep assertions to treat grep execution errors as failures.
- Corrected the shell-history safety regression check to look for destructive operations.
- Added targeted ShellCheck annotations for intentionally literal source-code patterns.
- Removed an unused setup counter, clarified Picom restore branching, and named the XFCE apply error handler.

## Build-container checks

- `bash tests/run-all.sh`: PASS (exit code 0).
- Static feature and safety checks: PASS.
- Color-output checks: PASS.
- Theme Bash syntax and asset checks: PASS.
- Prompt geometry checks: PASS (293 terminal widths).
- Installer rollback simulation: PASS.
- Prism theme rollback simulation: PASS.
- ZSH parser/runtime checks: SKIP because ZSH is not installed in this build container.
- ShellCheck: NOT RUN; installation timed out in this build container. No clean ShellCheck result is claimed.

## Prior user-reported Kali evidence

Candidate v0.2.5 was previously reported by the user to pass `bash tests/run-all.sh` on Kali 2026.1 / ZSH 5.9, including ZSH parser/runtime checks. The user also reported successful isolated core recovery and a real XFCE theme apply/restore cycle. These are prior v0.2.5 results and do not constitute user-run validation of v0.2.6.

## Remaining before public release

- Run ShellCheck on this v0.2.6 archive on Kali and resolve any remaining findings.
- Run `bash tests/run-all.sh` on Kali.
- Test upgrade from a prior release in an isolated HOME.
- Verify GitHub Actions and GitHub Pages after publishing to a test repository.

This is a candidate archive, not a final production release.
