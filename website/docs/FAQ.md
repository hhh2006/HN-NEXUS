---
layout: default
title: "FAQ"
description: "Frequently asked questions about HN NEXUS."
---

# FAQ — HN NEXUS (HN // CIT)

## What is HN NEXUS?
HN NEXUS (**HN // CIT Command Center**, CYBER CITADEL AGENCY) is a context-aware ZSH environment for Kali Linux and compatible systems. It provides a responsive three-row terminal HUD, Prism visual profiles, and explicitly invoked local utilities for inspecting files, processes, services, containers, logs, and supplied output.

**Author:** Hani Khaled Nasser Al-Nasiri — Cybersecurity Student, Al-Razi University · [@hhh2006](https://github.com/hhh2006)  
**Signature:** ENGINEERED BY HN

## Does it replace or break native Linux commands?
Core workflows remain native and user-controlled. In interactive terminals, selected familiar commands (`cat`, specific read-only `ip` views, `ps`, `df`, `free`, `ss`, `du`, `ls`, `tree`) may receive presentation-only formatting. Pipes, redirections, and many argument forms fall back to native behavior to preserve scripting and machine-readable output. You can bypass wrappers with `command <name>`. See [Command Reference](COMMAND-REFERENCE.md) and [Operator Utilities](OPERATOR-UTILITIES.md).

## Is this a scanner, IDS, AI agent, or background service?
No. HN NEXUS does not perform network discovery, packet capture, or autonomous actions. Features like `hnoutput`, `hnnet`, `hnanalyze`, `hnexplain`, and `hnsuggest` are local, heuristic, read-only aids over context or text you provide. There is no daemon or telemetry polling service, and suggested commands are never auto-executed.

## What are the version numbers?
- **Publishing pack:** `v1.0.0` (GitHub release/package)
- **Terminal source baseline:** `4.4.2` (runtime/prompt baseline in project metadata)

These identifiers are intentionally distinct.

## What platforms and requirements are supported?
- Kali Linux or a compatible Linux distribution with ZSH and Python 3.
- ANSI-capable terminal; truecolor and a Nerd Font improve appearance but are optional.
- Optional XFCE visual styling requires a running XFCE/X11 session with `xfconf-query` and `xfce4-terminal`.

## Do I need sudo or automatic package/font installs?
No sudo is required for the project installer. Scripts do not download or install system packages or fonts automatically. Optional tools (e.g. `fzf`, `bat`/`batcat`, `jq`, `yq`, `eza`, `rg`, `tree`, `docker`, `podman`) enhance features when already installed.

## Will it modify `.zsh_history` or expose secrets?
The project is designed not to intentionally read, change, or delete `.zsh_history`. Installers create timestamped backups and managed configuration blocks as documented. Always keep independent backups, review scripts before execution, and never share screenshots/logs containing secrets, tokens, or private host details.

## Can I install only the terminal core?
Yes. Use `./setup.sh --core` for terminal-only installation. `./setup.sh --visual` applies optional desktop styling when supported.

## How do I uninstall or recover?
Run `./uninstall.sh` from the extracted project directory and follow the prompts. Recovery uses available backups/rollback data where safe but is **not** a full system snapshot. See [Installation & Recovery](INSTALLATION-AND-RECOVERY.md).

## Where is the full command list and examples?
- In a ZSH session: `hnhelp`, `hnmenu`, `hnsearch <text>`
- Documentation: [Command Reference](COMMAND-REFERENCE.md), [Operator Utilities](OPERATOR-UTILITIES.md), and [Beginner & Advanced Tutorial](TUTORIAL.md)

## How do I report bugs or security issues?
- Bugs/questions: open a GitHub issue with sanitized details (OS, shell, terminal, steps, exact error).
- Security: follow [../SECURITY.md](../SECURITY.html) (do not publish exploit details publicly).

---
*HN // CIT · CYBER CITADEL AGENCY · ENGINEERED BY HN*
