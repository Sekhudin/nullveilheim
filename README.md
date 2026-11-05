<div align="center">
    <h1>[nv] nullveilheim ❄️</h1>
    <br>
    <div align="center">
        <a href="https://github.com/sekhudin/nullveilheim/actions/workflows/ci.yaml">
            <img alt="CI status" src="https://img.shields.io/github/actions/workflow/status/sekhudin/nullveilheim/ci.yaml?branch=main&style=for-the-badge&label=CI&logo=github">
        </a>
        <a href="https://github.com/sekhudin/nullveilheim">
            <img alt="Repository size" src="https://img.shields.io/github/repo-size/sekhudin/nullveilheim?style=for-the-badge&logo=github">
        </a>
        <a href="https://nixos.org">
            <img alt="NixOS Flakes" src="https://img.shields.io/badge/NixOS-Flakes-blue?style=for-the-badge&logo=NixOS&logoColor=white">
        </a>
    </div>
    <br>
</div>

Personal Nix configurations for Linux and macOS.

This repository contains my system and user environment built with
[Nix](https://nixos.org/), including [NixOS](https://nixos.org/),
[Home Manager](https://github.com/nix-community/home-manager), and
[nix-darwin](https://github.com/nix-darwin/nix-darwin).

The setup is actively evolving and is primarily designed for my own machines
and workflow.

> **Warning:** This repository contains personal NixOS, nix-darwin, and
> Home Manager configurations. The configurations may assume specific hardware,
> usernames, filesystem paths, desktop capabilities, and encrypted secrets.
> Review the relevant host configuration before applying it to another machine.
> Do not run `switch` commands blindly.

## Table of Contents

- [Overview](#overview)
- [Hosts and Users](#hosts-and-users)
- [Installation](#installation)
- [Adding a New Host](#adding-a-new-host)
- [Desktop Environment](#desktop-environment)
- [Desktop Screenshots](#desktop-screenshots)
- [Home Manager](#home-manager)
- [Secrets](#secrets)
- [Flakes](#flakes)
- [Nixvim](#nixvim)
- [Development Shells](#development-shells)
- [Process-Compose Services](#process-compose-services)
- [Common Commands](#common-commands)
- [Repository Structure](#repository-structure)
- [Flake Outputs](#flake-outputs)
- [Status](#status)

## Overview

The repository is organized around several layers:

- `configurations/`
  - Host and user entrypoints.
  - Contains NixOS hosts, nix-darwin hosts, and Home Manager users.

- `modules/`
  - Reusable NixOS, Home Manager, Darwin, and common modules.
  - Most system and user behavior is defined here.

- `parts/`
  - Flake-parts modules.
  - Contains packages, overlays, development shells, process-compose services,
    and flake-level wiring.

- `shared/`
  - Shared helpers, colors, icons, and internal libraries.

- `secrets/`
  - Encrypted secrets managed with SOPS.
  - Secret values are intentionally not documented.

## Hosts and Users

| Name         | Platform     | Type                          | Notes                        |
| ------------ | ------------ | ----------------------------- | ---------------------------- |
| `acerswift`  | NixOS        | System host                   | Linux desktop                |
| `t14`        | NixOS        | System host                   | Linux desktop                |
| `mbp`        | nix-darwin   | System host                   | macOS machine                |
| `syaikhu`    | Home Manager | User configuration            | Integrated with system hosts |
| `syaikhu-sa` | Home Manager | Standalone user configuration | Linux standalone setup       |

## Installation

### Requirements

- Nix with flakes enabled
- Git
- A supported NixOS, macOS, or Home Manager environment
- Access to the required SOPS encryption keys when using secret-dependent
  activation modules

Clone the repository:

```sh
git clone https://github.com/sekhudin/nullveilheim.git
cd nullveilheim
```

Review the relevant host and user files before applying any configuration.

### Apply a NixOS Host

```sh
sudo nixos-rebuild switch --flake .#t14
sudo nixos-rebuild switch --flake .#acerswift
```

### Apply the nix-darwin Host

```sh
darwin-rebuild switch --flake .#mbp
```

### Apply Standalone Home Manager

```sh
home-manager switch --flake .#syaikhu-sa
```

### Validate Before Applying

```sh
nix flake check
nix flake show
```

## Adding a New Host

Create a directory under `configurations/nixos/`:

```text
configurations/nixos/<hostname>/
```

Add the required host files:

```text
configurations/nixos/<hostname>/
├── default.nix
├── hardware-configuration.nix
├── networking.nix
├── services.nix
└── virtualisation.nix
```

Register the host in `parts/ez-config.nix`:

```nix
hosts = {
  <hostname> = {
    userHomeModules = {
      syaikhu = "syaikhu";
    };
  };
};
```

Generate and review the hardware configuration, then validate the host:

```sh
nix flake check
nixos-rebuild build --flake .#<hostname>
```

Apply it only after reviewing the build result:

```sh
sudo nixos-rebuild switch --flake .#<hostname>
```

## Desktop Environment

Linux desktop configurations use:

- **Hyprland** as the Wayland compositor and window manager
- **Noctalia** as the desktop shell layer
- Home Manager for user-level desktop configuration
- Shared theme, color, icon, and variable helpers

The desktop configuration includes support for:

- Wallpapers and desktop backdrops
- Bars, docks, and widgets
- Application launcher integration
- Audio and brightness controls
- Media and microphone controls
- Notifications and calendar integration
- Screenshot and session controls
- Hyprland keybindings, rules, animations, and workspaces
- Noctalia plugins and local integrations

The desktop configuration is enabled for Linux and disabled for the macOS
desktop setup.

## Desktop Screenshots

### Overview

<p align="center">
  <img src="docs/images/desktop-overview.png" alt="NullVeilheim desktop overview" width="100%">
</p>

<table>
  <tr>
    <td align="center" width="33%">
      <img src="docs/images/desktop-workspace.png" alt="NullVeilheim desktop workspace" width="100%">
      <br>
      <sub><b>Workspace</b></sub>
    </td>
    <td align="center" width="33%">
      <img src="docs/images/desktop-cheatsheet.png" alt="Hypr Cheatsheet" width="100%">
      <br>
      <sub><b>Cheatsheet</b></sub>
    </td>
    <td align="center" width="33%">
      <img src="docs/images/desktop-launcher.png" alt="Application launcher" width="100%">
      <br>
      <sub><b>Application Launcher</b></sub>
    </td>
  </tr>
</table>

## Home Manager

Home Manager manages user-level configuration, including:

- Shell configuration
- Terminal preferences
- Themes and desktop integration
- User packages
- Session variables
- Activation scripts
- Git, SSH, GPG, and other user programs

The main user configuration currently uses:

- Fish as the shell
- Ghostty as the terminal on supported systems
- Nixvim as the editor
- Aurora as the selected theme

## Secrets

Secrets are encrypted with [SOPS](https://github.com/getsops/sops) and stored
in:

```text
secrets/secrets.yaml
```

The declared secret structure is:

```text
secrets/
└── secrets.yaml
    ├── gpg_keys/
    │   └── personal/
    │       ├── email
    │       ├── private_key
    │       └── owner_trust
    ├── ssh_keys/
    │   └── personal/
    │       ├── path
    │       └── private_key
    ├── git_identities/
    │   └── personal/
    │       ├── name
    │       ├── email
    │       ├── signing_key
    │       ├── ssh_key
    │       └── gitdirs/
    │           ├── w1
    │           ├── w2
    │           └── w3
    ├── tokens/
    ├── passwords/
    └── certificates/
```

Edit the encrypted file with:

```sh
sops secrets/secrets.yaml
```

When adding a secret:

- Keep the file encrypted.
- Never commit plaintext secret values.
- Follow the existing key structure.
- Ensure the corresponding Nix module expects the new key.
- Test secret-dependent activation in a safe environment first.

The CI workflow does not decrypt or use repository secrets.

## Flakes

The flake provides:

- NixOS configurations
- nix-darwin configurations
- Home Manager configurations
- Custom packages
- Overlays
- Development shells
- Process-compose services
- Flake checks

External dependencies are managed through `flake.nix` and `flake.lock`.

## Nixvim

Neovim is configured with
[Nixvim](https://github.com/nix-community/nixvim).

Build the Nixvim package:

```sh
nix build .#nixvim
```

Run the Nixvim check:

```sh
nix build .#checks.x86_64-linux.nixvim
```

## Development Shells

Available development shells include:

- `default`
- `bun`
- `go`
- `go125`
- `go126`
- `goLatest`
- `nodejs22`
- `nodejs24`
- `nodejs26`
- `nodejsLatest`
- `c-general`
- `c-linux`

Enter a shell with:

```sh
nix develop
nix develop .#go
nix develop .#nodejs24
nix develop .#bun
nix develop .#c-linux
```

The default development shell includes pre-commit checks for GitHub Actions,
shell scripts, Lua, dead Nix code, and Nix formatting.

## Process-Compose Services

Run the local PostgreSQL sandbox:

```sh
nix run .#pg-sandbox
```

Run the local Mailpit sandbox:

```sh
nix run .#mail-sandbox
```

## Common Commands

```sh
nix flake check
nix fmt -- $(git ls-files '*.nix' ':!secrets/**')
nix flake update
nix flake show
```

## Repository Structure

```text
.
├── .github/
│   └── workflows/
│       └── ci.yaml
├── configurations/
│   ├── darwin/
│   ├── home/
│   └── nixos/
├── docs/
│   └── images/
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

Notable outputs include:

- `nixosConfigurations.acerswift`
- `nixosConfigurations.t14`
- `darwinConfigurations.mbp`
- `packages.*.nixvim`
- `packages.*.pg-sandbox`
- `packages.*.mail-sandbox`
- `checks.*.nixvim`
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
hardware assumptions, and workflows are specific to my machines and
preferences.
