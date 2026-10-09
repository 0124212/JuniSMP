# JuniSMP modpack

Fabric SMP on **MC 26.2**, loader **0.19.5**, Java 25. Client packs ship as
Prism Import zips — grab the latest from **Releases** (48 pinned entries in
`prism/mod-versions.json`).

## Layout

- `mc-fabric/docker-compose.yml` — server (`itzg/minecraft-server:java25`,
  survival/normal, 6G + Aikar flags, RCON on, playit.gg tunnel sidecar).
  Secrets via `.env` (see `mc-fabric/.env.example`) — never committed.
- `prism/` — Prism Launcher metadata for the client pack: `instance.cfg`
  (JuniSMP, 4G), `mmc-pack.json` (MC + loader pins),
  `mod-versions.json` (pinned client mod list with hashes/sizes/URLs).
- Full zips (`JuniSMP-v2/v3/v4.zip`, `JuniSMP-prism.zip`) live as release
  assets, not in git (see `.gitignore`).

## Server vs client mods

Server (`MODRINTH_PROJECTS` in compose, auto-downloaded on boot; 71 mods) =
perf: fabric-api, lithium, ferrite-core, krypton, c2me-fabric, carpet,
spark, vmp-fabric, alternate-current, noisiumforked, ksyxis, servercore;
JVM: 6G Aikar flags + explicit `-Xms6G -Xmx6G -XX:+UseG1GC`;
properties: view-distance=7, simulation-distance=4, sync-chunk-writes=false,
max-chained-neighbor-updates=10000 (via itzg env vars, no extra files);
admin/world: luckperms, chunky, skill-proficiencies; food: farmers-delight +
ubes/rustic/spanish/more delights, harvest-simplified, appleskin, brewery,
chefs-delight, crate-delight (picked over storage-delight — pick one);
worldgen:
dungeons-and-taverns, towns-and-towers, explorify, repurposed-structures,
explorations; exploration: terralith, tectonic (picked over lithosphere —
overlapping terrain engines), incendium (26.2 builds alpha-only: 5.5.1),
nullscape, structory, ct-overhaul-village, hopo-better-mineshaft,
hopo-better-underwater-ruins, moogs-voyager-structures,
mes-moogs-end-structures (picked over betterend — conflicts Nullscape),
natures-compass, explorers-compass,
travelersbackpack (these three also required client-side — in the Prism
pack); gameplay: waystones, veinminer, fallingtree (timber-mod excluded —
fallingtree already covers tree-chopping, two chop-handlers conflict),
friends-and-foes, double-doors (server-side only),
open-parties-and-claims (26.2 builds beta-only: fabric-26.2-0.32.7),
styled-chat (server-side only), crafting-tweaks; storage: toms-storage,
storagedrawers (both also required client-side — in the Prism pack);
utility: jade (picked over wthit — pick one), clumps, universal-graves
(server-side only); decoration:
adorn, macaws-furniture, blockus, modern-decorations-mod,
additional-lanterns, macaws-lights, macaws-doors, macaws-bridges,
macaws-windows, macaws-roofs, rechiseled, diagonal-fences,
skniros-furniture (picked over betterdeco — pick one; rechiseled +
diagonal-fences + skniros-furniture also required client-side — in the
Prism pack; macaws x4 + friends-and-foes + chefs-delight + crate-delight
are client-required per Modrinth too — players must install them); maps: bluemap (:8100 3D web map),
pl3xmap (:8080 2D web map) — configs persisted in ./bluemap, ./Pl3xMap.
(modernfix skipped: no MC 26.2 build — latest supports 26.1.2.)

Client-only (in the Prism zip, NOT on the server; 11 entries):
sodium, sodium-extra, iris, reeses-sodium-options, rei, immediatelyfast,
entityculling, inventory-sorter/profiles-next/management, mouse-tweaks.
Don't add these to `MODRINTH_PROJECTS`.

Client-required (in BOTH compose and the Prism zip — players must install;
part of the 42 pinned entries): natures-compass, explorers-compass,
travelersbackpack.

Client-only extras (Prism zip only; part of the 48 pinned entries):
xaeros-minimap, xaeros-world-map, shulkerboxtooltip, chat-heads,
moreculling — moreculling bundles with entityculling + immediatelyfast as
the client perf pack.

> Next: simple-voice-chat — HELD for a separate test pass (needs a UDP
> port exposed + both-side install). Not in compose or the pack yet.

> Worldgen caveat: terralith/tectonic/incendium/nullscape only affect
> FRESH chunks — the existing world keeps old terrain, so expect visible
> chunk borders where new meets old. Recommend Chunky pregen for new areas
> (`chunky radius 5000 world`, `chunky start`) before exploring far.

## Run the server

```sh
cp mc-fabric/.env.example /root/mc-fabric/.env  # fill in real secrets
docker compose -f /root/mc-fabric/docker-compose.yml up -d
```
