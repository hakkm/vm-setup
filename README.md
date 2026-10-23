# VM setup

My portable Zsh (Zap) and Neovim setup for fresh Linux VMs.

```sh
curl -fsSL https://raw.githubusercontent.com/hakkm/vm-setup/main/install.sh | sh
exec zsh
```

Run as the user you want to configure. The installer uses sudo for system
packages and changing the login shell. Running directly as root configures root.
Install `curl` first if your minimal image does not include it.

## What gets installed

- Zsh with Zap, supercharge, zap-prompt, autosuggestions, syntax highlighting,
  and completions. The prompt starts with `user@host` so each VM is recognizable.
- Your Vi mode (`kj` to leave insert mode), cursor shapes, timer, history search,
  Ctrl-E command editing, Ctrl-R fuzzy history, and Ctrl-V editor shortcut.
- Portable aliases, `mkcd`, `fcd`, `cdf`, `cdpr`, `sf`, and zoxide navigation.
  Package aliases follow the VM's package manager.
- Neovim **v0.12.6** with a lean editing config: Copilot, autopairs, surround,
  Telescope, nvim-tree, lualine, which-key, gitsigns, and the VS Code theme, pinned
  in `lazy-lock.json`. Official Linux tarballs are SHA-256 verified and installed
  under `~/.local/share/vm-setup`. Nothing is ever compiled: plugin build hooks,
  Luarocks, and Mason auto-installs are disabled. If the official binary cannot run
  (for example on Ubuntu 20.04's older glibc), Neovim is skipped, the existing
  editor config is left alone, and `vim` becomes `$EDITOR`. Alpine uses its native
  package and must provide Neovim 0.12 or newer.
- Git, Vim, Python, Node.js/npm, ripgrep, fd, fzf, ranger, bat, zoxide,
  man pages, and less. Debian's `batcat` and `fdfind` receive portable aliases.
  When an older Ubuntu release has no zoxide package, the installer uses a pinned,
  SHA-256-verified upstream musl binary. Existing npm installations (including
  NodeSource's bundled npm) are reused.

Targets: Debian/Ubuntu, Fedora, Arch, openSUSE, and Alpine. Other distributions
in those families are detected through `/etc/os-release`. The official Neovim
binary path supports x86_64 and arm64 and needs a compatible glibc. Arch installs
dependencies with `pacman -Syu`, including a full system upgrade to avoid a
partial upgrade. Package availability depends on the distro release/repositories.
The CI matrix exercises the named images on x86_64.

## Private and workstation-only settings

This repository is an explicitly selected snapshot, separate from my private
dotfiles and Neovim repositories. It includes no private Git history.
`config-manifest.txt` lists every publishable config file; the automated check
rejects extra files, symlinks, private paths, workstation paths, and common
credential formats. `.gitignore` also excludes private/runtime files.

Neither `secret.zsh` nor `secrets.zsh` is copied or sourced. Shell history,
completion caches, database connections, auth state, and environment files are
excluded. The Zsh loader names files explicitly and never sources a directory glob.

The VM export allowlist is `EDITOR`, `VISUAL`, `MANPAGER`, `PAGER`, and a portable
`~/.local/bin` PATH entry. History options are retained. Desktop apps, Warp hooks,
local SDKs, hardcoded home paths, language version managers, and service exports
are left out. `dotbare` is omitted because it manages private dotfiles.

Neovim is a trimmed copy of the existing config: language servers, completion,
debugging, Treesitter, and language-specific plugins are left out. Copilot requires
your own login (`:Copilot setup`). Comment toggling uses Neovim's built-in `gc`.
Nerd Font icons require a font on your **local terminal**, not on the VM.

## Backups and reruns

Before replacing `.zshrc`, the Zsh/Neovim config directories, or a local `nvim`
executable, the installer moves existing paths into a fresh directory:

```text
~/.local/state/vm-setup-backup.XXXXXXXX/<original absolute path>
```

Symlinks are backed up as symlinks. Private files inside an existing config
directory move into the local backup and remain private. Rerunning installs the
repository snapshot again; local config edits are preserved in the new backup.
Existing Neovim data/state are retained. Restore a config by moving its current
path aside and moving the corresponding backup path back to its original location.
System packages and plugin data are not removed by restoring configuration.

## Uninstall

```sh
curl -fsSL https://raw.githubusercontent.com/hakkm/vm-setup/main/uninstall.sh | sh
```

The installer records what it adds in `~/.local/state/vm-setup/install-record`:
packages that were missing beforehand, files it created, files it replaced, and
your previous login shell. `uninstall.sh` lists the planned changes, asks for
confirmation (`--yes` skips it), then removes only those packages and files,
moves the original files back, and resets the login shell. Packages and files that
were already on the VM are kept. `--keep-packages` leaves all packages installed.
Arch's `pacman -Syu` system upgrade cannot be undone. Backup directories stay in
place for you to delete after checking.

`XDG_CONFIG_HOME`, `XDG_DATA_HOME`, and `XDG_STATE_HOME` are respected; `.zshrc`
is installed in `$HOME`. Custom `ZDOTDIR` configurations need to source that file.

## Options and development

```sh
# Keep the current login shell:
curl -fsSL https://raw.githubusercontent.com/hakkm/vm-setup/main/install.sh | sh -s -- --no-chsh

# Defer Neovim plugin downloads until the first launch:
sh install.sh --local "$PWD" --no-chsh --no-sync

# Install a reviewed commit (use the same commit for bootstrap and payload):
ref=FULL_COMMIT_SHA
curl -fsSL "https://raw.githubusercontent.com/hakkm/vm-setup/$ref/install.sh" \
  | VM_SETUP_REF="$ref" sh

python3 scripts/check-public.py
docker run --rm -v "$PWD:/setup:ro" ubuntu:24.04 sh /setup/tests/smoke.sh
```

Plugin installation needs internet access to GitHub. `--no-sync` still installs Zap plugins, but defers Neovim plugins.
The downloaded Neovim release and Zap revision are pinned in `install.sh`;
Neovim plugin revisions are recorded in `config/nvim/lazy-lock.json`.

Upstream installation references: [Zap](https://github.com/zap-zsh/zap) and
[Neovim](https://neovim.io/doc/install/).
