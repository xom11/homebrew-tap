class Beckon < Formula
  desc "Cross-platform focus-or-launch app switcher"
  homepage "https://github.com/xom11/beckon"
  version "0.2.1"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "fd68aa226f02accc820c5e889b8cca775978b9bad059e1f0a37917ebb66fc5a9"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "67d5593e73e39eac504a1042e041ca374aa42a5955286780b4af4a3957ad2dfc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3dc7a342f35fca898f222b263f244a97ab9adadff4934605c615cbab3885c2f5"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4c95674451752cff2ec82b8673b0adce7578a9f5b9d86a1b0d00fbb22fe11dfd"
    end
  end

  def install
    bin.install "beckon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/beckon --version")
  end
end
