# xom11 Homebrew tap

Tap for [xom11](https://github.com/xom11) tools.

## Usage

```sh
brew tap xom11/tap
brew install beckon
# or, without tapping first:
brew install xom11/tap/beckon
```

## Available formulae

- [beckon](https://github.com/xom11/beckon) — cross-platform focus-or-launch app switcher

## Auto-generated

This repo is updated automatically by the
[`bump-packagers.yml`](https://github.com/xom11/beckon/blob/main/.github/workflows/bump-packagers.yml)
workflow in `xom11/beckon` on every release. Do not hand-edit `Formula/*.rb`
— changes will be overwritten by the next release.

The workflow authenticates via the fine-grained PAT stored in repo secret
`PACKAGER_TOKEN` on `xom11/beckon`. Scope: `Contents: write` on this repo
and `xom11/scoop-bucket` only. Renew before expiry (default 90 days).
