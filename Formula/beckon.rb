class Beckon < Formula
  desc "Cross-platform focus-or-launch app switcher"
  homepage "https://github.com/xom11/beckon"
  version "0.5.4"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "d2a872ecffd440855c8977181ff104cdc1ffdfb599676be42bd5f99323ca146b"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "02a9a5d90863d967feb93b01e66a7a18c7c31273b234d45be8be351240e43c87"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a309acfb1af41146f120231ac594ffda0800cc46ef26ec068d9d2da808b06973"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aeafad3ccf6302e0e9fa72a585952fa91180271d9b83e0f3f65a0cafe3fa7fe1"
    end
  end

  def install
    bin.install "beckon"
  end

  # `--serve` (the resident hotkey host) exists only on macOS and Windows; on
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
      run [opt_bin/"beckon", "--serve", "#{Dir.home}/.config/beckon/apps.toml"]
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
        beckon --check ~/.config/beckon/apps.toml
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
