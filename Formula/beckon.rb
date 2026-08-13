class Beckon < Formula
  desc "Cross-platform focus-or-launch app switcher"
  homepage "https://github.com/xom11/beckon"
  version "0.9.3"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "ecbe0937a04336a81c75f1fbe2cd5aba927406961d534d09ee46f70657e5acb4"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "31ddc787dc120f50c26be70060db0bf2f6945512dff19fc83fb5ae733a297ff0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ea8e3b35721d2f3169c1acf4ecbcb31b80a8d554761ba826d681c3a84e463ce3"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "108a8b8845ba0ca3c496d43a37886c55f5e39b0ec8191df7584003311d88f685"
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
