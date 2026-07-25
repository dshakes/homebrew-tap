class FirstpassProxy < Formula
  desc "Drop-in, Anthropic-compatible LLM proxy that routes each request to the cheapest model that provably passes a quality gate, escalates on failure, and records a tamper-evident audit trace."
  homepage "https://dshakes.github.io/firstpass"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.2.4/firstpass-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "b7e1b3f2235bd0273b355f3e00a757eb4c05766aed63aff74a3437445a166862"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.2.4/firstpass-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "d550b9714effe5bd219d813b2d842b7d8288c55673679c6bc027fc5f87596f69"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.2.4/firstpass-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "584dbf41cdad0f126e342c483d855ee08f57e2e1ed332d35bdc7577c9e889973"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.2.4/firstpass-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "07cc33c26c9e1eac318b10bbd542b6876445dea90282250f86b01617c71c36f2"
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
