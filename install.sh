#!/bin/sh
# POSIX entry point, including when invoked as curl ... | sh.
set -eu

main() {
  local_source=
  change_shell=1
  sync_plugins=1
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --local) [ "$#" -ge 2 ] || die '--local needs a repository path'; local_source=$2; shift 2 ;;
      --no-chsh) change_shell=0; shift ;;
      --no-sync) sync_plugins=0; shift ;;
      -h|--help)
        printf '%s\n' 'Usage: sh install.sh [--local PATH] [--no-chsh] [--no-sync]' \
          'Run as the user whose home should be configured (sudo is used for packages).' \
          'Existing configs are backed up. --no-sync defers Neovim plugin installation.'
        return ;;
      *) die "Unknown argument: $1" ;;
    esac
  done
  [ "$(uname -s)" = Linux ] || die 'This installer supports Linux VMs.'
  if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != root ]; then
    die 'Run without sudo; the installer elevates only package installation.'
  fi
  if [ -n "$local_source" ]; then
    local_source=$(cd "$local_source" && pwd)
    [ -f "$local_source/config/zshrc" ] || die 'Invalid local source.'
  fi
  privilege=
  if [ "$(id -u)" -ne 0 ]; then
    command -v sudo >/dev/null 2>&1 || die 'sudo or root is required to install packages.'
    privilege=sudo
    if ! sudo -n true 2>/dev/null; then
      # Read sudo's prompt from the terminal when the script itself arrives on stdin.
      # shellcheck disable=SC2024
      sudo true </dev/tty
    fi
  fi
  # Select from the distro identity, not whichever package manager happens to be on PATH.
  [ -r /etc/os-release ] || die 'Cannot identify Linux distribution.'
  # shellcheck disable=SC1091
  . /etc/os-release
  case " $ID ${ID_LIKE:-} " in
    *' debian '*|*' ubuntu '*) manager=apt ;;
    *' fedora '*) manager=dnf ;;
    *' arch '*) manager=pacman ;;
    *' suse '*|*' opensuse '*|*' opensuse-tumbleweed '*|*' opensuse-leap '*) manager=zypper ;;
    *' alpine '*) manager=apk ;;
    *) die "Unsupported distribution: $ID (supported: Debian/Ubuntu, Fedora, Arch, openSUSE, Alpine)" ;;
  esac
  log "Installing dependencies with $manager"
  case "$manager" in
    apt)
      $privilege apt-get update
      $privilege env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y zsh git curl ca-certificates tar gzip unzip build-essential python3 python3-venv nodejs ripgrep fd-find fzf bat less man-db util-linux passwd
      # NodeSource's nodejs package already includes npm and conflicts with apt's npm.
      if ! command -v npm >/dev/null 2>&1; then
        $privilege env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y npm
      fi
      # Ubuntu 20.04 has no zoxide package; install a verified upstream binary below.
      if apt-cache show zoxide >/dev/null 2>&1; then
        $privilege env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y zoxide
      fi ;;
    dnf)
      $privilege dnf install --setopt=install_weak_deps=False -y zsh git ca-certificates tar gzip unzip gcc gcc-c++ make python3 nodejs npm ripgrep fd-find fzf bat zoxide less man-db util-linux
      # Fedora images often already provide curl-minimal, which conflicts with curl.
      if ! command -v curl >/dev/null 2>&1; then $privilege dnf install -y curl; fi
      if ! command -v chsh >/dev/null 2>&1; then $privilege dnf install -y util-linux-user; fi ;;
    pacman)
      # A full upgrade avoids an unsupported Arch partial upgrade.
      $privilege pacman -Syu --needed --noconfirm zsh git curl ca-certificates tar gzip unzip base-devel python nodejs npm ripgrep fd fzf bat zoxide less man-db util-linux ;;
    zypper)
      $privilege zypper --non-interactive refresh
      $privilege zypper --non-interactive install zsh git curl ca-certificates tar gzip unzip gcc gcc-c++ make python3 nodejs npm ripgrep fd fzf bat zoxide less man util-linux shadow findutils ;;
    apk)
      $privilege apk add zsh git curl ca-certificates tar gzip unzip build-base python3 py3-pip nodejs npm ripgrep fd fzf bat zoxide less mandoc util-linux shadow neovim ;;
  esac
  work=$(mktemp -d)
  trap 'rm -rf "$work"' EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  if [ -z "$local_source" ]; then
    ref=${VM_SETUP_REF:-main}
    case "$ref" in *[!a-zA-Z0-9._/-]*|'') die 'Invalid VM_SETUP_REF' ;; esac
    curl -fL --retry 3 "https://codeload.github.com/hakkm/vm-setup/tar.gz/$ref" -o "$work/setup.tar.gz"
    mkdir "$work/source"
    tar -xzf "$work/setup.tar.gz" --strip-components=1 -C "$work/source"
    local_source=$work/source
  fi
  config_home=${XDG_CONFIG_HOME:-$HOME/.config}
  data_home=${XDG_DATA_HOME:-$HOME/.local/share}
  state_home=${XDG_STATE_HOME:-$HOME/.local/state}
  mkdir -p "$HOME/.local/bin" "$config_home" "$data_home" "$state_home"
  if ! command -v zoxide >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/zoxide" ]; then
    case "$(uname -m)" in
      x86_64) zoxide_arch=x86_64; zoxide_digest=2d93385b99f3e82cf2701609a1bffcad863fbeb75aa3fe7eb6be4d29be68b1ae ;;
      aarch64|arm64) zoxide_arch=aarch64; zoxide_digest=f1f16c5d6298d63dee467eedea1cdcd8490e43e493bea43acd416dc9033ef641 ;;
      *) die 'Upstream zoxide binaries support x86_64 and arm64 in this installer.' ;;
    esac
    log 'Installing zoxide v0.10.0 (verified SHA-256)'
    curl -fL --retry 3 "https://github.com/ajeetdsouza/zoxide/releases/download/v0.10.0/zoxide-0.10.0-$zoxide_arch-unknown-linux-musl.tar.gz" -o "$work/zoxide.tar.gz"
    printf '%s  %s\n' "$zoxide_digest" "$work/zoxide.tar.gz" | sha256sum -c -
    mkdir "$work/zoxide"
    tar -xzf "$work/zoxide.tar.gz" -C "$work/zoxide"
    "$work/zoxide/zoxide" --version >/dev/null
    backup "$HOME/.local/bin/zoxide"
    cp "$work/zoxide/zoxide" "$HOME/.local/bin/zoxide"
    chmod +x "$HOME/.local/bin/zoxide"
  fi
  if [ "$manager" != apk ]; then
    case "$(uname -m)" in
      x86_64) arch=x86_64; digest=474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87 ;;
      aarch64|arm64) arch=arm64; digest=8f1f64a0bdb97247034038c3823c6cbad5bdf9ecd5751b85494b71c3ee04c815 ;;
      *) die 'Neovim binaries support x86_64 and arm64 only.' ;;
    esac
    runtime=$data_home/vm-setup/nvim-v0.12.6-$arch
    mkdir -p "$(dirname "$runtime")"
    if [ ! -f "$runtime/share/nvim/runtime/filetype.lua" ] || ! "$runtime/bin/nvim" --version >/dev/null 2>&1; then
      log 'Installing Neovim v0.12.6 (verified SHA-256)'
      curl -fL --retry 3 "https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-linux-$arch.tar.gz" -o "$work/nvim.tar.gz"
      printf '%s  %s\n' "$digest" "$work/nvim.tar.gz" | sha256sum -c -
      tar -xzf "$work/nvim.tar.gz" -C "$work"
      # Ubuntu 20.04's glibc cannot run the official binaries. Build the same
      # pinned release locally, before replacing the user's editor configuration.
      if "$work/nvim-linux-$arch/bin/nvim" --version >/dev/null 2>&1; then
        backup "$runtime"
        mv "$work/nvim-linux-$arch" "$runtime"
      elif [ "$manager" = apt ]; then
        log 'Neovim binary is incompatible with this glibc; building v0.12.6 from source (this takes several minutes).'
        $privilege env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y cmake ninja-build gettext pkg-config
        git clone --depth 1 --branch v0.12.6 https://github.com/neovim/neovim.git "$work/neovim-source"
        [ "$(git -C "$work/neovim-source" rev-parse HEAD)" = 779c36969e31080503be2dfccbcc3f999e289606 ] || die 'Unexpected Neovim source revision.'
        backup "$runtime"
        (cd "$work/neovim-source" && CMAKE_BUILD_PARALLEL_LEVEL="${CMAKE_BUILD_PARALLEL_LEVEL:-2}" make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$runtime" install)
        "$runtime/bin/nvim" --version >/dev/null
      else
        die 'Neovim binary cannot run on this VM; a newer glibc may be required.'
      fi
    fi
    backup "$HOME/.local/bin/nvim"
    ln -s "$runtime/bin/nvim" "$HOME/.local/bin/nvim"
  fi
  PATH="$HOME/.local/bin:$PATH"
  export PATH
  nvim --headless -u NONE '+lua if vim.fn.has("nvim-0.12") == 0 then vim.cmd("cquit 1") end' +qa || die 'This config needs Neovim 0.12+. Upgrade your distro Neovim package.'
  # Debian calls these executables batcat/fdfind; normalize names for config/plugins.
  for pair in bat:batcat fd:fdfind; do
    name=${pair%:*}; alternate=${pair#*:}
    if ! command -v "$name" >/dev/null 2>&1 && command -v "$alternate" >/dev/null 2>&1; then
      ln -s "$(command -v "$alternate")" "$HOME/.local/bin/$name"
    fi
  done
  if [ ! -f "$data_home/zap/zap.zsh" ]; then
    git clone https://github.com/zap-zsh/zap.git "$work/zap"
    git -C "$work/zap" checkout --detach d8e74d3d97ded884d14079f98f0a328580e4f8dc
    backup "$data_home/zap"
    mv "$work/zap" "$data_home/zap"
  fi
  backup "$config_home/zsh"
  backup "$config_home/nvim"
  backup "$HOME/.zshrc"
  cp -R "$local_source/config/zsh" "$config_home/zsh"
  cp -R "$local_source/config/nvim" "$config_home/nvim"
  cp "$local_source/config/zshrc" "$HOME/.zshrc"
  log 'Installing Zap plugins'
  zsh -ic '(( $+functions[plug] )) || exit 1' </dev/null
  if [ "$sync_plugins" -eq 1 ]; then
    log 'Restoring Neovim plugins from lazy-lock.json'
    nvim --headless -u "$local_source/scripts/bootstrap-nvim.lua" +qa </dev/null
    VM_SETUP_VERIFY="$local_source/scripts/verify-nvim.lua" nvim --headless '+lua dofile(vim.env.VM_SETUP_VERIFY)' +qa </dev/null
  fi
  if [ "$change_shell" -eq 1 ]; then
    zsh_path=$(command -v zsh)
    user_name=$(id -un)
    current_shell=$(getent passwd "$user_name" | cut -d: -f7)
    if [ "$current_shell" != "$zsh_path" ]; then
      if ! $privilege chsh -s "$zsh_path" "$user_name"; then
        log "Could not change login shell. Run: chsh -s $zsh_path"
      fi
    fi
  fi
  log 'Done. Start your shell with: exec zsh'
  [ -z "${backup_root:-}" ] || log "Previous files: $backup_root"
}

log() { printf '\n%s\n' "$*"; }
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
backup() {
  target=$1
  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ -z "${backup_root:-}" ]; then
      backup_root=$(mktemp -d "${XDG_STATE_HOME:-$HOME/.local/state}/vm-setup-backup.XXXXXXXX")
    fi
    # Preserve the original absolute path under the backup root, including symlinks.
    saved=$backup_root$target
    mkdir -p "$(dirname "$saved")"
    mv "$target" "$saved"
  fi
}

# Read the whole script before any action, so downloads piped into sh are safe from truncation.
main "$@"
