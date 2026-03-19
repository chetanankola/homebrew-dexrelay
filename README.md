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

Operational commands:

```bash
dexrelay status
dexrelay repair
dexrelay uninstall
```

- `status` reports launch agents, ports, Tailscale host, and helper health
- `repair` restarts the bridge/helper and falls back to a reinstall if needed
- `uninstall` removes the runtime, launch agents, logs, and Homebrew CLI

Publishing notes:

1. Run `./scripts/release-dexrelay.sh` from the main repo
2. Let that script upload the payload, update the checksums, push the tap repo, and run the brew smoke test
