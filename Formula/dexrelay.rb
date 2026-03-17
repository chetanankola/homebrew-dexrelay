class Dexrelay < Formula
  desc "DexRelay installer and CLI for the Codex Relay Mac runtime"
  homepage "https://assets.cankolabuilds.com/setup-guide.html"
  url "https://assets.cankolabuilds.com/install.sh"
  sha256 "d4c0f295f7e63a8c5dc296ae550892597854e0f0ed1f5141ecb87bab3dc0891d"
  version "0.1.0"

  depends_on "jq"
  depends_on "node"
  depends_on "python"

  resource "bridge.js" do
    url "https://assets.cankolabuilds.com/bridge.js"
    sha256 "3a6df9c1e72c01600f500970ef7016caf4b6431ad663ea8d32caf6d23c266f23"
  end

  resource "helper.py" do
    url "https://assets.cankolabuilds.com/helper.py"
    sha256 "2783f4a7d227d76db1290b14dca076ca4995740b79975d29393b0e3683fd93a2"
  end

  resource "package.json" do
    url "https://assets.cankolabuilds.com/package.json"
    sha256 "435266209d1bf19be7848462bab8250ae433d63c5bc750029ecfa483164d0323"
  end

  def install
    (libexec/"payload").mkpath
    mv "install.sh", libexec/"install.sh"

    resource("bridge.js").stage do
      (libexec/"payload").install "bridge.js"
    end

    resource("helper.py").stage do
      (libexec/"payload").install "helper.py"
    end

    resource("package.json").stage do
      (libexec/"payload").install "package.json"
    end

    (bin/"dexrelay").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail

      case "${1:-install}" in
        install)
          shift || true
          export CODEX_RELAY_LOCAL_PAYLOAD_ROOT="#{libexec}/payload"
          exec /bin/bash "#{libexec}/install.sh" "$@"
          ;;
        doctor)
          cat <<EOF
      DexRelay via Homebrew
      - formula version: #{version}
      - install script: #{libexec}/install.sh
      - payload root: #{libexec}/payload
      - runtime root: ${CODEX_RELAY_ROOT:-$HOME/src/CodexRelayBackendBootstrap}
      - bridge port: ${CODEX_RELAY_BRIDGE_PORT:-4615}
      - helper port: ${CODEX_RELAY_HELPER_PORT:-4616}
      EOF
          ;;
        version|-v|--version)
          echo "dexrelay #{version}"
          ;;
        help|-h|--help)
          cat <<'EOF'
      dexrelay

      Usage:
        dexrelay install
        dexrelay doctor
        dexrelay version
      EOF
          ;;
        *)
          echo "Unknown command: ${1}" >&2
          exit 1
          ;;
      esac
    EOS

    chmod 0755, bin/"dexrelay"
  end

  def caveats
    <<~EOS
      Finish setup with:
        dexrelay install
    EOS
  end

  test do
    assert_match "dexrelay #{version}", shell_output("#{bin}/dexrelay version")
  end
end
