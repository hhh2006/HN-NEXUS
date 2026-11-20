#!/usr/bin/env bash
# HN//CIT Command Center visual suite: XFWM frame + GTK terminal styling + terminal palette.
set -Eeuo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
command -v xfconf-query >/dev/null || { echo '[BLOCKED] Run this inside an XFCE session (xfconf-query missing).'; exit 2; }
command -v xfce4-terminal >/dev/null || { echo '[BLOCKED] xfce4-terminal not found.'; exit 2; }
[[ -n "${DISPLAY:-}" ]] || { echo '[BLOCKED] No X11 display detected.'; exit 2; }
STAMP="$(date +%Y%m%d-%H%M%S)-$$"
HN_ROOT="$HOME/HN-NEXUS"
if [[ -f "$HOME/.zshrc" ]] && grep -q 'HN-HEXUS' "$HOME/.zshrc" && ! grep -q 'HN-NEXUS' "$HOME/.zshrc"; then HN_ROOT="$HOME/HN-HEXUS"; fi
BACKUP="$HN_ROOT/BACKUPS/PRISM-THEME-$STAMP"
THEME_DEST="$HOME/.themes/HN-Prism-X"
GTK_DEST="$HOME/.config/gtk-3.0/gtk.css"
README_DEST="$HOME/.config/gtk-3.0/README-HN-PRISM-X.txt"
mkdir -p "$BACKUP" "$HOME/.themes" "$HOME/.config/gtk-3.0"
# If apply fails mid-flight, retain the exact backup location for manual recovery.
on_theme_apply_error() {
  local rc=$?
  trap - ERR
  printf "[ERROR] XFCE theme apply stopped (exit %s). Preserve this backup and do not rerun blindly: %s\n" "$rc" "$BACKUP" >&2
  exit "$rc"
}
trap on_theme_apply_error ERR

# Stable content fingerprints: relative paths + file hashes, no timestamps/absolute paths.
tree_hash() {
  local dir="$1" listing
  [[ -d "$dir" ]] || return 1
  listing="$(mktemp)"
  ( cd "$dir" && find . -type f -print0 | sort -z | while IFS= read -r -d '' f; do printf '%s  ' "$f"; sha256sum "$f" | awk '{print $1}'; done ) > "$listing"
  sha256sum "$listing" | awk '{print $1}'
  rm -f "$listing"
}
file_hash() { [[ -f "$1" ]] && sha256sum "$1" | awk '{print $1}' || printf 'ABSENT'; }

# Preserve existing assets and README before any modification.
if [[ -e "$THEME_DEST" ]]; then cp -a "$THEME_DEST" "$BACKUP/HN-Prism-X.before"; echo 1 > "$BACKUP/theme-existed"; else echo 0 > "$BACKUP/theme-existed"; fi
if [[ -e "$GTK_DEST" ]]; then cp -a "$GTK_DEST" "$BACKUP/gtk.css.before"; echo 1 > "$BACKUP/gtk-css-existed"; else echo 0 > "$BACKUP/gtk-css-existed"; fi
if [[ -e "$README_DEST" ]]; then cp -a "$README_DEST" "$BACKUP/README-HN-PRISM-X.before"; echo 1 > "$BACKUP/readme-existed"; else echo 0 > "$BACKUP/readme-existed"; fi

# Save original XFConf values and types before changing them.
: > "$BACKUP/xfconf.tsv"
: > "$BACKUP/xfconf-expected.tsv"
snapshot() {
  local channel="$1" prop="$2" type="$3" value
  if value="$(xfconf-query -c "$channel" -p "$prop" 2>/dev/null)"; then
    printf '%s\t%s\t%s\t1\t%s\n' "$channel" "$prop" "$type" "$value" >> "$BACKUP/xfconf.tsv"
  else
    printf '%s\t%s\t%s\t0\t\n' "$channel" "$prop" "$type" >> "$BACKUP/xfconf.tsv"
  fi
}
for spec in 'xfwm4 /general/theme string' 'xfce4-terminal /color-use-theme bool' 'xfce4-terminal /color-background-color string' 'xfce4-terminal /color-foreground string' 'xfce4-terminal /color-cursor string' 'xfce4-terminal /color-cursor-use-theme bool' 'xfce4-terminal /color-palette string' 'xfce4-terminal /background-mode string' 'xfce4-terminal /font-name string' 'xfce4-terminal /misc-cursor-shape string' 'xfce4-terminal /misc-show-scrollbar bool' 'xfce4-terminal /scrolling-lines int'; do
  read -r c p t <<< "$spec"; snapshot "$c" "$p" "$t"
done

# Stage theme, then replace destination.
rm -rf "$THEME_DEST.new"
cp -a "$ROOT_DIR/theme/HN-Prism-X" "$THEME_DEST.new"
rm -rf "$THEME_DEST"
mv "$THEME_DEST.new" "$THEME_DEST"
cp -a "$ROOT_DIR/theme/gtk-3.0/gtk.css" "$GTK_DEST"

setprop() {
  local c="$1" p="$2" t="$3" v="$4"
  if xfconf-query -c "$c" -p "$p" >/dev/null 2>&1; then xfconf-query -c "$c" -p "$p" -t "$t" -s "$v"
  else xfconf-query -c "$c" -p "$p" --create -t "$t" -s "$v"; fi
  printf '%s\t%s\t%s\t%s\n' "$c" "$p" "$t" "$v" >> "$BACKUP/xfconf-expected.tsv"
}
FONT='DejaVu Sans Mono 10'
if command -v fc-match >/dev/null 2>&1; then
  for candidate in 'JetBrainsMono Nerd Font Mono' 'JetBrainsMonoNL Nerd Font Mono' 'FiraCode Nerd Font Mono' 'Hack Nerd Font Mono' 'MesloLGS Nerd Font Mono'; do
    family="$(fc-match -f '%{family}' "$candidate" 2>/dev/null || true)"
    if grep -qi 'Nerd Font' <<< "$family"; then FONT="$candidate 10"; break; fi
  done
fi
setprop xfwm4 /general/theme string 'HN-Prism-X'
setprop xfce4-terminal /color-use-theme bool false
setprop xfce4-terminal /color-background-color string '#080D16'
setprop xfce4-terminal /color-foreground string '#DCE7F2'
setprop xfce4-terminal /color-cursor string '#63E6D2'
setprop xfce4-terminal /color-cursor-use-theme bool false
setprop xfce4-terminal /color-palette string '#101A29;#F07882;#75C99A;#E7B86E;#68B9F4;#A88CE8;#42CFC4;#E4EDF7;#52647B;#FF9AA1;#98E0B2;#F2D18E;#8BCBFF;#C4A9FA;#78E4D7;#FFFFFF'
setprop xfce4-terminal /background-mode string 'TERMINAL_BACKGROUND_SOLID'
setprop xfce4-terminal /font-name string "$FONT"
setprop xfce4-terminal /misc-cursor-shape string 'TERMINAL_CURSOR_SHAPE_IBEAM'
setprop xfce4-terminal /misc-show-scrollbar bool true
setprop xfce4-terminal /scrolling-lines int 10000

cat > "$README_DEST" <<'NOTE'
HN//CIT Command Center GTK CSS is installed in this directory. Restore the previous
CSS using the restore.sh script in the corresponding HN backup folder under your home directory.
NOTE

# Record exact installed content after all writes complete.
tree_hash "$THEME_DEST" > "$BACKUP/theme-installed.sha256"
file_hash "$GTK_DEST" > "$BACKUP/gtk-css-installed.sha256"
file_hash "$README_DEST" > "$BACKUP/readme-installed.sha256"

cat > "$BACKUP/restore.sh" <<'RESTORE'
#!/usr/bin/env bash
set -Eeuo pipefail
B="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
THEME="$HOME/.themes/HN-Prism-X"
GTK="$HOME/.config/gtk-3.0/gtk.css"
README="$HOME/.config/gtk-3.0/README-HN-PRISM-X.txt"
restored=0 preserved=0 removed=0
file_hash() { [[ -f "$1" ]] && sha256sum "$1" | awk '{print $1}' || printf 'ABSENT'; }
tree_hash() {
  local dir="$1" listing
  [[ -d "$dir" ]] || return 1
  listing="$(mktemp)"
  ( cd "$dir" && find . -type f -print0 | sort -z | while IFS= read -r -d '' f; do printf '%s  ' "$f"; sha256sum "$f" | awk '{print $1}'; done ) > "$listing"
  sha256sum "$listing" | awk '{print $1}'
  rm -f "$listing"
}
restore_asset() {
  local current="$1" expected_file="$2" existed_file="$3" backup="$4" kind="$5" type="$6" current_hash expected
  expected="$(cat "$expected_file")"
  if [[ "$type" == tree ]]; then current_hash="$(tree_hash "$current" 2>/dev/null || printf 'ABSENT')"; else current_hash="$(file_hash "$current")"; fi
  if [[ "$current_hash" != "$expected" ]]; then printf '[PRESERVED] %s changed after HN installation.\n' "$kind"; ((preserved+=1)); return; fi
  if [[ "$(cat "$existed_file")" == 1 ]]; then
    rm -rf "$current"
    if [[ "$type" == tree ]]; then cp -a "$backup" "$current"; else mkdir -p "$(dirname "$current")"; cp -a "$backup" "$current"; fi
    printf '[RESTORED] Previous %s.\n' "$kind"; ((restored+=1))
  else
    rm -rf "$current"; printf '[REMOVED] HN-created %s.\n' "$kind"; ((removed+=1))
  fi
}

# Restore only properties that still equal the value HN set; preserve later user edits.
while IFS=$'\t' read -r c p t expected; do
  [[ -n "$c" ]] || continue
  current="$(xfconf-query -c "$c" -p "$p" 2>/dev/null || true)"
  if [[ "$current" != "$expected" ]]; then printf '[PRESERVED] XFConf %s:%s changed after HN installation.\n' "$c" "$p"; ((preserved+=1)); continue; fi
  while IFS=$'\t' read -r oc op ot existed oldvalue; do
    [[ "$oc" == "$c" && "$op" == "$p" ]] || continue
    if [[ "$existed" == 1 ]]; then
      if xfconf-query -c "$c" -p "$p" >/dev/null 2>&1; then xfconf-query -c "$c" -p "$p" -t "$t" -s "$oldvalue"; else xfconf-query -c "$c" -p "$p" --create -t "$t" -s "$oldvalue"; fi
    else xfconf-query -c "$c" -p "$p" --reset >/dev/null 2>&1 || true; fi
    printf '[RESTORED] XFConf %s:%s\n' "$c" "$p"; ((restored+=1))
    break
  done < "$B/xfconf.tsv"
done < "$B/xfconf-expected.tsv"

restore_asset "$THEME" "$B/theme-installed.sha256" "$B/theme-existed" "$B/HN-Prism-X.before" 'XFWM theme' tree
restore_asset "$GTK" "$B/gtk-css-installed.sha256" "$B/gtk-css-existed" "$B/gtk.css.before" 'GTK CSS' file
restore_asset "$README" "$B/readme-installed.sha256" "$B/readme-existed" "$B/README-HN-PRISM-X.before" 'HN GTK README' file
printf '[SUMMARY] restored=%s removed=%s preserved=%s\n' "$restored" "$removed" "$preserved"
echo '[NOTE] Restart xfce4-terminal or log out/in to refresh decorations and CSS.'
RESTORE
chmod 700 "$BACKUP/restore.sh"
printf '[APPLIED] HN-Prism-X XFWM decoration, GTK terminal styling and HN//CIT palette.\n'
printf '[FONT] %s\n[BACKUP] %s\n[RESTORE] %s/restore.sh\n' "$FONT" "$BACKUP" "$BACKUP"
printf '[NEXT] Close and reopen XFCE Terminal. Window decoration changes may require XFWM refresh or logout/login.\n'
