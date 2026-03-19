class Dexrelay < Formula
  desc "DexRelay installer and CLI for the Codex Relay Mac runtime"
  homepage "https://assets.cankolabuilds.com/setup-guide.html"
  url "https://assets.cankolabuilds.com/install.sh"
  sha256 "15db54ebb134909fa0cc6b4c44b4c2b423e03d82ba83c4534fcf0e04e96be624"
  version "0.1.6"

  depends_on "jq"
  depends_on "node"
  depends_on "python"

  resource "bridge.js" do
    url "https://assets.cankolabuilds.com/bridge.js"
    sha256 "a6d292209ad29f9060bf7ccc4537c62839ece3537999960052b52309b0a4601a"
  end

  resource "helper.py" do
    url "https://assets.cankolabuilds.com/helper.py"
    sha256 "b0549f62a897b1bf5723031acbcd72c98c8a43ec6914de25e2cf8bbaf371d909"
  end

  resource "package.json" do
    url "https://assets.cankolabuilds.com/package.json"
    sha256 "435266209d1bf19be7848462bab8250ae433d63c5bc750029ecfa483164d0323"
  end

  resource "dexrelay" do
    url "https://assets.cankolabuilds.com/dexrelay"
    sha256 "170d00be07753cfc0cd4296698b47743bf10940e8ba7491729280be31fc8f9e8"
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

    resource("dexrelay").stage do
      (libexec/"payload").install "dexrelay"
    end

    (bin/"dexrelay").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      export CODEX_RELAY_INSTALL_SCRIPT="#{libexec}/install.sh"
      export CODEX_RELAY_LOCAL_PAYLOAD_ROOT="#{libexec}/payload"
      export CODEX_RELAY_CLI_VERSION="#{version}"
      exec "#{libexec}/payload/dexrelay" "$@"
    EOS

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

    chmod 0755, bin/"dexrelay"
    chmod 0755, libexec/"payload/dexrelay"
  end

  test do
    assert_match "dexrelay", shell_output("#{bin}/dexrelay version")
  end
end
