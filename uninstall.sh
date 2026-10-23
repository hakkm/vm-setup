#!/bin/sh
# Undo install.sh: remove only what it added and restore the files it replaced.
set -eu

main() {
  assume_yes=0
  keep_packages=0
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -y|--yes) assume_yes=1; shift ;;
      --keep-packages) keep_packages=1; shift ;;
      -h|--help)
        printf '%s\n' 'Usage: sh uninstall.sh [--yes] [--keep-packages]' \
          'Removes files and packages recorded by install.sh, restores replaced files,' \
          'and resets the login shell. Packages that existed before install.sh are kept.'
        return ;;
      *) die "Unknown argument: $1" ;;
    esac
  done
  state_home=${XDG_STATE_HOME:-$HOME/.local/state}
  record=$state_home/vm-setup/install-record
  [ -f "$record" ] || die "No install record at $record; nothing to undo."
  privilege=
  [ "$(id -u)" -eq 0 ] || privilege=sudo
  packages=$(awk -F '\t' '$1 == "pkg" { printf "%s ", $2 }' "$record")
  [ "$keep_packages" -eq 0 ] || packages=
  log 'This will:'
  awk -F '\t' '
    $1 == "path" && $3 == "-" { print "  remove  " $2 }
    $1 == "path" && $3 != "-" { print "  restore " $2 }
    $1 == "shell" { print "  set login shell back to " $2 }' "$record"
  [ -z "$packages" ] || printf '  remove packages: %s\n' "$packages"
  if [ "$assume_yes" -eq 0 ]; then
    printf 'Continue? [y/N] '
    read -r answer </dev/tty
    case "$answer" in y|Y|yes|YES) ;; *) die 'Cancelled.' ;; esac
  fi
  # Restore the login shell first, while the original shell still exists.
  original_shell=$(awk -F '\t' '$1 == "shell" { print $2; exit }' "$record")
  if [ -n "$original_shell" ]; then
    $privilege chsh -s "$original_shell" "$(id -un)" || log "Could not reset login shell. Run: chsh -s $original_shell"
  fi
  # Later entries can live inside earlier ones; undo in reverse order.
  awk -F '\t' '$1 == "path" { print $2 "\t" $3 }' "$record" | sed -n '1!G;h;$p' |
    while IFS="$(printf '\t')" read -r target saved; do
      rm -rf "$target"
      if [ "$saved" != - ] && { [ -e "$saved" ] || [ -L "$saved" ]; }; then
        mkdir -p "$(dirname "$target")"
        mv "$saved" "$target"
      fi
    done
  if [ -n "$packages" ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    # shellcheck disable=SC2086
    case " $ID ${ID_LIKE:-} " in
      *' debian '*|*' ubuntu '*) $privilege env DEBIAN_FRONTEND=noninteractive apt-get remove -y $packages ;;
      *' fedora '*) $privilege dnf remove -y $packages ;;
      *' arch '*) $privilege pacman -Rs --noconfirm $packages ;;
      *' suse '*|*' opensuse '*|*' opensuse-tumbleweed '*|*' opensuse-leap '*) $privilege zypper --non-interactive remove $packages ;;
      *' alpine '*) $privilege apk del $packages ;;
    esac
  fi
  rm -rf "$state_home/vm-setup"
  log 'Uninstalled. Restart your shell.'
  log "Leftover backups (safe to delete once checked): $state_home/vm-setup-backup.*"
}

log() { printf '\n%s\n' "$*"; }
die() { printf 'Error: %s\n' "$*" >&2; exit 1; }

main "$@"
