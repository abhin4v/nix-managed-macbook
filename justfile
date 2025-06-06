in_nix_shell := env_var_or_default("IN_NIX_SHELL", "false")
root_dir := justfile_directory()
hostname := `scutil --get LocalHostName`

# choose a just command to run
default:
    @just --choose

# show available just commands
help:
    @just --list --unsorted --list-heading $'Available commands:\n'

forecast:
    nix-forecast -s -c {{ root_dir }}#darwinConfigurations.{{ hostname }} | \
      tee -p /tmp/nix-forecast.txt | head -4
    @echo "Packages to be built:"
    @cat /tmp/nix-forecast.txt | grep "/nix/store/" | \
      grep -Pv "\-completions$|\.zip$|\.patch$|\.lock$|\.fish$|\.sh$|\.json$|\.conf$|\.keep$|\.md$" | \
      cut -c 45- | sort | nl

_run cmd:
    #!/usr/bin/env -S sh -eu
    if [ "{{ in_nix_shell }}" = "false" ]; then
      nix-shell "{{ root_dir }}/shell.nix" --run "just \"{{ root_dir }}/{{ cmd }}\""
    else
      just "{{ root_dir }}/{{ cmd }}"
    fi

_build:
    nom build --show-trace {{ root_dir }}#darwinConfigurations.{{ hostname }}.system

# build nix-darwin system
build: (_run "_build")

_switch: _build
    sudo ./result/sw/bin/darwin-rebuild -v switch --flake "{{ root_dir }}"

# build nix-darwin system and switch to it
switch: (_run "_switch") && _report-changes

_update: && _switch _brew-update _report-changes
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

# clean up garbage
clean days="7":
    home-manager expire-generations "-{{days}} days"
    nix profile wipe-history --older-than "{{days}}d"
    sudo nix-collect-garbage -d --delete-older-than {{days}}d
    brew cleanup  --prune {{days}}
