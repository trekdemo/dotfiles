# Install config files

By running the `make install`.

## Manual steps

- [ ] Import the GPG key to be able to sign commits
- [ ] [Create a new GitHub PAT][1] to manage Git and GitHub
- [ ] Add GitHub PAT to the ~/.bundle/config (So I can access private gems from GitHub)

[1]: https://github.com/settings/tokens

## Linux devcontainers and devpods

macOS uses the Makefile above. Linux uses `install.sh`, which links a subset of
the configs (zsh, git, gh, neovim, lazygit, herdr, hunk, yazi, and the Claude
agents/commands/skills), installs the tools they need through `mise`, and
pre-installs the NeoVim plugins.

DevPod clones the repo to `~/dotfiles` and runs `./install.sh` once when the
workspace is created (after the monolith's on-create hook, so the git identity
and `gh` credential helper it configured are kept). Point a new devpod at it with:

```sh
DPOD_DOTFILES_URL=trekdemo/dotfiles dpod up ...
```

Dotfiles are installed at create time only. To pick up changes on an existing
workspace, `cd ~/dotfiles && git pull && ./install.sh`.
