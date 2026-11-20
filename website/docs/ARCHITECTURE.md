---
layout: default
title: "Architecture"
description: "Layered architecture and design boundaries of HN NEXUS."
---

# Architecture — HN NEXUS (HN // CIT)

**HN // CIT Command Center · CYBER CITADEL AGENCY · ENGINEERED BY HN**  
**Publishing pack:** `v1.0.0` · **Terminal source baseline:** `4.4.2`

This document describes the structure of HN NEXUS, component responsibilities, data/control flow, and the boundaries that preserve predictable, user-controlled behavior.

## 1. Design goals

- **User control:** explicit invocation, no background agent, no autonomous command execution, no telemetry polling daemon.
- **Native-first compatibility:** familiar command names and shell workflows remain intact; enhancements are presentation and utility layers with safe fallbacks.
- **Readable context:** a responsive HUD and on-demand views expose useful state without taking over the terminal.
- **Recoverability:** installation and optional visual changes are backup/rollback-aware.
- **Transparency:** assistance and analysis features are local heuristics over user-supplied or local contextual data.

## 2. Layered architecture

```text
┌─────────────────────────────────────────────────────────────┐
│ 04. Recovery & Verification                                 │
│     setup/install/uninstall/diagnostics, backups, tests     │
├─────────────────────────────────────────────────────────────┤
│ 03. Prism & Operator Utilities (on-demand)                  │
│     hn* commands, viewers, analyzers, native wrappers       │
├─────────────────────────────────────────────────────────────┤
│ 02. HUD & Context Engine                                    │
│     prompt geometry, palettes, context/git/runtime/status    │
├─────────────────────────────────────────────────────────────┤
│ 01. Interactive Shell Core                                  │
│     ZSH entry, hooks, completion, correction, rendering      │
└─────────────────────────────────────────────────────────────┘
  Optional (separate): XFCE/X11 desktop theme & terminal palette
```

## 3. Core runtime components

### 3.1 Entry point — `config/hn-sovereign.zsh`
- Activates only for **interactive** ZSH sessions.
- Configures command-name correction (`setopt CORRECT`, `unsetopt CORRECT_ALL`) so suggestions require confirmation and arguments are not auto-corrected.
- Initializes completion (`compinit`) if not already initialized, respecting existing setups.
- Loads optional plugins conservatively when present (e.g. autosuggestions, syntax highlighting) around core sourcing.
- Sources core modules:
  - `config/hn-terminal.zsh` (HUD/prompt engine)
  - `config/hn-tools.zsh` (utilities and wrappers)

### 3.2 HUD & prompt engine — `config/hn-terminal.zsh`
- **Event-driven ZSH integration:** uses hooks (`precmd`, `preexec`, `TRAPWINCH`) and `vcs_info`; no background polling daemon.
- **Three-row responsive HUD:**
  - **Top rail:** HN // CIT identity and gradient frame.
  - **Info row:** user/path/context with optional Git/runtime/remote/clock/duration segments, progressively collapsed by width budget.
  - **Status/input row:** READY/FAILED (and related state) with the command entry line.
- **Rendering model:** prompt rebuilt in precmd via a renderer; rows separated by literal newlines outside command substitutions; `PROMPT_SUBST` disabled for stable ZLE/history redraw behavior; `RPROMPT` managed to avoid stale/conflicting layout.
- **State tracking:** last command, exit status, duration, and palette cycling/index; failure can trigger alert styling as implemented.
- **Context detection:** lightweight filesystem/path and project-marker heuristics (e.g. Git, Python, Docker, Node, logs/scripts locations) to select labels/icons and inform suggestions; Git details via `vcs_info` in repositories.
- **Visual system:** Nerd Font family probing at startup with fallbacks, truecolor gradient rails, and 15 selectable/pinnable profiles (`hnstyle`) plus automatic rotation.

### 3.3 Utilities & presentation — `config/hn-tools.zsh`
- **Explicit `hn*` commands:** help/discovery, diagnostics, context assistance, file/log/data viewers, operations snapshots, local reporting, and text intelligence.
- **Native command presentation wrappers:** for selected familiar commands (e.g. `cat`, specific read-only `ip` views, `ps`, `df`, `free`, `ss`, `du`, `ls`, `tree`) to enhance interactive TTY output while forwarding arguments and preserving native behavior for pipes/redirections and unsupported cases. Bypass with `command <name>`.
- **Safety boundaries:** analyzers (`hnoutput`, `hnnet`, `hnanalyze`, `hnexplain`) classify user-supplied text or local context; they do not execute reviewed commands, scan networks, capture packets, or mutate system state. Inventory helpers (services/containers/ports) are read-only views.
- **Optional dependencies:** uses available tools (`fzf`, `bat`/`batcat`, `jq`, `yq`, `rg`, `eza`, `tree`, `colordiff`, `docker`, `podman`, etc.) when present without auto-installing.

## 4. Installation, theming, and recovery

| Component | Responsibility |
|---|---|
| `setup.sh` | Guided entry: `--check`, `--dry-run`, `--core`, `--visual`, full mode; detects XFCE/X11; no sudo |
| `install.sh` | Core install: backups, staged/config copy under install root, managed `.zshrc` block, verify/rollback artifacts |
| `uninstall.sh` | Recovery entry: orchestrates available rollback/restore paths |
| `apply-prism-theme.sh` (+ compat wrappers) | Optional XFCE/X11 visual theming (XFWM, GTK CSS, terminal palette/font), snapshots/restore script |
| `enable-prism-blur.sh` | Optional X11 Picom blur, separately guarded |
| `diagnostics.sh`, `recovery/verify.sh` | Read-only checks and verification |
| `tests/` | Static, theme/color/geometry, rollback, intelligence, and website checks; runtime tests when ZSH available |

**Recovery model:** timestamped backups, manifests/restore scripts, and conservative rollback of managed changes. Not a full system snapshot; user-modified files may be preserved and artifacts retained for audit.

## 5. Website and documentation packaging

- `website/`: static GitHub Pages site (Jekyll-compatible, deployed via Actions) with cinematic presentation and linked docs.
- `docs/`: canonical documentation (installation, commands, tutorial, architecture, FAQ, troubleshooting, changelog, reports).
- `.github/workflows/`: CI and Pages deployment workflows.
- `assets/`: branding SVGs, mockups, and placeholders for real screenshots/captures.

## 6. Data, privacy, and operational boundaries

- No network scanning/capture by project tools; network-related helpers operate on provided text or local read-only state.
- No intentional modification of `.zsh_history`.
- Reports/logs/history/captures may contain sensitive information and must be reviewed/redacted before sharing.
- Optional tools are detected, not installed automatically.

## 7. Extensibility

- Installed configs reside under `~/HN-NEXUS/CORE/CONFIG/` (or detected legacy root) and can be customized by the user.
- Runtime visual profile selection via `hnstyle`.
- Project behavior and documentation should remain aligned with runtime implementations.

---
*HN // CIT · CYBER CITADEL AGENCY · ENGINEERED BY HN*