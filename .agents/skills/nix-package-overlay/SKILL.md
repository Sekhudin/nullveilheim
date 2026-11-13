---
name: Nix Package Overlay
description: Add, replace, and expose Nix packages through flake inputs and repository overlays
---

# Nix Package Overlay

Use this skill when adding, replacing, or exposing packages through flake inputs,
nixpkgs channels, overlays, or Home Manager configuration.

The repository separates package sources into:

```text
nixpkgs package       → package already available in selected nixpkgs
nixpkgs channel       → package from another nixpkgs channel
external flake        → package provided by an external flake input
self package          → package built by this repository
Home Manager module   → installs or configures the package
```

Preserve this separation.

## Repository Structure

- External repositories belong in `flake.nix`.
- Overlay modules belong in `parts/overlays/` and are imported by
  `parts/overlays/default.nix`.
- Package installation belongs in `modules/home/`, `modules/nixos/`,
  `modules/darwin/`, or `configurations/`.
- Keep package exposure separate from package installation and configuration.

Current overlay files include:

```text
branches.nix
fish.nix
packages.nix
shell-application.nix
tree-sitter.nix
vim.nix
```

Use the overlay file matching the package's source or domain.

## Workflow

1. Read `AGENTS.md` and inspect the current working tree.
2. Search for existing package references and equivalent nixpkgs packages.
3. Respect any explicit package-source request from the user.
4. Decide whether the package belongs in `branches.nix`, `packages.nix`,
   `shell-application.nix`, or another overlay.
5. Add or update the flake input when required.
6. Update `flake.lock`.
7. Install the package in the correct Home Manager module based on platform.
8. Validate formatting, the diff, flake evaluation, and affected outputs.
9. Review the complete diff and report warnings or limitations.

## Choosing the Overlay File

### `parts/overlays/branches.nix`

Use `branches.nix` when the package already exists in nixpkgs but a specific
nixpkgs channel is required. Current inputs map automatically as follows:

```text
nixpkgs-stable   → branches.stable
nixpkgs-unstable → branches.unstable
```

Examples:

```nix
firefox = branches.unstable.firefox;
nixd = branches.stable.nixd;
```

Packages that only need an unstable version belong in `branches.nix`, not
`packages.nix`.

### `parts/overlays/packages.nix`

Use `packages.nix` when a package comes from an external flake input or from
`inputs.self.packages`:

```nix
noctalia = inputs.noctalia.packages.${system}.default;
```

```nix
inherit (inputs.self.packages.${system})
  nixvim
  yakc
  ;
```

### `parts/overlays/shell-application.nix`

Use `shell-application.nix` for custom shell applications created with
`writeShellApplication`.

These applications may:

- Combine shell commands.
- Declare runtime dependencies.
- Provide a stable executable name.
- Adapt platform-specific commands.
- Be exposed through the repository's `shellApplication` attribute set.

Follow the repository's existing structure:

```nix
{ ... }:

{
  flake.overlays.shellApplication = final: _: {
    shellApplication = {
      custom-command = final.writeShellApplication {
        name = "custom-command";
        runtimeInputs = with final; [
          coreutils
          jq
        ];
        text = ''
          echo "custom command"
        '';
      };
    };
  };
}
```

The resulting application is accessed as:

```nix
shellApplication.custom-command
```

The repository currently exposes applications such as:

```nix
shellApplication.copy
shellApplication.paste
shellApplication.fuck-systemctl
```

They can then be installed from a Home Manager module:

```nix
home.packages = [
  shellApplication.custom-command
];
```

Do not place custom shell applications in `packages.nix` unless they are
external flake packages or packages built under `inputs.self.packages`.

Do not create a custom shell application when an existing nixpkgs package or
repository helper already provides the required functionality.

### Other overlay files

Use domain-specific files when appropriate:

```text
fish.nix        → Fish-related overlays
tree-sitter.nix → Tree-sitter overlays
vim.nix         → Vim-related overlays
```

Do not place package logic in an unrelated overlay file merely because it is
convenient.

### Decision tree

```text
Default nixpkgs package        → use pkgs.<package> directly
Alternative nixpkgs channel    → branches.nix
External flake package         → packages.nix
inputs.self package            → packages.nix
Custom shell application       → shell-application.nix
Domain-specific customization  → corresponding domain overlay
```

## Home Package Placement

Home Manager package installation is split by platform:

```text
modules/home/core/home.nix
modules/home/core/home-linux.nix
modules/home/core/home-darwin.nix
```

Use `home.nix` for packages that support both Linux and Darwin:

```nix
home.packages = with pkgs; [
  cross-platform-package
];
```

Use `home-linux.nix` for Linux-only packages:

```nix
home.packages = with pkgs; [
  linux-only-package
];
```

Use `home-darwin.nix` for Darwin-only packages:

```nix
home.packages = with pkgs; [
  darwin-only-package
];
```

Before installing a package, determine its platform support:

```text
Cross-platform package → home.nix
Linux-only package     → home-linux.nix
Darwin-only package    → home-darwin.nix
```

Do not place Linux-only or Darwin-only packages in the shared `home.nix`.

Package exposure and installation are separate concerns:

```text
parts/overlays/*.nix     → exposes the package or application
modules/home/core/*.nix  → installs it through home.packages
```

## Package Source Selection

Check nixpkgs first:

```sh
nix search nixpkgs <package-name>
```

Prefer the existing nixpkgs package by default when it satisfies the
requirement:

```nix
home.packages = with pkgs; [
  spotify-player
];
```

Do not add an external input merely to duplicate a package already available in
nixpkgs.

### Explicit user source requests

An explicit user request takes precedence over the default nixpkgs preference.
If the user requests a GitHub flake, upstream repository, specific revision,
newer version, upstream feature, or another source, use that source even when
an equivalent nixpkgs package exists.

In that case:

1. Do not silently substitute the nixpkgs package.
2. Verify the upstream flake and package output.
3. Report whether an equivalent nixpkgs package exists.
4. Explain why the requested source is used.
5. Check platform compatibility.

## Adding Flake Inputs

Use the repository's existing style:

```nix
package-input.url = "github:owner/repository";
package-input.inputs.nixpkgs.follows = "nixpkgs-unstable";
```

Use stable nixpkgs when appropriate:

```nix
package-input.inputs.nixpkgs.follows = "nixpkgs";
```

Confirm that the upstream flake has an input named `nixpkgs` before adding a
`follows` relationship. Do not add a second nixpkgs input unless an
incompatible version is required.

Use `flake = false` only for raw source inputs:

```nix
package-source.url = "github:owner/repository/tag";
package-source.flake = false;
```

Do not use `flake = false` when the upstream flake exposes a suitable package.
Prefer release tags or pinned revisions; use branches only intentionally.

## Inspecting an Upstream Flake

Before adding an external input, inspect its:

- `flake.nix` and package output names.
- Default package output.
- Supported systems.
- Nixpkgs compatibility and required overlays.
- License and release or revision strategy.

Useful commands:

```sh
nix flake show github:owner/repository
nix flake metadata github:owner/repository
```

Possible package outputs include:

```nix
inputs.package-input.packages.${system}.default
inputs.package-input.packages.${system}.package-name
inputs.package-input.legacyPackages.${system}.package-name
```

Do not assume every flake uses `.default`. Prefer upstream outputs over a
manual derivation.

## Overlay Format

Use the repository's standard structure:

```nix
{ inputs, ... }:

{
  flake.overlays.packages =
    _: prev:

    let
      system = prev.stdenv.hostPlatform.system;
    in
    {
      package-name = inputs.package-input.packages.${system}.default;
    };
}
```

Always derive the system dynamically:

```nix
system = prev.stdenv.hostPlatform.system;
```

Never hardcode a system such as `x86_64-linux` in a shared overlay.

External default package:

```nix
noctalia = inputs.noctalia.packages.${system}.default;
```

External named package:

```nix
package-name = inputs.package-input.packages.${system}.package-name;
```

Repository package:

```nix
inherit (inputs.self.packages.${system})
  nixvim
  yakc
  ;
```

Use `inputs.self.packages` only for packages built by this repository.

Use `prev` for the existing package set:

```nix
hyprlandPlugins = prev.hyprlandPlugins // {
  package-name = inputs.package-input.packages.${system}.default;
};
```

Keep `override`, `overrideAttrs`, and attribute merging in the overlay
responsible for the relevant domain. Document unusual overrides.

## Naming and Conflicts

Use predictable names matching the upstream package or executable where
practical:

```nix
herd = inputs.herd.packages.${system}.default;
```

Search before adding an attribute:

```sh
rg -n "package-name|overlays" parts/overlays modules configurations
```

Do not silently redefine an existing package. An override must be intentional.
Do not add an alias when direct nixpkgs usage is sufficient unless the user
requested an external flake, repository-level exposure, or package adaptation.

## Home Manager Module Configuration

For a package that should always be installed:

```nix
home.packages = with pkgs; [
  package-name
];
```

For reusable program options:

```nix
options.programs.package-name = {
  package = lib.mkPackageOption pkgs "package-name" {
    nullable = false;
  };
};
```

Keep package exposure in the overlay and installation/configuration in the
Home Manager module. Do not add an `enable` option merely by habit.

## Replacing a Package

Search all references first:

```sh
rg -n "old-package|OldPackage" .
```

Check `flake.nix`, `flake.lock`, `parts/overlays/`, all module and
configuration directories, theme files, desktop integrations, documentation,
and scripts. Remove package-specific integrations only when unused; preserve
shared configuration.

## Updating `flake.lock`

After adding an input:

```sh
nix flake lock
```

To update or remove one input:

```sh
nix flake lock --update-input package-input
nix flake lock --remove-input package-input
```

Do not edit `flake.lock` manually unless necessary. Review transitive
dependency removal carefully.

## Platform Compatibility

The repository currently declares:

```nix
systems = [
  "x86_64-linux"
  "aarch64-linux"
  "aarch64-darwin"
];
```

A globally exposed package must support all required systems, be guarded by a
platform condition, or be installed only from a platform-specific
configuration.

Evaluate availability when practical:

```sh
nix eval .#legacyPackages.x86_64-linux.package-name
nix eval .#legacyPackages.aarch64-linux.package-name
nix eval .#legacyPackages.aarch64-darwin.package-name
```

Do not add a Linux-only package to a shared module without checking macOS
compatibility.

## Validation

After modifying inputs, overlays, or package modules:

```sh
nixfmt --check path/to/changed-file.nix
git diff --check
nix flake check
```

Build or evaluate the affected package when practical:

```sh
nix build .#packages.x86_64-linux.package-name
nix eval .#legacyPackages.x86_64-linux.package-name.name
```

Search for stale references:

```sh
rg -n "old-package|OldPackage" .
```

Do not claim validation passed unless commands actually completed successfully.

## Safety Rules

- Do not read, decrypt, modify, or remove files under `secrets/`.
- Do not modify `.sops.yaml`.
- Do not expose credentials, tokens, private keys, or sensitive data.
- Do not modify unrelated user changes.
- Do not commit or push.
- Do not run `nixos-rebuild switch` or `darwin-rebuild switch`.
- Ask for clarification when package source or platform requirements are
  ambiguous.

## Reporting

Report:

- Whether the package came from nixpkgs, another nixpkgs channel, or an
  external flake.
- Whether the user explicitly requested the source.
- Changed input and overlay files.
- Upstream package output used.
- Supported systems checked.
- Lockfile changes.
- Validation results and warnings.
- Required Home Manager or system rebuild steps.
