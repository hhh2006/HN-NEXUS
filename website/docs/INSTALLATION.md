---
layout: default
title: "Installation"
description: "Quick installation guide for HN NEXUS."
---

# Installation (Quick)

For the complete, recommended guide see **[INSTALLATION-AND-RECOVERY.md](INSTALLATION-AND-RECOVERY.md)**.

## Recommended (guided)
From the extracted project directory (normal user, no sudo):

```bash
chmod +x setup.sh install.sh uninstall.sh
./setup.sh --check
./setup.sh --dry-run
./setup.sh
```

Open a **new ZSH** terminal and verify:

```zsh
hnhelp
hnstatus
hnvisual
hndoctor
```

## Notes
- Core terminal setup works without optional desktop theming.
- Optional XFCE/X11 visual styling is applied only on supported sessions and with confirmation in guided mode (`./setup.sh --visual` for advanced use).
- The installer creates timestamped backups and recovery artifacts under the install root (e.g. `~/HN-NEXUS/BACKUPS`, `RECOVERY`, `LOGS`) or detected legacy path.
- Review scripts before running and keep independent backups.

*HN // CIT · CYBER CITADEL AGENCY · ENGINEERED BY HN*