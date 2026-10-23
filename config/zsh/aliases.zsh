alias x='chmod +x'
alias nv='$EDITOR'
alias vi='$EDITOR'
alias ls='ls --color=auto'
alias ll='ls -lh'
alias lll='ls -lah'
alias grep='grep --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias df='df -h'
alias free='free -m'
alias psmem='ps auxf | sort -nr -k 4 | head -5'
alias pscpu='ps auxf | sort -nr -k 3 | head -5'
alias aliasrc='$EDITOR "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/aliases.zsh"'
alias alrc=aliasrc
alias al=aliasrc
alias exrc='$EDITOR "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/exports.zsh"'
alias nvrc='$EDITOR "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.lua"'
alias zshrc='$EDITOR "${XDG_CONFIG_HOME:-$HOME/.config}/zsh"'
if command -v bat >/dev/null; then
  alias cat='bat -n --pager less'
elif command -v batcat >/dev/null; then
  alias bat=batcat
  alias cat='batcat -n --pager less'
fi
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd=z
  alias zz='z -'
fi
# Package shortcuts follow the VM's package manager.
if command -v apt-get >/dev/null; then
  alias i='sudo apt-get install' u='sudo apt-get update && sudo apt-get upgrade'
  alias r='sudo apt-get remove' q='apt-cache search' c='sudo apt-get autoremove'
elif command -v dnf >/dev/null; then
  alias i='sudo dnf install' u='sudo dnf upgrade --refresh'
  alias r='sudo dnf remove' q='dnf search' c='sudo dnf autoremove'
elif command -v pacman >/dev/null; then
  alias i='sudo pacman -S' u='sudo pacman -Syu'
  alias r='sudo pacman -Rns' q='pacman -Ss'
elif command -v zypper >/dev/null; then
  alias i='sudo zypper install' u='sudo zypper update'
  alias r='sudo zypper remove' q='zypper search'
elif command -v apk >/dev/null; then
  alias i='sudo apk add' u='sudo apk upgrade'
  alias r='sudo apk del' q='apk search'
fi
command -v kubectl >/dev/null && alias k=kubectl
command -v lazygit >/dev/null && alias lg=lazygit
command -v lazydocker >/dev/null && alias lk=lazydocker
# Keep optional tools from making the source command return failure.
true
