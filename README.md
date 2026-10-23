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
  and completions.
- Your Vi mode (`kj` to leave insert mode), cursor shapes, timer, history search,
  Ctrl-E command editing, Ctrl-R fuzzy history, and Ctrl-V Neovim shortcut.
- Portable aliases, `mkcd`, `fcd`, `cdf`, `cdpr`, `sf`, and zoxide navigation.
  Package aliases follow the VM's package manager.
- Neovim **v0.12.6**, with your Lua config, plugins, keymaps, snippets, themes,
  and `lazy-lock.json`. Official Linux tarballs are SHA-256 verified and installed
  under `~/.local/share/vm-setup`; Alpine uses its native musl-compatible package
  and must provide Neovim 0.12 or newer.
- Git, C/C++ build tools, Python, Node.js/npm, ripgrep, fd, fzf, bat, zoxide,
  man pages, and less. Debian's `batcat` and `fdfind` receive portable aliases.

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

Neovim is a copy of the existing config, with snippets resolved relative to its
config directory and the Python debugger path pointing to Mason's debugpy
installation. Hop uses the public `smoka7/hop.nvim` fork at the same locked commit;
the original repository is unavailable. Blade's unused SSH submodule is disabled.
The Markdown preview build restores its generated lockfile so reruns stay clean;
folding skips unnamed buffers, and the statusline uses the current option format.
The installer restores plugins before loading the full editor configuration.
Copilot requires your own login (`:Copilot setup`). Language
servers are managed by Mason; external formatters, runtimes, debuggers, LaTeX/PDF
tools, and lazygit still need their corresponding packages when you use them.
Treesitter parsers are installed as needed with `:TSInstall`; automatic parser
installation stays disabled, as in the original configuration.
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

Plugin installation needs internet access to GitHub, GitLab, npm, and Mason's
package sources. `--no-sync` still installs Zap plugins, but defers Neovim plugins.
The downloaded Neovim release and Zap revision are pinned in `install.sh`;
Neovim plugin revisions are recorded in `config/nvim/lazy-lock.json`.

Upstream installation references: [Zap](https://github.com/zap-zsh/zap) and
[Neovim](https://neovim.io/doc/install/).
