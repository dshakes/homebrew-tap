class FirstpassProxy < Formula
  desc "Drop-in, Anthropic-compatible LLM proxy that routes each request to the cheapest model that provably passes a quality gate, escalates on failure, and records a tamper-evident audit trace."
  homepage "https://dshakes.github.io/firstpass"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.8.2/firstpass-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "976a6edf87ba676f3cb69bb5334d2c70f69e87953bfb75b4a2e98ae4000dd754"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.8.2/firstpass-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "5d7fe31caa4df84cfb307d87b562ab6396f45ef139b8c62da33c0483fb80c0c9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.8.2/firstpass-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7b4bc23051a395f2379ab1557355228a8da732e2fd4cb7d1fd7e746085255d4b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.8.2/firstpass-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d3ace78d2da88342a8b6dd4d7fac98a0159d49162c806c30bbd351cbd0f07c0d"
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
