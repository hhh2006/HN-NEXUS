# PRISM X Operator Utilities

| Command | Purpose | Requirements |
|---|---|---|
| `hnops` | Local capability/session overview | base ZSH + common Kali tools |
| `hnports` | Listening TCP/UDP sockets | `ss` (iproute2) |
| `hnproc` | Top processes by CPU | `ps`, `head` |
| `hninspect FILE` | File metadata and SHA-256 | `file`, `stat`, `sha256sum` |
| `hndiff OLD NEW` | Colored unified diff | `diff`; optional `colordiff` |

The commands are read-only. `hnports` shows local listening sockets only; it is not a network scanner. `hninspect` hashes regular files only. Output color is intended for interactive terminals; redirect or pipe output when you need plain processing by using the native commands instead.


## PRISM X 2.7 — Cyber file intelligence

- `hnfiles [DIR]` displays the immediate entries in a directory, including hidden entries, with semantic glyphs and colors. It does not recurse or modify files.
- `hnicon PATH` identifies a single path. Symlinks are identified before their targets; directories and executable files have dedicated categories. File extensions provide best-effort categories only and do not validate file contents.


## `hnanalyze [FILE|-]` — Advanced Operator Intelligence
Classifies text already collected from Nmap, SSH authentication logs, DNS/HTTP traces, firewall logs, and common network output.

Examples:
```zsh
hnanalyze scan.txt
cat /var/log/auth.log | hnanalyze -
nmap -oN - 192.0.2.10 | hnanalyze -
```

This is a text classifier, not a scanner or packet analyzer. It does not execute Nmap/TShark, establish connections, capture traffic, or change files. Classification is heuristic; totals count matching lines, not unique hosts or events.


## Structured command output (3.0.5)

- `hncat /path/to/file` — framed, numbered text view; uses `bat`/`batcat` for syntax colors when available. Binary files are not dumped to the terminal.
- `hnipa` — interface, state, and IP/prefix table.
- `hnipa -4` / `hnipa -6` — IPv4-only / IPv6-only view.
- `cat` and `ip a` remain their original native commands.


## Native commands (3.1.0)
- `cat FILE` — interactive syntax-aware file view with line numbers via optional `bat`/`batcat`; native fallback for pipes, redirection and options.
- `ip a` — compact interface/address table with numbering and state colors. `ip -4 a` / `ip -6 a` filter families. Other `ip` subcommands remain native.


## Native system commands (3.2.0)
`ps`, `df`, `free`, and `ss` keep their normal names and options. Direct interactive terminal output receives semantic color emphasis; pipelines and redirects use the native output unchanged.


## Native command presentation

Use the familiar Linux commands directly: `cat`, `ip a`, `ps`, `df`, `free`, `ss`, and `du`. Interactive terminal views use PRISM colors and line/row organization where appropriate. Pipes and redirections remain native, for example `df -h | grep /dev` and `ps aux > processes.txt`. No `hn` prefix is needed.

## v3.4.0 — File, log and report tools

- `hnlog FILE`: numbered log lines with severity markers and a count summary.
- `hnyaml FILE`: optional YAML formatting via an already-installed `yq`.
- `hnreport [FILE]`: creates a local system snapshot. Default location is `~/HN-NEXUS/REPORTS/`; inspect before sharing because host and network details may be included.
- `ls`: native directory listing with color and grouped directories in interactive terminals; non-terminal output stays native.
- `tree`: native tree view with color when `tree` is installed; non-terminal output stays native.
- `hnmenu` options 9 and 10 open the system report and log viewer.


## v3.5.0 — Discovery and history

- `hnsearch [TEXT]`: searches the built-in command catalogue. This is an informational lookup, not an executor.
- `hnhistory [COUNT]`: displays 1–200 recent entries from the active ZSH history list. Treat history as sensitive; it can contain commands, paths, or tokens.
- `hnmenu`: choices 11 and 12 open the command finder and recent history.
- Completion styles are refined only; PRISM does not initialize completion or replace existing key bindings.


## v3.6.0 — Route and neighbor matrices

- `ip route` / `ip -4 route` / `ip -6 route`: read-only routing table with destination, gateway, device and route details.
- `ip neigh` / `ip -4 neigh` / `ip -6 neigh`: local neighbor/ARP cache with link address and state emphasis.
- `ip route show` and `ip neigh show` are also supported. Other arguments are passed to the native `ip` command unchanged.
