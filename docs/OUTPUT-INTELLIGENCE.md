# Smart Output Intelligence — PRISM X 2.8

`hnoutput` is an explicit, read-only output classifier. It does not change command execution, parse or execute shell input, alter files, or install hooks.

## Saved command output

```zsh
command-that-you-want-to-review > command-output.txt 2>&1
hnoutput command-output.txt
```

## Direct pipeline

```zsh
some-command 2>&1 | hnoutput -
```

The classifier highlights critical/authentication/access failures, common errors and failed operations, warnings and insecure/deprecated signals, success/ready/connected states, informational messages, and debug/trace lines. A final tally summarizes each category. Matching is heuristic and keyword-based: it is a visual triage aid, not a security scanner or a substitute for reading the complete output.

No global aliases or hooks are installed. The function runs only when invoked.
