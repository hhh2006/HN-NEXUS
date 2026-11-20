#!/usr/bin/env python3
"""Check local website references and required public-facing assets."""
from html.parser import HTMLParser
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
SITE = ROOT / "website"

class References(HTMLParser):
    def __init__(self):
        super().__init__()
        self.items = []
    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        for key in ("href", "src"):
            value = attrs.get(key)
            if value:
                self.items.append(value)

parser = References()
parser.feed((SITE / "index.html").read_text(encoding="utf-8"))
errors = []
for ref in parser.items:
    if ref.startswith(("https://", "http://", "mailto:", "tel:", "#", "data:")):
        continue
    path = ref.split("#", 1)[0].split("?", 1)[0]
    if not path:
        continue
    target = SITE / path
    if target.exists():
        continue
    if target.suffix == ".html" and target.with_suffix(".md").exists():
        continue
    errors.append(f"missing local reference: {ref}")

required = [
    SITE / "style.css", SITE / "script.js", SITE / "assets/hn-nexus-mark.svg",
    SITE / "assets/og-cover.svg", SITE / "_layouts/default.html",
    SITE / "guides/installation.md", SITE / "guides/troubleshooting.md",
]
for path in required:
    if not path.is_file() or path.stat().st_size == 0:
        errors.append(f"missing required website asset: {path.relative_to(ROOT)}")

# Check relative Markdown links as they will resolve from the generated page URL.
import re
for markdown in SITE.rglob("*.md"):
    source = markdown.read_text(encoding="utf-8")
    for raw in re.findall(r"\[[^\]]*\]\(([^)]+)\)", source):
        if raw.startswith(("https://", "http://", "mailto:", "#")):
            continue
        target_text = raw.split("#", 1)[0].split("?", 1)[0]
        if not target_text:
            continue
        target = (markdown.parent / target_text).resolve()
        if target.is_file():
            continue
        if target.suffix == ".html" and target.with_suffix(".md").is_file():
            continue
        errors.append(f"broken Markdown link in {markdown.relative_to(ROOT)}: {raw}")

if errors:
    print("[FAIL] Website checks")
    for error in errors:
        print(f" - {error}")
    sys.exit(1)
print("[PASS] Website local links, documentation routes and required assets")
