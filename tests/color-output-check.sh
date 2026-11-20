#!/usr/bin/env bash
set -Eeuo pipefail

# Assert that grep finds no match; propagate grep I/O/usage errors instead of
# treating every non-zero status as a successful absence check.
assert_absent() {
  local rc
  if grep "$@"; then
    echo "[FAIL] Unexpected forbidden pattern found: $*" >&2
    return 1
  else
    rc=$?
    [[ "$rc" -eq 1 ]] || return "$rc"
  fi
}
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS="$ROOT/config/hn-tools.zsh"
for fn in hnhelp hncolors hnprism hnstatus hnicons _hn_head _hn_row _hn_rule _hn_foot; do
  grep -Fq "$fn()" "$TOOLS" || { echo "[FAIL] Missing $fn"; exit 1; }
done
grep -Fq 'COMMAND CENTER SPECTRUM / TRUECOLOR CHECK' "$TOOLS"
grep -Fq 'OPERATOR QUICK REFERENCE' "$TOOLS"
assert_absent -Eq 'alias[[:space:]]+ls=' "$TOOLS"
echo '[PASS] Color-coded report helpers and native command preservation'
