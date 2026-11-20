# PRISM Output Design

PRISM uses semantic colors in its own interface: Cyan for structure, Ice/Blue for primary data, Violet/Magenta for identity, Green for success, Amber for attention, Red for failure, and muted gray for secondary context.

## Smart viewers (opt-in)
- `hnlog FILE`: colors common severity words without modifying the file.
- `hnjson FILE`: uses `jq -C` to format and color JSON to stdout.
- `hncat FILE`: uses bat/batcat when installed; otherwise falls back to native `cat`.
- `hnfind TEXT [PATH]`: uses ripgrep or grep with colored matches.

These are explicit viewing commands. PRISM does not globally rewrite arbitrary stdout, pipes, scripts, or machine-readable output.
