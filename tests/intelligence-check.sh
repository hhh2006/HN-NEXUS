#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS="$ROOT/config/hn-tools.zsh"
for fn in hnsuggest hnhistory-search hnexplain hnwhy; do
  grep -q "^${fn}()" "$TOOLS" || { echo "[FAIL] missing ${fn}" >&2; exit 1; }
done
grep -q 'CONTEXT-AWARE COMMAND SUGGESTIONS' "$TOOLS"
grep -q 'Operator intelligence helper loaded' "$TOOLS"
grep -q 'print -z -- "\$selected"' "$TOOLS"
grep -q 'never executed' "$TOOLS"
grep -q 'ERROR INTELLIGENCE / ADVISORY ANALYSIS' "$TOOLS"
grep -q 'LAST COMMAND / EXIT STATUS ANALYSIS' "$TOOLS"
grep -q 'compdef _files hncat hnlog hnjson hnyaml hninspect hnicon' "$TOOLS"
grep -q '17) hnsuggest' "$TOOLS"
grep -q '18) print -Pn' "$TOOLS"
grep -q '19) hnwhy' "$TOOLS"
# The new history and explanation helpers must not mutate history or execute selected content.
if grep -Eq 'history[[:space:]]+-c|fc[[:space:]].*-p|eval[[:space:]]+.*selected|command[[:space:]]+\$selected' "$TOOLS"; then
  echo '[FAIL] unsafe history mutation or execution pattern detected' >&2
  exit 1
fi
echo '[PASS] context suggestions, safe history search, error explanation and task-specific completion are present'
