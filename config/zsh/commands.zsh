mkcd() { mkdir -p -- "$1" && builtin cd -- "$1"; }
mc() { mkcd "$@"; }
fcd() {
  local dir
  dir=$(find "${1:-.}" -type d \( -name .git -o -name node_modules \) -prune -o -type d -print 2>/dev/null | fzf) || return
  [[ -n "$dir" ]] && builtin cd -- "$dir"
}
cdf() { fcd "$@"; }
cdpr() { fcd "${PROJECTS_DIR:-$HOME/pr}"; }
co() { "$EDITOR" "${XDG_CONFIG_HOME:-$HOME/.config}"; }
fh() {
  local selected
  selected=$(fc -rl 1 | fzf --no-sort | sed -E 's/^[[:space:]]*[0-9]+\*?[[:space:]]*//') || return
  [[ -n "$selected" ]] && print -z -- "$selected"
}
sf() {
  local file
  file=$(find "${1:-.}" -type f -not -path '*/.git/*' -not -path '*/node_modules/*' | fzf --preview 'bat --color=always --style=plain -- {}') || return
  [[ -n "$file" ]] && "$EDITOR" -- "$file"
}
sff() { sf "$@"; }
listports() { ss -tuln; }
disable_wrap() { print -n '\e[?7l'; }
enable_wrap() { print -n '\e[?7h'; }
