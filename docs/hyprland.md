# Hyprland Development

> Scope: developing Hyprland bindings, rules, plugins, and application integrations.

Linux desktop configurations use [Hyprland](https://wiki.hypr.land/) through
[Home Manager](https://home-manager.dev/manual/26.05/). The main
module is `modules/home/desktop/hypr/hypr.nix`, and the desktop module tree is
automatically discovered by `modules/home/desktop/default.nix`.

The Home Manager option used by this repository is documented at
[`wayland.windowManager.hyprland.enable`](https://home-manager.dev/manual/26.05/options.xhtml#opt-wayland.windowManager.hyprland.enable).

Hyprland is enabled by the repository's `homeDesktop.enable` option. The
Hyprland module maps that option to
`wayland.windowManager.hyprland.enable`; it is enabled for Linux desktop
profiles and disabled for the macOS profile.

## Module Structure

```text
modules/home/desktop/hypr/
├── hypr.nix             # main Hyprland settings and Lua config mode
├── animation.nix        # animation settings
├── env.nix              # environment variables
├── monitor.nix          # monitor configuration
├── variable.nix         # Hyprland variables
├── plugins.nix          # Hyprland plugins
├── binds/               # keybindings grouped by purpose
├── options/             # application/module options
├── configs/             # application configuration values
├── window-rule.nix      # window rules
└── workspace-rule.nix   # workspace rules
```

The `binds/` directory is split into focused groups such as applications,
media, volume, brightness, workspaces, sessions, screenshots, and panels.

## Automatic Imports

The desktop entrypoint recursively imports the modules below
`modules/home/desktop/`. A new `.nix` file in the Hyprland tree is therefore
discovered automatically when it follows the existing module structure.

Keep reusable Hyprland behavior in the module tree. Keep shared helper logic
in `shared/lib/hyprland/` instead of duplicating generated Lua expressions.

## Bindings

Bindings use helpers from the repository's `extraLib.hyprland`. These helpers
wrap Home Manager's Hyprland settings and the repository's Nix library
functions. A typical binding looks like:

```nix
{
  config,
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland) ctl hl hypr;
in
{
  wayland.windowManager.hyprland.settings.bind = [
    (hypr.mkBind {
      group = "apps";
      key = ctl.combos.mod ctl.keys.enter;
      dispatcher = hl.dsp.exec_cmd {
        cmd = "ghostty";
      };
      flags.description = "open terminal";
    })
  ];
}
```

Use `hypr.mkSubmap` and `hypr.mkSubmapBind` for groups of related bindings.
Submaps automatically get an Escape binding when the default `escape` option
is enabled.

Use the existing `hl` helpers for compositor actions such as launching a
command, changing workspaces, moving windows, toggling floating state, and
controlling displays.

## Rules and Workspaces

Window and workspace rules are represented as structured values:

```nix
wayland.windowManager.hyprland.settings.window_rule = [
  (hypr.mkWindowRule {
    name = "example-window";
    match.class = "^(Example)$";
    float = true;
  })
];
```

Use `hypr.mkWorkspaceRule` when the same rule applies to multiple workspaces.
Keep matching expressions and rule names descriptive so they remain easy to
find in the generated configuration.

## Application Options and Configs

Application-specific Hyprland integrations are split between `options/` and
`configs/`:

- `options/` declares Home Manager options and enables packages or rules.
- `configs/` supplies the selected configuration values.

For example, the YAKC option module declares `programs.yakc`, while its config
module enables it and derives styling from the active theme and font settings.

## Shared Helpers

The helper library is exposed through `extraLib.hyprland` and includes:

- `hypr` for structured Hyprland values and bindings.
- `hl` for generated Lua helper calls.
- `events` for event handlers.
- `ctl` and `variables` for shared controls and variable definitions.

`hypr.getVarRefs config "name"` returns Lua references to configured values.
Use it when generated Lua should read the value at runtime. Use
`hypr.getVarValues config "name"` when a module needs the concrete Nix value
while evaluating the configuration.

The implementation is in:

```text
shared/lib/hyprland/
├── default.nix
├── hypr.nix
├── hl.nix
├── events.nix
└── variables-ctl.nix
```

For the complete helper reference, see
[`../.opencode/skills/nix-hyprland/reference.md`](../.opencode/skills/nix-hyprland/reference.md).

For the underlying Home Manager module options, see the
[Home Manager manual](https://home-manager.dev/manual/26.05/). For
general Nix module helpers such as `lib.mkIf` and `lib.mkOption`, see the
[Nixpkgs library manual](https://nixos.org/manual/nixpkgs/stable/#sec-functions-library).

[← Back to README](../README.md)
