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
# Run outside the command buffer so unfinished input survives closing ranger.
_vm_ranger() {
  zle -I
  command ranger
  zle reset-prompt
}
zle -N _vm_ranger
bindkey -M viins '^o' _vm_ranger
bindkey -M vicmd '^o' _vm_ranger
bindkey -M emacs '^o' _vm_ranger
command -v zoxide >/dev/null && bindkey -s '^f' 'zi\n'
true
