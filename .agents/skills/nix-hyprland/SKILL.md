---
name: Nix Hyprland
description: Develop Hyprland configuration using this repository's modules and custom Lua helpers
---

# Nix Hyprland

Use this skill when adding, modifying, or debugging Hyprland behavior in this
repository's Home Manager configuration.

This repository uses Home Manager's Hyprland module with:

```nix
wayland.windowManager.hyprland = {
  configType = "lua";
};
```

Hyprland configuration is written declaratively in Nix and converted to Lua by
Home Manager and the repository's custom helpers.

## Repository Architecture

Hyprland configuration is split into two layers:

```text
modules/home/desktop/hypr/
    → feature modules and Home Manager settings

shared/lib/hyprland/
    → reusable Nix helpers and Lua expression generators
```

The shared helper API is exposed through:

```nix
extraLib.hyprland
```

Typical module imports:

```nix
{
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    hypr
    ctl
    hl
    events
    ;
in
{
  # Hyprland settings
}
```

Do not duplicate helper logic inside individual modules when an existing
`extraLib.hyprland` helper already provides the required behavior.

## Automatic Module Loading

The desktop module loader recursively imports `.nix` files under:

```text
modules/home/desktop/
```

The loader is configured in:

```text
modules/home/desktop/default.nix
```

Therefore, a new `.nix` file placed under:

```text
modules/home/desktop/hypr/
modules/home/desktop/hypr/binds/
modules/home/desktop/hypr/options/
modules/home/desktop/hypr/configs/
```

is normally loaded automatically.

Do not add redundant manual imports for ordinary Hyprland modules.

Manual imports are appropriate when a module imports an external module:

```nix
imports = [
  inputs.openscreen.homeManagerModules.default
];
```

## File Naming and Placement

Use lowercase kebab-case for Hyprland-related file names:

```text
window-rule.nix
workspace-rule.nix
hyprexpo.nix
```

Do not use uppercase names, spaces, or inconsistent abbreviations.

Prefer extending an existing feature file when the change belongs to an
existing domain. Create a new file only when the behavior represents a
distinct, reusable, or substantial feature.

### Directory layout

```text
modules/home/desktop/hypr/
├── hypr.nix
├── variable.nix
├── env.nix
├── monitor.nix
├── animation.nix
├── window-rule.nix
├── workspace-rule.nix
├── plugins.nix
├── binds/
├── options/
└── configs/
```

### Core modules

Use the root of `hypr/` for general Hyprland session configuration:

```text
hypr.nix           → enablement and global settings
variable.nix       → shared variables, commands, tokens, and styles
env.nix            → Hyprland environment variables
monitor.nix        → monitor definitions
animation.nix      → curves and animations
window-rule.nix    → global window rules
workspace-rule.nix → workspace rules
plugins.nix        → plugin declarations and plugin events
```

Do not add application-specific configuration to `hypr.nix`.

### Binding files

Binding files belong under:

```text
modules/home/desktop/hypr/binds/
```

Name them after their behavior or feature:

```text
apps.nix
brightness.nix
hyprexpo.nix
ipc.nix
media.nix
mic.nix
monitor.nix
other.nix
panels.nix
sessions.nix
screenshots.nix
volume.nix
window.nix
workspace.nix
```

Examples:

```text
application launcher → binds/apps.nix
window actions       → binds/window.nix
workspace actions    → binds/workspace.nix
monitor actions      → binds/monitor.nix
volume controls      → binds/volume.nix
panel commands       → binds/panels.nix
IPC commands         → binds/ipc.nix
```

Do not create one file per individual keybinding. Create a new binding file
only when the feature has a distinct domain or is large enough to deserve its
own module.

### Application options and configurations

Application-specific integration uses matching files:

```text
modules/home/desktop/hypr/options/<application>.nix
modules/home/desktop/hypr/configs/<application>.nix
```

Current examples:

```text
options/yakc.nix
configs/yakc.nix

options/openscreen.nix
configs/openscreen.nix
```

Use `options/<application>.nix` for:

- `options.programs.<application>`.
- Enable options.
- Package options.
- Typed settings.
- Conditional package installation.
- Application-specific window rules.
- External Home Manager module imports.

Use `configs/<application>.nix` for:

- Application defaults.
- Theme-derived settings.
- Desktop context.
- Commands and paths from existing variables.
- Enabling the application through repository options.

Keep the application name identical in both directories.

Do not put reusable option declarations in `configs/`.
Do not put large application defaults in the core `hypr.nix`.

### Global rules versus application rules

Use root rule modules for broadly applicable rules:

```text
window-rule.nix
workspace-rule.nix
```

Put a rule in an application option module when it is only needed while that
application is enabled:

```nix
config = lib.mkIf cfg.enable {
  wayland.windowManager.hyprland.settings.window_rule = [
    (hypr.mkWindowRule {
      name = "application-window";
      match.class = "^application$";
      float = true;
    })
  ];
};
```

Do not add optional application rules to `window-rule.nix` when they depend on
an application-specific option.

### Shared helper files

Reusable Hyprland helper logic belongs under:

```text
shared/lib/hyprland/
```

Current helper files:

```text
default.nix
hypr.nix
hl.nix
events.nix
variables-ctl.nix
```

Responsibilities:

```text
default.nix
    → assembles and exports the helper API

hypr.nix
    → Nix constructors and variable/rule/bind helpers

hl.nix
    → Lua helper calls, dispatchers, plugin helpers, custom Lua behavior

events.nix
    → reusable Hyprland event definitions

variables-ctl.nix
    → key, mouse, direction, and variable-control helpers
```

Add logic to an existing helper when it belongs to that helper's responsibility.
Create a new helper file only for a distinct reusable subsystem. If a new helper
file is created, expose it through `shared/lib/hyprland/default.nix`.

Do not define reusable Lua generators directly inside feature modules.

### File placement decision tree

```text
Global Hyprland setting
    → modules/home/desktop/hypr/hypr.nix

Shared variable or command
    → modules/home/desktop/hypr/variable.nix

Environment variable
    → modules/home/desktop/hypr/env.nix

Monitor configuration
    → modules/home/desktop/hypr/monitor.nix

Animation or curve
    → modules/home/desktop/hypr/animation.nix

Global window rule
    → modules/home/desktop/hypr/window-rule.nix

Workspace rule
    → modules/home/desktop/hypr/workspace-rule.nix

Generic plugin declaration
    → modules/home/desktop/hypr/plugins.nix

Keybinding or submap
    → modules/home/desktop/hypr/binds/<domain>.nix

Application option or package integration
    → modules/home/desktop/hypr/options/<application>.nix

Application defaults
    → modules/home/desktop/hypr/configs/<application>.nix

Reusable Nix or Lua helper
    → shared/lib/hyprland/<responsible-helper>.nix
```

### Before creating a new file

Search existing modules and helpers:

```sh
find modules/home/desktop/hypr shared/lib/hyprland -type f -name '*.nix'

rg -n "wayland\\.windowManager\\.hyprland|extraLib\\.hyprland" \
  modules/home/desktop/hypr shared/lib/hyprland
```

Extend the closest matching module when possible.

## Recommended Workflow

1. Read `AGENTS.md`.
2. Inspect Git status and preserve unrelated changes.
3. Search for existing modules, variables, helpers, binding groups, and rules.
4. Decide the correct file and module category.
5. Reuse `extraLib.hyprland`.
6. If a required `hl.<namespace>.<function>` helper is missing, extend
   `shared/lib/hyprland/hl.nix` before writing raw Lua in a feature module.
7. Add or extend a shared variable before hardcoding reused values.
8. Keep options separate from application defaults.
9. Keep reusable Lua logic inside shared helpers.
10. Validate the affected Home Manager configuration.
11. Review the complete diff and report warnings or limitations.

## Reference Guide

For the complete helper API and implementation examples, read:

```text
.agents/skills/nix-hyprland/reference.md
```

The reference covers:

- `extraLib.hyprland` and its exported helpers.
- Variables and Lua references.
- Core Hyprland settings.
- Environment variables and monitors.
- Animations and rules.
- Keybindings and submaps.
- Plugins and application integration.
- Lua helper extension patterns.

## Platform and Host Compatibility

Hyprland modules are Linux desktop configuration. Do not assume they are valid
for Darwin Home Manager configurations.

Before changing shared Home Manager modules:

- Check where the Hyprland module is imported.
- Confirm the affected configuration enables the desktop module.
- Avoid adding Linux-only package assumptions to shared modules.
- Keep host-specific monitor and hardware behavior configurable.

Use `config.homeDesktop.enable` and existing feature options instead of
duplicating host conditionals.

## Design Rules

- Prefer existing `extraLib.hyprland` helpers.
- Prefer typed Nix options for reusable configuration.
- Use `lib.mkIf` for optional application integrations.
- Use `lib.mkMerge` when multiple modules contribute to shared settings.
- Use `hypr.getVarRefs` for generated Lua references.
- Use `hypr.getVarValues` for Nix-side calculations.
- Use `ctl` for keys, modifiers, mouse buttons, and directions.
- Use named window rules.
- Give bindings meaningful descriptions.
- Keep binding groups consistent with their feature.
- Use generated Nix lists for repetitive configuration.
- Avoid hardcoding monitor names, paths, colors, or dimensions when existing
  variables provide them.
- Do not modify generated or runtime files directly.
- Do not place unrelated application configuration in a Hyprland module.

## Validation

After changing Hyprland modules or helpers:

```sh
nixfmt --check path/to/changed-file.nix
git diff --check
nix flake check --all-systems
```

Use the repository's `nix-validation` skill for the complete validation
workflow.

When practical, inspect available outputs:

```sh
nix flake show
```

Evaluate the affected Home Manager configuration:

```sh
nix eval .#homeConfigurations.<name>.config
```

Build the affected Home Manager output when appropriate:

```sh
nix build .#homeConfigurations.<name>.activationPackage
```

Do not run:

```sh
nixos-rebuild switch
darwin-rebuild switch
```

Do not report validation as passed when it was skipped, blocked, or only
partially completed.

Report:

- Changed Hyprland modules.
- Changed shared helpers.
- Affected options, bindings, rules, plugins, or applications.
- Affected platforms and Home Manager outputs.
- Commands executed.
- Passed checks.
- Failures and whether they are related.
- Warnings and pre-existing failures.
- Known limitations.

## Safety Rules

- Do not read, decrypt, modify, or remove files under `secrets/`.
- Do not modify `.sops.yaml`.
- Do not expose credentials, tokens, private keys, or sensitive machine data.
- Do not run system-wide rebuild or switch commands.
- Do not commit or push changes.
- Preserve unrelated user changes.
- Do not revert or discard existing work.
