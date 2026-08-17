class Beckon < Formula
  # 75 chars and no leading article: `brew audit` warns on both, and on a desc
  # that repeats the formula name. "focus-or-launch app switcher" was none of
  # those things and still failed the only test that matters — it reads as
  # jargon to anyone who has not already used beckon.
  desc "One key per app: launch, focus or cycle windows on macOS, Windows and Linux"
  homepage "https://github.com/xom11/beckon"
  version "0.9.15"
  license any_of: ["Apache-2.0", "MIT"]

  on_macos do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "3a2369d4f615d4be2b54961d3af7e703a3c6c021fbda21da0b668765f29a2a56"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-apple-darwin.tar.gz"
      sha256 "9b0242b119c3fcbbc93cc5b332dd50dfa74d407c7c121813b908949b14b32e7e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "584494e976fb1ae11f674fd562a1bc78edf68e5ff00527ae0d3e313e3edca64a"
    end
    on_intel do
      url "https://github.com/xom11/beckon/releases/download/v#{version}/beckon-#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a3718ea1c52d3590ab3636e759746adb3d6240d10e37ba91418a0ea7eb16ae77"
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
      # `--log` here is a DECLARATION, not a redirect: launchd already writes
      # this file through the two paths below, and beckon must not be a second
      # writer on the same fd. It is passed so the tray's `Open log` and the
      # System page's log row can be drawn at all -- without it beckon has no
      # way to learn where launchd put the file, and both were omitted over a
      # log that exists. Keep the three paths identical.
      run [opt_bin/"beckon", "serve", "#{Dir.home}/.config/beckon/apps.toml",
           "--log", var/"log/beckon.log"]
      # `successful_exit: false`, NOT `true`. Plain `keep_alive true` restarts
      # on ANY exit, including a clean one -- which silently undoes beckon's
      # own tray Quit. `beckon_macos::tray::request_quit` ends with
      # `std::process::exit(0)`, so launchd had the daemon back inside
      # `ThrottleInterval`, forever, and the menu item a user reaches for to
      # stop beckon did nothing they could see. Restart a crash; respect a
      # deliberate exit. The config-failure path below is unaffected: an
      # unreadable or missing file still exits non-zero, so launchd still
      # retries it.
      keep_alive successful_exit: false
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
