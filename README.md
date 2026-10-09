# nullveilheim

Personal Nix configurations for Linux and macOS.

This repository contains my system and user environment built with
[Nix](https://nixos.org/), including [NixOS](https://nixos.org/),
[Home Manager](https://github.com/nix-community/home-manager), and
[nix-darwin](https://github.com/nix-darwin/nix-darwin).

The setup is actively evolving. It is designed primarily for my own machines and
workflow, but parts of it may be useful as references for other Nix setups.

## Overview

The repository is organized around a few main layers:

- `configurations/`
  - Host and user entrypoints.
  - Contains NixOS hosts, nix-darwin hosts, and Home Manager users.

- `modules/`
  - Reusable NixOS, Home Manager, Darwin, and common modules.
  - Most system and user behavior is expressed here.

- `parts/`
  - Flake-parts modules.
  - Contains packages, overlays, development shells, process-compose services,
    and flake-level wiring.

- `shared/`
  - Shared helpers, colors, icons, and small internal libraries.
  - Used by modules and packages to keep common logic centralized.

- `secrets/`
  - Encrypted secrets managed with SOPS.
  - Secret contents are intentionally not documented here.

## Hosts

| Host        | Platform   | Notes         |
| ----------- | ---------- | ------------- |
| `acerswift` | NixOS      | Linux desktop |
| `t14`       | NixOS      | Linux desktop |
| `mbp`       | nix-darwin | macOS machine |

## Highlights

### Flakes

All external dependencies are managed through `flake.nix` and `flake.lock`.

The flake provides:

- NixOS configurations
- nix-darwin configurations
- Home Manager configurations
- custom packages
- overlays
- development shells
- process-compose services
- checks

### Modular Configuration

The configuration is split between host-specific entrypoints and reusable
modules.

Host files stay small and mostly define machine-specific details, while shared
behavior lives under `modules/`.

### Home Manager

User-level configuration is handled through Home Manager.

The main user configuration currently defines:

- shell preference
- terminal preference
- theme selection
- desktop enablement
- activation settings
- user packages
- session variables

### Hyprland and Noctalia

Linux desktop systems use Hyprland with additional Home Manager configuration.

Noctalia is used as the desktop shell layer, with theme templates and desktop
integration managed declaratively.

### Secrets

Secrets are managed with `sops-nix`.

The setup supports declarative handling for:

- SSH keys
- GPG keys
- Git identities
- other encrypted values

The encrypted secret file is kept in the repository, but secret values are not
documented.

### Nixvim

Neovim is configured with [Nixvim](https://github.com/nix-community/nixvim).

The editor configuration is built as a flake package and covered by a flake
check.

### Development Shells

Development shells are provided through the flake.

The default development shell installs pre-commit hooks for formatting and basic
static checks.

Available development shells include:

- `default`
- `bun`
- `go`, `go125`, `go126`, `goLatest`
- `nodejs22`, `nodejs24`, `nodejs26`, `nodejsLatest`

## Common Commands

Build or switch a NixOS host:

```sh
sudo nixos-rebuild switch --flake .#t14
sudo nixos-rebuild switch --flake .#acerswift
```

Build or switch the macOS host:

```sh
darwin-rebuild switch --flake .#mbp
```

Run flake checks:

```sh
nix flake check
```

Run a specific check:

```sh
nix build .#checks.x86_64-linux.nvim
nix build .#checks.x86_64-linux.pre-commit
```

Update flake inputs:

```sh
nix flake update
```

Enter the default development shell:

```sh
nix develop
```

Enter a specific development shell:

```sh
nix develop .#go
nix develop .#nodejs24
nix develop .#bun
```

Run a process-compose environment:

```sh
nix run .#pg-sandbox
nix run .#mail-sandbox
```

Build the Neovim package:

```sh
nix build .#nvim
```

Format the repository:

```sh
nix fmt
```

Inspect flake outputs:

```sh
nix flake show
```

## Repository Structure

```text
.
├── configurations/
│   ├── darwin/
│   ├── home/
│   └── nixos/
├── modules/
│   ├── common/
│   ├── darwin/
│   ├── home/
│   └── nixos/
├── parts/
│   ├── devshells/
│   ├── overlays/
│   ├── packages/
│   └── process-compose/
├── secrets/
├── shared/
├── flake.nix
└── flake.lock
```

## Flake Outputs

Current notable outputs include:

- `nixosConfigurations.acerswift`
- `nixosConfigurations.t14`
- `packages.*.nvim`
- `packages.*.pg-sandbox`
- `packages.*.mail-sandbox`
- `checks.*.nvim`
- `checks.*.pre-commit`
- `devShells.*.default`
- `devShells.*.bun`
- `devShells.*.go`
- `devShells.*.nodejs24`
- `overlays.branches`
- `overlays.fish`
- `overlays.shellApplication`
- `overlays.tree-sitter`
- `overlays.vim`

## Status

This is a personal configuration repository and is still under active
development.

It is not intended to be a drop-in framework. Some modules, paths, secrets,
hardware assumptions, and workflows are specific to my machines and preferences.
