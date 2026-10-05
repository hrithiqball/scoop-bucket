# hrithiqball/scoop-bucket

[Scoop](https://scoop.sh) manifests for [Tridennote](https://github.com/hrithiqball/tridennote-tui).

```powershell
scoop bucket add tridennote https://github.com/hrithiqball/scoop-bucket
scoop install tridennote
```

`bucket/tridennote.json` is regenerated from the latest GitHub release's `checksums.txt` by
`scripts/update-manifest.sh`. The **Update manifest** workflow runs it every 6 hours, on
demand (`gh workflow run update-manifest.yml -R hrithiqball/scoop-bucket`), or when it
receives a `tridennote-release` repository dispatch. The manifest also carries `checkver`
and `autoupdate`, so Scoop's own tooling can bump it.
