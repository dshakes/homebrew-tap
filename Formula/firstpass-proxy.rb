class FirstpassProxy < Formula
  desc "Drop-in, Anthropic-compatible LLM proxy that routes each request to the cheapest model that provably passes a quality gate, escalates on failure, and records a tamper-evident audit trace."
  homepage "https://dshakes.github.io/firstpass"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.7.0/firstpass-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "6bbe0eea642db41f180b4cd967397b45a795a667bc2e960b5aa576c7bfe27009"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.7.0/firstpass-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "ed11da07c305abf5285338d2d76f9aff0a9ef51d9cf026fb2d034c4dbc101c6b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.7.0/firstpass-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0598c1f558c4c681e4d090d14dcedeb7f3db150d8cb91111f26df5abe0085280"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.7.0/firstpass-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "74fafca23927cf4626215403538c984946be867e1aef68e266fcd4335dff7fbd"
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
