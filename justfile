in_nix_shell := if env_var_or_default("IN_NIX_SHELL", "false") == "false" { "false" } else { "true" }
root_dir := justfile_directory()

# choose a just command to run
default:
    @just --choose

# show available just commands
help:
    @just --list --unsorted --list-heading $'Available commands:\n'

_run cmd:
    #!/usr/bin/env -S sh -eu
    if [ "{{ in_nix_shell }}" = "true" ]; then
      just "{{ root_dir }}/{{ cmd }}"
    else
      nix-shell "{{ root_dir }}/shell.nix" --run "just \"{{ root_dir }}/{{ cmd }}\""
    fi

_build:
    home-manager build --flake "{{ root_dir }}#abhinav"

# build latest home-manager generation
build: (_run "_build")

_switch:
    home-manager switch --flake "{{ root_dir }}#abhinav"

# switch to latest home-manager generation
switch: (_run "_switch")

_update: && _switch
    nix flake update --commit-lock-file "{{ root_dir }}"

# update packages and switch
update: (_run "_update")

# clean up nix garbage
clean:
    nix-collect-garbage -d --delete-old