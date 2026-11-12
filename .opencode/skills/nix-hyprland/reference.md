# Nix Hyprland Reference

This reference documents the repository's Hyprland helper API and the standard
implementation patterns used by modules under `modules/home/desktop/hypr/`.

It is used together with:

```text
.opencode/skills/nix-hyprland/SKILL.md
```

## Helper API

The helper library is assembled in:

```text
shared/lib/hyprland/default.nix
```

It exposes:

```nix
extraLib.hyprland = {
  hypr = ...;
  hl = ...;
  events = ...;
  variables = ...;
  ctl = ...;
};
```

### `hypr`

Important constructors and helpers:

```text
mkVar
mkEnv
mkAnimation
mkCurve
mkWindowRule
mkLayerRule
mkWorkspaceRule
mkBind
mkSubmap
mkSubmapBind
mkEvent
mkMonitor
getVarRefs
getVarValues
```

### `hl`

`hl` generates calls to the repository's Lua helper API.

Important namespaces:

```text
hl.exec_cmd
hl.config

hl.dsp.dpms
hl.dsp.exec_cmd
hl.dsp.exit
hl.dsp.focus
hl.dsp.submap

hl.dsp.window.close
hl.dsp.window.cycle_next
hl.dsp.window.drag
hl.dsp.window.float
hl.dsp.window.fullscreen
hl.dsp.window.move
hl.dsp.window.pin
hl.dsp.window.resize
hl.dsp.window.swap

hl.dsp.workspace.change_id
hl.dsp.workspace.move
hl.dsp.workspace.rename
hl.dsp.workspace.swap_monitors
hl.dsp.workspace.toggle_special

hl.plugin.hyprexpo.expo
hl.plugin.hyprexpo.kb_focus
hl.plugin.hyprexpo.kb_confirm

hl.extra.layout_toggle
hl.extra.toggle_pin
hl.extra.zen_mode
```

Use these helpers instead of manually writing equivalent Lua strings.

### `events`

Current event helpers include:

```nix
events.config.reloaded
events.hyprland.start
```

Example:

```nix
settings.on = [
  (hypr.mkEvent {
    event = events.config.reloaded;
    action = hl.config {
      plugin = {
        hyprexpo = {
          columns = 3;
          rows = 3;
        };
      };
    };
  })
];
```

### `ctl`

`ctl` provides reusable keys, mouse buttons, directions, and combinations:

```nix
ctl.keys.mod
ctl.keys.enter
ctl.keys.escape
ctl.keys.volume_up

ctl.mouse.left
ctl.mouse.right

ctl.directions.left
ctl.directions.right
ctl.directions.up
ctl.directions.down

ctl.combos.plain "F"
ctl.combos.mod "F"
ctl.combos.alt "M"
ctl.combos.ctrl "H"
ctl.combos.shift "H"
ctl.combos.of [ ctl.keys.mod ctl.keys.shift ] "R"
```

Use `ctl` instead of repeating raw modifier and key expressions.

## Variables and References

Shared values belong in:

```text
modules/home/desktop/hypr/variable.nix
```

Current variable groups include:

```text
monitors
submaps
cursor
tokens
styles
apps
ipc
panels
sessions
screenshots
brightness
media
volume
mic
```

### `hypr.mkVar`

Create shared variables with:

```nix
hypr.mkVar {
  terminal = core.terminal;
  browser = core.browser;
}
```

### `hypr.getVarRefs`

Use `getVarRefs` when generated Lua should reference a variable:

```nix
let
  styles = hypr.getVarRefs config "styles";
in
{
  wayland.windowManager.hyprland.settings.general = {
    border_size = styles.border_size;
    gaps_in = styles.margin_in;
    gaps_out = styles.margin_out;
  };
}
```

### `hypr.getVarValues`

Use `getVarValues` when Nix needs the actual value for calculations or
configuration generation:

```nix
let
  styles = hypr.getVarValues config "styles";
  speed = styles.animation_ms / 100;
in
{
  wayland.windowManager.hyprland.settings.animation = [
    (hypr.mkAnimation {
      inherit speed;
      enabled = true;
      leaf = "windows";
      bezier = "smooth";
      style = "slide";
    })
  ];
}
```

## Core Hyprland Settings

Global settings belong in:

```text
modules/home/desktop/hypr/hypr.nix
```

The core module enables Hyprland from `config.homeDesktop.enable`, uses
`configType = "lua"`, enables systemd integration, and defines global input,
decoration, layout, rendering, XWayland, and behavior settings.

Use `lib.mkMerge` when multiple modules contribute to the same settings
attribute, as done by `variable.nix`.

## Environment Variables

Environment variables belong in:

```text
modules/home/desktop/hypr/env.nix
```

Use `hypr.mkEnv`:

```nix
settings.env = [
  (hypr.mkEnv "HYPRCURSOR_THEME" cursor.theme)
  (hypr.mkEnv "HYPRCURSOR_SIZE" cursor.size)
  (hypr.mkEnv "XCURSOR_THEME" cursor.theme)
  (hypr.mkEnv "XCURSOR_SIZE" cursor.size)
];
```

Do not hardcode theme values when they already exist in shared variables.

## Monitors

Monitor configuration belongs in:

```text
modules/home/desktop/hypr/monitor.nix
```

Use `hypr.mkMonitor`:

```nix
settings.monitor = [
  (hypr.mkMonitor {
    output = "";
  })

  (hypr.mkMonitor {
    output = monitors.primary;
    mode = "1920x1080@60";
    position = "0x0";
    scale = 1;
  })
];
```

Prefer monitor names from:

```nix
monitors = hypr.getVarRefs config "monitors";
```

Do not duplicate host-specific monitor names across modules.

## Animations and Curves

Animation configuration belongs in:

```text
modules/home/desktop/hypr/animation.nix
```

Use `hypr.mkCurve` and `hypr.mkAnimation`:

```nix
let
  styles = hypr.getVarValues config "styles";
  speed = styles.animation_ms / 100;
in
{
  wayland.windowManager.hyprland.settings = {
    curve = [
      (hypr.mkCurve {
        name = "smooth";
        options = {
          type = "bezier";
          points = [
            [ 0.22 1.0 ]
            [ 0.36 1.0 ]
          ];
        };
      })
    ];

    animation = [
      (hypr.mkAnimation {
        inherit speed;
        enabled = true;
        leaf = "windows";
        bezier = "smooth";
        style = "slide";
      })
    ];
  };
}
```

Derive animation values from `styles` instead of scattering timing constants.

## Window and Workspace Rules

Global window rules belong in:

```text
modules/home/desktop/hypr/window-rule.nix
```

Workspace rules belong in:

```text
modules/home/desktop/hypr/workspace-rule.nix
```

Window rule example:

```nix
settings.window_rule = [
  (hypr.mkWindowRule {
    name = "example-window";
    match = {
      class = "(?i)^example$";
      title = "(?i)^example window$";
    };
    float = true;
    no_focus = true;
    border_size = 0;
  })
];
```

Workspace rule example:

```nix
settings.workspace_rule = hypr.mkWorkspaceRule {
  workspaces = [
    "1"
    "2"
    "3"
  ];

  rules = {
    persistent = true;
    monitor = monitors.primary;
  };

  extraWorkspaceRule = [ ];
};
```

Use named rules and structured `match` attributes. Application-specific rules
should normally live in the corresponding application option module.

## Keybindings and Submaps

Keybindings belong under:

```text
modules/home/desktop/hypr/binds/
```

A typical binding module:

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
    ;

  apps = hypr.getVarRefs config "apps";
  bindGroup = "apps";
in
{
  wayland.windowManager.hyprland.settings.bind = [
    (hypr.mkBind {
      group = bindGroup;
      key = ctl.combos.mod ctl.keys.enter;
      dispatcher = hl.dsp.exec_cmd {
        cmd = apps.terminal;
      };
      flags = {
        description = "open terminal";
      };
    })
  ];
}
```

`hypr.mkBind` accepts:

```nix
{
  key,
  dispatcher,
  group ? "other",
  flags ? { },
}
```

The group is automatically included in the generated description. Do not
manually repeat the group prefix.

Use dispatchers such as:

```nix
hl.dsp.exec_cmd { cmd = apps.terminal; }
hl.dsp.focus { direction = ctl.directions.left; }
hl.dsp.window.close { }
hl.dsp.window.move { workspace = 2; }
hl.dsp.workspace.move { monitor = "+1"; }
```

### Submaps

Use `hypr.mkSubmap` for a mode with multiple bindings:

```nix
settings.define_submap = [
  (hypr.mkSubmap {
    group = "monitor";
    name = submaps.monitor;
    escape = true;
    bind = [
      (hypr.mkSubmapBind {
        group = "monitor";
        key = ctl.combos.plain "H";
        dispatcher = hl.dsp.focus {
          monitor = "-1";
        };
        flags = {
          description = "focus previous monitor";
        };
      })
    ];
  })
];
```

Use `hypr.mkSubmapBind` instead of `hypr.mkBind` inside a submap.

By default, `escape = true` adds an escape binding that resets the submap.
Use `escape = false` only when the submap has explicit exit behavior.

### Generated bindings

Use Nix generation for repetitive bindings:

```nix
mkWorkspaceBind =
  {
    count,
    extraBind ? [ ],
  }:
  (lib.flatten (
    lib.genList (
      i:
      let
        workspace = i + 1;
        key = toString workspace;
      in
      [
        (hypr.mkBind {
          key = ctl.combos.mod key;
          dispatcher = hl.dsp.focus {
            inherit workspace;
          };
          flags = {
            description = "switch to workspace ${toString workspace}";
          };
        })
      ]
    ) count
  ))
  ++ extraBind;
```

Do not manually duplicate systematic bindings.

## Plugins

Plugin configuration belongs in:

```text
modules/home/desktop/hypr/plugins.nix
```

Example:

```nix
wayland.windowManager.hyprland = {
  plugins = with pkgs.hyprlandPlugins; [
    hyprexpo
  ];

  settings.on = [
    (hypr.mkEvent {
      event = events.config.reloaded;
      action = hl.config {
        plugin = {
          hyprexpo = {
            columns = 3;
            rows = 3;
          };
        };
      };
    })
  ];
};
```

Plugin package exposure is separate from plugin configuration. Confirm that the
plugin is available through `pkgs.hyprlandPlugins` before adding it.

Plugin-specific bindings belong under `binds/<plugin>.nix` when they form a
distinct feature.

## Application Integration

Application integration uses two layers:

```text
options/<application>.nix
    → reusable options, package integration, and conditional rules

configs/<application>.nix
    → application-specific defaults
```

An options module may define enablement, package options, typed settings,
optional installation, and application-specific rules:

```nix
{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.programs.example;
  inherit (extraLib.hyprland) hypr;
in
{
  options.programs.example = {
    enable = lib.mkEnableOption "example";

    package = lib.mkPackageOption pkgs "example" {
      nullable = false;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Configuration for example.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    wayland.windowManager.hyprland.settings.window_rule = [
      (hypr.mkWindowRule {
        name = "example";
        match.class = "^example$";
        float = true;
      })
    ];
  };
}
```

A configuration module provides defaults derived from repository context:

```nix
{ config, ... }:

let
  cfg = config.homeDesktop;
in
{
  programs.example = {
    enable = cfg.enable;
    settings = {
      keyboardLayout = config.homeCore.keyboardLayout;
    };
  };
}
```

Keep option declarations and application defaults separate.

## Lua Generation Rules

Prefer structured helpers:

```nix
dispatcher = hl.dsp.exec_cmd {
  cmd = apps.terminal;
};
```

Avoid manually assembling equivalent Lua strings:

```nix
dispatcher = ''hl.dsp.exec_cmd("${apps.terminal}")'';
```

Use constructors for rules, bindings, monitors, events, and animations instead
of manually generating serialized syntax.

Use raw Lua only when:

- No existing helper can express the behavior.
- The behavior is genuinely custom.
- The code belongs in a reusable helper.

Complex reusable Lua belongs in:

```text
shared/lib/hyprland/hl.nix
```

Do not copy the same Lua implementation into multiple feature modules.

### Extending the `hl` helper

If a required helper such as:

```text
hl.<namespace>.<function>
```

does not exist, add it to:

```text
shared/lib/hyprland/hl.nix
```

Do not bypass the helper architecture by writing the same raw Lua expression
directly inside a feature module.

Before adding a helper:

1. Search `shared/lib/hyprland/hl.nix` for an existing equivalent.
2. Check whether the required Lua function already exists in the repository's
   runtime or helper API.
3. Follow the existing namespace and naming convention.
4. Keep the helper generic and reusable.
5. Use the helper from the feature module.
6. Validate both the helper and affected Home Manager configuration.

Use `mkCall` for positional Lua arguments:

```nix
special_action =
  p:
  mkCall {
    func = "hl.dsp.special_action";
    args = [
      p.name
      p.value
    ];
  };
```

Use `mkCallAttrs` for named Lua table attributes:

```nix
special_action =
  p:
  mkCallAttrs {
    func = "hl.dsp.window.special_action";
    attrs = p;
  };
```

Use it from a module:

```nix
dispatcher = hl.dsp.window.special_action {
  action = "toggle";
};
```

For custom multi-step Lua, use the existing `luaLib.mkLuaFunc` and
`luaLib.toLua` patterns inside `hl.nix`:

```nix
special_action =
  p:
  luaLib.mkLuaFunc ''
    local target = ${luaLib.toLua p.target}

    if target then
        hl.dispatch(hl.dsp.focus({
            target = target,
        }))
    end
  '';
```

Helper placement rules:

```text
Existing helper matches behavior
    → use the existing helper

Missing helper with reusable behavior
    → add it to shared/lib/hyprland/hl.nix

Missing helper with feature-specific behavior
    → keep it local to the feature module

Repeated raw Lua across modules
    → extract it into hl.nix

One-off simple behavior with no reuse
    → local implementation may be acceptable
```

Do not add feature-specific behavior to `hl.nix` when it is only useful to one
module. Add it to `hl.nix` when the generated Lua behavior is reusable or is
part of the shared Hyprland helper API.
