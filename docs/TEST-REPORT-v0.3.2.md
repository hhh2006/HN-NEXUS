# Test report — publishing candidate v0.3.2

## Scope

This candidate adds read-only feature diagnostics while retaining interactive ZSH command-name correction and the v0.3.0 guided installer.

## Changes

- Adds `hndoctor` to report required core files, command correction state, completion, plugin load state, optional tools, Nerd Font and truecolor capability.
- Adds the diagnostic to `hnhelp` and `hnmenu`. It performs no installation or settings changes.

- Enables ZSH `CORRECT`, which asks the user before correcting a misspelled command name.
- Explicitly disables `CORRECT_ALL`; command arguments are not automatically corrected.
- Adds a static regression check for both option settings.

## Validation status

- `bash tests/run-all.sh`: exit code 0 in the build environment. Static, color, prompt-geometry and rollback tests passed.
- ZSH parser/runtime checks: skipped because ZSH is not installed in the build environment; run on Kali.
- ShellCheck: not available in the build environment; run on Kali.
- Live XFCE install/restore: v0.3.0 was reported successful by the user; this candidate needs a fresh end-to-end regression run before release.
- ZSH parser and interactive correction prompt: pending execution on Kali with ZSH.
- ShellCheck: pending execution on Kali.
- Live XFCE install/restore: v0.3.0 was reported successful by the user; this v0.3.1 change does not modify the desktop installer, but the new candidate still requires regression testing before release.
- GitHub Actions and Pages: pending after upload.

Do not treat this candidate as final until the pending checks pass.
