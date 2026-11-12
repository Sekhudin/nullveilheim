# Hosts and Users

> Scope: installing NixOS, creating hosts, and applying system or Home Manager configurations.

The available configurations are registered through `parts/ez-config.nix`
using [ez-configs](https://flake.parts/options/ez-configs.html). The system
configuration is built with [NixOS](https://nixos.org/manual/nixos/stable/)
and the flake structure is assembled with
[flake-parts](https://flake.parts/).

## Supported Configurations

| Name | Platform | Type | Notes |
| --- | --- | --- | --- |
| `acerswift` | NixOS | System host | Linux desktop. |
| `t14` | NixOS | System host | Linux desktop. |
| `mbp` | nix-darwin | System host | macOS machine. |
| `syaikhu` | Home Manager | Integrated user profile | Included by the system hosts. |
| `syaikhu-sa` | Home Manager | Standalone user configuration | Standalone Linux setup. |

Integrated Home Manager outputs are generated per host:

```text
homeConfigurations.syaikhu@acerswift
homeConfigurations.syaikhu@t14
homeConfigurations.syaikhu@mbp
homeConfigurations.syaikhu-sa
```

The `syaikhu-mini@...` outputs are internal composition outputs from
`ez-configs` and are not intended as the primary user-facing commands.

## Applying a Configuration

Review the target configuration before applying it. These are personal
configurations and may assume specific hardware, usernames, paths, and
encrypted secrets.

### NixOS

```sh
sudo nixos-rebuild switch --flake .#t14
sudo nixos-rebuild switch --flake .#acerswift
```

Build without switching:

```sh
nixos-rebuild build --flake .#t14
```

### nix-darwin

```sh
darwin-rebuild switch --flake .#mbp
```

### Standalone Home Manager

```sh
home-manager switch --flake .#syaikhu-sa
```

The integrated `syaikhu` configuration is normally applied through the NixOS
or nix-darwin host that includes it.

## Recommended Workflow: Install NixOS First

The recommended workflow is to install NixOS normally first, then apply this
repository after the first boot. The repository does not use the installer-
generated `/etc/nixos/configuration.nix` as its main host entrypoint. A new
host is assembled under `configurations/nixos/<hostname>/` and registered in
`parts/ez-config.nix`.

The workflow is:

1. Install NixOS using the [official installation
   guide](https://nixos.org/manual/nixos/stable/#sec-installation).
2. Boot into the newly installed NixOS system.
3. Clone this repository and create the new host.
4. Back up the generated hardware module by renaming it, then copy the backup
   into the new host directory.
5. Create the host's `default.nix`.
6. Register the host in `parts/ez-config.nix`.
7. Build and validate the flake.
8. Apply the host with `nixos-rebuild switch`.

The normal installation creates:

```text
/etc/nixos/
├── configuration.nix
└── hardware-configuration.nix
```

The repository replaces the generated `configuration.nix` with its own host
entrypoint. The generated `hardware-configuration.nix` is preserved as a
backup and copied into the repository host directory.

Disk partitioning and filesystem commands are intentionally not prescribed
here because they are hardware-specific and can destroy data when copied
blindly. Follow the official NixOS guide and verify the target devices.

### Prepare the New Host

Clone the repository and choose a unique hostname:

```sh
git clone https://github.com/sekhudin/nullveilheim.git \
  ~/.config/nullveilheim

cd ~/.config/nullveilheim
hostname="my-host" # replace with the actual hostname
mkdir -p "configurations/nixos/$hostname"
```

The two primary host files are:

```text
configurations/nixos/<hostname>/
├── default.nix
└── hardware-configuration.nix
```

Run only the backup operation from a root shell because `/etc/nixos/` is
normally owned by root:

```sh
mv /etc/nixos/hardware-configuration.nix \
  /etc/nixos/hardware-configuration.bak.nix
```

Return to the regular user shell in the repository, then copy the backup:

```sh
cp /etc/nixos/hardware-configuration.bak.nix \
  "configurations/nixos/$hostname/hardware-configuration.nix"
```

The generated file contains machine-specific filesystem UUIDs, kernel
modules, and platform information. Do not reuse it for another machine or
replace it with a generic example.

Create `configurations/nixos/<hostname>/default.nix`. This is the primary host
entrypoint. A minimal host imports the generated hardware module and shared
repository modules:

```nix
{
  lib,
  pkgs,
  ezModules,
  ...
}:

{
  imports = lib.attrValues ezModules ++ [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "26.05";

  users.users.syaikhu = {
    description = "syaikhu";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nixosDesktop.enable = true;
}
```

The exact user, groups, system version, and desktop setting must be adapted to
the new machine. `hardware-configuration.nix` and `default.nix` are the
primary host files. The `lib` helpers come from the
[Nixpkgs library](https://nixos.org/manual/nixpkgs/stable/#sec-functions-library).

Networking, services, and virtualization modules are optional. Create and
import them only when the host needs them:

```nix
imports = lib.attrValues ezModules ++ [
  ./hardware-configuration.nix
  ./networking.nix       # optional
  ./services.nix         # optional
  ./virtualisation.nix   # optional
];
```

### Register the Host

Add the host to `ezConfigs.nixos.hosts` in `parts/ez-config.nix` and connect
the [Home Manager](https://home-manager.dev/manual/26.05/) user
profile:

```nix
ezConfigs.nixos = {
  hosts = {
    <hostname> = {
      userHomeModules = {
        syaikhu = "syaikhu";
      };
    };
  };
};
```

The `ezConfigs` declaration is provided by
[ez-configs](https://flake.parts/options/ez-configs.html). The `syaikhu` value refers
to the user configuration under
`configurations/home/syaikhu.nix`. That profile imports the shared user
configuration and enables the Linux desktop when running on Linux.

### Validate and Apply

From the repository root, validate and build the new host before switching:

```sh
nix flake check --all-systems
nixos-rebuild build --flake .#<hostname>
sudo nixos-rebuild switch --flake .#<hostname>
```

The `build` command does not change the active system. Only run `switch` after
reviewing the build and host configuration.

## Advanced: Install Directly from the Flake

`nixos-install --flake` is also supported by NixOS, but it is an advanced
workflow and is not required for this repository. Before using it from an
installer environment, all of the following must already be prepared:

- The target filesystems are mounted under `/mnt`.
- The repository is available in the installer environment.
- `configurations/nixos/<hostname>/default.nix` exists.
- `configurations/nixos/<hostname>/hardware-configuration.nix` exists.
- The host is registered in `parts/ez-config.nix`.

Then the installation can be started with:

```sh
nixos-install --flake /path/to/nullveilheim#<hostname>
```

This command does not generate or discover the hardware configuration by
itself. The generated hardware module must be prepared and included in the
flake before running it.

## Adding a NixOS Host

For an existing installed system, the shorter workflow is:

1. Create `configurations/nixos/<hostname>/`.
2. Add `default.nix` and the machine-generated
   `hardware-configuration.nix`.
3. Add optional networking, services, and virtualization modules as needed.
4. Register the host and its Home Manager users in `parts/ez-config.nix`.
5. Run `nix flake check --all-systems` and build the host.
6. Apply it with `nixos-rebuild switch --flake .#<hostname>`.

Example registration:

```nix
ezConfigs.nixos = {
  hosts = {
    <hostname> = {
      userHomeModules = {
        syaikhu = "syaikhu";
      };
    };
  };
};
```

See [Development](development.md) for validation commands and the change
workflow.

[← Back to README](../README.md)
