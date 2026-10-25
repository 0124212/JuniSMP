# JuniSMP mod guide

Not every mod in the pack needs an explanation — most are drop-in QoL or
visual. This covers the ones with actual mechanics worth reading up on.
Full pinned mod list: `prism/mod-versions.json` in the repo.

## Skills & progression

- **Skill Proficiencies** — the server's mcMMO-style progression system: 15
  skills (Mining, Woodcutting, Harvesting, Excavation, Fishing, Combat, Arms
  Mastery, Archery, Defence, Acrobatics, Athletics, Sneaking, Smithing,
  Alchemy, Enchanting) level 0→100 just from playing normally — no grinding
  menus, no new currency, no gated gear. Every level gives a real passive
  bonus in that same activity, and bonuses stack **additively** with vanilla
  enchantments (a Fortune II pickaxe at Mining 60 mines like Fortune V).
  Check your levels and what each one currently gives you from the **Skills
  tab in your inventory screen** — it lists exactly what trains each skill
  and what you're getting, no wiki needed. A couple of examples: Mining 100
  = +100% pickaxe break speed and +5 Fortune; Archery 100 = -30% bow draw
  time and arrows ricochet to two extra targets.
  [Modrinth](https://modrinth.com/mod/skill-proficiencies) ·
  [Source](https://github.com/balovich-matje/specialities)

## Mining & tools

- **Hammer Enchantment** — a real enchantment, not a separate tool. Goes on
  pickaxes, axes, or shovels; get it from an enchanting table, loot chests,
  or villager trades, up to level III. Breaking one block also breaks
  matching blocks around it:
  - **Level I** — one extra block, straight behind the one you broke.
  - **Level II** — a 3-wide line perpendicular to your mining direction (3
    blocks total per swing).
  - **Level III** — the full 3x3 face around the block you broke, adjusted
    automatically whether you're mining up, down, or sideways.
  Stacks fine with Fortune/Silk Touch and the Smelting/Magnetic
  enchantments. Doesn't replace **VeinMiner** below — Hammer clears a flat
  area regardless of block type, VeinMiner chains connected blocks of the
  *same* type (ore veins); reach for whichever fits the job.
  [Modrinth](https://modrinth.com/datapack/hammer-enchantment) ·
  [Source](https://github.com/lullaby6/data-packs/tree/main/_enchantments)

  > This one's a **datapack**, not a mod — it lives in the world save, not
  > `.minecraft/mods`. Nothing to install on your end; it just works once
  > you're on the server.

## Sorting & inventory

- **Inventory Profiles Next** — the sort/restock buttons built into every
  container GUI. The real power is the modifier-key combos when moving
  items: hold **Alt** = include hotbar, **Shift** = move all, **Ctrl** =
  move only items matching what's under your cursor, **Caps Lock** = only
  top up existing stacks.
  [Docs](https://inventory-profiles-next.github.io) ·
  [Source](https://codeberg.org/Inventory-Profiles-Next-Mod/IPN)
- **REI (Roughly Enough Items)** — recipe/item browser, press the default
  keybind to open it from any screen. Handy to know: you can search by
  mod name (`@modname`) or recipe type.
  [Modrinth](https://modrinth.com/mod/rei) ·
  [Source](https://github.com/shedaniel/RoughlyEnoughItems)
- **Jade** — hover-over info tooltip (what a block/entity is, health,
  progress). No config needed, just look at things.
  [Modrinth](https://modrinth.com/mod/jade) ·
  [Source](https://github.com/Snownee/Jade)

## Storage

- **Tom's Storage** — networked storage system (think a lighter-weight
  Applied Energistics): link storage crates to a terminal for one-screen
  access to everything. Worth reading before building a storage room.
  [Source/README](https://github.com/tom5454/Toms-Storage)
- **Storage Drawers** — visual, in-world bulk item storage (drawers show
  their contents). Upgradeable with storage/void upgrades.
  [Wiki](https://github.com/jaquadro/StorageDrawers/wiki)

## Magic & combat (Wizards suite)

- **Wizards** + **Spell Engine** + **Spell Power** + **Runes** — adds a
  real spellcasting system: craft spellbooks/staffs, learn spells, scale
  damage with Spell Power stats, socket Runes for extra effects. This is
  the one genuinely deep system in the pack, worth reading the wiki
  before diving in.
  [Spell Engine docs](https://github.com/ZsoltMolnarrr/SpellEngine) ·
  [Spell Power docs](https://github.com/ZsoltMolnarrr/SpellPower) ·
  [Wizards source](https://github.com/ZsoltMolnarrr/Wizards) ·
  [Runes source](https://github.com/ZsoltMolnarrr/Runes)

## Farming, food & seasons

- **Farmers Delight** (+ Rustic/Ubes/Spanish/More Delight addons) — adds
  cooking stations, new crops, and recipes well beyond vanilla food. The
  base wiki covers the core mechanics the addons build on.
  [Wiki](https://github.com/vectorwing/FarmersDelight/wiki)
- **Serene Seasons** — real seasons (spring/summer/autumn/winter) that
  affect crop growth, foliage, and more. Plan farming around the season —
  not everything grows year-round anymore.
  [Wiki](https://github.com/Glitchfiend/SereneSeasons/wiki)
- **Vanilla NPCs** — customizable mannequin-style NPCs for decoration/
  roleplay. Simple to use, no wiki needed beyond in-game tooltips.
  [Modrinth](https://modrinth.com/mod/vanilla-npcs)

## Exploration & travel

- **Waystones** — place a waystone, then warp between any you've
  discovered. The fast-travel backbone of this world — build one near
  your base early.
  [Docs](https://mods.twelveiterations.com/minecraft/waystones)
- **Traveler's Backpack** — upgradeable backpack with tanks, hoses, and
  crafting-on-the-go upgrades depending on the skin you craft it from.
  [Wiki](https://github.com/Tiviacz1337/Travelers-Backpack/wiki)
- **VeinMiner** — hold the keybind while mining to break a whole
  connected vein of ore at once (configurable, doesn't apply to
  everything). See **Hammer Enchantment** above for flat-area clearing
  instead of vein-chaining.
  [Source](https://github.com/MiraculixxT/Veinminer)

## Worldgen (why the terrain looks like this)

- **Terralith** — the main overworld terrain overhaul (new biomes,
  terrain shapes).
  [Wiki](https://stardustlabs.miraheze.org/wiki/Terralith)
- **Tectonic** — large-scale terrain features (mountains, ridges) layered
  on top.
  [Config docs](https://github.com/Apollounknowndev/tectonic/wiki/Config)
- **Incendium** — Nether overhaul.
  [Wiki](https://stardustlabs.miraheze.org/wiki/Incendium)
- **Nullscape** — End overhaul.
  [Wiki](https://stardustlabs.miraheze.org/wiki/Nullscape)

> All four only affect **newly generated** chunks — old terrain keeps its
> original shape, so you'll see a visible seam where new meets old if you
> travel far enough.

## Visuals

- **Resource pack (bundled):** Pixel Perfection Fidelity — not enabled by
  default, turn it on under **Options → Resource Packs** after importing.
- **Shaders:** Iris + Sodium are installed, but no shader is bundled —
  grab whichever one you like and drop it in `.minecraft/shaderpacks/`.

## Admin-only (you won't need these as a player)

- **LuckPerms** — permissions/ranks. [Wiki](https://luckperms.net/wiki)
- **Chunky** — world pregeneration. [Wiki](https://github.com/pop4959/Chunky/wiki)
