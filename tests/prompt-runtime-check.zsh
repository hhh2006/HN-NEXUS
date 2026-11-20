# Run by tests/run-all.sh only when ZSH is available.
main() {
[[ -o interactive ]] || { print -u2 -- '[FAIL] prompt runtime test requires interactive ZSH'; return 1; }
local root="${1:A}"
source "$root/config/hn-terminal.zsh" || return 1

_visible_text() {
  emulate -L zsh
  local rendered
  rendered=$(print -P -- "$1" | command sed -E $'s/\033\\[[0-9;]*[[:alpha:]]//g')
  print -rn -- "$rendered"
}

local width top info bottom cells top_text info_text bottom_text
for width in 8 10 16 20 24 30 40 48 49 64 75 76 80 96 112 120 160 240; do
  COLUMNS=$width
  top=$(_hn_hud_top)
  info=$(_hn_hud_info)
  bottom=$(_hn_hud_bottom)
  top_text=$(_visible_text "$top")
  info_text=$(_visible_text "$info")
  bottom_text=$(_visible_text "$bottom")
  for pair in "top:$top_text" "info:$info_text" "bottom:$bottom_text"; do
    local row_name="${pair%%:*}" row="${pair#*:}"
    cells=${#row}
    if (( cells > width - 1 )); then
      print -u2 -- "[FAIL] ${row_name} row uses ${cells} cells at COLUMNS=${width}; safe limit is $((width-1))"
      return 1
    fi
  done
  if (( width >= 19 )); then
    (( ${#top_text} == width - 1 && ${#info_text} == width - 1 )) || {
      print -u2 -- "[FAIL] top/info caps are not aligned at COLUMNS=${width}"
      return 1
    }
    [[ "${top_text[-1]}" == '╮' && "${info_text[-1]}" == '╯' ]] || {
      print -u2 -- "[FAIL] expected matching ╮/╯ right caps at COLUMNS=${width}"
      return 1
    }
  fi
  _hn_render_prompt
  local -a prompt_rows
  prompt_rows=("${(@f)PROMPT}")
  (( ${#prompt_rows} == 3 )) || {
    print -u2 -- "[FAIL] expected 3 literal prompt rows at COLUMNS=${width}; got ${#prompt_rows}"
    exit 1
  }
done

# Simulate repeated resizes in both directions and ensure the cached HUD remains
# exactly three literal rows after every re-render.
for width in 160 80 40 120 24 96 16 240; do
  COLUMNS=$width
  _hn_render_prompt
  local -a prompt_rows
  prompt_rows=("${(@f)PROMPT}")
  (( ${#prompt_rows} == 3 )) || exit 1
done

print -- '[PASS] ZSH runtime prompt width and repeated resize smoke tests'
}

main "$@"
