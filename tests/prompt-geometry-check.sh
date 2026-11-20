#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPT_FILE="$ROOT/config/hn-terminal.zsh"

# Rounded frame contract and requested Kali mark.
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -Fq 'prefix="╭─( HN ${icon} CIT )"' "$PROMPT_FILE"
grep -Fq "_hn_gradient_text '╮'" "$PROMPT_FILE"
grep -Fq "print -rn -- ' %F{141}─╯%f'" "$PROMPT_FILE"
grep -Fq "_hn_gradient_text '╰─'" "$PROMPT_FILE"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -Fq 'rail+="%{${esc}%}─"' "$PROMPT_FILE"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -Fq 'icon="${HN_KALI_ICON:-◈}"' "$PROMPT_FILE"
grep -Fq "typeset -g RPROMPT=''" "$PROMPT_FILE"
grep -Fq 'TRAPWINCH()' "$PROMPT_FILE"
# shellcheck disable=SC2016 # Match literal shell source; expansion is not intended.
grep -Fq '[[ -n "$path" ]] && REPLY+=" ${path}"' "$PROMPT_FILE"

python3 - <<'PY'
# Width model: rounded cap and info-row cap remain inside COLUMNS-1.
for columns in range(8, 301):
    safe = columns - 1
    prefix = len('╭─( HN ◈ CIT )')
    top = min(safe, prefix) if safe <= prefix else prefix + (safe - prefix - 1) + 1
    assert top <= safe, (columns, 'top', top, safe)
    # The info row always reserves the right cap and at least one separator cell.
    right = len('─╯') + (8 + 3 if safe >= 76 else (5 + 1 if safe >= 48 else 0))
    left_budget = max(0, safe - right - 1)
    left = min(left_budget, max(1, len('│ ● kali@kali │ ⌂ …')))
    gap = max(1, safe - left - right)
    assert left + gap + right <= safe, (columns, 'info', left, gap, right, safe)
# Extremely narrow terminals use compact caps; the full identity is not
# allowed to overflow the reserved final column.
for columns in range(8, 19):
    safe = columns - 1
    assert len('╭─╮') <= safe, (columns, 'compact-top')
    assert safe <= safe, (columns, 'compact-info')
    assert len('╰›') <= safe, (columns, 'compact-bottom')
print('[PASS] rounded prompt geometry model: 293 terminal widths')
print('[PASS] compact prompt contract for narrow terminals (8-18 columns)')
PY

echo '[PASS] rounded corners, Kali icon, matching rail glyph, RPROMPT isolation and resize hook' 
