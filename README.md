# JuniSMP modpack

[![prism-release](https://github.com/0124212/JuniSMP/actions/workflows/prism-release.yml/badge.svg)](https://github.com/0124212/JuniSMP/actions/workflows/prism-release.yml)

Fabric SMP on **MC 26.2**, loader **0.19.5**, Java 25. Client packs ship as
Prism Import zips — grab the latest from **Releases** (103 pinned entries in
`prism/mod-versions.json`: 87 shared with the server + 16 client-only
QoL/performance additions, see below). See `CHANGELOG.md` for the dated
decision log behind the current mod list and infra.

## Join

- **Server:** `mc.junilab.xyz` — ping **@kutejuni** for whitelist.
- **Modpack:** [latest Prism Import zip](https://github.com/0124212/JuniSMP/releases/download/prism-latest/JuniSMP-prism.zip)
  — in Prism Launcher: **Add Instance → Import → From Zip**, paste that URL.
  Auto-rebuilt on every pack change, so this link is always current.
- **Live map:** `map.junilab.xyz` (3D, BlueMap) — behind the same login as
  the rest of junilab.xyz.

**Two live deployments, this repo is the single source of truth for both:**
- **junismp** (production, `mc.junilab.xyz`, what people actually play on) —
  runs via k3s on the `junilab` host, manifests in `junismp-k8s/`. The real
  mod list lives in `junismp-k8s/deployment.yaml`'s `MODRINTH_PROJECTS` env
  value — pulled fresh from the live cluster, not hand-maintained.
- **mc-fabric** (secondary/test, on `ak`) — plain `docker compose`,
  `mc-fabric/docker-compose.yml`. Smaller, separately-curated mod list; not
  guaranteed to match junismp's.
`prism/mod-versions.json` (the client pack) is built against **junismp's**
mod list specifically — that's the one players need to match.

## Layout

- `junismp-k8s/` — the production server's real k8s manifests
  (`deployment.yaml`, `service.yaml`, `service-bluemap.yaml`,
  `backup-pvc.yaml`), pulled directly from the live cluster on junilab.
  RCON password is a real k8s Secret reference (`secretKeyRef`), never an
  inline value — safe to commit as-is. Re-pull with
  `kubectl get deploy/svc -n minecraft <name> -o yaml` after any live change
  (`kubectl patch`/`kubectl edit` don't update this file automatically —
  that's exactly how it drifted out of sync before). Daily, auto-pruned
  world backups run as a sidecar (`itzg/mc-backup`) — see `CHANGELOG.md`
  for how it's configured.
- `mc-fabric/docker-compose.yml` — the ak test server
  (`itzg/minecraft-server:java25`, survival/normal, 6G + Aikar flags, RCON
  on, playit.gg tunnel sidecar). Secrets via `.env` (see
  `mc-fabric/.env.example`) — never committed.
- `prism/` — Prism Launcher metadata for the client pack: `instance.cfg`
  (JuniSMP, 4G, custom icon via `iconKey=junismp-earth`), `mmc-pack.json`
  (MC + loader pins), `mod-versions.json` (pinned client mod list with
  hashes/sizes/URLs, built against junismp's live mod list),
  `junismp-earth.png` (instance icon, picked up automatically by Prism on
  import since it sits at the zip root matching `iconKey`).
- Full zips (`JuniSMP-prism.zip`) live as release assets, not in git (see
  `.gitignore`).

## Rebuilding the Prism zip

`prism/mod-versions.json` is the single truth for the client pack. To rebuild:

```sh
prism/build-prism-zip.sh --mods-dir ./mods --out dist/JuniSMP-prism.zip
```

Missing jars with a manifest `url` are downloaded automatically; entries
without one must already sit in the mods dir (`--strict` turns gaps into a
failure — this is what CI uses). Every push to `prism/**` on main runs
`.github/workflows/prism-release.yml`, which rebuilds `--strict` and attaches
the zip to the rolling `prism-latest` release (`gh release`, no extra secrets).

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
are client-required per Modrinth too — players must install them); maps: bluemap
(:8100 3D web map, publicly at `map.junilab.xyz`), config persisted in
./bluemap (`pl3xmap` dropped — see `CHANGELOG.md`); seasons/npcs:
serene-seasons (+ hard dep glitchcore), vanilla-npcs.
(modernfix skipped: no MC 26.2 build — latest supports 26.1.2.)

Client-only (in the Prism zip, NOT on the server; 16 entries, part of the
103 pinned total): sodium, sodium-extra, iris, reeses-sodium-options, rei,
immediatelyfast, entityculling, inventory-profiles-next,
mouse-tweaks, xaeros-minimap, xaeros-world-map,
shulkerboxtooltip, chat-heads, moreculling, libipn, architectury-api —
moreculling bundles with entityculling + immediatelyfast as the client perf
pack; libipn/architectury-api are transitive deps of
inventory-profiles-next/rei (Prism's dependency checker flags these as
missing on import if absent). Don't add these to `MODRINTH_PROJECTS`
(server side) — they have no server-side equivalent to derive them from if
`mod-versions.json` is ever rebuilt from the server list again.

Client-required (in BOTH compose and the Prism zip — players must install):
natures-compass, explorers-compass, travelersbackpack.

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

## License

MIT for this repo's own files (manifests, scripts, configs) — see
`LICENSE`. Does not cover the third-party mods themselves; each is under
its own license on Modrinth.
