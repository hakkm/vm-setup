bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '^[[P' delete-char
bindkey '^p' up-line-or-beginning-search
bindkey '^ ' autosuggest-accept
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -s '^v' "${EDITOR}\n"
bindkey -s '^r' 'fh\n'
command -v zoxide >/dev/null && bindkey -s '^f' 'zi\n'
true
