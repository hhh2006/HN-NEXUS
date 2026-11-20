---
layout: default
title: "Installation and Recovery"
description: "Guided installation, verification, recovery, and safety notes."
---

# Installation & Recovery — HN NEXUS (HN // CIT)

**Publishing pack:** `v1.0.0` · **Terminal source baseline:** `4.4.2`  
**Identity:** HN // CIT · CYBER CITADEL AGENCY · **ENGINEERED BY HN**

This is the practical operator guide for a fresh Kali/Linux installation. The recommended route is the guided one-command installer. Optional desktop styling is applied only when XFCE/X11 is detected and the user confirms.

## 1. Before you begin

- Use a normal user account. **Do not use `sudo`** for the project installer.
- Use Kali Linux or a compatible Linux distribution with ZSH and Python 3.
- Back up important dotfiles/home-directory data independently. The project backup is a safety aid, not a complete system image.
- Extract the downloaded release ZIP to a directory you own. Do not run scripts from an untrusted mirror.
- Read `SECURITY.md` and inspect `setup.sh` / `install.sh` before execution.

Check prerequisites without changing anything:

```bash
./setup.sh --check
```

Preview the guided installation plan:

```bash
./setup.sh --dry-run
```

## 2. Recommended one-command installation

From the extracted project directory:

```bash
chmod +x setup.sh install.sh uninstall.sh
./setup.sh
```

The guided installer checks for ZSH and Python 3, backs up `.zshrc` and existing HN configuration files, installs the project configuration, and creates timestamped verification and rollback scripts. On a supported XFCE/X11 session it asks once before applying the HN-Prism-X window frames, GTK styling and terminal palette; the visual installer creates its own restore backup first. If XFCE/X11 is unavailable, it installs the terminal core and reports that desktop styling was skipped. In non-interactive sessions, desktop styling is skipped safely.

Open a **new ZSH terminal**, then run:

```zsh
hnhelp
hnstatus
hnvisual
```

If a command is not found, confirm that ZSH is the shell you launched and inspect `~/.zshrc` for the HN NEXUS managed block.

## 3. Advanced: XFCE visual theme

Only use this on a desktop currently running **XFCE with X11**, with `xfconf-query` and `xfce4-terminal` installed. It changes the XFWM theme, XFCE Terminal palette/font preferences and GTK CSS. It is not required for the terminal prompt.

Preflight and preview:

```bash
./setup.sh --visual --dry-run
```

Apply the visual layer:

```bash
./setup.sh --visual
```

The script creates a unique restore directory under `~/HN-NEXUS/BACKUPS/PRISM-THEME-*` (or the detected legacy `~/HN-HEXUS` root). It uses a Nerd Font only if one is already installed; otherwise it selects a standard fallback. It does **not** download fonts.

The restore script records SHA-256 fingerprints for the installed theme directory, GTK CSS and generated note, plus the exact XFConf values written by HN. On restore, it changes an item only if that item still matches the HN-installed value: unchanged items are restored to their prior state (or removed if HN created them), while post-install user edits are reported as `[PRESERVED]` and left in place. The restore summary reports restored, removed and preserved counts. Backups are retained. If apply stops partway through, the error message prints the backup directory; keep it and do not rerun blindly. A partial apply may require support-assisted recovery because a completed `restore.sh` is not guaranteed to exist until apply finishes.

The default `./setup.sh` command performs the guided combined installation. Advanced users can use `./setup.sh --core` for terminal-only installation or `./setup.sh --visual` to apply the visual layer separately. The visual layer requires an active XFCE/X11 session.

## 4. Verify and diagnose

Run the project checks from the extracted repository:

```bash
bash tests/run-all.sh
./diagnostics.sh
```

A test marked `SKIP` is not a pass. ZSH parser/runtime checks require ZSH. A successful static test run does not replace testing in a real Kali desktop session.

## 5. Restore / uninstall

Run the recovery entry point from the extracted project directory:

```bash
./uninstall.sh
```

Review the prompt, then confirm. Where matching recovery data exists, the script restores the latest saved XFCE settings first and then runs the latest core rollback. Core rollback detaches only the HN managed block, restores files that existed before installation, and removes newly created HN config files only when their contents still match the install-time SHA-256 manifest. If you edited a new config after installation, it is preserved and reported as `preserved_modified`; do not assume it was removed. The rollback prints a summary with restored, removed and preserved-modified counts.

The recovery operation deliberately retains timestamped backups, release copies, logs and recovery scripts for audit and possible manual recovery. It does not recursively delete the HN data directory. Review and archive those retained files yourself after verifying the shell works.

**Important limits:**

- Recovery is not a full disk snapshot and cannot reverse unrelated system changes.
- If you manually changed a file after installation, compare it with the backup before deciding what to restore.
- Do not delete the backup directory until you have verified the restored shell and desktop.
- `.zsh_history` is not intentionally read, changed or deleted by the installer.
- If recovery itself reports an error, stop; keep the backup folders and inspect the exact error before trying manual cleanup.

## 6. Common problems

| Symptom | What to do |
|---|---|
| `ZSH is required` | Install ZSH using your distribution's package manager, then rerun `./setup.sh --check`. |
| `Python 3 is required` | Install Python 3, rerun the preflight, and retry. |
| Visual mode says XFCE tools are missing | Use `./setup.sh --core`, or log into an XFCE/X11 session and install the missing XFCE components first. |
| No Nerd Font / icons look different | This is expected on systems without a Nerd Font. Install one from its official project instructions if desired, then reopen the terminal. |
| Prompt does not appear | Confirm you launched ZSH (`echo $SHELL` is not definitive for the current process; use `ps -p $$ -o comm=`), inspect `~/.zshrc`, then open a fresh terminal. |
| Terminal looks broken after theme apply | Run `./uninstall.sh` and allow it to restore saved desktop properties. The restore script preserves post-install changes; keep the backup folder. |
| A test is skipped | Install the missing test dependency (usually ZSH) and rerun. Do not report skipped checks as passing. |
| Installer stops partway through | Do not repeatedly rerun or manually delete files. Preserve `~/HN-NEXUS/BACKUPS`, `RECOVERY` and `LOGS`; run `./uninstall.sh` if a rollback script was created. If not, ask for support with the exact error and redacted diagnostics. |

## 7. Getting support safely

When opening an issue, include the HN NEXUS version, Linux distribution, desktop/session type (XFCE/X11 or other), the exact command, the full error text and the output of `./diagnostics.sh`. Remove usernames, hostnames, IP addresses, tokens, keys and private paths first. Never upload `.zshrc`, shell history, private logs or screenshots containing secrets without reviewing/redacting them.

See also [Troubleshooting](TROUBLESHOOTING.md), [Security](../SECURITY.md), and [Support](../SUPPORT.md).
