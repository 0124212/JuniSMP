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

Server (`MODRINTH_PROJECTS` in compose, auto-downloaded on boot) = all
worldgen/structure/food/server mods: fabric-api, luckperms, chunky,
lithium, ferrite-core, skill-proficiencies, krypton, farmers-delight +
ubes/rustic/spanish/more delights, harvest-simplified, appleskin,
dungeons-and-taverns, towns-and-towers, explorify, repurposed-structures,
explorations, waystones, veinminer, fallingtree, adorn, macaws-furniture,
blockus, modern-decorations-mod, additional-lanterns, macaws-lights.

Client-only (in the Prism zip, NOT on the server): sodium, sodium-extra,
iris, rei, immediatelyfast, entityculling, inventory-sorter/profiles-next/
management. Don't add these to `MODRINTH_PROJECTS`.

## Run the server

```sh
cp mc-fabric/.env.example /root/mc-fabric/.env  # fill in real secrets
docker compose -f /root/mc-fabric/docker-compose.yml up -d
```
