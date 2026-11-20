# Tutorial — HN NEXUS (HN // CIT)

**Beginner to Advanced Guide** · **ENGINEERED BY HN**  
**Author:** Hani Khaled Nasser Al-Nasiri — Cybersecurity Student, Al-Razi University · [@hhh2006](https://github.com/hhh2006)

This tutorial walks through installing, verifying, using, and customizing HN NEXUS safely on Kali Linux or compatible ZSH environments.

---

## Part 1 — Beginner: first install and orientation

### 1.1 What you get
- A responsive **three-row terminal HUD** (identity, context/path/status, ready/input line).
- **Prism visual profiles** (`hnstyle`) with icon/color fallbacks.
- On-demand **local utilities** for files, logs, data, processes, services, containers, and supplied output.
- **Context-aware assistance** (suggestions, history search, error hints, exit analysis) — heuristic, advisory, never auto-executed.
- **Recovery-aware** guided installation and optional XFCE visual styling.

### 1.2 Before you install (safety checklist)
1. Use a **normal user account** — do **not** run the project installer with `sudo`.
2. Ensure **ZSH** and **Python 3** are installed.
3. Keep **independent backups** of important dotfiles/home data (installer backups help, but are not a full system snapshot).
4. Obtain the project from a trusted source, extract it, and review scripts (`setup.sh`, `install.sh`, `uninstall.sh`, `SECURITY.md`) before running.

### 1.3 Step-by-step installation (recommended)

Open a terminal in the extracted project folder:

```bash
# 1) Make entry scripts executable (if needed)
chmod +x setup.sh install.sh uninstall.sh

# 2) Check prerequisites (no changes made)
./setup.sh --check

# 3) Preview the guided plan (no changes made)
./setup.sh --dry-run

# 4) Run guided installation
./setup.sh
```

**What to expect:**
- Core ZSH configuration is installed with timestamped backups and recovery/rollback artifacts.
- On a supported **XFCE/X11** session, you may be prompted once to apply optional desktop styling. If unsupported or non-interactive, desktop styling is safely skipped and the core install proceeds/reports status.

**Advanced modes:**
- `./setup.sh --core` — terminal core only
- `./setup.sh --visual` — apply optional XFCE/X11 visual layer (supported sessions)
- `./setup.sh --full` — guided full installation

### 1.4 Verify in a fresh ZSH session

Open a **new ZSH terminal**, then run:

```zsh
hnhelp
hnstatus
hnvisual
hndoctor
```

- `hnhelp` confirms commands are available.
- `hnstatus` shows a compact snapshot.
- `hnvisual` and `hndoctor` report fonts/colors/plugins/tools/capabilities (optional items may be missing and reported as optional).

If commands are missing, confirm you launched ZSH and that `~/.zshrc` contains the HN NEXUS managed block. See [Troubleshooting](TROUBLESHOOTING.md).

### 1.5 Everyday basics

```zsh
# Discover commands
hnhelp
hnmenu
hnsearch docker

# Workspace-aware suggestions (advisory only, never executed)
hnsuggest

# Explain the last exit status
false
hnwhy

# Explain common error text
hnexplain "Permission denied"
some_command 2>&1 | hnexplain
```

> **Safe history recall:** `hnhistory-search` can filter history (uses `fzf` if installed) and inserts the selection into your prompt for review — it never runs it automatically.

### 1.6 Safe uninstall / recovery (beginner view)

From the extracted project folder:

```bash
./uninstall.sh
```

Follow prompts carefully. Recovery uses available backups/rollback data where safe, but it is **not** a full system snapshot. Keep backups until you verify your shell and desktop (if themed) are working as expected.

---

## Part 2 — Intermediate: daily workflows

### 2.1 Understand your context

```zsh
hnprism        # session/git/runtime overview
hnstatus       # compact snapshot
hnsuggest      # ideas based on local project markers/tools
```

The HUD updates per prompt (event-driven hooks) and adapts to terminal width.

### 2.2 Work with files and logs

```zsh
# Browse directory entries (immediate, semantic icons)
hnfiles
hnfiles /var/log

# Identify a path type
hnicon ./setup.sh

# View files
cat README.md          # interactive presentation when applicable
hncat config/hn-tools.zsh
command cat README.md  # force native cat

# Logs with severity highlighting and summary
hnlog /var/log/syslog

# Structured data (optional tools)
hnjson data.json       # jq
hnyaml config.yml      # yq

# Search and inspect
hnfind "TODO" .
hninspect setup.sh
hndiff old.conf new.conf
```

**Pipelines/redirections:** wrappers are designed to preserve native behavior for scripting (e.g. `cat file | grep x`, `ls > out.txt`).

### 2.3 System and process visibility (read-only)

```zsh
hnops
hnproc
hnports        # local listening sockets only, not a scanner
hnhealth
hnservices     # if systemctl available
hncontainers   # if docker/podman installed
hnreport       # local snapshot report (review before sharing)
```

Interactive native-style views (semantic presentation in TTY):

```zsh
ps aux
df -h
free -h
ss -lntup
du -sh *
# native in pipelines/redirections
ps aux | grep ssh
df -h > disk.txt
```

### 2.4 Network and output triage (supplied/local, read-only)

```zsh
hnipa
ip a
ip route
ip neigh

# Heuristic analysis of provided text (no scanning/capture/execution)
hnnet saved-output.txt
some_command 2>&1 | hnnet -

hnanalyze nmap-output.txt
cat /var/log/auth.log | hnanalyze -

hnoutput build.log
make 2>&1 | hnoutput -
```

### 2.5 Visual customization

```zsh
hnstyle
hnstyle royal
hnstyle matrix
hnstyle auto
hncolors
hnicons
```

For best glyph rendering, select a Nerd Font in your terminal profile (e.g. JetBrainsMono Nerd Font Mono). Fallbacks are supported.

---

## Part 3 — Advanced: power use and recovery mindset

### 3.1 Wrappers, pipelines, and predictability
- Interactive presentation applies to selected commands; pipes/redirections/non-interactive contexts are intended to remain native for supported wrappers.
- Force native behavior explicitly: `command <name> ...`
- When writing portable scripts, prefer explicit native commands and validate behavior in a clean shell.

### 3.2 Completion, correction, and plugins
- Command-name correction can suggest fixes and ask before applying (arguments are not auto-corrected).
- Completion is initialized/configured as provided; optional plugins (autosuggestions/syntax highlighting) load only if present.
- Use `hndoctor` to inspect status.

### 3.3 Optional XFCE visual theme
Requirements: supported **XFCE/X11** session, `xfconf-query`, `xfce4-terminal`.

```bash
./setup.sh --visual --dry-run
./setup.sh --visual
```

Core functionality does not require the visual layer. Visual apply creates backups/restore scripts; keep them until verified. Picom blur (`enable-prism-blur.sh`) is optional and separately guarded.

### 3.4 Diagnostics and validation

```bash
./setup.sh --check
./diagnostics.sh
bash tests/run-all.sh
python3 tests/website-check.py
```

Skipped tests are not passes. Full ZSH/ShellCheck/runtime/desktop and GitHub CI/Pages validation depend on target environments.

### 3.5 Recovery discipline
- Do not rerun installers blindly after partial failures; inspect errors and preserve `~/HN-NEXUS/BACKUPS`, `RECOVERY`, `LOGS` (or legacy root).
- Rollback targets managed changes and may preserve user-modified configs while retaining artifacts for audit.
- `.zsh_history` is not intended to be modified by the project.

### 3.6 Privacy and responsible sharing
`hnreport`, logs, history, and terminal captures may contain sensitive data (hosts, IPs, users, tokens, paths). Redact before sharing. Follow [SECURITY.md](../SECURITY.md).

---

## Quick recipes

```zsh
hnhelp && hnstatus && hndoctor
hnsuggest
some_command; hnwhy
some_command 2>&1 | hnexplain
hnhistory-search git
hnreport ./my-report.txt
```

## Next steps
- [Command Reference](COMMAND-REFERENCE.md)
- [Architecture](ARCHITECTURE.md)
- [FAQ](FAQ.md)
- [Troubleshooting](TROUBLESHOOTING.md)
- [Installation & Recovery](INSTALLATION-AND-RECOVERY.md)

*HN // CIT · CYBER CITADEL AGENCY · ENGINEERED BY HN*