---
layout: default
title: "Visual Assets"
description: "Branding assets, mockups, and guidance for real captures."
---

# Visual Assets & Identity

**HN // CIT · CYBER CITADEL AGENCY · ENGINEERED BY HN**

## Branding and mockups (included)
- `assets/branding/hn-nexus-mark.svg` — primary HN NEXUS mark
- `assets/branding/cyber-citadel-agency.svg` — secondary agency emblem
- `assets/branding/terminal-mockup.svg` — **illustrative** SVG terminal HUD mockup (not a real screenshot)
- `assets/branding/architecture-mockup.svg` — **illustrative** architecture diagram
- `website/assets/og-cover.svg` — social/website cover artwork
- `assets/branding/IDENTITY.txt` — identity, philosophy, and attribution notes

## Real captures (to be added)
Real Kali/ZSH runtime screenshots and captures are **not fabricated** in this repository. Add genuine, privacy-scrubbed captures under `assets/screenshots/` following `assets/screenshots/README.md`, then reference them in README and the website.

## Typography and iconography (runtime)
The prompt uses Nerd Font glyphs when available and falls back to readable text symbols. Commonly detected families include JetBrainsMono Nerd Font Mono, FiraCode Nerd Font Mono, Hack Nerd Font Mono, and MesloLGS Nerd Font Mono. The theme installer detects installed fonts and does not download/install fonts automatically.

## Rendering behavior
- HUD rendering is event-driven (ZSH hooks), with width-aware layout and prompt-safe color handling.
- Visual profiles are selectable via `hnstyle` (session-local).
- No background polling daemon, compositor blur dependency for core operation, or automatic package installation.

## Usage guidance
- Prefer SVG for branding/diagrams and PNG/GIF/MP4 for real environment captures.
- Always label mockups as illustrative and redact sensitive information from real captures.
- Maintain consistent identity: **HN // CIT**, **CYBER CITADEL AGENCY**, **ENGINEERED BY HN**.