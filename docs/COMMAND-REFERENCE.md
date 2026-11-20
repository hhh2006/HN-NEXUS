# Command Reference — HN NEXUS (HN // CIT)

**Publishing pack:** `v1.0.0` · **Terminal source baseline:** `4.4.2`  
**Identity:** `HN // CIT` · **CYBER CITADEL AGENCY** · **ENGINEERED BY HN**  
**Author:** Hani Khaled Nasser Al-Nasiri — Cybersecurity Student, Al-Razi University · [@hhh2006](https://github.com/hhh2006)

This reference documents commands provided by HN NEXUS as implemented in `config/hn-tools.zsh` and `config/hn-terminal.zsh`. Runtime scripts are authoritative. Where behavior depends on installed optional tools or terminal context, that is noted explicitly.

> **Design principles:** commands are explicitly invoked and local-first. Suggestions/analysis helpers are heuristic (not AI), read-only/advisory, never auto-execute commands, and do not perform network discovery, scanning, or packet capture. Native command wrappers preserve native behavior for pipes/redirections and unsupported argument forms; use `command <name>` to bypass.

---

## Quick index

| Category | Commands |
|---|---|
| Help & discovery | `hnhelp`, `hnmenu`, `hnsearch`, `hnstatus`, `hnprism`, `hnvisual`, `hndoctor`, `hncolors`, `hnicons` |
| Visual profile | `hnstyle` |
| Context & assistance | `hnsuggest`, `hnhistory-search`, `hnhistory`, `hnexplain`, `hnwhy` |
| Files & viewing | `hnfiles`, `hnicon`, `hncat`, `hnlog`, `hnjson`, `hnyaml`, `hnfind`, `hninspect`, `hndiff`, `cat` (interactive presentation) |
| System & operations | `hnops`, `hnports`, `hnproc`, `hnhealth`, `hnservices`, `hncontainers`, `hnreport`, `ps`/`df`/`free`/`ss`/`du` (interactive presentation) |
| Network views & intelligence | `hnipa`, `ip a`/`ip route`/`ip neigh` (specific read-only forms), `hnnet`, `hnanalyze` |
| Output triage | `hnoutput` |
| Shell helpers & extras | `mkcd`, `extract`, `ls`/`tree` (interactive presentation), `l`/`ll`/`la`/`lt` (if `eza` installed) |

---

## 1) Help, discovery & diagnostics

### `hnhelp`
- **Purpose:** Show the operator quick reference (available commands and short descriptions).
- **Usage:** `hnhelp`
- **Example:**
  ```zsh
  hnhelp
  ```
- **Notes:** Read-only display.

### `hnmenu`
- **Purpose:** Interactive, keyboard-driven COMMAND CENTER launcher for existing utilities.
- **Usage:** `hnmenu`
- **Example:**
  ```zsh
  hnmenu
  # select an option (1-19) and follow prompts (path, query, or text)
  ```
- **Notes:** Runs selected helpers only on demand; no background tasks.

### `hnsearch [TEXT]`
- **Purpose:** Search the built-in local catalogue of native Linux commands and HN/PRISM utilities (informational lookup).
- **Usage:** `hnsearch [TEXT]` (omit text to browse)
- **Examples:**
  ```zsh
  hnsearch ssh
  hnsearch "docker"
  hnsearch
  ```
- **Notes:** Displays descriptions/results and **never executes** listed commands.

### `hnstatus`
- **Purpose:** Compact system/session snapshot.
- **Usage:** `hnstatus`
- **Example:** `hnstatus`

### `hnprism`
- **Purpose:** Live session / Git / runtime overview.
- **Usage:** `hnprism`
- **Example:** `hnprism`

### `hnvisual`
- **Purpose:** Diagnose Nerd Font detection, glyph/icon readiness, terminal color capability and width.
- **Usage:** `hnvisual`
- **Example:** `hnvisual`
- **Notes:** Read-only diagnostic; does not install fonts or modify settings.

### `hndoctor`
- **Purpose:** Read-only diagnostic for core files, command correction, ZSH completion, optional plugins (autosuggestions/syntax highlighting if present), optional CLI tools, Nerd Font and truecolor support.
- **Usage:** `hndoctor`
- **Example:** `hndoctor`
- **Notes:** Identifies optional components clearly; never installs packages or changes shell/desktop settings.

### `hncolors`
- **Purpose:** Preview PRISM/HN color spectrum / truecolor output.
- **Usage:** `hncolors`
- **Example:** `hncolors`

### `hnicons`
- **Purpose:** Preview supported symbol/icon set and fallbacks.
- **Usage:** `hnicons`
- **Example:** `hnicons`

---

## 2) Visual profile

### `hnstyle [PROFILE]`
- **Purpose:** Show or set the HUD/prompt visual profile (palette). Default mode is automatic cycling.
- **Usage:**
  - `hnstyle` or `hnstyle show` — display current profile and mode
  - `hnstyle auto` — restore automatic palette rotation
  - `hnstyle <profile>` — pin a profile for the current session
- **Profiles:** `auto`, `emerald`, `sapphire`, `amethyst`, `arctic`, `rose`, `turquoise`, `indigo`, `lilac`, `jade`, `polar`, `royal`, `matrix`, `blood`, `quantum`, `obsidian`
- **Examples:**
  ```zsh
  hnstyle
  hnstyle royal
  hnstyle matrix
  hnstyle auto
  ```
- **Notes:** Session-local visual setting; does not change command behavior. Prompt engine may use alert/failure palette behavior as designed.

---

## 3) Context & assistance (local, heuristic, no auto-execution)

### `hnsuggest [TEXT]`
- **Purpose:** Suggest relevant commands based on local workspace markers (Git, Python, Node, Docker, tests, logs) and installed tools. Advisory only.
- **Usage:** `hnsuggest [TEXT]` (optional filter)
- **Examples:**
  ```zsh
  hnsuggest
  hnsuggest git
  hnsuggest docker
  ```
- **Notes:** Suggestions are **never executed**. Based on local files/markers and tool presence; not an AI service.

### `hnhistory-search [TEXT]`
- **Purpose:** Search recent ZSH history and insert a selected command into the editable prompt for review.
- **Usage:** `hnhistory-search [TEXT]`
- **Examples:**
  ```zsh
  hnhistory-search ssh
  hnhistory-search "git commit"
  ```
- **Behavior:**
  - Reads recent in-session history via ZSH `fc` (read-only).
  - With `fzf`: interactive filter; selected entry inserted into ZLE buffer (`print -z`) — **review and press Enter yourself**.
  - Without `fzf`: prints matching/recent lines (fallback) with a read-only reminder.
- **Notes:** Never executes selections; does not clear or rewrite `.zsh_history`.

### `hnhistory [COUNT]`
- **Purpose:** Read-only, numbered view of recent ZSH history.
- **Usage:** `hnhistory [COUNT]` (1–200, default 30)
- **Examples:**
  ```zsh
  hnhistory
  hnhistory 50
  ```
- **Notes:** Does not edit/clear/rewrite `.zsh_history`. History may contain sensitive data.

### `hnexplain [ERROR]`
- **Purpose:** Heuristic, advisory explanations for common error text (command not found, permission denied, missing files, connection refused, syntax errors, Python tracebacks, etc.).
- **Usage:** `hnexplain <text>` or pipe via stdin
- **Examples:**
  ```zsh
  hnexplain "zsh: command not found: jq"
  hnexplain "Permission denied"
  some_command 2>&1 | hnexplain
  ```
- **Notes:** Read-only text analysis; suggests checks/next steps but does not execute fixes.

### `hnwhy`
- **Purpose:** Explain the last command exit status (`$?`) in plain terms.
- **Usage:** `hnwhy`
- **Examples:**
  ```zsh
  false; hnwhy
  grep missing /etc/hosts; hnwhy
  ```
- **Notes:** Advisory interpretation only.

---

## 4) Files, logs & viewing

### `hnfiles [DIR]`
- **Purpose:** Semantic file browser for immediate entries (including hidden files) with glyphs/colors.
- **Usage:** `hnfiles [DIR]` (default: current directory)
- **Examples:** `hnfiles` · `hnfiles /etc`
- **Notes:** Non-recursive, read-only.

### `hnicon PATH`
- **Purpose:** Identify a path by type (file/dir/symlink/exec/category hints).
- **Usage:** `hnicon PATH`
- **Examples:** `hnicon ./setup.sh` · `hnicon /usr/bin/python3`
- **Notes:** Symlinks identified before targets; extensions are best-effort.

### `hncat FILE`
- **Purpose:** Numbered, framed text viewer with syntax colors via `bat`/`batcat` when available; safe numbered fallback otherwise.
- **Usage:** `hncat FILE`
- **Examples:** `hncat README.md` · `hncat config/hn-tools.zsh`
- **Notes:** Binary files are not dumped as unreadable text.

### `hnlog FILE`
- **Purpose:** Read logs with line numbers, severity-aware highlighting, and a compact severity summary.
- **Usage:** `hnlog FILE`
- **Examples:** `hnlog /var/log/syslog` · `hnlog ./app.log`
- **Notes:** Read-only.

### `hnjson FILE`
- **Purpose:** Pretty-print JSON with syntax colors (uses `jq`).
- **Usage:** `hnjson FILE`
- **Example:** `hnjson data.json`
- **Notes:** Requires `jq` if available for enhanced output; optional dependency.

### `hnyaml FILE`
- **Purpose:** Format/view YAML when `yq` is available.
- **Usage:** `hnyaml FILE`
- **Example:** `hnyaml config.yml`
- **Notes:** Optional dependency; no automatic installation.

### `hnfind TEXT [PATH]`
- **Purpose:** Search text with colored matches (`rg` when available, else `grep`).
- **Usage:** `hnfind TEXT [PATH]`
- **Examples:** `hnfind TODO .` · `hnfind "HN_NEXUS" config`
- **Notes:** Read-only search.

### `hninspect FILE`
- **Purpose:** File metadata and SHA-256 report (regular files).
- **Usage:** `hninspect FILE`
- **Example:** `hninspect setup.sh`
- **Requirements:** common tools such as `file`, `stat`, `sha256sum`.

### `hndiff OLD NEW`
- **Purpose:** Colored unified diff view.
- **Usage:** `hndiff OLD NEW`
- **Example:** `hndiff old.conf new.conf`
- **Requirements:** `diff`; optional `colordiff`.

### `cat FILE` (interactive presentation wrapper)
- **Purpose:** In interactive terminals, provide a syntax-aware, numbered view via `bat`/`batcat` when installed (presentation convenience).
- **Usage:** `cat FILE` (familiar form)
- **Examples:**
  ```zsh
  cat README.md
  command cat README.md      # bypass presentation
  cat README.md | grep HN    # pipeline preserves native behavior
  cat README.md > copy.txt   # redirection preserves native behavior
  ```
- **Notes:** Pipes, redirections, options/stdin cases fall back to native `cat` as designed. Does not change file contents.

---

## 5) System & operations

### `hnops`
- **Purpose:** Operations center / local capability and session overview (read-only).
- **Usage:** `hnops`

### `hnports`
- **Purpose:** Read-only overview of listening TCP/UDP sockets (local).
- **Usage:** `hnports`
- **Requirements:** `ss` (iproute2).
- **Notes:** Not a network scanner.

### `hnproc`
- **Purpose:** Top processes by CPU usage (snapshot).
- **Usage:** `hnproc`
- **Requirements:** `ps`, `head`.

### `hnhealth`
- **Purpose:** One-shot system health snapshot (read-only).
- **Usage:** `hnhealth`

### `hnservices`
- **Purpose:** Read-only systemd service inventory/status view.
- **Usage:** `hnservices`
- **Requirements:** `systemctl` for full results.
- **Notes:** No start/stop/restart/enable/disable actions.

### `hncontainers`
- **Purpose:** Read-only Docker/Podman container inventory.
- **Usage:** `hncontainers`
- **Requirements:** `docker` and/or `podman` if present.
- **Notes:** No run/start/stop/rm actions.

### `hnreport [FILE]`
- **Purpose:** Create a local, read-only system/network snapshot report.
- **Usage:** `hnreport [FILE]` (default location under `~/HN-NEXUS/REPORTS/` when omitted)
- **Examples:** `hnreport` · `hnreport ~/hn-report.txt`
- **Notes:** May include host/network details—**review before sharing**.

### Interactive native system wrappers: `ps`, `df`, `free`, `ss`, `du`
- **Purpose:** Semantic, numbered/color-emphasized presentation in interactive terminals while preserving original command names/arguments.
- **Examples:**
  ```zsh
  ps aux
  df -h
  free -h
  ss -lntup
  du -sh *
  ps aux | grep ssh    # pipeline -> native
  df -h > disk.txt     # redirection -> native
  command ps aux       # bypass wrapper
  ```
- **Notes:** Presentation layer only; does not alter command results.

### `ls` and `tree` (interactive presentation)
- **Purpose:** Enhanced interactive directory views (colors/grouping; `tree` when installed).
- **Examples:** `ls` · `ls -lah` · `tree -L 2` · `ls > files.txt` (native when redirected)
- **Notes:** Non-terminal output remains native for scripting.

### `l`, `ll`, `la`, `lt`
- **Purpose:** Convenience `eza` shortcuts **only if `eza` is installed**.
- **Notes:** Optional.

---

## 6) Network & output intelligence (read-only, supplied input)

### `hnipa [-4|-6]`
- **Purpose:** Compact, color-coded interface/address matrix.
- **Usage:** `hnipa`, `hnipa -4`, `hnipa -6`
- **Notes:** Read-only local view; not a scanner.

### `ip a` / `ip route` / `ip neigh` (specific read-only presentation forms)
- **Purpose:** Familiar `ip` command with compact matrices for supported read-only display forms.
- **Supported examples:** `ip a`, `ip addr`, `ip -4 a`, `ip -6 a`, `ip route`, `ip -4 route`, `ip -6 route`, `ip neigh`, `ip -4 neigh`, `ip -6 neigh`
- **Passthrough:** All other arguments/subcommands and piped/redirected usage pass to native `ip` unchanged.
- **Bypass:** `command ip ...`
- **Notes:** Read-only presentation of local tables; no configuration changes or discovery.

### `hnnet [FILE|-]`
- **Purpose:** Passive highlighter/classifier for network-related text you provide (IPs, ports, protocols, firewall/routing/interface terms).
- **Usage:** `hnnet FILE` or `command 2>&1 | hnnet -`
- **Examples:** `hnnet scan-output.txt` · `ip route | hnnet -` (note: if piped into hnnet, provide text as intended)
- **Notes:** Does not execute reviewed commands, connect, scan, or capture traffic. Heuristic only.

### `hnanalyze [FILE|-]`
- **Purpose:** Heuristic text intelligence over supplied output (e.g. Nmap text, SSH auth logs, DNS/HTTP traces, firewall/common network output).
- **Usage:** `hnanalyze FILE` or piped stdin
- **Examples:** `hnanalyze scan.txt` · `cat /var/log/auth.log | hnanalyze -`
- **Notes:** Classifier only; does not run tools or modify files.

### `hnoutput [FILE|-]`
- **Purpose:** Smart output triage/classification for saved or piped command output.
- **Usage:** `hnoutput FILE` or `some-command 2>&1 | hnoutput -`
- **Examples:** `make 2>&1 | hnoutput -` · `hnoutput build.log`
- **Notes:** Heuristic triage aid; not a security verdict engine.

---

## 7) Shell helpers

### `mkcd DIR`
- **Purpose:** Create a directory and enter it.
- **Example:** `mkcd ~/lab/workspace`

### `extract FILE`
- **Purpose:** Extract supported archive formats using available system tools.
- **Examples:** `extract archive.tar.gz` · `extract bundle.zip`
- **Notes:** Depends on installed archive utilities.

---

## Safety & accuracy
- **Privacy:** history/reports/logs/screenshots may contain sensitive data—review and redact before sharing.
- **Native bypass:** `command <name> ...`
- **Authoritative source:** `config/hn-tools.zsh`, `config/hn-terminal.zsh`, and `hnhelp`

---
*HN // CIT · CYBER CITADEL AGENCY · ENGINEERED BY HN*