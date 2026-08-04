class FirstpassProxy < Formula
  desc "Drop-in, Anthropic-compatible LLM proxy that routes each request to the cheapest model that provably passes a quality gate, escalates on failure, and records a tamper-evident audit trace."
  homepage "https://dshakes.github.io/firstpass"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.3.0/firstpass-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "4944a9ec6f67bafff9deba89321c45c1c6cc1e02ae8626b2481638d37de5edb8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.3.0/firstpass-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "a6fe5a00383770eb2f7262727061683d0738fc77eb29495e831b462a86dce18a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.3.0/firstpass-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0ca7a403b76e4d25c9e774cc09f477cdfd1dcf189a85d73ce157e20fd600a905"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.3.0/firstpass-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "00879a92ab68ea5b4d199c8afc174d55942f172afbba488c2db29604c428885b"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "firstpass", "firstpass-proxy" if OS.mac? && Hardware::CPU.arm?
    bin.install "firstpass", "firstpass-proxy" if OS.mac? && Hardware::CPU.intel?
    bin.install "firstpass", "firstpass-proxy" if OS.linux? && Hardware::CPU.arm?
    bin.install "firstpass", "firstpass-proxy" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
