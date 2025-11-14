---
title: "Nix quickstart guide"
date: 2023-04-17
draft: false
comments:
    host: floss.social
    username: tomodachi94
    id: 110573535034609447
tags:
- "Nix"
- "Home-Manager"
- "Nixpkgs"
categories:
- "Guides"
---

This guide helps you start quickly with using Nix as a package manager. This guide covers setting up, `nix-shell`, `nix-env -iA`, and Home Manager.

Here's a quick way to get started with using Nix as a *package manager* without diving into the complex internals:
* Install Nix with `sh <(curl -L https://nixos.org/nix/install) --daemon`. Make sure to add that snippet at the end to your shell configuration or you'll have some trouble later.
* Run `nix-channel --update`. This is pretty much the same as `apt-get update`.
* Run `nix-shell -p cowsay`. This downloads `cowsay` into your *Nix Store* (at `/nix/store`) and then modifies your `$PATH` and other variables to make it executable in your shell. Run `cowsay 'Hello Nix!'` to test it out; it should behave the same.
* Run `nix-env -iA pkgs.cowsay` to add `cowsay` into your path permanently. I don't recommend this method if you use more than a few packages; see later bullet points about Home Manager.
* Side note, if you want to search all of the packages in Nixpkgs, you can use the wonderful interface at <https://search.nixos.org>. Make sure to select to `unstable` channel in the switcher below the search bar.

This is pretty much all you need to use Nix, but there are much better ways to ensure packages are installed and automatically put on `$PATH`. Out of the solutions, I still prefer [Home Manager](https://github.com/nix-community/home-manager) (abbreviated to HM).

## Home Manager

HM is a configuration management system that can also manipulate your `$PATH` and other things.

Here's a quick way to start using HM:
* Install HM with `nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager`, then update your channels with `nix-channel --update`. If you see something being 'built', that is perfectly normal. You'll also need to run `nix-shell '<home-manager>' -A install` to complete the installation.
* Add `. $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh` to your `.bashrc`/`.zshrc` to ensure binaries are added to the `$PATH`. Relaunch your shell afterwards.
* You'll need to `mkdir ~/.config/home-manager`, then run `$EDITOR ~/.config/home-manager/home.nix`. Add this snippet to start:
```nix
{
  environment,
  config,
  pkgs,
  lib,
  ...
}:

{
  # Home-Manager needs to know who you are, which is why I use `me` as my username
  home.username = "me";
  home.homeDirectory = "/home/me";

  # Remove this if you are on Darwin or some non-Linux platform
  targets.genericLinux.enable = true;

  # Here's the fun part!
  home.packages = [
    pkgs.git # Version control
    pkgs.neovim # Text editor
    pkgs.exa # Better ls
    pkgs.fd # Better find
    pkgs.ripgrep # Better grep
    pkgs.fzf # Better fuzzy finder
    pkgs.bat # Better cat
    pkgs.zathura # PDF reader
    pkgs.starship # Shell prompt
    pkgs.atuin # Better shell history
  ];
}
```
* This is all you need to start. I recommend removing some of the packages that I have filled and replace them with some of your own tools that you use on a daily basis.
* Update your HM configuration with `home-manager switch`. You'll notice some stuff being downloaded and eventually you will return to your shell.
* Try out your new packages!
* There is also a way to configure things with Home Manager; I will cover that in another guide since that is out of scope for this one.

## Further reading
If Nix seems interesting and you want to learn the internals, I recommend the following resources:

* [Zero to Nix](https://zero-to-nix.com) is a great resource explaining a lot of Nix concepts. This is my go-to resource for most things Nix.
* [The Nixpkgs manual](https://nixos.org/manual/nixpkgs/stable/). I cannot recommend this enough, especially once you want to create your own packages.
* The [Home Manager manual](https://nix-community.github.io/home-manager/) for HM-related things.
* Again, the [Nixpkgs package search](https://search.nixos.org) for finding packages.
