---
layout: default
title: "Security Policy"
description: "Security reporting and responsible use guidance for HN NEXUS."
---

# Security Policy

## Scope

This project customizes an interactive ZSH environment and includes local inspection and text-classification utilities.

## Reporting a vulnerability

Please do not publish exploit details in a public issue. Until a private security contact is configured for this repository, use GitHub's private vulnerability reporting feature if it is enabled. Otherwise contact the maintainers through a verified channel listed on the repository profile.

Include the affected version, platform, reproduction steps and impact. Remove secrets, tokens, private keys and personal data from reports.

## Security expectations

- Review install, upgrade and rollback scripts before execution.
- Run without elevated privileges unless strictly required.
- Test changes in a disposable account or VM first.
- Do not treat text classification as a security scanner or verdict engine.
