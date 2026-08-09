class Beckon < Formula
  desc "Cross-platform focus-or-launch app switcher"
  homepage "https://github.com/xom11/beckon"
  version "0.5.0"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "fe1db7b0c339b9dcccd78264b6604ac06f1d4eccac054b36a8ba4ca9956bdf6b"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "2489a11699a46af62a49a268799ecbb3c3e258e19b6dd956b1d153509f467646"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d8e3795b60b77504b9b9c0ffb90d4d831ca3f3b4fbdca7e08bdea62519f4237"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "255056f91cb534ca12d9045beab762e7447c1d987cd194aaf7e116c361952784"
    end
  end

  def install
    bin.install "beckon"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/beckon --version")
  end
end
