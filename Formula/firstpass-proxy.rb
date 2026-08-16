class FirstpassProxy < Formula
  desc "Drop-in, Anthropic-compatible LLM proxy that routes each request to the cheapest model that provably passes a quality gate, escalates on failure, and records a tamper-evident audit trace."
  homepage "https://dshakes.github.io/firstpass"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.8.1/firstpass-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "d15ea3821e30aa6437ebc55aa271094c95de919acfa394a25107fd9912476b96"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.8.1/firstpass-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "a3e9bab8026578537cb3edad340ce2f574fdc64e2239d499cb68806b2bf18f4d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.8.1/firstpass-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4e03e4aa26c502ebc3cc8717d4a7936b327bca4ac38ec9ea2eb09209ad796d50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.8.1/firstpass-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "528aaf543970d0ffb1c195dd602400e55be104ec17430fe10d247ed725e91a53"
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
