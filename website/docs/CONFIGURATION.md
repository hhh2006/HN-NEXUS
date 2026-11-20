---
layout: default
title: "Configuration"
description: "Configuration files and customization guidance for HN NEXUS."
---

# Configuration

Main files are installed under `~/HN-NEXUS/CORE/CONFIG/`.

- Edit colors in `hn-terminal.zsh` (`HN_C_*` variables).
- Context rules live in `_hn_context`.
- Optional Eza aliases live in `hn-tools.zsh`.
- Remove or comment the optional `source` lines in `hn-sovereign.zsh` if you do not want an installed plugin loaded.

Do not remove the managed block markers from `~/.zshrc` unless you also remove its source line manually.

## Interactive operator controls (v3.0.4)
- Run `hnmenu` for a small keyboard-driven launcher to existing PRISM utilities.
- Run `hnvisual` to check Nerd Font detection, terminal color capability and terminal width.
- Choose `JetBrainsMono Nerd Font Mono` in the terminal profile for the intended Nerd Font glyphs. If absent, the prompt uses text fallbacks.
- The prompt is keyboard-first; icon glyphs are visual indicators, not clickable UI controls.


## Native command presentation

PRISM X 3.1.0 keeps familiar names: `cat file` and `ip a`. The interactive ZSH presentation layer formats direct terminal views only; pipes, redirections, options and unrelated `ip` subcommands fall back to native commands. Use `command cat` or `command ip` to bypass the presentation layer.


PRISM X 3.2.0 adds interactive-only color emphasis to `ps`, `df`, `free`, and `ss`. Arguments are passed to the native binaries unchanged; pipes and redirections bypass formatting.


## Native system output (v3.3.0)

In interactive ZSH terminals, `ps`, `df`, `free`, `ss`, and `du` receive a numbered, color-emphasized view with a consistent separator and row count. The original command arguments are forwarded unchanged. When output is piped or redirected, the wrappers call the native command directly, preserving machine-readable output. `MANPAGER` and `SYSTEMD_COLORS` are set only if the user has not already configured them.


## File, log and report tools (v3.4.0)

- `ls` adds GNU ls color and group-directory ordering only when stdout and stdin are terminals; pipes and redirects call native `ls` unchanged.
- `tree` adds color only in interactive terminals and only when the native `tree` program is installed.
- `hnlog FILE` numbers lines, marks severity, and prints a summary.
- `hnyaml FILE` requires an already-installed `yq`; it never installs dependencies.
- `hnreport [FILE]` creates a local system snapshot under `~/HN-NEXUS/REPORTS/` by default. It reads system information only; review the file before sharing because it can contain host/network details.


### Command discovery and completion (3.5.0)

`hnsearch` searches a local, static command catalogue; it does not execute results. `hnhistory` reads the active ZSH history list and is capped at 200 entries. Completion menu colors and case-insensitive matching are configured through `zstyle`; the user's existing `compinit` setup and key bindings are left untouched.

## v4.4 visual profiles
Use `hnstyle` to display the active profile. Choose `hnstyle royal`, `hnstyle matrix`,
`hnstyle blood`, `hnstyle arctic`, or `hnstyle obsidian` to pin a coordinated rail palette.
Run `hnstyle auto` to restore the automatic palette rotation. These settings are session-local.
