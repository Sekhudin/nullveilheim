---
name: Nix Module
description: Create and structure Nix modules for darwin, NixOS, or home-manager
---

# Nix Module Development

Use this skill when creating or modifying NixOS, nix-darwin, or Home Manager
modules, including module options, package-backed programs, platform-specific
configuration, and Home Manager settings.

## Safety Rules

- Read and follow `AGENTS.md`.
- Do not read, decrypt, modify, or remove files under `secrets/`.
- Do not modify `.sops.yaml`.
- Do not expose secrets, credentials, tokens, private keys, or sensitive
  machine data.
- Do not apply system-wide changes.
- Do not run `nixos-rebuild switch` or `darwin-rebuild switch`.
- Do not commit or push changes unless explicitly requested.
- Preserve unrelated user changes.

## Workflow

1. Read `AGENTS.md`.
2. Inspect Git status and preserve unrelated changes.
3. Search for existing options, consumers, and equivalent modules.
4. Place the module according to the repository structure.
5. Review the complete diff.
6. Validate the affected outputs.

## Module Template

```nix
{ lib, config, pkgs, ... }:

let
  cfg = config.<namespace>.<name>;
in
{
  options.<namespace>.<name> = {
    enable = lib.mkEnableOption "<description>";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.<package>;
      description = "Package to use";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Configuration settings";
    };
  };

  config = lib.mkIf cfg.enable {
    # Implementation here
  };
}
```

## Repository Placement

Keep feature modules grouped by domain and feature:

```text
modules/home/core/<feature>/<name>/
├── options.nix
└── <name>.nix
```

For example:

```text
modules/home/core/multiplexer/herdr/
├── options.nix
└── herdr.nix
```

`options.nix` contains the module option declarations and the module
implementation (`config = ...`). `<name>.nix` contains the selected repository
configuration, such as:

```nix
{ ... }:

{
  programs.herdr = {
    enable = true;
    settings = { };
  };
}
```

Keep domain-level `homeCore` options in the existing domain options file:

```text
modules/home/core/options.nix
```

Do not change an existing option's structure unless explicitly requested. For
example, keep this as a string when adding a sibling option:

```nix
homeCore.terminal = "ghostty";
```

The repository recursively imports modules through `mkImports`. Do not add
manual imports unless the existing import mechanism cannot discover the module.
Avoid `default.nix` inside feature directories because the import helper
excludes files with that name.

## File Naming Rules

- Use `options.nix` for module option declarations and implementation.
- Use `<name>.nix` for selected configuration values.
- Match `<name>` with the package or program name, such as `herdr.nix`.
- Keep options and selected configuration in the same feature directory.
- Do not use generic names such as `config.nix`, `module.nix`, or `setup.nix`
  for the selected configuration file.

## Common Option Types

```nix
lib.types.bool
lib.types.str
lib.types.int
lib.types.path
lib.types.package
lib.types.listOf lib.types.str
lib.types.attrsOf lib.types.str
lib.types.nullOr lib.types.str
lib.types.enum [ "a" "b" "c" ]
lib.types.submodule { options = { ... }; }
```

## Module Patterns

### Platform-specific config

```nix
config = lib.mkIf cfg.enable (lib.mkMerge [
  {
    # Common config
  }
  (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    # macOS only
  })
  (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    # Linux only
  })
]);
```

### Import platform modules

```nix
let
  platformModule = if pkgs.stdenv.hostPlatform.isDarwin
    then ./darwin.nix
    else ./linux.nix;
in {
  imports = [ platformModule ];
}
```

### Conditional imports

```nix
imports = lib.optional cfg.enableFeatureX ./feature-x.nix;
```

## Darwin-specific

### Launchd daemon

```nix
launchd.daemons.<name> = {
  script = ''
    exec ${lib.getExe cfg.package}
  '';
  serviceConfig = {
    RunAtLoad = true;
    KeepAlive = true;
  };
};
```

### Launchd user agent

```nix
launchd.user.agents.<name> = {
  command = "${lib.getExe cfg.package}";
  serviceConfig.KeepAlive = true;
};
```

## Home Manager-specific

### XDG config file

```nix
xdg.configFile."<app>/config".text = ''
  # config content
'';
```

### Program configuration

```nix
programs.<name> = {
  enable = true;
  package = cfg.package;
  settings = cfg.settings;
};
```

## Validation

Use the `nix-validation` skill for the complete validation workflow.

At minimum, run:

```sh
nixfmt --check path/to/changed-file.nix
git diff --check
```

For module, overlay, input, or lockfile changes, evaluate the affected output
and run:

```sh
nix flake check --all-systems
```

Do not report validation as passed when it was skipped, blocked, or failed.

## Best Practices

1. Use `lib.mkEnableOption` for enable flags
2. Use `lib.mkDefault` for overridable defaults
3. Use `lib.mkForce` sparingly, only when necessary
4. Keep modules focused on single responsibility
5. Document options with `description`
6. Use `lib.getExe` for binary paths
7. Keep `settings` optional with `default = { };` unless the program requires configuration
