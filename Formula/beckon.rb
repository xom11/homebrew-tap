class Beckon < Formula
  desc "Cross-platform focus-or-launch app switcher"
  homepage "https://github.com/xom11/beckon"
  version "0.3.1"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "9504ed972ae387855af15aae6ad71768e9beff9cc57d6f20f629b93e9e7db0b3"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "cdfec6a8ad603b7d3dd4670f74fa6018abf94f52bd811db190fe6d70b3cd38e2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fdc6286da9a649a68ef11557caa98b4a26df4cf3beb729520347895f3fd59cc5"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e3ccb0f8421da8cd41fa260640e4aabfb5b505ea69ae9e64956ea6ebb3f5ba0e"
    end
  end

  def install
    bin.install "beckon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/beckon --version")
  end
end
