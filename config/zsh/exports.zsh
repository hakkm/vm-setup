export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'
export PAGER=less
typeset -U path PATH
path=("$HOME/.local/bin" $path)

mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=1000000
SAVEHIST=1000000
setopt append_history share_history hist_verify hist_save_no_dups hist_ignore_all_dups
