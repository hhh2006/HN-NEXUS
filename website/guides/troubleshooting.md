---
layout: default
title: "Troubleshooting Guide"
description: "Common issues, diagnostics, and recovery guidance for HN NEXUS."
---

# Troubleshooting — HN NEXUS (HN // CIT)

**ENGINEERED BY HN** · Publishing pack `v1.0.0` · Terminal baseline `4.4.2`

Start with safe, read-only checks:

```bash
./setup.sh --check
./diagnostics.sh
python3 tests/website-check.py
bash tests/run-all.sh
```

> A **skipped** test is not a pass. Full runtime/desktop validation requires the target Kali/ZSH (and XFCE/X11, if applicable) environment.

---

## 1. Prompt or commands not available after install

**Symptoms:** `hnhelp` not found, HUD missing, plain prompt.

1. Confirm a **ZSH** session: `echo $ZSH_VERSION` or `ps -p $$ -o comm=`.
2. Check `~/.zshrc` for a complete **HN NEXUS managed block**.
3. Verify core files exist, e.g. `~/HN-NEXUS/CORE/CONFIG/hn-sovereign.zsh` (legacy installs may use `~/HN-HEXUS/...`).
4. Syntax-check (on systems with ZSH): `zsh -n ~/.zshrc` and relevant config files.
5. Open a **new** terminal/session after installation.

**Recovery:** if issues began immediately after install, preserve backups and run `./uninstall.sh` from the extracted project directory. Do not delete backup/recovery folders.

## 2. Icons or glyphs missing/incorrect

- Use a **Nerd Font** in your terminal profile (e.g. JetBrainsMono Nerd Font Mono). HN NEXUS probes common Nerd Font families and falls back to text symbols otherwise.
- Run `hnvisual` and `hnicons`.
- Fonts are not installed automatically by project scripts.

## 3. Colors or gradients look flat

- Use a terminal with truecolor/256-color support; run `hncolors`.
- Appearance depends on terminal emulator, font, and palette (`hnstyle`).

## 4. `hnhistory-search` not interactive

- Install `fzf` for interactive filtering. Without it, a read-only fallback is shown.
- Selections are inserted for **review only** and never executed automatically.

## 5. Optional tool-dependent features unavailable

| Feature | Optional dependency |
|---|---|
| `hnjson` | `jq` |
| `hnyaml` | `yq` |
| `hnfind` | `rg` (preferred) or `grep` |
| Enhanced `cat`/`hncat` views | `bat`/`batcat` |
| `l/ll/la/lt` | `eza` |
| `tree` view | `tree` |
| Containers view | `docker` / `podman` |

HN NEXUS does not install packages automatically.

## 6. Different behavior in scripts or pipes

- Presentation wrappers target **interactive** output; pipes/redirections and unsupported cases are designed to remain native for supported wrappers.
- Bypass explicitly with `command <name> ...`
- See [Command Reference](../docs/COMMAND-REFERENCE.html).

## 7. XFCE visual theme cannot be applied

**Requires:** active **XFCE/X11** session, `xfconf-query`, `xfce4-terminal`.

- Unsupported on Wayland, SSH-only, other desktops, or terminal-only environments — use `./setup.sh --core`.
- Visual apply creates backups and restore scripts (e.g. under `~/HN-NEXUS/BACKUPS/PRISM-THEME-*` or legacy root). If interrupted, keep the reported backup and do not rerun blindly.
- Restore may preserve post-install user edits for tracked items (reported as preserved).
- Optional blur (`enable-prism-blur.sh`) is separate and may be refused under software rendering.

## 8. Recovery or uninstall issues

- Run `./uninstall.sh` from the extracted project directory and follow prompts.
- Recovery is not a full system snapshot; rollback may preserve user-modified configs and retains artifacts for audit.
- Do not remove `~/HN-NEXUS/RECOVERY`, `BACKUPS`, or `LOGS` (or legacy equivalents) until verified.
- If rollback scripts are missing, do not fabricate steps—collect sanitized diagnostics.

## 9. Interrupted or partial installation

- Stop, inspect the error, and preserve backup/recovery/log directories.
- Use existing rollback paths if available; rerun only after resolving the root cause.

## 10. Website / Pages issues

- Validate locally: `python3 tests/website-check.py`
- Pages deploys via GitHub Actions from `website/` (see `.github/workflows/pages.yml`); set repository Pages source to **GitHub Actions**.
- Expected project URL/base: `https://hhh2006.github.io/HN-NEXUS/`

## 11. Reporting bugs safely

Include: pack/baseline version, OS, `zsh --version`, terminal, session type, exact command, full error, and relevant diagnostics/test output.

**Redact** usernames, hostnames, IPs, tokens, keys, private paths, and secrets. **Never** share `.zsh_history`, private logs, or unredacted screenshots.

- Bugs/support: GitHub issues
- Security: [../SECURITY.md](../SECURITY.html)

---
*HN // CIT · CYBER CITADEL AGENCY · ENGINEERED BY HN*