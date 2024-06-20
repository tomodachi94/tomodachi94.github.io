+++
title = "Setting up a development environment with Neovim and ComputerCraft"
date = "2023-07-04T21:57:13-07:00"
tags = ["Neovim", "ComputerCraft"]
categories = ["Guides"]
draft = false
[comments]
host = "floss.social"
username = "tomodachi94"
id = "110662845640480394"
+++

[ComputerCraft](https://tweaked.cc) is a Minecraft mod that adds programmable computers to the game. These computers are programmed with [Lua](https://lua.org), a scripting language written in C.

[Neovim](https://neovim.io) is a fork of the [Vim](https://vim.org) text editor; it adds configuration with Lua and language server support, among other things, to the classic Vim editor.

In this guide, I'll be walking you through setting up a tolerable IDE-like environment for ComputerCraft in Neovim, similar to Visual Studio Code's IntelliSense.

## Prerequisites
* Basic Vim and Neovim skills.
* Basic comprehension of Lua (needed for configuring Neovim).
* `nvim` and `git` installed.
* `nvim-cmp` setup and working. That is slightly out-of-scope for this guide; I recommend [Heiker Curiel's guide](https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/) for getting this working.
* The following Neovim plugins, installed with your plugin manager of choice:
    + [`nvim-lspconfig`](https://github.com/neovim/nvim-lspconfig), for automatically setting up the Neovim LSP consumer for common LSP servers.
    + [`mason`](https://github.com/williamboman/mason.nvim), for installing and managing other bits of software, including LSP servers.
    + [`mason-lspconfig`](https://github.com/williamboman/mason-lspconfig.nvim), for gluing together `mason` and `nvim-lspconfig`.
    + ...and whatever plugins you need for `nvim-cmp`.

## Setting up `lua-language-server` and the `cc-tweaked` addon
After you've installed Mason, install the `lua-language-server` with Mason and ensures that `nvim-lspconfig` knows about it:

```vim
:MasonInstall lua-language-server
```

Then, clone the `lua-language-server` plugins with Git:

```sh
$ git clone https://github.com/LuaLS/LLS-Addons ~/LLS-Addons --recurse-submodules --shallow-submodules --depth=1
```

Afterwards, create a `.luarc.json` file in your project's root directory with the following contents:

```json
{
    "workspace.library": ["/home/me/LLS-Addons/addons/cc-tweaked"]
}
```
(Don't forget to replace `me` with your username!)

Launch Neovim and try it out:
```sh
$ nvim some-cool-cc-project.lua
```

Voila! Your faux IntelliSense should now be working!
