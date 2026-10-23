export PAGER=less
typeset -U path PATH
path=("$HOME/.local/bin" $path)

if command -v nvim >/dev/null; then
  export EDITOR=nvim
  export MANPAGER='nvim +Man!'
else
  export EDITOR=vim
  export MANPAGER=less
fi
export VISUAL="$EDITOR"

mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt append_history share_history hist_verify hist_save_no_dups hist_ignore_all_dups
