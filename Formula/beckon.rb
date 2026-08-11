class Beckon < Formula
  desc "Cross-platform focus-or-launch app switcher"
  homepage "https://github.com/xom11/beckon"
  version "0.7.0"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "a73a64139c0096ee5cdc77d24caf6ef0b5c8b10b39479aa1544b8c7f167cc773"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "457535d5e614ae7148ada007dd8fc456227504b1d1c5bfe1ec60e98274c0ba29"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "412c804b4e26e3c1421986b0666034c48bbca58527fb23d29b06080bd8b05213"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "45c1407af28274b2b9775cf6ccfab60c3cc8d3ed00c7c5139a5c62b2fe98a7e8"
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
