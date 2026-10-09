#!/usr/bin/env bash
# Build the Prism Launcher import zip for JuniSMP.
#
# Single truth: prism/mod-versions.json (pinned mod list: file/version/size/url).
# Never commit the zip itself — it ships as a GitHub Release asset only (*.zip is gitignored).
#
# Usage:
#   prism/build-prism-zip.sh [--mods-dir DIR] [--out FILE] [--strict]
#
# Sources jars from DIR (default ./mods/, gitignored) plus manifest "url"
# downloads for anything missing; the source dir is never modified — everything
# is staged in a temp dir. --strict fails if any manifest jar is still missing
# (CI); without it, missing jars are warnings only (local dry-run with a subset).
#
# Zip layout (Prism import): mmc-pack.json + instance.cfg at root, mods/*.jar.
set -euo pipefail
cd "$(dirname "$0")/.."   # repo root

MODS_DIR="mods"
OUT="dist/JuniSMP-prism.zip"
STRICT=0
while [ $# -gt 0 ]; do
  case "$1" in
    --mods-dir) MODS_DIR="$2"; shift 2 ;;
    --out) OUT="$2"; shift 2 ;;
    --strict) STRICT=1; shift ;;
    *) echo "usage: $0 [--mods-dir DIR] [--out FILE] [--strict]" >&2; exit 1 ;;
  esac
done
case "$OUT" in /*) ;; *) OUT="$PWD/$OUT" ;; esac  # absolutize (we cd around below)

[ -f prism/mmc-pack.json ] || { echo "missing prism/mmc-pack.json" >&2; exit 1; }
[ -f prism/instance.cfg ] || { echo "missing prism/instance.cfg" >&2; exit 1; }
[ -d "$MODS_DIR" ] || { echo "missing mods dir: $MODS_DIR" >&2; exit 1; }

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir "$STAGE/mods"

# Stage exactly the manifest set: local jars where present, URL downloads for
# the rest (staging only — the source dir is never modified).
STRICT="$STRICT" STAGE="$STAGE" MODS_DIR="$MODS_DIR" python3 - <<'EOF'
import json, os, shutil, urllib.request
stage, strict, src = os.environ['STAGE'], os.environ['STRICT'] == '1', os.environ['MODS_DIR']
fails = []
man = json.load(open('prism/mod-versions.json'))
for slug, e in man.items():
    dest = os.path.join(stage, 'mods', e['file'])
    local = os.path.join(src, e['file'])
    if os.path.exists(local):
        shutil.copy(local, dest)
        assert os.path.getsize(dest) == e['size'], f"size mismatch (stale local jar?): {e['file']}"
        continue
    if 'url' not in e:
        fails.append(f"{slug}: {e['file']} (no url in manifest — add jar manually)")
        continue
    print(f"downloading {e['file']} ...")
    urllib.request.urlretrieve(e['url'], dest)
    assert os.path.getsize(dest) == e['size'], f"size mismatch: {e['file']}"
for f in fails:
    print(f"WARN missing: {f}")
exit(1 if strict and fails else 0)
EOF

mkdir -p "$(dirname "$OUT")"
rm -f "$OUT"
cp prism/mmc-pack.json prism/instance.cfg "$STAGE/"
(cd "$STAGE" && zip -q -r "$OUT" mmc-pack.json instance.cfg mods)

echo "--- $OUT ($(stat -c%s "$OUT") bytes) ---"
unzip -l "$OUT" | head -8
echo "jars in zip: $(unzip -l "$OUT" | grep -c '\.jar$') (manifest pins $(python3 -c "import json;print(len(json.load(open('prism/mod-versions.json'))))"))"
