# Homebrew DexRelay

This folder contains the tap-ready Homebrew formula for `dexrelay`.

Recommended install flow:

```bash
brew install chetanankola/dexrelay/dexrelay && dexrelay install
```

What the formula installs:

- `dexrelay` CLI in Homebrew `bin`
- local installer payload in Homebrew `libexec`
- dependencies: `node`, `python`, `jq`

What `dexrelay install` does:

- reuses the same DexRelay installer logic as the Cloudflare bootstrap script
- installs the isolated runtime in `~/src/CodexRelayBackendBootstrap`
- installs the bootstrap relay on port `4615`
- installs the setup helper on port `4616`
- writes the user LaunchAgents and starts them

Publishing notes:

1. Host the current payload files on `https://assets.cankolabuilds.com/`
2. Update checksums in `Formula/dexrelay.rb` when those payload files change
3. Push this formula into the tap repo that users will run `brew tap` against
