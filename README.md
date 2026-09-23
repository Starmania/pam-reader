# pam-reader

Reader signer modules for the Pam multisrc theme of
[keiyoushi/extensions-source](https://github.com/keiyoushi/extensions-source).

Pam sites rebuild their reader's WASM signer often. The theme fetches the current module from the
latest release of this repo, so a rotation only needs a new release, not a new extension build.

## Layout

- `sites/<id>.wasm` - current module per site, `<id>` being the source's `readerId`.
- `release.sh` - publishes them as a release with a `reader.json` manifest:

```json
{ "validVersion": [1], "sites": { "epsilonsoft": "epsilonsoft-<sha256:12>.wasm" } }
```

`validVersion` lists the theme parser versions the modules work with. An extension whose
`PARSER_VERSION` is not listed keeps its cached or bundled module.

## Updating a site

1. Replace `sites/<id>.wasm` (see the theme's `IMPLEMENT.md`) and commit.
2. `./release.sh`
