# Changelog

Dated decision log for this repo and the live `junismp` deployment. For
current-state reference (what's installed and why), see `README.md`.

## 2026-10-19

- Removed `inventory-sorting` and `inventory-management` from the client
  pack — both overlapped with `inventory-profiles-next` on inventory
  sorting, and having more than one active at once meant multiple
  competing sort UIs in-game. `inventory-profiles-next` is the one that
  stayed: its sort/restock controls are a compact overlay icon built into
  every container GUI, rather than adding a separate UI element.
- Added `libipn` and `architectury-api` to the client pack — transitive
  dependencies of `inventory-profiles-next` and `rei` respectively that
  Prism's own dependency checker flagged as missing on import (`libipn`
  needs 6.9.0–6.10 exclusive, `architectury-api` needs 21.0.0+). Neither
  has a server-side equivalent.
- Fixed a world-breaking join error ("received N registry entries unknown
  to this client") caused by 5 server-side mods silently updating one
  release ahead of the pinned client pack on a routine pod restart —
  `modern-decorations-mod`, `double-doors`, `collective`,
  `friends-and-foes`, `farmers-delight-refabricated` were listed in
  `MODRINTH_PROJECTS` without explicit version pins, so itzg's downloader
  grabs "latest release" fresh on every boot. Pinned all 5 to the exact
  versions already baked into the client pack.
- Added a custom instance icon (`prism/junismp-earth.png`) to the Prism
  zip, picked up automatically by Prism Launcher on import.

## 2026-10-18

- Added `itzg/mc-backup` as a sidecar container on the `junismp` pod:
  RCON-coordinated (`save-off`/tar/`save-on`, no corruption risk from
  backing up a live world), daily (`BACKUP_INTERVAL=24h`), keeps the last
  7 (`PRUNE_BACKUPS_COUNT=7`), writing to a dedicated
  `junismp-backup-data` PVC separate from the world's own volume.
- Added `serene-seasons` (+ hard dependency `glitchcore`) and
  `vanilla-npcs` — requested: more Stardew-Valley-style cozy/farm-life
  feel, not just exploration/building. `fabric-seasons` was considered
  first (has first-party Terralith/Delight compat addons) but has no MC
  26.2 build. `vanilla-npcs` (customizable mannequins) is the closest
  available to NPC presence — not a true dialogue/relationship/gift
  system; nothing at that depth has a 26.2 build yet.
- Found and fixed a regression from the repo consolidation: the 16
  client-only QoL mods (Sodium, Iris, REI, inventory tools, Xaero's maps,
  etc.) got silently dropped when `mod-versions.json` was regenerated
  purely from the server's own mod list, which has no record of
  client-only mods at all. Re-added the same day.

## 2026-10-09

- First verified end-to-end boot of `mc-fabric/docker-compose.yml` —
  nobody had actually booted this file before; several entries would
  have failed immediately. `c2me-fabric`, `vmp-fabric`, `incendium`,
  `open-parties-and-claims` only publish alpha/beta builds for MC 26.2
  and needed explicit `slug:version` pins. 15 transitive dependencies
  required by Fabric's loader at boot weren't declared by Modrinth
  metadata for the mods that need them, so itzg's auto-resolver never
  pulled them in: `polymer`, `lithostitched`, `forge-config-api-port`,
  `puzzles-lib`, `collective`, `resourceful-lib`, `moogs-structure-lib`,
  `supermartijn642s-core-lib`, `delight-lib`,
  `supermartijn642s-config-lib`, `fusion-connected-textures`,
  `cristel-lib`, `fabric-language-kotlin`, `balm`, `shogi`.
- Dropped `pl3xmap` — junilab is only 2 vCPU, running two full map
  renderers simultaneously was pure redundant CPU contention with zero
  functional gain. `bluemap` kept as the more actively maintained of
  the two.
