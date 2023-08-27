in_nix_shell := env_var_or_default("IN_NIX_SHELL", "false")
root_dir := justfile_directory()

# choose a just command to run
default:
    @just --choose

# show available just commands
help:
    @just --list --unsorted --list-heading $'Available commands:\n'

_run cmd:
    #!/usr/bin/env -S sh -eu
    if [ "{{ in_nix_shell }}" = "false" ]; then
      nix-shell "{{ root_dir }}/shell.nix" --run "just \"{{ root_dir }}/{{ cmd }}\""
    else
      just "{{ root_dir }}/{{ cmd }}"
    fi

_build:
    home-manager -v build --flake "{{ root_dir }}#abhinav"

# build latest home-manager generation
build: (_run "_build")

_switch:
    home-manager -v switch --flake "{{ root_dir }}#abhinav"
    report-hm-changes

# switch to latest home-manager generation
switch: (_run "_switch")

_update-vscode-extensions:
    $NIXPKGS_PATH/pkgs/applications/editors/vscode/extensions/update_installed_exts.sh > \
        {{ root_dir }}/programs/vscode/extensions.nix

_update: _update-vscode-extensions && _switch
    nix flake update --commit-lock-file "{{ root_dir }}"

# update packages and switch
update: (_run "_update")

# clean up nix garbage
clean:
    home-manager expire-generations "-7 days"
    nix-collect-garbage -d --delete-old
