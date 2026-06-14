oh-my-posh init fish --config /home/momoi/.config/fish/poshthemes/paradox1.omp.json | source
if status is-interactive
# Commands to run in interactive sessions can go here
end
alias debian-dev='podman start -ai debian-dev'
alias fedora-dev='podman start -ai fedora-dev'
alias ubuntu-dev-snap='podman exec -it ubuntu-dev-snap bash'


# Added by Antigravity CLI installer
set -gx PATH "/home/momoi/.local/bin" $PATH
