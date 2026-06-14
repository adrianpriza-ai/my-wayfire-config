# alps fish completion
# Install: alps completion fish > ~/.config/fish/completions/alps.fish

complete -c alps -f

complete -c alps -n '__fish_use_subcommand' -a 'help' -d 'show help'
complete -c alps -n '__fish_use_subcommand' -a 'aliases' -d 'show aliases'
complete -c alps -n '__fish_use_subcommand' -a 'config-show' -d 'show config'
complete -c alps -n '__fish_use_subcommand' -a 'version' -d 'show version'
complete -c alps -n '__fish_use_subcommand' -a 'repo' -d 'manage alps-more repo packages'
complete -c alps -n '__fish_use_subcommand' -a 'flatpak' -d 'manage flatpak packages'
complete -c alps -n '__fish_use_subcommand' -a 'install' -d 'install package'
complete -c alps -n '__fish_use_subcommand' -a 'remove' -d 'remove package'
complete -c alps -n '__fish_use_subcommand' -a 'purge' -d 'purge package and config'
complete -c alps -n '__fish_use_subcommand' -a 'update' -d 'update package lists'
complete -c alps -n '__fish_use_subcommand' -a 'upgrade' -d 'upgrade packages'
complete -c alps -n '__fish_use_subcommand' -a 'full-upgrade' -d 'full system upgrade'
complete -c alps -n '__fish_use_subcommand' -a 'search' -d 'search packages'
complete -c alps -n '__fish_use_subcommand' -a 'show' -d 'show package info'
complete -c alps -n '__fish_use_subcommand' -a 'list' -d 'list packages'
complete -c alps -n '__fish_use_subcommand' -a 'autoremove' -d 'remove unused packages'
complete -c alps -n '__fish_use_subcommand' -a 'autoclean' -d 'clean partial packages'
complete -c alps -n '__fish_use_subcommand' -a 'clean' -d 'clean package cache'
complete -c alps -n '__fish_use_subcommand' -a 'aur' -d 'manage AUR packages directly'

# top-level commands
# $t[1]=alps  $t[2]=cmd  $t[3]=subcmd  $t[4]=arg

# repo subcommands
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" repo; and test (count $t) -eq 2' \
    -a 'update list install remove purge search upgrade' -d 'repo subcommand'

# repo list sub-actions
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" repo; and contains -- "$t[3]" list ls; and test (count $t) -eq 3' \
    -a 'install remove' -d 'list action'

# repo install/search → alps-more packages
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" repo; and contains -- "$t[3]" install ins search se' \
    -a "(grep '^\[' /var/cache/alps/more/main.txt 2>/dev/null | tr -d '[]')" -d 'alps-more package'

# repo remove/purge/upgrade → installed alps-more packages
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" repo; and contains -- "$t[3]" remove rm purge pu upgrade ug' \
    -a "(jq -r 'keys[]' /var/lib/alps/installed.json 2>/dev/null)" -d 'installed alps-more package'

# aur subcommands
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" aur; and test (count $t) -eq 2' \
    -a 'install search list remove clean build-local fetch-abs' -d 'aur subcommand'

# aur install/search → pacman repo + AUR
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" aur; and contains -- "$t[3]" install ins search se' \
    -a "(pacman -Ssq 2>/dev/null)" -d 'repo package'
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" aur; and contains -- "$t[3]" install ins search se' \
    -a "(cat "$HOME/.cache/alps/aur-names.txt" 2>/dev/null)" -d 'AUR package'

# aur remove → AUR-installed packages
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" aur; and contains -- "$t[3]" remove rm' \
    -a "(pacman -Qm 2>/dev/null | awk '{print $1}')" -d 'AUR installed package'

# aur build-local / bl → directories
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" aur; and contains -- "$t[3]" build-local bl' \
    -a "(__fish_complete_directories)" -d 'directory'

# flatpak subcommands (fp alias included)
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" flatpak fp; and test (count $t) -eq 2' \
    -a 'install remove search list update' -d 'flatpak subcommand'

# snap subcommands (sk alias included)
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" snap sk; and test (count $t) -eq 2' \
    -a 'install remove search list update' -d 'snap subcommand'

# top-level install/search → all repo packages
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" install ins search se; and test (count $t) -eq 2' \
    -a "(pacman -Ssq 2>/dev/null)" -d 'package'

# top-level remove/purge → installed packages
complete -c alps -n 'set -l t (commandline -poc); contains -- "$t[2]" remove rm purge pu; and test (count $t) -eq 2' \
    -a "(pacman -Qq 2>/dev/null)" -d 'installed package'
