# Homebrew formula for the Work Tunnel agent (WT-015) — GENERATED.
#
# This template is rendered by packaging/render-formula.sh (invoked by the release workflow,
# .github/workflows/release-agent.yml) with the version + per-arch sha256s from the built tarballs, then
# pushed to the tap repo MollsAndHersh/homebrew-work-tunnel as Formula/work-tunnel.rb. Do not hand-edit the
# tap's copy — edit this template. Placeholders: 0.7.0, 5c3fd21b7e1dda0514d04c590434f3802b7d2beeef05df56e24091c260402087, 92962cae0d3a62afd7104959c38b3c3d98c2300599eacb7dc8ff2434b381419d, a399b8bfa3b9121db5c612a4b8ec85548986c689c755df50d87f12e04591ea88.
class WorkTunnel < Formula
  desc "Drive Claude Code (or any CLI) on your own Mac/Linux from a locked-down work browser"
  homepage "https://worktunnel.mollsandhersh.com"
  version "0.7.0"
  # Proprietary — Molls and Hersh LLC. (Homebrew taps don't require an SPDX license.)

  # Tarballs are hosted on the public Work Tunnel download endpoint (the same host that serves /download's
  # installers), not GitHub Releases — the source repo is private, so its Release assets aren't anonymously
  # downloadable, whereas https://worktunnel.mollsandhersh.com/downloads/ is public. Refreshed per release by
  # packaging/publish-homebrew.sh.
  RELEASE = "https://worktunnel.mollsandhersh.com/downloads".freeze

  on_macos do
    on_arm do
      url "#{RELEASE}/work-tunnel-#{version}-osx-arm64.tar.gz"
      sha256 "5c3fd21b7e1dda0514d04c590434f3802b7d2beeef05df56e24091c260402087"
    end
    on_intel do
      url "#{RELEASE}/work-tunnel-#{version}-osx-x64.tar.gz"
      sha256 "92962cae0d3a62afd7104959c38b3c3d98c2300599eacb7dc8ff2434b381419d"
    end
  end

  on_linux do
    on_intel do
      url "#{RELEASE}/work-tunnel-#{version}-linux-x64.tar.gz"
      sha256 "a399b8bfa3b9121db5c612a4b8ec85548986c689c755df50d87f12e04591ea88"
    end
  end

  # tmux is the session substrate on macOS/Linux (one tmux session per tunnel; survives agent restarts).
  depends_on "tmux"

  def install
    # The AOT binary dlopen()s libporta_pty relative to its own directory, so keep them co-located in
    # libexec and expose the command via a symlink on PATH.
    libexec.install "work-tunnel"
    libexec.install Dir["libporta_pty.*"]
    bin.install_symlink libexec/"work-tunnel"
  end

  service do
    run [opt_bin/"work-tunnel"] # relay URL + device token are read from the secure store written by `work-tunnel pair`
    keep_alive true
    log_path var/"log/work-tunnel/agent.log"
    error_log_path var/"log/work-tunnel/agent.log"
  end

  def caveats
    <<~EOS
      (First time only) Homebrew may ask you to trust this third-party tap before installing:
        brew tap MollsAndHersh/work-tunnel
        brew trust mollsandhersh/work-tunnel   # or: brew install MollsAndHersh/work-tunnel/work-tunnel

      To connect this computer to Work Tunnel:

        1. Pair it (starts the device-authorization flow and prints a short code):
             work-tunnel pair --relay https://worktunnel.mollsandhersh.com
           Sign in at https://worktunnel.mollsandhersh.com/activate and approve the code.

        2. Start the background agent (and enable autostart on login):
             brew services start work-tunnel

      The default tunnel program is Claude Code — install `claude` separately if you haven't.
      Logs: #{var}/log/work-tunnel/agent.log
    EOS
  end

  test do
    # With no pairing on disk the agent exits 2 and tells the user to run `pair` — a dependency-free smoke test.
    output = shell_output("#{bin}/work-tunnel 2>&1", 2)
    assert_match "pair", output
  end
end
