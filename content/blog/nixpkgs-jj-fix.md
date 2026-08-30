---
title: "Automatically formatting your nixpkgs commits using Jujutsu VCS"
date: 2026-08-29
draft: false
tags:
- "nixpkgs"
- "treefmt"
- "Jujutsu VCS"
categories:
- "Guides"
---

A bit of a shorter one:

[Jujutsu VCS](https://www.jj-vcs.dev/latest/) (jj) is an alternative Git-compatible version control system (VCS). Among its many features, there is a command called [`jj fix`](https://docs.jj-vcs.dev/latest/config/#code-formatting-and-other-file-content-transformations) which can automatically reformat your mutable commits.

We can take advantage of this in nixpkgs by configuring jj to use `treefmt`. Open your repository-specific config using `jj config edit --repo` (or your global config if you use treefmt everywhere) and add this to it:

```toml
[fix.tools.treefmt]
command = ["nix", "develop", "--command", "treefmt", "--no-cache", "--tree-root", "$root", "--stdin", "$path"]
patterns = ["glob:'**'"]
```
