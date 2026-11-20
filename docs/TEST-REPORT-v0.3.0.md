# Test report — publishing candidate v0.3.0

## Scope

This candidate changes the default setup flow to a guided one-command installation. The terminal engine baseline remains v4.4.2.

## Local checks performed for v0.3.0

- `bash -n setup.sh install-all.sh`: PASS.
- `bash tests/run-all.sh`: all runnable local checks PASS.
- Static checks, color-output checks, prompt geometry, installer rollback and PRISM theme rollback: PASS.
- XFWM theme assets and GTK CSS presence: PASS.
- ZSH parser/runtime checks: SKIPPED in this build environment because ZSH is not installed here.
- ShellCheck: NOT RUN in this build environment; rerun on Kali before release.
- Real XFCE visual apply/restore: NOT RUN for this exact candidate; rerun on Kali before release.

## Previously established evidence (v0.2.9 lineage)

The user reported successful Kali test suite execution for v0.2.7, successful ShellCheck (`EXIT CODE: 0`), successful isolated upgrade/rollback, and a successful real XFCE theme apply/restore on an earlier candidate. These results are historical evidence and are not represented as tests of v0.3.0.

## Important behavior

The default guided setup changes desktop styling only when XFCE/X11 requirements are detected and the user confirms in an interactive terminal. It creates backups through the existing theme installer. If the session is unsupported or non-interactive, it installs core only and reports that desktop styling was skipped. Advanced users can still choose `--core` or `--visual`.
