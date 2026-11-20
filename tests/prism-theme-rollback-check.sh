#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/bin" "$TMP/home/.themes/HN-Prism-X" "$TMP/home/.config/gtk-3.0" "$TMP/state"
printf 'OLD THEME\n' > "$TMP/home/.themes/HN-Prism-X/old.txt"
printf 'OLD GTK CSS\n' > "$TMP/home/.config/gtk-3.0/gtk.css"
printf 'OLD README\n' > "$TMP/home/.config/gtk-3.0/README-HN-PRISM-X.txt"
printf 'xfwm-old\n' > "$TMP/state/xfwm4___general__theme"
printf 'old-font\n' > "$TMP/state/xfce4_terminal___font_name"
cat > "$TMP/bin/xfconf-query" <<'MOCK'
#!/usr/bin/env bash
set -Eeuo pipefail
state="$MOCK_XFCONF_STATE"
c='' p='' value='' reset=0
while (($#)); do
 case "$1" in
  -c) c="$2"; shift 2;;
  -p) p="$2"; shift 2;;
  -s) value="$2"; shift 2;;
  --reset) reset=1; shift;;
  *) shift;;
 esac
done
key="${c//[^a-zA-Z0-9]/_}__${p//[^a-zA-Z0-9]/_}"
file="$state/$key"
if ((reset)); then rm -f "$file"; exit 0; fi
if [[ -n "$value" ]]; then printf '%s\n' "$value" > "$file"; exit 0; fi
[[ -f "$file" ]] || exit 1
cat "$file"
MOCK
cat > "$TMP/bin/xfce4-terminal" <<'MOCK'
#!/usr/bin/env bash
exit 0
MOCK
chmod +x "$TMP/bin/"*
export PATH="$TMP/bin:$PATH" MOCK_XFCONF_STATE="$TMP/state" HOME="$TMP/home" DISPLAY=:test
bash "$ROOT/apply-prism-theme.sh" > "$TMP/apply.log"
BACKUP="$(sed -n 's/^\[BACKUP\] //p' "$TMP/apply.log")"
[[ -x "$BACKUP/restore.sh" ]]
# Change one installed asset and one property after installation: both must survive rollback.
printf 'USER THEME EDIT\n' > "$HOME/.themes/HN-Prism-X/user.txt"
printf 'USER GTK EDIT\n' >> "$HOME/.config/gtk-3.0/gtk.css"
printf 'USER README EDIT\n' >> "$HOME/.config/gtk-3.0/README-HN-PRISM-X.txt"
printf 'user-font\n' > "$MOCK_XFCONF_STATE/xfce4_terminal___font_name"
# An unchanged theme asset is not possible once directory edited; use unchanged xfwm property to prove restore.
bash "$BACKUP/restore.sh" > "$TMP/restore.log"
grep -q 'USER THEME EDIT' "$HOME/.themes/HN-Prism-X/user.txt"
grep -q 'USER GTK EDIT' "$HOME/.config/gtk-3.0/gtk.css"
grep -q 'USER README EDIT' "$HOME/.config/gtk-3.0/README-HN-PRISM-X.txt"
grep -q 'user-font' "$MOCK_XFCONF_STATE/xfce4_terminal___font_name"
grep -q 'xfwm-old' "$MOCK_XFCONF_STATE/xfwm4___general__theme"
grep -q '\[PRESERVED\] GTK CSS changed' "$TMP/restore.log"
grep -q '\[PRESERVED\] HN GTK README changed' "$TMP/restore.log"
grep -q '\[PRESERVED\] XFConf xfce4-terminal:/font-name' "$TMP/restore.log"
echo '[PASS] post-install theme, GTK, README and XFConf edits are preserved; unchanged XFConf value is restored.'

# Second isolated install: no edits means previous files and previously-absent properties are restored/removed.
rm -rf "$HOME/.themes/HN-Prism-X" "$HOME/.config/gtk-3.0/gtk.css" "$HOME/.config/gtk-3.0/README-HN-PRISM-X.txt"
mkdir -p "$HOME/.themes/HN-Prism-X"
printf 'PRE-EXISTING THEME\n' > "$HOME/.themes/HN-Prism-X/original.txt"
printf 'PRE-EXISTING GTK\n' > "$HOME/.config/gtk-3.0/gtk.css"
rm -f "$MOCK_XFCONF_STATE/xfwm4___general__theme"
printf 'pre-existing terminal font\n' > "$MOCK_XFCONF_STATE/xfce4_terminal___font_name"
bash "$ROOT/apply-prism-theme.sh" > "$TMP/apply2.log"
BACKUP2="$(sed -n 's/^\[BACKUP\] //p' "$TMP/apply2.log")"
bash "$BACKUP2/restore.sh" > "$TMP/restore2.log"
grep -q 'PRE-EXISTING GTK' "$HOME/.config/gtk-3.0/gtk.css"
grep -q 'PRE-EXISTING THEME' "$HOME/.themes/HN-Prism-X/original.txt"
[[ ! -e "$MOCK_XFCONF_STATE/xfwm4___general__theme" ]]
grep -q 'pre-existing terminal font' "$MOCK_XFCONF_STATE/xfce4_terminal___font_name"
[[ ! -e "$HOME/.config/gtk-3.0/README-HN-PRISM-X.txt" ]]
echo '[PASS] unchanged pre-existing theme and GTK assets restored; previously-absent XFConf property and HN-created README removed.'
