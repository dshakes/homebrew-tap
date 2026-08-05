class FirstpassProxy < Formula
  desc "Drop-in, Anthropic-compatible LLM proxy that routes each request to the cheapest model that provably passes a quality gate, escalates on failure, and records a tamper-evident audit trace."
  homepage "https://dshakes.github.io/firstpass"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.4.0/firstpass-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "ae402611f18fe2691acf7ba2e843cafa2d9bb81dec88ac5e733b76d11f088490"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.4.0/firstpass-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "32a24a61d8f2c71bf2c9291662f1524d42d15c319ff4e3c0abf3fc93627b1536"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.4.0/firstpass-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d98934b7ce38c1c5fc51617d06327da4d1efbefea797f3d0db48f5eb87dd97b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.4.0/firstpass-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d617f2f256389d2be4524ea674bbb7e55f9dc8edbfc939892b30837dc4639fd"
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
