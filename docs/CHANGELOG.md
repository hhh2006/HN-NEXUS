## v1.0.0 — Cinematic publishing release (HN // CIT)
- Unified **HN // CIT** and **CYBER CITADEL AGENCY** identity across README, documentation, branding assets, metadata, and the project website (**ENGINEERED BY HN**).
- Rebuilt the GitHub Pages experience as a cinematic, animated Cyberpunk presentation: gradient/light motion, particle/starfield effects, glow and glassmorphism, interactive hover/reveal behavior, responsive layouts, and reduced-motion support.
- Added SVG branding system and illustrative mockup previews (terminal/architecture) with explicit guidance to avoid fabricated real Kali screenshots.
- Comprehensive documentation overhaul: rewritten README, step-by-step installation & recovery, full command reference with examples, beginner-to-advanced tutorial, expanded Architecture, FAQ, and Troubleshooting, plus publishing/validation documentation.
- Expanded website structure, metadata, and local link/asset validation coverage; recorded feasible checks and environment limitations in `docs/TEST-REPORT-v1.0.0.md`.
- Preserved existing command/runtime behavior and shell functionality; changes focused on presentation, documentation, branding, and packaging. **Publishing pack:** `v1.0.0` · **Terminal source baseline:** `4.4.2`.

## v0.3.4 — Cinematic GitHub publishing experience
- Rebuilt the GitHub Pages landing page with a responsive HN // CIT identity, animated starfield, terminal preview, capability cards, architecture view, documentation hub, installation steps and author profile.
- Added accessible mobile navigation, reduced-motion support, responsive layouts, social preview artwork and a dedicated documentation layout.
- Expanded publishing guidance, author attribution and explicit separation between publishing-pack version `v0.3.4` and terminal source baseline `4.4.2`.
- Added a website link/asset checker to the CI workflow.

## v0.3.3 — Context-aware operator assistance
- Added `hnsuggest` to propose commands from local workspace markers (Git, Python, Node, Docker, tests and logs); suggestions are advisory and never run.
- Added `hnhistory-search`; uses FZF when available and inserts a selected command into the ZLE edit buffer for review, never executing it. A grep/tail fallback remains available without FZF.
- Added `hnexplain` for read-only heuristics over common error text, from arguments or stdin, and `hnwhy` for last-command exit-status guidance.
- Added task-specific ZSH completion for visual profiles and file-oriented helpers.
- Expanded `hnhelp`, `hnsearch`, `hnmenu`, README and regression coverage. No daemon, network call, package installation or history mutation was introduced.

## v0.3.2 — HN NEXUS diagnostics and feature visibility
- Added `hndoctor`, a read-only diagnostic for core files, command correction, ZSH completion, autosuggestions, syntax highlighting, optional CLI tools, Nerd Font and truecolor support.
- Added `hndoctor` to the quick reference and interactive launcher.
- Optional components are clearly identified as optional; diagnostics never install packages or change shell/desktop settings.

## v0.3.1 — interactive command correction

- Enable ZSH command-name correction with an explicit confirmation prompt.
- Keep argument auto-correction disabled to avoid changing command arguments unexpectedly.
- Add static regression coverage and user documentation.

## v4.4.2 — Responsive metadata overflow hardening
- Optional Git, runtime and SSH segments now collapse in the same order in the width model and rendered output.
- Prevents metadata from reappearing after the path has been shortened for a narrow terminal.
- Preserves the rounded three-row HUD, READY/input line, palette rotation and all 15 selectable profiles.

## v4.3.4 — Terminal autowrap root-cause correction
- Reserved the last terminal column on every prompt row to avoid delayed-autowrap moving the requested `╮` / `╯` frame corners onto a separate line.
- Unified the top rail and telemetry row around a shared safe printable width (`COLUMNS - 1`), keeping both caps aligned and off the wrap boundary.
- Reworked ultra-narrow fallbacks for clock, identity and input status so no artificial minimum width can overflow the actual terminal.
- Escaped literal percent characters in user/host/path content before prompt expansion.
- Added runtime resize/visible-width smoke tests that run with ZSH on the target machine.
- No command execution, history storage, tool wrappers, or theme assets were removed.

# Changelog

## 4.3.3 — Responsive HUD geometry correction
- Anchored the telemetry block at the right edge and placed `╯` as its final cell directly below the top-right `╮`.
- Rebuilt width budgeting to match the actual rendered identity/path string; optional context is removed before path abbreviation.
- Added a compact fallback for narrow terminals to prevent the path from colliding with clock/duration data.
- Preserved the dedicated command-entry row and existing ZSH hooks/history behavior.

# Changelog

## 4.3.1 — Rounded telemetry cap and resize-aware HUD
- Replaced the incorrect diagonal slash with the requested paired right-end corners: the top identity rail terminates in `╮`, and the telemetry row terminates in `╯`.
- Removed the stray diagonal before the clock; time and duration now sit inside the visual end-cap area.
- Added a `WINCH` handler that rebuilds the prompt using the current terminal width and asks ZLE to reset the prompt after window resizing.
- Kept the three-row prompt, dynamic palettes, command status, and existing shell history behavior.
- Static regression checks updated for the new geometry. Live ZSH/Kali rendering still requires validation on the target VM.

## v4.2.8 — HUD geometry and narrow-width refinement
- Reworked the information row to reserve the clock/telemetry block before laying out identity and path.
- Added progressive compact mode for narrow terminals: hides optional context and duration before shortening the path.
- Keeps the user identity visible and collapses the path to a minimal marker at very small widths rather than allowing row collision.
- Preserved the three-row graphic composition, command hooks, palette cycling and native command behavior.
- Static, color-output and theme checks pass. ZSH runtime and Kali visual checks remain pending because ZSH/Kali are unavailable in the build environment.

## v4.2.4 — Auto-hide terminal scrollbar
- Enabled the XFCE Terminal scrollbar but styled it to stay visually hidden until the pointer hovers over its edge.
- Preserved mouse-wheel and scrollbar-drag navigation; expanded scrollback to 10,000 lines.
- Added the scrollbar and scrollback properties to the theme backup/restore snapshot.

## v4.2.2 — Actual three-row prompt fix

- Root cause: ZSH strips trailing newlines from command substitutions (`$(...)`), so newlines printed inside HUD functions vanished when PROMPT was assembled.
- PROMPT now places two literal `$'\n'` separators between the three row renderers, outside command substitutions.
- Removed row-renderer trailing newline prints to avoid extra blank lines.
- Added a regression check that rejects the old single-row PROMPT expression.

## v4.2.1 — Responsive three-row HUD correction
- Corrected literal `\e[0m` reset artifacts by emitting actual ESC bytes inside ZSH prompt non-printing markers.
- Added width-aware information-row collapse and path truncation to prevent unintended wrapping.
- Separated the wordmark color spectrum (emerald/lime/coral/rose) from the cool multi-color rail.

# Changelog

## v4.2.0 — Jewel Spectrum / Graphic Context
- Replaced the single-color accent rail with a responsive multi-stop truecolor gradient.
- Improved Nerd Font family detection for JetBrainsMono, JetBrainsMonoNL, FiraCode, Hack and Meslo variants.
- Added a richer icon vocabulary using Nerd Font Linux, Font Awesome, DevIcons and Material-style glyphs.
- Context icons now adapt to project, Python, Docker, network, SSH, Git, scripts and log workspaces.
- Refined the three-row prompt: compact brand rail, context-rich session row, separate status/input row.
- Kept command execution native and avoided blur, animation loops, polling and background services.

## v4.1.0 — Adaptive Graphic Prompt
- Rebuilt the three-row prompt composition around HN//CIT.
- Added context-sensitive workspace iconography and concise context labels.
- Made Git/runtime/SSH details responsive to available terminal width.
- Kept the third row dedicated to command entry with compact last-command status and duration.
- Removed redundant written product labels from the visible prompt.
- No background services, polling, blur, or automatic package installation.

## v3.7.4 — Bracketed Operator HUD & Live Command Context
- Rebuilt the title row to match the requested bracketed Kali/HN//CIT identity, with the Kali dragon glyph (not a text-only logo) when Nerd Font is available.
- Added a live command badge that changes after each executed command and reports its duration/status.
- Separated the text gradient palette from the long-rail gradient palette for clearer visual hierarchy.
- Reworked compact-width layouts and path clipping so the HUD progressively simplifies instead of pushing content outside the terminal.
- Preserved native command names, command behavior, history, and the existing modular terminal utilities.
- No daemon, polling loop, package installation, blur, or desktop-wide theme changes.

## v3.7.0 — functional audit and responsive HUD repair
- Corrected the inner horizontal rail width so both side borders fit the declared terminal width.
- Rebuilt the information row width budget from the actual visible segments; narrow windows progressively collapse metadata before truncating the path.
- Removed the duplicate terminal-title precmd hook.
- Initialized ZSH completion when it has not already been initialized, so the configured completion styles and menu are active.
- Updated README wording to accurately describe interactive command wrappers and native pipe/redirection behavior.
- Added a full audit report and an aggregate test runner. ZSH runtime and VMware visual checks remain explicitly pending when unavailable.

# Changelog

## v4.2.0 — Jewel Spectrum / Graphic Context
- Replaced the single-color accent rail with a responsive multi-stop truecolor gradient.
- Improved Nerd Font family detection for JetBrainsMono, JetBrainsMonoNL, FiraCode, Hack and Meslo variants.
- Added a richer icon vocabulary using Nerd Font Linux, Font Awesome, DevIcons and Material-style glyphs.
- Context icons now adapt to project, Python, Docker, network, SSH, Git, scripts and log workspaces.
- Refined the three-row prompt: compact brand rail, context-rich session row, separate status/input row.
- Kept command execution native and avoided blur, animation loops, polling and background services.

## v3.6.3 — HN//CIT COMMAND CENTER identity
- Replaced the visible “PRISM X” product label in the terminal HUD with “COMMAND CENTER”.
- Updated the terminal window title and operator menu headings to use clear operational language.
- Kept internal filenames, install paths, legacy helper names, and existing command behavior unchanged for upgrade compatibility.

v3.6.2 — Responsive HUD geometry

- Rebuilt the HUD rails around the live terminal column count; removed the old 58/120-column clamps that caused gaps and overflow when resizing.
- Moved the live clock and last-command duration into the information row inside the frame; disabled the outside right prompt.
- Kept the original HN//CIT PRISM X identity, gradient palette, and native Linux command names.
- No compositor, blur, daemon, polling loop, or automatic package installation added.

## 3.6.2 — Full-Spectrum HUD Rails

- Corrected the prompt frame so the gradient engine is actually used by the long top, inner, and bottom HUD rules.
- Extended the Emerald/Cyan/Blue/Violet/Magenta/Amber truecolor gradient across each complete horizontal rail instead of leaving long separators in a single flat color.
- Kept the operator information row and READY/EXIT status colors semantic for readability.
- No background animation, polling, daemon, blur, package installation, or command behavior changes.

## 3.6.0 — Network Route & Neighbor Intelligence

- Extended the original `ip` command's interactive presentation layer with compact, color-coded matrices for `ip route` / `ip -4 route` / `ip -6 route` and `ip neigh` / `ip -4 neigh` / `ip -6 neigh`.
- Route view highlights default routes, gateways, interfaces, source addresses, protocol and metric fields.
- Neighbor view highlights local neighbor/ARP entries, link-layer addresses and reachability states.
- Only exact read-only display forms are formatted. All other `ip` arguments—including address changes, link changes, route mutations, and complex filters—pass directly to native `ip` unchanged. Pipes and redirections continue to use native output.
- No network scan, packet capture, configuration change, package installation, daemon, polling, blur, or history modification.

## 3.5.0 — Command Discovery & History Navigation

- Added `hnsearch [TEXT]`, a searchable local catalogue of common native Linux commands and PRISM utilities. It displays descriptions only and never executes a selected result.
- Added `hnhistory [1..200]`, a numbered, colored, read-only view of recent commands from the active ZSH history list. It does not edit, clear, or rewrite `.zsh_history`.
- Extended `hnmenu` with command discovery and recent-history entries.
- Refined ZSH completion menu styling, case-insensitive matching, group labels, and selection prompts. Existing completion initialization and keybindings remain user-controlled.
- No background services, polling, package installation, blur, network scan, or automatic command execution.

## 3.1.0 — Native Output Intelligence

- Added an interactive ZSH presentation layer for the familiar native `cat FILE` command: syntax-aware colors, line numbers and a framed header through `bat`/`batcat` when installed. If no viewer is available, or output is piped/redirected, native `cat` is used unchanged.
- Added a compact, numbered, color-coded interface matrix for the familiar `ip a`, `ip addr`, `ip address`, `ip -4 a` and `ip -6 a` forms. All other `ip` arguments pass directly to the system command.
- Added conservative terminal color/pager defaults while respecting user-defined settings.
- Expanded help and operator documentation.
- No package installation, background process, polling, Picom/blur activation, or network configuration changes.

## 3.0.5 — Structured CAT & Network Address Matrix

- Added `hncat FILE`: framed file viewer with line numbers and syntax highlighting through bat/batcat when available; safe numbered fallback otherwise. Binary files show metadata instead of dumping unreadable bytes.
- Added `hnipa [-4|-6]`: compact, colored interface/address table based on `ip -br addr`; highlights interface state and loopback.
- Added both viewers to the interactive `hnmenu` launcher (options 7 and 8).
- Native `cat` and `ip` commands remain untouched. No packages, services, background polling, or system network changes.

# Changelog

## v4.2.0 — Jewel Spectrum / Graphic Context
- Replaced the single-color accent rail with a responsive multi-stop truecolor gradient.
- Improved Nerd Font family detection for JetBrainsMono, JetBrainsMonoNL, FiraCode, Hack and Meslo variants.
- Added a richer icon vocabulary using Nerd Font Linux, Font Awesome, DevIcons and Material-style glyphs.
- Context icons now adapt to project, Python, Docker, network, SSH, Git, scripts and log workspaces.
- Refined the three-row prompt: compact brand rail, context-rich session row, separate status/input row.
- Kept command execution native and avoided blur, animation loops, polling and background services.

## 3.0.3 — Visual Identity & Kali Dragon
- Added the Kali Linux Nerd Font dragon glyph (U+F327) beside the existing HN//CIT identity.
- Replaced key prompt indicators with Nerd Font glyphs when JetBrainsMono Nerd Font is detected.
- Added one-time font-family detection at ZSH load and readable fallbacks when absent.
- Added `hnvisual` diagnostic and updated `hnhelp`.
- Preserved the v3.0.0 prompt layout, gradient rail, context detection, Git/runtime segments, and operator tools.
- No background tasks, external image renderer, Picom/blur, package installation, or native command overrides.

## 3.0.0
- Advanced operator intelligence for Nmap, SSH, DNS, HTTP, firewall, and network text output.

## 3.0.4 — Operator HUD & Interactive Controls
- Rebuilt the prompt as a framed, five-row HUD with a Kali Nerd Font dragon glyph, identity, path, FIELD CONSOLE context and explicit READY/EXIT state.
- Added responsive width bounds and ZSH prompt-safe formatting; long paths use native ZSH prompt truncation.
- Improved `hnvisual` diagnostics and added the interactive `hnmenu` launcher.
- No background services, polling, blur, package installation, or native command replacements.


## 3.2.0 — Native System Output Intelligence

- Added an interactive-only semantic color layer for the original `ps`, `df`, `free`, and `ss` commands. Their original arguments and command implementations are preserved.
- Color emphasis highlights process headers/root entries/states, filesystem usage thresholds, memory/swap rows, and socket states.
- Pipes and redirections bypass the presentation layer and call the native command directly.
- Added PRISM colors to Zsh completion listings when completion is active.
- Updated operator help; no `hn` prefix is required for native commands.
- No aliases for core commands, no package installation, no background process, polling, blur, or system configuration changes.


## 3.3.0 — Structured System Output

- Extended the native interactive output layer to `du`, retaining the original command name and arguments.
- Added compact row numbering, a consistent header separator and a row-count footer to interactive `ps`, `df`, `free`, `ss`, and `du` views.
- Kept severity coloring for process states, filesystem capacity, memory/swap rows, socket states, and large human-readable disk-usage entries.
- Added conservative `MANPAGER=less -R` and `SYSTEMD_COLORS=1` defaults only when the user has not configured them.
- Pipes and redirections bypass formatting and use native commands; no aliases, daemons, polling, package installation, blur, or network changes.


## 3.4.0 — File, Log & Reporting Intelligence

- Added `hnreport [FILE]`: local read-only system snapshot (OS, kernel, uptime, memory, filesystems, interface addresses, routes, socket summary). The report is saved locally and warns that host/network details may be sensitive.
- Added `hnyaml FILE` using optional `yq`; no dependency is installed automatically.
- Improved `hnlog FILE` with line numbering, severity markers, and a compact severity summary.
- Added interactive-only `ls` color/group-directory presentation and `tree` color presentation when the native `tree` binary exists. Non-terminal output is passed directly to the native commands.
- No daemon, polling, network scan, blur, package installation, or history modification.


## v3.7.1 — Balanced HUD & visual refinement

- Rebuilt the terminal prompt as a clean three-row frame: one title rail, one information row, and one status rail.
- Removed the duplicated inner horizontal rule that made the upper frame look like two stacked long lines.
- Removed raw ANSI/`%{...%}` rail assembly that could leak fragments such as `0m` into the terminal. All HUD color output now uses ZSH prompt color expansion.
- Replaced the continuous rainbow gradient with coordinated solid-color accents: cyan, blue, violet, magenta, amber, emerald, and ice.
- Made the Kali identity more prominent with a bold dragon glyph plus a readable KALI LINUX label when Nerd Font is available; a clean text badge remains as fallback.
- Kept the HUD adaptive to terminal width, with progressive metadata reduction and path truncation.
- Kept native Linux command names and existing interactive utilities unchanged.
- No background polling, blur, or automatic package installation added.


## v3.7.2 — HUD identity restoration
- Restored the parallel upper double-rail: the segmented multicolour title line plus a continuous truecolor gradient line beneath it.
- Kept the clock and last-command duration inside the information frame.
- Preserved the lower status rail as a restrained multi-accent line for visual balance.
- Re-emphasized the Kali dragon glyph in the title when Nerd Font is available.
- Upper rail width is recalculated from the live terminal width at each prompt; no background timer or compositor was added.

## v3.7.3 — Cinematic Gradient Command HUD
- Reworked the prompt to follow the supplied bracketed COMMAND CENTER layout.
- Restored the dual upper rail: gradient title and continuous parallel gradient rule.
- Added truecolor gradient typography for identity, user, path, context, duration, and status labels.
- Added responsive title compaction for narrow terminal widths.
- Preserved the Kali Nerd Font glyph with a readable fallback.
- No background service, polling loop, automatic package installation, or Picom activation added.

## v3.7.5 — HUD geometry correction
- Corrected the bracketed top-line width accounting so the long rail fills the actual remaining terminal columns.
- Removed the duplicate compact title emission at narrow widths.
- Reworked the information row to drop lower-priority fields before clipping the path, preserving balanced left/right frame edges.
- Kept the original three-row bracket layout, Kali Nerd Font dragon glyph, separate text/rail gradients, and native command behavior.
- Runtime rendering and resize behavior still require confirmation in the target Kali terminal.


## v3.8.0 — Host & Runtime Intelligence
- Added one-shot system health, systemd service inventory and Docker/Podman container inventory.
- Wired all three commands into `hnmenu` and `hnsearch`; all are explicitly invoked and read-only.
- Fixed release metadata so `VERSION`, package directory and documentation agree on 3.8.0.
- Added regression checks for command definitions, menu wiring, catalogue wiring, read-only behavior and release metadata.


## v3.9.0 — PRISM X Operator HUD Redesign
- Replaced the rectangular prompt with a compact identity/session/workspace/status HUD.
- Added visible host/session mode, user/root state, Git/runtime indicators, clock, previous command, exit status and duration.
- Simplified the input line and responsive path handling to improve readability.
- Changed XFCE terminal styling to an opaque deep-navy background and a softer, semantic 16-color palette.
- Kept the prompt event-driven through existing ZSH preexec/precmd hooks; no timers or background workers.


## v4.0.0 — Compact Cyber-Code Workspace
- Reworked the prompt into two compact context rows plus the command-entry row; the live input cursor shares the status/last-command line, eliminating the separate fourth prompt line.
- Preserved gradient identity typography and multi-hue accents while keeping the terminal work area dominant.
- Reduced GTK terminal padding to reclaim usable screen area and changed the terminal surface to a fully opaque charcoal-navy background.
- Kept native commands unchanged; no daemon, polling, blur, Picom, automatic package installation, or background telemetry was added.


## v4.0.1 — HN//CIT identity refinement and ZSH alias hotfix
- Removed redundant visible “KALI LINUX” and “PRISM X” wording from the prompt; Kali is represented by its graphical Nerd Font icon (or a compact ◈ fallback).
- Rebuilt the HUD as a minimal identity row, an operator/path/connection row, and a dedicated command-entry row.
- Preserved the multicolor gradient treatment without filling the terminal with decorative labels.
- Fixed the ZSH `ip` alias collision by removing the conflicting alias before declaring the interactive wrapper.


## v4.2.3 — Alias-safe startup and command HUD geometry
- Fixed `defining function based on alias` / `parse error near ()` for the `ls()` wrapper and removed only the conflicting `ip` and `ls` aliases before declaring their native-command wrappers.
- Rebuilt the prompt into three deliberate rows: full-width identity rail; user/path/context with right-edge clock and elapsed-command duration; process status and command input arrow.
- Restyled the Kali dragon glyph in emerald and separated it from the warm HN//CIT wordmark; the top rail retains its independent cool jewel spectrum.
- Installer follows an existing legacy `HN-HEXUS` home path only when that is the sole path referenced by `.zshrc`.
- Rollback retains newly introduced files instead of deleting them.
- ZSH runtime and VMware visual verification remain pending on target hardware.

## v4.2.5 — Adaptive Jewel HUD
- Added ten command-cycling cool jewel palettes; failed commands force a crimson alert palette.
- Replaced the plain identity divider with a compact geometric energy glyph and framed HN//CIT wordmark.
- Removed yellow/orange from the long rail palette; the upper rail and diagonal clock connector share the active palette and stroke glyph.
- Rebuilt the three-row prompt during `precmd` and disabled `PROMPT_SUBST` for the HUD, avoiding command-substitution prompt redraw churn during ZLE history navigation.
- Kept native command execution and output untouched; no daemon, polling loop, or background renderer added.


## v4.2.6 — Graphic alignment and command-aware jewel HUD
- Centered the Kali dragon emblem between HN and CIT in the wordmark; removed the slash separator.
- Recomputed top-rail fill from the measured identity prefix so the gradient spans the remaining terminal width.
- Shared the active cool jewel palette across upper rail, left/right diagonal accents and frame corners; no yellow/orange in the identity rail.
- Added a context glyph for the most recently executed command family (Git, Python, Docker/Podman/Kubernetes, SSH, network, development).
- Assembled PROMPT with literal newline bytes rather than escaped newline text, preserving the dedicated three-row structure during ZLE history navigation.
- Preserved all existing tools, command wrappers, scrollback settings, backups and history files.
- ZSH runtime and target-VM visual checks are pending because ZSH is not installed in the build environment.


## v4.2.7 — Responsive HUD refinement
- Removed the decorative rail marker and enhanced the Kali emblem color.
- Simplified command state labels to READY / FAILED; removed “PROCESS”.
- Reduced context clutter and added stronger narrow-terminal fallbacks for the information row.
- Preserved ten rotating jewel palettes without warm yellow/orange as a primary rail hue.


## v4.3.0 — Prompt geometry and hook-order correction
- Locked the intended visual order to three rows: HN//CIT identity rail; user/path/context with right-aligned clock and duration; status and command input.
- Removed duplicate renderer hook registrations before adding the final renderer hook.
- Set PROMPT and RPROMPT together from one renderer to prevent stale right prompts or competing HN renderers from creating mixed layouts.
- Retained adaptive width handling, palette rotation, failure alert palette, command hooks, and history behavior.
- Static/package checks can be run in the build environment; actual ZSH and VMware rendering remain unverified until tested on Kali.

## v4.3.2 — Responsive HUD hardening
- Reworked the information-row width budget so optional context and command duration are dropped before core identity/clock fields collide.
- Added progressive compact layouts for medium and narrow terminal widths; path shortening happens before path omission.
- Kept the paired right-edge `╮` / `╯` caps and three-row prompt geometry.
- Hardened the resize trap so non-interactive shells return immediately and ZLE redraw is attempted only when the line editor is active.
- No command wrappers, history settings, or native command execution paths were changed.

## v4.3.6 — Rounded Premium HUD
- Rebuilt the prompt frame with rounded Unicode corners: `╭ ╮ ╰ ╯`.
- Unified the long gradient rail glyph with the frame stroke (`─`) instead of mixed heavy/double-line characters.
- Uses the configured Kali dragon/Nerd Font glyph (`HN_KALI_ICON`) in the HN // CIT identity; falls back to `◈` when Nerd Fonts are unavailable.
- Information row now ends with the matching `─╯` cap; READY/input row begins with `╰─`.
- Retains one-cell autowrap safety, responsive path/context reduction, `RPROMPT` isolation and `SIGWINCH` redraw handling.
- Updated geometry/static regression checks for the rounded three-row layout.

## v4.4.1 — Runtime integrity and palette completion

- Fixed malformed Nerd Font and fallback icon declarations that contained literal `\n` text instead of actual line breaks.
- Completed all 15 advertised selectable visual profiles in `hnstyle` and connected each profile to its matching rail colors.
- Preserved the existing rounded three-row HUD and the established READY/input row; the rejected alternate READY layout remains excluded.
- Added regression checks for icon declaration formatting and every selectable palette.

## v4.4.0 — Luxury Cyber Experience
- Expanded the automatic jewel-spectrum engine to 15 coordinated palettes.
- Added optional pinned profiles: `hnstyle auto|royal|matrix|blood|arctic|obsidian`.
- Added contextual Nerd Font glyphs for clock, Git branch, lock, warning and activity.
- Added Git, virtual-environment and remote-session indicators to the information rail when width permits.
- Preserved the existing three-row rounded HUD and existing READY/input line; the rejected `◆ READY ┃ ❯ _` concept was not adopted.
- Kept native commands, history, ZLE and the existing prompt geometry architecture.


## GitHub publishing candidate v0.2.3

- Added SHA-256 tracking for files written by the core installer.
- Rollback restores pre-existing configuration, removes only unchanged installer-created files, and preserves post-install user modifications.
- Added explicit rollback counts and an automated installer/rollback regression test.
- Kept backups, release artifacts, logs and recovery scripts for audit; no recursive project-directory deletion.


## GitHub publishing candidate v0.2.4

- Added SHA-256 content checks for XFWM theme files, GTK CSS and the generated GTK note.
- XFConf restoration is conditional on the current property still matching the HN-installed value.
- Restore now preserves post-install user changes and reports per-item restored/removed/preserved outcomes.
- Added mock-XFConf regression coverage for both clean rollback and preservation of later edits.
- Visual apply failures now print the retained backup location; incomplete applies still require careful recovery and are not claimed to auto-rollback.
