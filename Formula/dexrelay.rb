class Dexrelay < Formula
  desc "DexRelay installer and CLI for the Codex Relay Mac runtime"
  homepage "https://assets.cankolabuilds.com/setup-guide.html"
  url "https://assets.cankolabuilds.com/install.sh"
  sha256 "7ee8352de2e5bda341ed602421ff5dd2a12b55129bfd33e925b3d9dd8ed59210"
  version "0.1.2"

  depends_on "jq"
  depends_on "node"
  depends_on "python"

  resource "bridge.js" do
    url "https://assets.cankolabuilds.com/bridge.js"
    sha256 "91547a5640af9384b4348e2d7504f9abbaab82f1f1345bc70c0b377d8bc13261"
  end

  resource "helper.py" do
    url "https://assets.cankolabuilds.com/helper.py"
    sha256 "cc08feb0a0f58dff09037715182915b85068b6c6c3c63311e28b6183f0b863cc"
  end

  resource "package.json" do
    url "https://assets.cankolabuilds.com/package.json"
    sha256 "435266209d1bf19be7848462bab8250ae433d63c5bc750029ecfa483164d0323"
  end

  resource "create-mac-project.sh" do
    url "https://assets.cankolabuilds.com/create-mac-project.sh"
    sha256 "c56897dfa1454fd6b5cc2e388c61521624281b20c4d3dc00877deb8c856cd85c"
  end

  resource "git-project-automation.sh" do
    url "https://assets.cankolabuilds.com/git-project-automation.sh"
    sha256 "22adee936f1fdf73597d0412ee3b824621afc4f61b0e336ed5f74bdcedd78477"
  end

  resource "governancectl.py" do
    url "https://assets.cankolabuilds.com/governancectl.py"
    sha256 "19aef3fe0a9a0f9969051f792355c5c66af539f27702c65d481b33230a525a33"
  end

  resource "services.registry.json" do
    url "https://assets.cankolabuilds.com/services.registry.json"
    sha256 "1b459dbe5ae219cdc278eb1d0c086236ba28855edeb7223f20e57429f7dd026d"
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

    resource("create-mac-project.sh").stage do
      (libexec/"payload").install "create-mac-project.sh"
    end

    resource("git-project-automation.sh").stage do
      (libexec/"payload").install "git-project-automation.sh"
    end

    resource("governancectl.py").stage do
      (libexec/"payload").install "governancectl.py"
    end

    resource("services.registry.json").stage do
      (libexec/"payload").install "services.registry.json"
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
