#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin" "$TMP/home/HN-NEXUS/CORE/CONFIG"
cat > "$TMP/bin/zsh" <<'ZSHSTUB'
#!/usr/bin/env bash
if [[ "${1:-}" == --version ]]; then echo 'zsh test stub'; exit 0; fi
if [[ "${1:-}" == -n ]]; then exit 0; fi
exit 0
ZSHSTUB
chmod +x "$TMP/bin/zsh"
H="$TMP/home"
printf '# USER CONFIG\n' > "$H/.zshrc"
printf 'HISTORY_SENTINEL\n' > "$H/.zsh_history"
printf 'PREEXISTING_CONFIG_SENTINEL\n' > "$H/HN-NEXUS/CORE/CONFIG/hn-sovereign.zsh"
PATH="$TMP/bin:$PATH" HOME="$H" bash "$ROOT/install.sh" >/dev/null
ROLLBACK="$(find "$H/HN-NEXUS/RECOVERY" -maxdepth 1 -type f -name 'rollback-prism-x-*.sh' -print -quit)"
test -x "$ROLLBACK"
printf '\n# USER CUSTOMIZATION AFTER INSTALL\n' >> "$H/HN-NEXUS/CORE/CONFIG/hn-tools.zsh"
HOME="$H" bash "$ROLLBACK" > "$TMP/rollback.log"
grep -q 'PREEXISTING_CONFIG_SENTINEL' "$H/HN-NEXUS/CORE/CONFIG/hn-sovereign.zsh"
test ! -e "$H/HN-NEXUS/CORE/CONFIG/hn-terminal.zsh"
grep -q 'USER CUSTOMIZATION AFTER INSTALL' "$H/HN-NEXUS/CORE/CONFIG/hn-tools.zsh"
grep -q 'USER CONFIG' "$H/.zshrc"
grep -q 'HISTORY_SENTINEL' "$H/.zsh_history"
if grep -q 'HN NEXUS MANAGED BLOCK' "$H/.zshrc"; then
  echo '[FAIL] HN managed block remained in .zshrc' >&2; exit 1
fi
grep -q 'restored=1 removed=1 preserved_modified=1' "$TMP/rollback.log"
echo '[PASS] rollback restores pre-existing config, removes unchanged new config, preserves user-edited config, .zshrc and history'
