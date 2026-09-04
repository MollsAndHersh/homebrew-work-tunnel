# Homebrew tap for Work Tunnel

Install **Work Tunnel** (the agent that lets you drive Claude Code — or any CLI/shell — on your own
Mac/Linux from a locked-down work browser) via Homebrew:

```sh
brew tap MollsAndHersh/work-tunnel
brew install work-tunnel
```

Homebrew may ask you to **trust this third-party tap** the first time:

```sh
brew trust mollsandhersh/work-tunnel
# …or skip the trust prompt by installing with the full path:
brew install MollsAndHersh/work-tunnel/work-tunnel
```

Then pair the machine and start the background agent:

```sh
work-tunnel pair --relay https://worktunnel.mollsandhersh.com   # prints a code; approve it at /activate
brew services start work-tunnel
```

Requires **tmux** (installed automatically as a dependency). The default tunnel program is Claude Code —
install `claude` separately if you want it. Binaries are hosted at
`https://worktunnel.mollsandhersh.com/downloads/`; the formula here just points at them.

More: https://worktunnel.mollsandhersh.com
