class FirstpassProxy < Formula
  desc "Drop-in, Anthropic-compatible LLM proxy that routes each request to the cheapest model that provably passes a quality gate, escalates on failure, and records a tamper-evident audit trace."
  homepage "https://dshakes.github.io/firstpass"
  version "0.9.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.9.2/firstpass-proxy-aarch64-apple-darwin.tar.xz"
      sha256 "c10e4a549f3eb904a273942e2a5095c2ef0c634c187ca4e0863de947694cb2c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.9.2/firstpass-proxy-x86_64-apple-darwin.tar.xz"
      sha256 "263c1ff6dc855076d8242ce1307f5ec65056365d27172c68f6f40083a6eb3af0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dshakes/firstpass/releases/download/v0.9.2/firstpass-proxy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "39c2575fb5ae59b61e4985a0e448fc8d7c9b0776ff0026441c2d725b7df8c2db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dshakes/firstpass/releases/download/v0.9.2/firstpass-proxy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6bb2cb413e51d3fcf622e54e3562de485970cccb278c116dac8c815e1ca1efca"
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
