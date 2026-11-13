# Architecture

> Scope: how the flake, configuration discovery, modules, and shared libraries fit together.

This repository is a personal [Nix flake](https://nix.dev/manual/nix/latest/command-ref/new-cli/nix3-flake)
organized into entrypoints, reusable modules, flake-level outputs, and shared
libraries.

## Flake Assembly

```text
flake.nix
    ↓
flake-parts
    ↓
parts/
    ↓
ez-configs
    ↓
configurations/
    ↓
modules/
    ↓
NixOS / nix-darwin / Home Manager
```

## Directory Roles

| Directory | Role |
| --- | --- |
| `configurations/` | Host and user entrypoints. |
| `modules/` | Reusable NixOS, nix-darwin, Home Manager, and common modules. |
| `parts/` | Flake-parts modules for outputs, packages, overlays, shells, and services. |
| `shared/` | Reusable helpers, colors, icons, and internal libraries. |
| `docs/` | Repository documentation and desktop images. |
| `secrets/` | Encrypted SOPS data. Secret values are not documented here. |
| `.opencode/` | Repository-specific agents, skills, and development instructions. |

## Entrypoint Wiring

The flake entrypoint imports `parts/` through
[flake-parts](https://flake.parts/), which assembles the flake outputs:

```text
flake.nix
  └── parts/
      ├── ez-config.nix
      ├── overlays/
      ├── packages/
      ├── devshells/
      └── process-compose/
```

The [`ez-configs`](https://flake.parts/options/ez-configs.html) integration connects
configuration entrypoints to reusable modules:

```text
configurations/nixos/  ─┐
configurations/darwin/ ─┼─> host configurations
configurations/home/  ──┘

modules/nixos/
modules/darwin/          ──> reusable system modules
modules/home/
modules/common/
```

Shared values and helpers are passed through the repository's flake context.
For example, [Home Manager](https://home-manager.dev/manual/26.05/)
modules use shared theme data and helpers through `extraLib`, while Hyprland
modules use `extraLib.hyprland`.

## Automatic Module Discovery

Several module trees use the repository's automatic module discovery helpers.
The Home Manager desktop entrypoint recursively imports Nix modules below
`modules/home/desktop/`. This allows related configuration to be split into
focused files without manually adding every file to an import list.

When adding a module, keep it in the appropriate module boundary and follow
the existing naming and option patterns. Host-specific values belong under
`configurations/`; reusable behavior belongs under `modules/`.

## Package Boundaries

Package source selection and package installation are intentionally separate:

```text
parts/overlays/      → expose packages and select package channels
modules/home/        → install and configure packages
parts/packages/      → define packages built by this repository
flake.nix            → declare external inputs
```

For example, `babelfish` is selected from the stable nixpkgs channel in the
branches overlay, while the Fish module only consumes `pkgs.babelfish`.

## Main Library Dependencies

The main external libraries that form the repository's configuration
backbone are:

- [flake-parts](https://flake.parts/) — composes the flake and its outputs.
- [ez-configs](https://flake.parts/options/ez-configs.html) — discovers and registers
  system and Home Manager configurations.
- [Home Manager](https://home-manager.dev/manual/26.05/) — manages
  user-level modules and activation.
- [sops-nix](https://github.com/Mic92/sops-nix) — integrates encrypted SOPS
  secrets with NixOS and Home Manager.
- [Nixpkgs library](https://nixos.org/manual/nixpkgs/stable/#sec-functions-library)
  — provides helpers such as `lib.mkIf`, `lib.mkOption`, `lib.types`, and
  `lib.attrValues`.

[← Back to README](../README.md)
