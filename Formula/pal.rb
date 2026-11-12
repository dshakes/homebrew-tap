# Homebrew formula for the pal CLI (PAL Runtime). The release workflow pins
# url + sha256 on each tag and syncs this file into dshakes/homebrew-tap:
#
#   brew install dshakes/tap/pal
#
class Pal < Formula
  desc "CLI for PAL Runtime, the production runtime for AI agents"
  homepage "https://github.com/dshakes/pal"
  url "https://github.com/dshakes/pal/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "f87b902035a11ad85d41687d2af92af2d2cbb81954d6ffbd7d37d5be819f8bd7"
  license "Apache-2.0"
  head "https://github.com/dshakes/pal.git", branch: "master"

  depends_on "go" => :build

  def install
    cd "packages/cli" do
      system "go", "build", *std_go_args(output: bin/"pal", ldflags: "-s -w -X main.version=#{version}"), "./cmd/pal"
    end
  end

  test do
    system bin/"pal", "--version"
  end
end
