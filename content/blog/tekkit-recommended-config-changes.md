---
title: "Recommended configuration changes for Tekkit 1.6.4"
date: 2026-07-24
draft: false
comments:
    host: floss.social
    username: tomodachi94
    id: 116978108717269626
tags:
- "Minecraft"
- "Tekkit"
- "ComputerCraft"
- "SerializationIsBad"
- "MineFactory Reloaded"
- "Mystcraft"
- "Big Reactors"
categories:
- "Guides"
---

These are changes I recommend for [Tekkit, a Minecraft modpack for 1.6.4](https://www.technicpack.net/modpack/tekkitmain.552547/discuss) by Technic.
This post will be continuously updated as I discover new client-side mods, configuration options, and other tweaks.

Exclaimation point emoji (❗) indicate urgency, mostly pertaining to things that a malicious user could exploit.
Bug emoji (🐛) fix minor bugs and other annoyances.
Sparkles emoji (✨) indicate features that introduce quality of life (QOL) improvements for players.

All of these changes can be applied to clients and servers; some of them will only have an effect on one or another.

## ❗❗Install SerializationIsBad (clients and servers)

SerializationIsBad fixes [a remote code execution (RCE) vulnerability caused by insecure usage of serialization APIs](https://github.com/dogboy21/serializationisbad/blob/master/README.md#information-on-the-vulnerability).
The mod is available on [Modrinth](https://modrinth.com/project/TTZtsNrf) and [CurseForge](https://legacy.curseforge.com/minecraft/mc-mods/serializationisbad).
Make sure to [read these instructions to properly configure the mod](https://github.com/dogboy21/serializationisbad/blob/master/README.md#any-other-instances).

## ❗Disable Pink Slime page from Mystcraft (servers)

Pink Slime is a liquid added by MineFactory Reloaded. When placed on the ground, it turns into a pink slimeball, which is used in numerous crafting recipes from the mod.
Using the Mystcraft page, it is possible to overwhelm and even crash a server by creating a Mystcraft world filled with Pink Slime.

To disable the page, turn off the `B:modmat_fluid.mfr.liquid.pinkslime.still.enabled` option in `config/mystcraft/symbols.cfg`:

```diff
-B:modmat_fluid.mfr.liquid.pinkslime.still.enabled=true
+B:modmat_fluid.mfr.liquid.pinkslime.still.enabled=false
```

## ❗ Various duplication glitches (servers)

Plastic Bags and Plastic Cups from MineFactory Reloaded can be used to duplicate items and fluids, respectively.

*Know about any others? Please let me know.*

## 🐛 Fix Pastebin for ComputerCraft (servers)

The `pastebin` command for ComputerCraft has been broken for a very long time.
[This datapack](https://modrinth.com/resourcepack/computercraft-pastebin-patch) can fix the issue.

## ✨ Install NEI Addons (clients and servers)

NEI Addons allows players to fill in Pattern Provider patterns by autocompleting from Not Enough Items (NEI). It can be downloaded [from CurseForge]() or [directly from the mod creator's website](https://old-minecraft.bdew.net/neiaddons/).

Including it on servers allows players to fill recipes without having the physical items; having it installed still allows players without the mod to connect, so don't worry about getting everyone to install it.
