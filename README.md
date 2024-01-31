# Nix + Home Manager based MacBook configuration

This is the [Nix] and [Home Manager] configuration for managing my MacBook.

## Usage

First install [Nix] and [Homebrew]. Then, in the repo directory, run `nix develop` to get into the Nix shell.

To set up the MacBook as per the config, run:

```bash
just switch
```

To update installed packages, run:

```bash
just update
```

To clean up garbage, run:

```bash
just clean
```

If you have [`just`] installed, you can also run these commands from any other directory, without starting Nix shell:

```bash
just <repo_dir>/switch # or update or clean
```

[Nix]: https://nixos.org
[Homebrew]: https://brew.sh
[Home Manager]: https://github.com/nix-community/home-manager
[`just`]: https://just.systems
