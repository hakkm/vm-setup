#!/bin/sh
# Run inside a disposable Linux container, never on a real user's home.
set -eu
source_dir=$(CDPATH='' cd -- "$(dirname "$0")/.." && pwd)
# Any attempted native compilation is a failure, including plugin build hooks.
guard=$(mktemp -d)
trap 'rm -rf "$guard"' EXIT
export VM_BUILD_LOG="$guard/build-attempts"
for tool in make cmake ninja cc gcc c++ g++ clang cargo rustc; do
  # shellcheck disable=SC2016 # expanded later by the shim
  printf '#!/bin/sh\nprintf "build attempted: %%s\\n" "$0" >> "$VM_BUILD_LOG"\nexit 97\n' > "$guard/$tool"
  chmod +x "$guard/$tool"
done
PATH="$guard:$PATH"
export PATH
mkdir -p "$HOME/.config/zsh" "$HOME/.config/nvim"
printf 'original zshrc\n' > "$HOME/.zshrc"
printf 'preserve me\n' > "$HOME/.config/zsh/secrets.zsh"
printf 'original init\n' > "$HOME/.config/nvim/init.lua"
sh "$source_dir/install.sh" --local "$source_dir" --no-chsh
PATH="$HOME/.local/bin:$PATH"
export PATH
expected_editor=vim
if [ -f "$HOME/.config/nvim/lazy-lock.json" ]; then
  expected_editor=nvim
  VM_SETUP_VERIFY="$source_dir/scripts/verify-nvim.lua" nvim --headless '+lua dofile(vim.env.VM_SETUP_VERIFY)' +qa
else
  test "$(cat "$HOME/.config/nvim/init.lua")" = 'original init'
  test ! -e "$HOME/.local/bin/nvim"
fi
export VM_EXPECTED_EDITOR="$expected_editor"
test ! -e "$HOME/.config/zsh/secrets.zsh"
backup=$(find "$HOME/.local/state" -path '*/zsh/secrets.zsh' | head -1)
test -n "$backup"
test "$(cat "$backup")" = 'preserve me'
zsh -ic '[[ $EDITOR == $VM_EXPECTED_EDITOR && $VISUAL == $VM_EXPECTED_EDITOR ]] || exit 1; (( $+functions[mkcd] && $+functions[fh] )) || exit 1; [[ $(bindkey -M viins kj) == *vi-cmd-mode* ]]'
# A rerun must preserve the previous config and any VM-local private file too.
printf 'local only\n' > "$HOME/.config/zsh/secret.zsh"
sh "$source_dir/install.sh" --local "$source_dir" --no-sync
test "$(getent passwd "$(id -un)" | cut -d: -f7)" = "$(command -v zsh)"
backup=$(find "$HOME/.local/state" -path '*/zsh/secret.zsh' | head -1)
test -n "$backup"
test "$(cat "$backup")" = 'local only'
test ! -e "$HOME/.config/zsh/secret.zsh"
test ! -e "$VM_BUILD_LOG"
if [ "$expected_editor" = vim ]; then
  test "$(cat "$HOME/.config/nvim/init.lua")" = 'original init'
fi
# Uninstall must undo only the installer's work and bring back the originals.
sh "$source_dir/uninstall.sh" --yes
test "$(cat "$HOME/.zshrc")" = 'original zshrc'
test "$(cat "$HOME/.config/zsh/secrets.zsh")" = 'preserve me'
test "$(cat "$HOME/.config/nvim/init.lua")" = 'original init'
test ! -e "$HOME/.local/bin/nvim"
test ! -e "${XDG_DATA_HOME:-$HOME/.local/share}/zap"
test ! -e "${XDG_DATA_HOME:-$HOME/.local/share}/vm-setup"
test ! -e "${XDG_STATE_HOME:-$HOME/.local/state}/vm-setup"
# Packages present before install stay; packages it added go.
hash -r
command -v tar >/dev/null
if command -v zsh >/dev/null; then exit 1; fi
printf '\nSmoke test passed (no source builds, clean uninstall).\n'
