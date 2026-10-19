# JuniSMP modpack

Fabric SMP on **MC 26.2**, loader **0.19.5**, Java 25. Client packs ship as
Prism Import zips — grab the latest from **Releases** (103 pinned entries in
`prism/mod-versions.json`: 87 shared with the server + 16 client-only
QoL/performance additions, see below).

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
  (`deployment.yaml`, `service.yaml`, `service-bluemap.yaml`), pulled
  directly from the live cluster on junilab. RCON password is a real k8s
  Secret reference (`secretKeyRef`), never an inline value — safe to commit
  as-is. Re-pull with `kubectl get deploy/svc -n minecraft <name> -o yaml`
  after any live change (`kubectl patch`/`kubectl edit` don't update this
  file automatically — that's exactly how it drifted out of sync before).
- `mc-fabric/docker-compose.yml` — the ak test server
  (`itzg/minecraft-server:java25`, survival/normal, 6G + Aikar flags, RCON
  on, playit.gg tunnel sidecar). Secrets via `.env` (see
  `mc-fabric/.env.example`) — never committed.
- `prism/` — Prism Launcher metadata for the client pack: `instance.cfg`
  (JuniSMP, 4G), `mmc-pack.json` (MC + loader pins),
  `mod-versions.json` (pinned client mod list with hashes/sizes/URLs, built
  against junismp's live mod list).
- Full zips (`JuniSMP-v2/v3/v4.zip`, `JuniSMP-prism.zip`) live as release
  assets, not in git (see `.gitignore`). The old versioned local YAML
  snapshots (`junismp-v4.yaml*` and friends, on junilab's own disk) are
  retired now that this repo is the real source of truth — this repo wins
  any conflict with those.

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
(:8100 3D web map), config persisted in ./bluemap. **pl3xmap dropped 2026-10-09**
(junilab is only 2 vCPU — two full map renderers running simultaneously was
pure redundant CPU contention with zero functional gain; bluemap kept as the
more actively maintained of the two).
(modernfix skipped: no MC 26.2 build — latest supports 26.1.2.)

**Added 2026-10-18** (requested: more Stardew-Valley-style cozy/farm-life
feel — seasons + NPCs, not just exploration/building): `serene-seasons`
(26.2 builds beta-only, pinned `serene-seasons:beta`; `fabric-seasons` was
considered first — has first-party Terralith/Delight compat addons — but has
no 26.2 build at all, so it wasn't viable) + its hard dependency
`glitchcore` (also beta-only on 26.2, pinned `glitchcore:beta` — Fabric's own
loader error names the missing dependency directly, that's how this was
found); `vanilla-npcs` (customizable mannequins — the closest thing
available for NPC presence; note this is **not** a true Stardew-style
dialogue/relationship/gift system — nothing at that depth has a 26.2 build
yet, this is the honest ceiling right now, not a settled "good enough").

**Verified working end-to-end 2026-10-09** (prior to this, nobody had actually
booted this compose file — several entries would have failed immediately):
- `c2me-fabric`, `vmp-fabric`, `incendium`, `open-parties-and-claims` only
  publish alpha/beta builds for 26.2; `MODRINTH_PROJECTS` defaults to
  release-only, so each needs an explicit `slug:version` pin (already applied
  above). The README already flagged incendium and open-parties-and-claims as
  beta-only — the pins just weren't in the actual compose file.
- 15 transitive dependencies are hard-required by Fabric's loader at boot but
  aren't declared by Modrinth metadata for the mods above, so itzg's
  auto-resolver never pulls them: `polymer`, `lithostitched`,
  `forge-config-api-port`, `puzzles-lib`, `collective`, `resourceful-lib`,
  `moogs-structure-lib`, `supermartijn642s-core-lib`, `delight-lib`,
  `supermartijn642s-config-lib`, `fusion-connected-textures`, `cristel-lib`,
  `fabric-language-kotlin`, `balm`, `shogi`. All added to `MODRINTH_PROJECTS`.

Client-only (in the Prism zip, NOT on the server; 16 entries, part of the
103 pinned total): sodium, sodium-extra, iris, reeses-sodium-options, rei,
immediatelyfast, entityculling, inventory-sorting, inventory-profiles-next,
inventory-management, mouse-tweaks, xaeros-minimap, xaeros-world-map,
shulkerboxtooltip, chat-heads, moreculling — moreculling bundles with
entityculling + immediatelyfast as the client perf pack. Don't add these to
`MODRINTH_PROJECTS` (server side). **2026-10-18: these got silently dropped
when `mod-versions.json` was regenerated from the server's own mod list
during the repo consolidation — the server obviously doesn't need REI etc,
but the file is the CLIENT pack and needs them layered back on top. Re-added
same day; if `mod-versions.json` is ever rebuilt from the server list again,
remember this category has to be added back by hand, it has no server-side
equivalent to derive it from.** (`inventory-sorting` — not `inventory-sorter`,
the mod's actual Modrinth slug doesn't match its display name or jar
filename; verify by resolving the project ID from an existing `url` field,
not by guessing from the name, if this ever needs re-deriving.)

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
