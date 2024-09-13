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
    nom build {{ root_dir }}#darwinConfigurations.{{ hostname }}.system

# build latest home-manager generation
build: (_run "_build")

_switch: _build
    ./result/sw/bin/darwin-rebuild -v switch --flake "{{ root_dir }}"

# switch to latest home-manager generation
switch: (_run "_switch") && _report-changes

_update-vscode-extensions:
  $NIXPKGS_PATH/pkgs/applications/editors/vscode/extensions/update_installed_exts.sh > \
        {{ root_dir }}/programs/vscode/extensions.nix

_update: && _update-vscode-extensions _switch _brew-update _report-changes
    nix flake update --commit-lock-file --flake {{ root_dir }}

_brew-update:
    brew update
    brew upgrade
    mas upgrade

_report-changes:
  #!/bin/bash
  if [ $(ls -d1v /nix/var/nix/profiles/system-*-link 2>/dev/null | wc -l) -lt 2 ]; then
    echo "Skipping changes report..."
  else
    nvd diff $(/bin/ls -d1v /nix/var/nix/profiles/system-*-link | tail -2)
  fi

# update packages and switch
update: (_run "_update")

# clean up nix garbage
clean days="7":
    home-manager expire-generations "-{{days}} days"
    nix profile wipe-history --older-than "{{days}}d"
    sudo nix-collect-garbage -d --delete-older-than {{days}}d
    brew cleanup  --prune {{days}}
