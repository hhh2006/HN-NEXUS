# Public publishing checklist — HN NEXUS (HN // CIT)

**ENGINEERED BY HN** · **CYBER CITADEL AGENCY**

## Repository identity
- Repository: `hhh2006/HN-NEXUS`
- Website: `https://hhh2006.github.io/HN-NEXUS/`
- Default branch: `main`
- Pages source: **GitHub Actions**
- Publishing package: `v1.0.0`
- Terminal source baseline: `4.4.2`

## Before pushing
- [ ] Confirm the full guided install `bash setup.sh` on Kali.
- [ ] Confirm owner-reported tests and keep their raw output with the release records.
- [ ] Review all files for secrets, credentials, private hostnames/IPs, personal machine paths and accidental data.
- [ ] Capture genuine terminal and XFCE screenshots; redact private details.
- [ ] Confirm the MIT license decision and author attribution.
- [ ] Review links, README, release notes and package checksum.

## GitHub setup
- [ ] Create public repository `HN-NEXUS` under `hhh2006`.
- [ ] Push the contents of this package to `main` (the folder contents, not an extra nested ZIP folder).
- [ ] Enable GitHub Actions and allow the Pages workflow to deploy.
- [ ] Open Settings → Pages and select **GitHub Actions** as the build and deployment source.
- [ ] Confirm the CI workflow succeeds.
- [ ] Confirm the Pages workflow succeeds and the website opens at the expected project URL.
- [ ] Check desktop/mobile layout, navigation, documentation links and browser console.

## Release
- [ ] Create a version tag/release only after all release gates pass.
- [ ] Create a GitHub Release with highlights, known limitations, and verification notes.
- [ ] Attach release assets as appropriate (e.g. source archive/zip and `.sha256` checksum file).
- [ ] Verify downloaded asset checksums after upload.

## Post-publish quality review
- [ ] Verify all README/website links and docs routes on desktop and mobile.
- [ ] Confirm cinematic animations render smoothly and `prefers-reduced-motion` behavior is acceptable.
- [ ] Ensure no fabricated real screenshots are presented as genuine captures.
- [ ] Sanity-check command documentation against `hnhelp`/runtime behavior.

Do not claim the repository is published, CI is green, or Pages is live until those results are observed in GitHub.
