class FirstpassProxy < Formula
  desc "Drop-in, Anthropic-compatible LLM proxy that routes each request to the cheapest model that provably passes a quality gate, escalates on failure, and records a tamper-evident audit trace."
  homepage "https://dshakes.github.io/firstpass"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.2.0/firstpass-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "59b7c46b3432e3e67dc9928d22d3aa4e67129b3e99fae8f2a0975a834de15975"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.2.0/firstpass-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "edd190dfe2a1337fbf26399fde7f6619084c83bd30b47440eda2d56cf112ef70"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.2.0/firstpass-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "43fbd33a18c97f194b52fb1566dbe2251d8cce3427bc2520b1a648a24ab174f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.2.0/firstpass-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fef78da6d4488c60094f22d76099d0c005bb946b45dd119aab10cc7e16c1d0a5"
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
