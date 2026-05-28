class Beckon < Formula
  desc "Cross-platform focus-or-launch app switcher"
  homepage "https://github.com/xom11/beckon"
  version "0.2.2"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "0d3b51dab8965ea0fd4734559a9537f5d511882856925bd3bb3f8e619c2396e6"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "e7babcbb3db081693e4d747c0dfd693c26295570b87094da8593a13ec4dd5fa8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "68dd46e260e371b979776526ae7f688bf30f115bd3e79869317a2f549a54b2bc"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "38f17ba7c2186b90f0fe42afe2824540f54f01f174f4e7b22070468f3d1caacc"
    end
  end

  def install
    bin.install "beckon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/beckon --version")
  end
end
