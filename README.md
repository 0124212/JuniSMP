# JuniSMP modpack

Fabric SMP on **MC 26.2**, loader **0.19.5**, Java 25. Client packs ship as
Prism Import zips — grab the latest from **Releases** (v4.0: 43 mods).

## Layout

- `mc-fabric/docker-compose.yml` — server (`itzg/minecraft-server:java25`,
  survival/normal, 6G + Aikar flags, RCON on, playit.gg tunnel sidecar).
  Secrets via `.env` (see `mc-fabric/.env.example`) — never committed.
- `prism/` — Prism Launcher metadata for the client pack: `instance.cfg`
  (JuniSMP-v4, 4G), `mmc-pack.json` (MC + loader pins),
  `mod-versions.json` (pinned client mod list with hashes/sizes/URLs).
- Full zips (`JuniSMP-v2/v3/v4.zip`, `JuniSMP-prism.zip`) live as release
  assets, not in git (see `.gitignore`).

## Server vs client mods

Server (`MODRINTH_PROJECTS` in compose, auto-downloaded on boot; 38 mods) =
perf: fabric-api, lithium, ferrite-core, krypton, c2me-fabric, carpet,
spark, vmp-fabric, alternate-current, noisiumforked, ksyxis, servercore;
JVM: 6G Aikar flags + explicit `-Xms6G -Xmx6G -XX:+UseG1GC`;
properties: view-distance=7, simulation-distance=4, sync-chunk-writes=false,
max-chained-neighbor-updates=10000 (via itzg env vars, no extra files);
admin/world: luckperms, chunky, skill-proficiencies; food: farmers-delight +
ubes/rustic/spanish/more delights, harvest-simplified, appleskin; worldgen:
dungeons-and-taverns, towns-and-towers, explorify, repurposed-structures,
explorations; gameplay: waystones, veinminer, fallingtree; decoration:
adorn, macaws-furniture, blockus, modern-decorations-mod,
additional-lanterns, macaws-lights; maps: bluemap (:8100 3D web map),
pl3xmap (:8080 2D web map) — configs persisted in ./bluemap, ./Pl3xMap.
(modernfix skipped: no MC 26.2 build — latest supports 26.1.2.)

Client-only (in the Prism zip, NOT on the server; 34 pinned entries):
sodium, sodium-extra, iris, reeses-sodium-options, rei, immediatelyfast,
entityculling, inventory-sorter/profiles-next/management. Don't add these
to `MODRINTH_PROJECTS`.

## Run the server

```sh
cp mc-fabric/.env.example /root/mc-fabric/.env  # fill in real secrets
docker compose -f /root/mc-fabric/docker-compose.yml up -d
```
