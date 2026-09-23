#!/bin/sh
# Publishes sites/<id>.wasm as a new latest release, with the reader.json manifest the Pam theme
# polls. Filenames carry the module hash so clients only download modules that changed.
set -eu
cd "$(dirname "$0")"

# Parser versions of the Pam theme these modules work with; bump alongside PARSER_VERSION in
# ReaderWasmManager.kt when a module needs Kotlin changes.
VALID_VERSION='[1]'

out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT

sites='{}'
for wasm in sites/*.wasm; do
    id=$(basename "$wasm" .wasm)
    file="$id-$(sha256sum "$wasm" | cut -c1-12).wasm"
    cp "$wasm" "$out/$file"
    sites=$(printf '%s' "$sites" | jq --arg id "$id" --arg file "$file" '. + {($id): $file}')
done

jq -n --argjson v "$VALID_VERSION" --argjson sites "$sites" '{validVersion: $v, sites: $sites}' > "$out/reader.json"
cat "$out/reader.json"

tag=$(date -u +%Y%m%d-%H%M%S)
gh release create "$tag" "$out"/* --title "$tag" --notes "$(git log -1 --format=%s)"
