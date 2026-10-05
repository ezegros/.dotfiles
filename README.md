# .dotfiles

Config for fish, Neovim, Ghostty and herdr on macOS, plus the agent skills I use with Claude Code.

## Setup

Clone to `~/.dotfiles`. The setup script expects that path.

```bash
git clone git@github.com:ezegros/.dotfiles.git ~/.dotfiles
bash ~/.dotfiles/mac/setup
```

`mac/setup` installs Homebrew if it's missing, runs `brew bundle`, then runs every `*/install` script:

| Directory | Installs to |
|---|---|
| `fish` | `~/.config/fish`, plus the fisher plugins |
| `nvim` | `~/.config/nvim` |
| `ghostty` | `~/.config/ghostty` |
| `herdr` | `~/.config/herdr/config.toml` |
| `agents` | `~/.agents`, and links each skill into `~/.claude/skills` |
| `fonts` | copies MesloLGS into `~/Library/Fonts` |

The fish, nvim and ghostty scripts delete the existing config directory before linking this one. Back it up first if it isn't already in this repo.

## GPG

Setup doesn't touch GPG. After importing your key, run:

```bash
bash ~/.dotfiles/mac/gpg
```

It sets pinentry-mac as gpg-agent's pinentry and kills the running agent so the next one picks it up.

## Agent skills

Skills live in `agents/skills`. `agents/context` and `agents/skills-archive` are gitignored because they hold work material, so they only exist on the machine that created them.

## Not in the Brewfile

The Brewfile only has CLI tools. Install these yourself:

- [Ghostty](https://ghostty.org) and [OrbStack](https://orbstack.dev)
- [herdr](https://herdr.dev)
- [Go](https://go.dev/dl/), into `/usr/local/go`
- [Rust](https://www.rust-lang.org/tools/install)
- [Zig](https://ziglang.org/learn/getting-started/)
- SSH keys for [GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) and [GitLab](https://docs.gitlab.com/ee/user/ssh.html), and a [GPG key for signed commits](https://docs.github.com/en/authentication/managing-commit-signature-verification)
