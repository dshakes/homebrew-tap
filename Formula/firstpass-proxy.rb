class FirstpassProxy < Formula
  desc "Drop-in, Anthropic-compatible LLM proxy that routes each request to the cheapest model that provably passes a quality gate, escalates on failure, and records a tamper-evident audit trace."
  homepage "https://dshakes.github.io/firstpass"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.9.0/firstpass-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "5bbbbf6f7e4f906d92ea1d9608749579b7f838f8b0b8d0c70dff8662ec976c84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.9.0/firstpass-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "3328cf4e631da670dd397a7958b7c823365413d1c1f6c6fc5b282091eb3fec8b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.9.0/firstpass-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6fd02047a52e2fa8d9fe33653ce68b6102a446d54e0ebe6bb580b78544c6720a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.9.0/firstpass-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "972d2dfbfdd9f2bf2c61384123b7471dcc0689b6076d933bc15e57ac4ed20b9c"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "firstpass", "firstpass-proxy"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "firstpass", "firstpass-proxy"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "firstpass", "firstpass-proxy"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "firstpass", "firstpass-proxy"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
