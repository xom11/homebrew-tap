class Beckon < Formula
  desc "Cross-platform focus-or-launch app switcher"
  homepage "https://github.com/xom11/beckon"
  version "0.2.0"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "543acfd3da5fd89fdc05ad143f07f3c40db0974676f4d8257986e1e5fe8fa067"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "3f36bb05e20df973b08fee73319e2647dd1462ea2d71c91187a76c54bb0d5139"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fd9e05fe23500d7f0debbee73bfc1c7e73bef9b1ff1ed0525363396207d3c2e3"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1439df80c921d579e75ce40f6f135f7f88f8037023a2ec67cb8674f6e8992f59"
    end
  end

  def install
    bin.install "beckon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/beckon --version")
  end
end
