# HN NEXUS COMMAND CENTER — Code Audit v3.7.0

## Scope inspected
All delivered Bash scripts, ZSH configuration files, test scripts, documentation files, GTK CSS, XFWM theme metadata, and XPM assets in the v3.6.3 archive were enumerated and inspected. The existing automated test scripts were executed before changes.

## Confirmed findings and repairs

| Finding | Impact | Repair |
|---|---|---|
| Inner HUD rails used `width - 6` although the printed border/corner sequence consumed one more column. | Horizontal border could exceed the requested terminal width by one cell. | Changed inner rail budget to `width - 7`. |
| HUD info-row path budget used a guessed fixed subtraction and a placeholder clock string. | Long rows could overflow when resized or with longer usernames/paths. | Rebuilt budget from exact plain-text left/right segments and added full/compact/short/minimal layouts. |
| Terminal title hook was defined and registered twice. | Redundant prompt work and duplicate OSC title updates. | Kept one definition/registration. |
| Completion styles were configured, but the package did not initialize `compinit`. | Completion styles/menu and completion-dependent integrations might remain inactive on systems without global completion initialization. | Initialize completion only when `_comps` is not already present. |
| README claimed there was no global command interception, while interactive ZSH functions wrap selected native command names. | Documentation contradicted actual behavior. | Clarified interactive TTY-only wrapper behavior and native pipe/redirection fallback. |

## Additional code review notes
- `cat`, `ip`, `ps`, `df`, `free`, `ss`, `du`, `ls`, and `tree` retain native command fallback paths.
- Network matrix helpers read local `ip` output only; they do not scan or alter network configuration.
- `hnoutput`, `hnnet`, and `hnanalyze` classify supplied text and do not launch scanners or network connections.
- `hnhistory` reads the active ZSH history list; no code in the installer or helper rewrites `.zsh_history`.
- Picom blur remains opt-in and is not invoked by the standard installer.
- Optional external tools are detected before use; no package installation was added.

## Verification results
- `tests/static-check.sh`: PASS after repairs.
- `tests/color-output-check.sh`: PASS after repairs.
- `tests/theme-check.sh`: Bash syntax and theme asset checks PASS.
- ZIP integrity: PASS.
- ZSH parser/runtime: SKIP — `zsh` is not installed in the build environment.
- Live interactive terminal resize, Nerd Font glyph width, XFCE rendering, and VMware performance: NOT RUN — requires the target Kali VM.

## Known limitations / manual target checks
1. ZSH parser/runtime must be run on Kali with `zsh -n` and a fresh interactive session.
2. Test terminal widths around 40, 55, 71, 95, and 120 columns, including long paths and a long username/hostname.
3. Verify prompt wrapping and glyph cell widths with the actual terminal font; Nerd Font glyph metrics can differ between terminal emulators.
4. Verify optional plugins (autosuggestions, syntax-highlighting, fzf, zoxide) only when installed.
5. Verify XFCE theme application and restore script on the target session before using the optional theme installer.

No claim is made that the unavailable ZSH/Kali/VMware tests passed.


## Follow-up visual correction — v3.7.1

The user-provided VMware screenshot showed a visually doubled upper rail and stray ANSI reset fragments (`0m` / `e[0m`). The prompt renderer was rebuilt to avoid raw ANSI wrapper construction and to use three intentional rows only. This follow-up was validated by shell/static tests; ZSH runtime and VMware rendering remain unverified in this build environment.
