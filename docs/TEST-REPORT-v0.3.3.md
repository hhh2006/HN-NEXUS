# Test report — publishing candidate v0.3.3

## Scope
Adds context-aware suggestions, safe history search, local error hints, exit-status explanation and task-specific completion.

## Changes reviewed
- `hnsuggest` reads current directory markers and available commands, then prints advisory command ideas.
- `hnhistory-search` reads ZSH history; FZF selection is inserted with `print -z` for user review, not executed. Without FZF it prints filtered matches.
- `hnexplain` reads error text from arguments or stdin and provides heuristic hints without running remediation.
- `hnwhy` reports the previous exit status and common meanings.
- Completion definitions are added only when `compdef` is available.

## Validation status
- `tests/intelligence-check.sh`: added to the suite; checks feature presence and guards against history-clearing/eval patterns.
- `bash tests/run-all.sh`: run in the build environment; see actual execution results supplied with this package.
- ZSH parser/runtime: requires execution on Kali because ZSH is not installed in the build environment.
- ShellCheck: requires execution on Kali because ShellCheck is not installed in the build environment.
- Live Kali/XFCE regression: not performed for this candidate.

Do not treat this candidate as final until ZSH parsing/runtime and ShellCheck pass on Kali, and key interactive behavior is manually verified.
