# Hosts and Users

> Scope: installing NixOS, creating hosts, and applying system or Home Manager configurations.

The available configurations are registered through `parts/ez-config.nix`
using [ez-configs](https://github.com/ehllie/ez-configs). The system
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

## Installing NixOS with This Flake

The repository does not use the installer-generated
`/etc/nixos/configuration.nix` as its main host entrypoint. A new host is
assembled under `configurations/nixos/<hostname>/` and registered in
`parts/ez-config.nix`.

The standard NixOS installation flow is:

1. Boot the NixOS installer ISO in UEFI mode.
2. Connect to the network and partition the target disk according to the
   machine's hardware and storage layout.
3. Mount the target filesystem at `/mnt`, including its boot filesystem at
   `/mnt/boot` when applicable.
4. Generate the machine-specific hardware module:

   ```sh
   sudo nixos-generate-config --root /mnt
   ```

   This creates temporary installer configuration files in
   `/mnt/etc/nixos/`, including `hardware-configuration.nix`.

5. Clone this repository in the installer environment and create the new host.
6. Back up the generated hardware module by renaming it, then copy the backup
   into the new host directory.
7. Register the host in `parts/ez-config.nix`.
8. Build or evaluate the flake before installing.
9. Install with `nixos-install --flake` using the new host output.
10. Reboot into the installed system, move or clone the repository into the
   user's normal configuration directory, and use `nixos-rebuild` for future
   changes.

Disk partitioning and filesystem commands are intentionally not prescribed
here because they are hardware-specific and can destroy data when copied
blindly. Verify the target devices and mount points before running any
installation command.

### Prepare the New Host

Choose a unique hostname and create its directory:

```sh
hostname=<hostname>
mkdir -p "configurations/nixos/$hostname"
```

The two primary host files are:

```text
configurations/nixos/<hostname>/
├── default.nix
└── hardware-configuration.nix
```

First back up the generated hardware module by renaming it. When installing
from an ISO with `--root /mnt`, the generated file is under `/mnt/etc/nixos/`:

Run these commands from a root shell. The NixOS installer environment commonly
starts with root privileges.

```sh
mv \
  /mnt/etc/nixos/hardware-configuration.nix \
  /mnt/etc/nixos/hardware-configuration.bak.nix
```

Then copy the backup into the repository host directory:

```sh
cp /mnt/etc/nixos/hardware-configuration.bak.nix \
  "configurations/nixos/$hostname/hardware-configuration.nix"
```

On an already installed NixOS system, use `/etc/nixos/` instead of
`/mnt/etc/nixos/` in these commands:

```sh
mv /etc/nixos/hardware-configuration.nix \
  /etc/nixos/hardware-configuration.bak.nix
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
the [Home Manager](https://nix-community.github.io/home-manager/) user
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
[ez-configs](https://github.com/ehllie/ez-configs). The `syaikhu` value refers
to the user configuration under
`configurations/home/syaikhu.nix`. That profile imports the shared user
configuration and enables the Linux desktop when running on Linux.

### Validate and Install

From the repository root, validate the new host before switching or
installing:

```sh
nix flake check --all-systems
nixos-rebuild build --flake .#<hostname>
```

While still in the installer environment, install the selected host:

```sh
sudo nixos-install --flake /path/to/nullveilheim#<hostname>
```

Use the actual path where the repository was cloned in the installer
environment. Review the target host, filesystem module, boot settings, and
user configuration before confirming the installation.

After rebooting into the new system:

```sh
git clone https://github.com/sekhudin/nullveilheim.git \
  ~/.config/nullveilheim
cd ~/.config/nullveilheim
nix flake check --all-systems
sudo nixos-rebuild switch --flake .#<hostname>
```

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
