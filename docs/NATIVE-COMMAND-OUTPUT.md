# Native command output layer — PRISM X 3.2.0

The shell keeps familiar command names. In interactive ZSH terminals:

- `cat file` uses `bat`/`batcat` when installed for line numbers, syntax colors and a file header. Without either dependency, it falls back to native `cat`. Options, stdin, pipes and redirected output use native `cat`.
- `ip a`, `ip addr`, `ip address`, `ip -4 a` and `ip -6 a` show a compact interface/address matrix. Other `ip` commands are passed directly to the system binary.
- Explicit `hncat` and `hnipa` viewers remain available.

This is a presentation convenience, not a change to file contents or network state. To bypass presentation wrappers for a single command, use `command cat ...` or `command ip ...`.

No packages are installed automatically. `bat` or `batcat` is optional.


## 3.2.0 — system commands

The interactive Zsh layer also applies semantic ANSI emphasis to `ps`, `df`, `free`, and `ss`. The wrappers pass every argument unchanged to the system executable. When stdout or stdin is not a terminal (for example, a pipe or redirect), the wrapper calls the native command without formatting. This is a presentation-only layer; it does not parse or alter command results.

Examples:

```bash
ps aux
df -h
free -h
ss -lntup
ps aux | grep ssh
df -h > disk-report.txt
```

The first four commands receive interactive color emphasis. The last two use native output for scripting and redirection.
