#!/bin/sh
# Run inside a disposable Linux container, never on a real user's home.
set -eu
source_dir=$(CDPATH='' cd -- "$(dirname "$0")/.." && pwd)
mkdir -p "$HOME/.config/zsh" "$HOME/.config/nvim"
printf 'original zshrc\n' > "$HOME/.zshrc"
printf 'preserve me\n' > "$HOME/.config/zsh/secrets.zsh"
printf 'original init\n' > "$HOME/.config/nvim/init.lua"
sh "$source_dir/install.sh" --local "$source_dir" --no-chsh
PATH="$HOME/.local/bin:$PATH"
export PATH
test -f "$HOME/.config/nvim/lazy-lock.json"
test ! -e "$HOME/.config/zsh/secrets.zsh"
backup=$(find "$HOME/.local/state" -path '*/zsh/secrets.zsh' | head -1)
test -n "$backup"
test "$(cat "$backup")" = 'preserve me'
zsh -ic '[[ $EDITOR == nvim && $VISUAL == nvim ]] || exit 1; (( $+functions[mkcd] && $+functions[fh] )) || exit 1; [[ $(bindkey -M viins kj) == *vi-cmd-mode* ]]'
VM_SETUP_VERIFY="$source_dir/scripts/verify-nvim.lua" nvim --headless '+lua dofile(vim.env.VM_SETUP_VERIFY)' +qa
# A rerun must preserve the previous config and any VM-local private file too.
printf 'local only\n' > "$HOME/.config/zsh/secret.zsh"
sh "$source_dir/install.sh" --local "$source_dir" --no-sync
test "$(getent passwd "$(id -un)" | cut -d: -f7)" = "$(command -v zsh)"
backup=$(find "$HOME/.local/state" -path '*/zsh/secret.zsh' | head -1)
test -n "$backup"
test "$(cat "$backup")" = 'local only'
test ! -e "$HOME/.config/zsh/secret.zsh"
printf '\nSmoke test passed.\n'
