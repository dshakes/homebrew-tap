class FirstpassProxy < Formula
  desc "Drop-in, Anthropic-compatible LLM proxy that routes each request to the cheapest model that provably passes a quality gate, escalates on failure, and records a tamper-evident audit trace."
  homepage "https://dshakes.github.io/firstpass"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.6.0/firstpass-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "5f948d4650a9bf4381eb7ff6a2176383d78c55f79efa44b36cd1acbad8237e61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.6.0/firstpass-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "b46a463fef4f598e5f5b4d99ac49fffa46663bc54404bd9c6bb71b01efab46c5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.6.0/firstpass-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3953c099298fe5949d098b20a6bac067d81111416cbc5174a477d466bf5650b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.6.0/firstpass-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "179d3b19b03b7b7b62e1dc572d8e432c7566c51774a5ba0c41ba19a399f99469"
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
