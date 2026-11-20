# HN NEXUS v4.3.4 — Verification report

## Root cause addressed

The former renderer sized the top rail and information row to exactly `COLUMNS` printable cells. Many terminal emulators use delayed auto-wrap at the last physical column. Writing the final `╮` or `╯` into that cell can leave the terminal in a wrap-pending state, making the corner appear on an extra line or at the far edge unexpectedly.

The new renderer computes one shared safe width of `COLUMNS - 1` for the upper rail and information row. Both caps are placed inside that safe width, leaving the physical last column unused. The bottom input/status row also has compact layouts so it does not wrap independently.

## Changes

- One shared safe-width calculation for the top and information rows.
- `╮` and `╯` retained as matching right-end frame caps, but no longer drawn in the terminal's auto-wrap column.
- No artificial minimum width larger than the actual terminal width.
- Compact clock and identity fallbacks for narrow widths.
- Optional context and duration are removed before core row geometry can overflow.
- Literal `%` signs in user/host/path text are escaped before ZSH prompt expansion.
- Added a ZSH runtime smoke test for visible row widths and repeated resize sequences.

## Build-container results

- `bash tests/run-all.sh`: PASS for all available static, color, theme and geometry checks.
- Geometry model: PASS across 293 terminal widths (8–300 columns); no modeled row reaches the physical auto-wrap column.
- ZIP archive integrity: checked during packaging.
- ZSH parser/runtime: NOT RUN in the build container because `zsh` is not installed here. The package includes `tests/prompt-runtime-check.zsh`; on Kali, `bash tests/run-all.sh` will run the ZSH parser and resize smoke tests automatically when ZSH is available.
- VMware/XFCE visual verification: NOT RUN here. The final appearance still requires a screenshot from the target Kali terminal.

## Verification on Kali

After extracting and installing the release, run:

```bash
bash tests/run-all.sh
```

Then resize the terminal repeatedly (wide → narrow → wide) and confirm that `╮` and `╯` stay on their intended rows without creating a fourth line.
