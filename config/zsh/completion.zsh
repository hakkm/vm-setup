zmodload zsh/complist
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
# Use the installed tools' completions instead of stale generated scripts.
command -v kubectl >/dev/null && source <(kubectl completion zsh)
true
