---
title: "grsecurity in Nixpkgs: an obituary (or: what was 'paxmark'?)"
date: 2025-02-11
draft: false
tags:
- "Nixpkgs"
- "PaX"
- "grsecurity"
- "OpenPaX"
- "Linux"
categories:
- "Miscellenea"
---

This post aims to provide a bunch of historical background around [PaX](https://pax.grsecurity.net/) and [grsecurity](https://grsecurity.net) support in Nixpkgs.
It is fairly abstract and can probably be digested by non-Nix people with ease.

This post is mostly focused on the implementation in Nixpkgs; I am not an expect in PaX/grsecurity (so if I've gotten something wrong, please correct me).

I'm also partially writing this so that people know what paxmark was, in case they encounter a reference to it.

## Background

[PaX](https://pax.grsecurity.net/) was an ecosystem of Linux patches and command-line tools which aimed to improve the security of Linux systems by [making it more difficult to abuse arbitrary code injection attacks](https://pax.grsecurity.net/docs/pax.txt).

Development was initially started by the PaX team [in 2000](https://grsecurity.net/faq#paxgrsec), eventually being adopted into the grsecurity project.

Development of standalone PaX ceased sometime in 2013, eventually becoming integrated into grsecurity. grsecurity [ceased providing free Linux kernel patches and other grsecurity software in April 2017](https://grsecurity.net/passing_the_baton). 

## The rise: patches submitted to Nixpkgs

The grsecurity patches were [submitted to Nixpkgs in July 2013](https://github.com/NixOS/nixpkgs/commit/af2a12755113d8c1e1464fbe20ead31389a66e32) by [Rob Vermaas](https://github.com/rbvermaa) with the update to [Linux 3.2](https://kernelnewbies.org/Linux_3.2).

Maintenance in 2013 and 2014 was primarily conducted by [wizeman](https://github.com/wizeman) and [Evgeny Egorochkin](https://github.com/Phreedom), with [Austin Seipp](https://github.com/thoughtpolice) starting to submit patches in 2014.
Egorochkin stopped submitting patches in 2014.

copumpkin and tg-x began submitting fixes in 2016.

joachifm and wkennington began submitting patches regularly in 2015, continuing to do so until grsecurity's removal in 2018 (more on that later).
wizeman continued to submit patches to grsecurity in Nixpkgs until mid-2015; after that, we saw a sharp decline in their activity in Nixpkgs.

## The middle era: adding support to more packages with `paxmark`

### What is `paxmark`?

In short, `paxmark` was a wrapper formerly included in `stdenv` (and [later moved to `paxctl`'s setup hook](https://github.com/NixOS/nixpkgs/pull/52661)) which thinly wrapped `paxctl` with options that were commonly used at the time in Nixpkgs.

Here's some documentation I wrote as part of a documentation campaign but never submitted to Nixpkgs (which *totally* isn't the reason I'm writing this blog post at all, no no no `/sarc`):

> #### paxctl
> This setup hook exposes a function, `paxmark`, which uses `paxctl` to manipulate the [PaX](https://en.wikipedia.org/wiki/Executable-space_protection#PaX) flags in a standard way:
> * Convert the headers from the old-style `PT_GNU_STACK` program header to the newer `PT_PAX_FLAGS` header.
> * Reset all previous flags, then set the `NOEMUTRAMP` and `NORANDEXEC` flags.

### `paxmark` proliferation

Packages which need some advanced memory management features need to be explicitly whitelisted in PaX.
People started adding `paxmark` commands to packages [as early as 2014](https://github.com/NixOS/nixpkgs/commit/4f745ce8b27bbb3ca6fac8ad314bcc4bfd025f87), with roughly 60 packages containing `paxmark` by 2018.

## The decline: licensing lockdown, removal from Nixpkgs

In 2017, grsecurity made the decision to change the licensing of their patches from GPL to a proprietary licensing arrangement, requiring payment.

Support for the patches [was promptly removed from Nixpkgs](https://github.com/NixOS/nixpkgs/pull/25277) based on concerns that we could no longer reliably support grsecurity.
Similar moves were made by some other distributions; [LWN.net has an excellent overview](https://lwn.net/Articles/721848) for the curious.

Even after the patches were removed from Nixpkgs, much of its infrastructure and tooling lingered (with some things, like [the removal of the grsecurity NixOS options](https://github.com/NixOS/nixpkgs/pull/118576/files), [the `paxmark` function's removal from `stdenv`](https://github.com/NixOS/nixpkgs/pull/52983/commits/1b146a8c6f55b23981c3817d8346f95bb3a799fe) and then [from Nixpkgs](https://github.com/NixOS/nixpkgs/pull/349693), being removed piecemeal).
Much of it was left in place with the hopes that a successor would take off, but I haven't noticed much activity on this.

## A successor?

In November 2024, [OpenPaX](https://thenewstack.io/openpax-a-new-linux-memory-security-patch-arrives/) was released by Edera, a security company.
OpenPaX intended to be an open-source replacement for grsecurity's PaX.

Alpine Linux has [packaged the patches](https://pkgs.alpinelinux.org/package/edge/community/aarch64/linux-openpax); it's unclear if other distributions have done so.
Nixpkgs does not have the patches available as of writing (February 2025).
