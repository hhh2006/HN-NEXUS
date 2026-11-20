---
layout: default
title: "Network Intelligence"
description: "Read-only network text classification and local network views."
---

# PRISM X 2.9 — Cyber Command Intelligence

`hnnet` is a passive text highlighter for output that you explicitly provide. It does not execute the command being reviewed, connect to hosts, scan ports, capture packets, or change files.

## Examples

Review a saved output file:

```zsh
hnnet scan-output.txt
```

Review output from a command you choose to run:

```zsh
command 2>&1 | hnnet -
```

The display prioritizes firewall/security decisions, protocol mentions, IPv4-like strings, port references, and routing/interface/VLAN terms. The final tally counts lines assigned to each primary category. Classification is heuristic: an address or port-like string is not validated as reachable, open, or safe. This is not a scanner, IDS, packet analyzer, or substitute for the original output.

No native commands are replaced and no shell hooks are added.


## Route and neighbor views (3.6.0)

The familiar `ip` command displays compact matrices for exact read-only forms: `ip route`, `ip -4 route`, `ip -6 route`, `ip neigh`, `ip -4 neigh`, and `ip -6 neigh`. These views read the local kernel tables only. They do not discover remote hosts or modify routing/neighbor state. Any other `ip` syntax is passed unchanged to the system binary.
