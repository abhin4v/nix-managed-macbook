in_nix_shell := env_var_or_default("IN_NIX_SHELL", "false")
root_dir := justfile_directory()
hostname := `scutil --get LocalHostName`

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
    nix build {{ root_dir }}#darwinConfigurations.{{ hostname }}.system

# build latest home-manager generation
build: (_run "_build")

_switch: _build
    ./result/sw/bin/darwin-rebuild -v switch --flake "{{ root_dir }}"

# switch to latest home-manager generation
switch: (_run "_switch")

_update: && _switch
    nix flake update --commit-lock-file "{{ root_dir }}"
    $NIXPKGS_PATH/pkgs/applications/editors/vscode/extensions/update_installed_exts.sh > \
        {{ root_dir }}/programs/vscode/extensions.nix

# update packages and switch
update: (_run "_update")

# clean up nix garbage
clean:
    home-manager expire-generations "-7 days"
    nix-collect-garbage -d --delete-old
