#!/usr/bin/env bash
set -Eeuo pipefail
# Follow the active HN directory already referenced by the user's .zshrc.
# Older builds used HN-HEXUS (E); preserve that path rather than creating a
# second competing installation. Default to the canonical HN-NEXUS directory.
ROOT="$HOME/HN-NEXUS"
if [[ -f "$HOME/.zshrc" ]] && grep -q 'HN-HEXUS' "$HOME/.zshrc" && ! grep -q 'HN-NEXUS' "$HOME/.zshrc"; then
  ROOT="$HOME/HN-HEXUS"
fi
PKG_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$ROOT/BACKUPS/PRE-HN-CIT-$STAMP"
CONFIG="$ROOT/CORE/CONFIG"
RELEASE="$ROOT/CORE/ENGINE/RELEASE-HN-CIT-$STAMP"
MARKER="# >>> HN NEXUS MANAGED BLOCK >>>"
ENDMARKER="# <<< HN NEXUS MANAGED BLOCK <<<"
say(){ printf '\033[1;38;2;65;220;255m[HN//CIT]\033[0m %s\n' "$*"; }
fail(){ printf '[ERROR] %s\n' "$*" >&2; exit 1; }

command -v zsh >/dev/null 2>&1 || fail "ZSH is required."
mkdir -p "$ROOT" "$BACKUP" "$CONFIG" "$RELEASE" "$ROOT/RECOVERY" "$ROOT/LOGS"
touch "$HOME/.zshrc"

# Reject malformed/duplicated managed blocks before touching user files.
python3 - "$HOME/.zshrc" "$MARKER" "$ENDMARKER" <<'PY'
import pathlib,sys
p=pathlib.Path(sys.argv[1]); s=p.read_text(errors="replace")
a=s.count(sys.argv[2]); b=s.count(sys.argv[3])
if a != b or a > 1: raise SystemExit("Malformed or duplicated HN managed markers; no changes made.")
if a and s.index(sys.argv[2]) > s.index(sys.argv[3]): raise SystemExit("Managed markers are reversed; no changes made.")
PY

cp -a "$HOME/.zshrc" "$BACKUP/zshrc.before"
for f in hn-sovereign.zsh hn-terminal.zsh hn-tools.zsh; do
  if [[ -f "$CONFIG/$f" ]]; then cp -a "$CONFIG/$f" "$BACKUP/$f.before"; : > "$BACKUP/$f.existed"; fi
done
cp -a "$PKG_DIR/." "$RELEASE/"
for f in hn-sovereign.zsh hn-terminal.zsh hn-tools.zsh; do
  install -m 0644 "$PKG_DIR/config/$f" "$CONFIG/$f"
done

# Record exact installed bytes. Rollback removes a new config only if unchanged.
: > "$BACKUP/installed-config.sha256"
for f in hn-sovereign.zsh hn-terminal.zsh hn-tools.zsh; do
  sha256sum "$CONFIG/$f" | awk -v name="$f" '{print $1 "  " name}' >> "$BACKUP/installed-config.sha256"
done

# Replace only our own block; all unrelated .zshrc lines remain untouched.
python3 - "$HOME/.zshrc" "$MARKER" "$ENDMARKER" <<'PY'
import pathlib,sys
p=pathlib.Path(sys.argv[1]); s=p.read_text()
a,b=sys.argv[2:]
if a in s:
    start=s.index(a); end=s.index(b,start)+len(b)
    s=s[:start]+s[end:]
p.write_text(s)
PY
if ! grep -Eq 'HN-(HEXUS|NEXUS).*(hn-sovereign|hn-tools)\.zsh' "$HOME/.zshrc"; then
  cat >> "$HOME/.zshrc" <<EOF

# >>> HN NEXUS MANAGED BLOCK >>>
[[ -r "$ROOT/CORE/CONFIG/hn-sovereign.zsh" ]] && source "$ROOT/CORE/CONFIG/hn-sovereign.zsh"
# <<< HN NEXUS MANAGED BLOCK <<<
EOF
fi

ROLLBACK="$ROOT/RECOVERY/rollback-prism-x-$STAMP.sh"
cat > "$ROLLBACK" <<EOF
#!/usr/bin/env bash
set -Eeuo pipefail
BACKUP=$(printf '%q' "$BACKUP")
CONFIG=$(printf '%q' "$CONFIG")
python3 - "\$HOME/.zshrc" <<'PYROLL'
import pathlib,sys
p=pathlib.Path(sys.argv[1])
if not p.exists():
    print('[INFO] .zshrc does not exist; nothing to detach.')
    raise SystemExit(0)
s=p.read_text(errors='replace')
a="# >>> HN NEXUS MANAGED BLOCK >>>"; b="# <<< HN NEXUS MANAGED BLOCK <<<"
if a in s and b in s:
    i=s.index(a); j=s.index(b,i)+len(b)
    s=s[:i]+s[j:]
    p.write_text(s)
    print('[SAFE] Detached HN managed block; preserved all other .zshrc content.')
else:
    print('[INFO] HN managed block not present; .zshrc left unchanged.')
PYROLL
restored=0
removed=0
preserved=0
for f in hn-sovereign.zsh hn-terminal.zsh hn-tools.zsh; do
  target="\$CONFIG/\$f"
  if [[ -f "\$BACKUP/\$f.existed" && -f "\$BACKUP/\$f.before" ]]; then
    install -m 0644 "\$BACKUP/\$f.before" "\$target"
    echo "[RESTORED] Previous config: \$target"
    ((restored+=1))
  elif [[ -f "\$target" ]]; then
    expected="\$(awk -v name="\$f" '\$2 == name {print \$1}' "\$BACKUP/installed-config.sha256" 2>/dev/null || true)"
    actual="\$(sha256sum "\$target" | awk '{print \$1}')"
    if [[ -n "\$expected" && "\$actual" == "\$expected" ]]; then
      rm -- "\$target"
      echo "[REMOVED] Installer-created, unmodified config: \$target"
      ((removed+=1))
    else
      echo "[PRESERVED] Config changed after installation: \$target"
      ((preserved+=1))
    fi
  fi
done
# Remove only empty directories; never recursively delete user data.
rmdir "\$CONFIG" 2>/dev/null || true
printf '[SUMMARY] restored=%s removed=%s preserved_modified=%s\n' "\$restored" "\$removed" "\$preserved"
echo '[PRESERVED] .zsh_history was never read or modified.'
echo '[RETAINED] Backups, release files, logs and recovery scripts were retained for audit/recovery.'
EOF
chmod 700 "$ROLLBACK"

for f in "$CONFIG/hn-sovereign.zsh" "$CONFIG/hn-terminal.zsh" "$CONFIG/hn-tools.zsh" "$HOME/.zshrc"; do
  zsh -n "$f" || { echo "[ERROR] ZSH syntax check failed: $f" >&2; echo "Run rollback: $ROLLBACK" >&2; exit 1; }
done

VERIFY="$ROOT/RECOVERY/verify-prism-x-$STAMP.sh"
cat > "$VERIFY" <<EOF
#!/usr/bin/env bash
set -u
ROOT=$(printf '%q' "$ROOT")
fail=0
for f in "\$ROOT/CORE/CONFIG/hn-sovereign.zsh" "\$ROOT/CORE/CONFIG/hn-terminal.zsh" "\$ROOT/CORE/CONFIG/hn-tools.zsh" "\$HOME/.zshrc"; do
  if zsh -n "\$f"; then echo "[PASS] ZSH syntax: \$f"; else echo "[FAIL] \$f"; fail=1; fi
done
for c in eza batcat fzf zoxide btop; do
  command -v "\$c" >/dev/null 2>&1 && echo "[AVAILABLE] \$c" || echo "[OPTIONAL] \$c missing"
done
exit "\$fail"
EOF
chmod 700 "$VERIFY"
say "HN//CIT installed."
say "Backup: $BACKUP"
say "Verify: $VERIFY"
say "Rollback: $ROLLBACK"
say "Open a new ZSH terminal."
