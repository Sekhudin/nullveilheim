# nullveilheim

My Nix configurations for Linux and macOS.

This repository contains my system and user configurations built with [Nix](https://nixos.org/), including [NixOS](https://nixos.org/), [Home Manager](https://github.com/nix-community/home-manager), and [nix-darwin](https://github.com/nix-darwin/nix-darwin).

I'm continuously tweaking and improving my setup, experimenting with different tools, desktop components, and ways to make more of my environment declarative and reproducible.

## Highlights

In no particular order:

- [Flakes](./flake.nix)
  - All external dependencies are managed through flakes.
  - NixOS configurations for my Linux machines.
  - nix-darwin configuration for macOS.
  - Home Manager configuration for user-level programs and environments.
  - Custom packages, overlays, and development shells.

- Modular configuration
  - Reusable NixOS, Home Manager, and Darwin modules.
  - Host-specific configuration is separated from reusable modules.
  - Shared functionality is kept under [`modules/`](./modules/).

- [Hyprland](https://hyprland.org/) desktop configuration
  - Wayland-based desktop environment for my NixOS systems.
  - Declaratively configured through NixOS and Home Manager modules.

- [sops-nix](https://github.com/Mic92/sops-nix)
  - Encrypted secrets managed declaratively.
  - SSH keys, GPG keys, Git identities, and other sensitive configuration are kept encrypted.

- [Nixvim](https://github.com/nix-community/nixvim)
  - Declarative Neovim configuration.

- Shell environment
  - [Fish](https://fishshell.com/) as my primary shell.
  - [Ghostty](https://ghostty.org/) as my terminal emulator.
  - CLI tools and their configuration managed through Home Manager.

- Development environments
  - Reproducible development shells defined through the flake.
  - Custom packages and overlays for tools that aren't provided directly by nixpkgs.

## Structure

```text
.
├── configurations/     # Host and user configurations
├── modules/            # Reusable NixOS/Home Manager/Darwin modules
├── parts/              # Flake components, packages, overlays, devshells
├── secrets/            # Encrypted secrets
├── shared/             # Shared configuration and helper
├── flake.nix
└── flake.lock
```

## Hosts

| Host        | Platform   |
| ----------- | ---------- |
| `acerswift` | NixOS      |
| `t14`       | NixOS      |
| `mbp`       | nix-darwin |

This is a personal configuration, so some parts may be specific to my hardware, workflow, or preferences. Feel free to take anything useful from it and adapt it to your own setup.
