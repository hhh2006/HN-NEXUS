# Visual Assets & Identity

**HN // CIT · CYBER CITADEL AGENCY · ENGINEERED BY HN**

## Branding and mockups (included)
- `assets/branding/agency-seal.svg` — **primary HN // CIT agency seal (designed, cinematic, animated SVG)** used for README and website identity placements (header, hero, creator, footer, 404). Self-contained: spin/pulse keyframes, arc text "HN // CIT · CYBER CITADEL AGENCY" / "ENGINEERED BY HN". This is a designed identity mark for this project — not a claim of exact reproduction of any external original.
- `assets/branding/prism-profiles.svg` — **Prism spectrum reference sheet**: all 15 profiles with exact start/mid/end RGB rail values generated from `config/hn-terminal.zsh`.
- `assets/branding/hn-nexus-hero.svg` — cinematic full-width hero/banner artwork for the README and site identity (includes HN // CIT identity motif and prominent creator attribution)
- `assets/branding/terminal-theater.svg` / `terminal-mockup.svg` — **illustrative** cinematic SVG terminal HUD mockup (not a real screenshot)
- `assets/branding/readme-divider.svg` — decorative neon divider used in README
- `assets/branding/hn-nexus-mark.svg` — primary HN NEXUS mark (favicon/small mark)
- `assets/branding/cit-seal.png` — original provided CIT seal source image (preserved as-is)
- `assets/branding/cit-seal-emblem.png` — processed transparent/balanced presentation variant of the provided CIT seal (kept in the asset library; no longer the primary placement)
- `assets/branding/cit-seal-emblem.webp` / `assets/branding/cit-seal-trim.png` — optimized/trimmed variants for flexible use
- `assets/branding/cyber-citadel-agency.svg` — secondary agency emblem
- `assets/branding/architecture-mockup.svg` — **illustrative** architecture diagram
- `website/assets/` mirrors key assets for the published site (`agency-seal.svg`, `prism-profiles.svg`, `cit-seal-emblem.png/.webp`, `hn-nexus-hero.svg`, `terminal-theater.svg`, `readme-divider.svg`, `hn-nexus-mark.svg`, `cit-seal*`, `og-cover.svg`, real captures in `screenshots/`, etc.)
- `assets/branding/IDENTITY.txt` — identity, philosophy, and attribution notes

## Seal presentation policy
- Identity placements (README header/creator/footer, website header/hero/creator/final CTA/footer/404, Jekyll layout) use the **designed animated SVG seal** (`agency-seal.svg`) for a cinematic presentation.
- The seal is an original geometric design made for this project's identity. **Do not claim it is an exact match to any external/original seal.**
- Raster variants (`cit-seal*`) remain available in the asset library for flexibility but are not the default placement.

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

## Real screenshots (author-provided)

- `assets/screenshots/hn-nexus-kali-capture-01.png` (mirrored in `website/assets/screenshots/`)
- `assets/screenshots/hn-nexus-kali-capture-02.png` (mirrored in `website/assets/screenshots/`)

Real captures provided by the project author. Appearance may vary by environment. Review and redact sensitive information before sharing additional captures.
