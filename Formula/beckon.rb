class Beckon < Formula
  desc "Cross-platform focus-or-launch app switcher"
  homepage "https://github.com/xom11/beckon"
  version "0.9.0"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "6bb9df6ae14f93d4062764800d3afc146c49a8b036409defe1bc9c49ef3e17a0"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "2fd1d7501689e5cf62d55ddd15d082ce5e974e59a485d2066c3cf541a5af5e45"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a5f61772613487a5926e203e2b4476aea77f27a147304f7eda4f8375206ba4c8"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bc773f1da2d8769cc26dd53694d36aae84fc71eb0135fd9828b46e2ea16c2035"
    end
  end

  def install
    bin.install "beckon"
  end

  # `serve` (the resident hotkey host) exists only on macOS and Windows; on
  # Linux the compositor owns the keybind, so there is deliberately no service
  # there. `OS.mac?` is evaluated when the formula is loaded, so on Linux no
  # service is registered at all and beckon never appears in
  # `brew services list`.
  #
  # Do NOT nest this in `on_macos do` — `brew style` and `brew audit --strict`
  # both reject that outright ("on_macos cannot include service"), and no
  # formula in homebrew-core does it. Do NOT "simplify" it to `run macos:`
  # either: that leaves `service?` true on Linux, so `brew services start`
  # there fails with "has not implemented #plist, #service or provided a
  # locatable service file" — a broken service instead of no service.
  #
  # `log_path` uses `var`, not `Dir.home`: Homebrew creates a referenced
  # `#{var}/log` directory at install time and gives a home-relative path no
  # such treatment, which would leave launchd failing to open it in silence.
  if OS.mac?
    service do
      run [opt_bin/"beckon", "serve", "#{Dir.home}/.config/beckon/apps.toml"]
      keep_alive true
      process_type :interactive
      log_path var/"log/beckon.log"
      error_log_path var/"log/beckon.log"
    end
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      Resident hotkey mode reads a shortcuts file. Create and validate it
      BEFORE starting the service — keep_alive restarts a serve that cannot
      read its config every ~10 seconds, forever:

        mkdir -p ~/.config/beckon
        printf '"ctrl+super+alt+t" = "kitty"\\n' > ~/.config/beckon/apps.toml
        beckon check ~/.config/beckon/apps.toml
        brew services start beckon

      Do not use `sudo brew services start`: that installs a LaunchDaemon,
      which has no window-server session, so hotkeys register and never fire.

      Focusing other apps needs Accessibility permission:
      System Settings -> Privacy & Security -> Accessibility.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/beckon --version")
  end
end
