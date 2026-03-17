class Dexrelay < Formula
  desc "DexRelay installer and CLI for the Codex Relay Mac runtime"
  homepage "https://assets.cankolabuilds.com/setup-guide.html"
  url "https://assets.cankolabuilds.com/install.sh"
  sha256 "2a537bd7ccc105c680d65cd0bf4be225231ddd748b3e87749345e55a27773704"
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
    sha256 "d3a46c967bb09557b3ee69c795ef172e0eefd3951a6f20e713e8f184d1a76a8f"
  end

  resource "package.json" do
    url "https://assets.cankolabuilds.com/package.json"
    sha256 "435266209d1bf19be7848462bab8250ae433d63c5bc750029ecfa483164d0323"
  end

  resource "create-mac-project.sh" do
    url "https://assets.cankolabuilds.com/create-mac-project.sh"
    sha256 "19e901529702f1232b9d8c019239eff8a0c30d23309ff4390081d958e7b8a0b4"
  end

  resource "git-project-automation.sh" do
    url "https://assets.cankolabuilds.com/git-project-automation.sh"
    sha256 "22adee936f1fdf73597d0412ee3b824621afc4f61b0e336ed5f74bdcedd78477"
  end

  resource "governancectl.py" do
    url "https://assets.cankolabuilds.com/governancectl.py"
    sha256 "448d4c1e631c3b75ca1a6e3c343cac7ebb665a406e7a525d4e220f1abd990c0a"
  end

  resource "services.registry.json" do
    url "https://assets.cankolabuilds.com/services.registry.json"
    sha256 "4c6123eced73d51e09c962971b91d356b78645b8bb61abf8c4c58b71cd895a3e"
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
