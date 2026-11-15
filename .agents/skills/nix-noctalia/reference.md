# Nix Noctalia Reference

This reference documents the repository's Noctalia integration patterns for
Nix modules, external plugins, local Luau plugins, and theme templates.

It is used together with:

```text
.agents/skills/nix-noctalia/SKILL.md
```

## Nix Plugin Integration

External plugin integrations normally use:

```nix
{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
in
{
  home = lib.mkIf cfg.enable {
    packages = with pkgs; [
      required-package
    ];
  };

  programs.noctalia.settings = {
    plugins.enabled = [ "namespace/plugin-name" ];

    plugin_settings."namespace/plugin-name" = {
      # plugin settings
    };
  };
}
```

Use `cfg = config.homeDesktop.noctalia` consistently. Install CLI
dependencies conditionally through `home.packages` rather than globally.

## Plugin Sources and IDs

Plugin sources are configured in:

```text
modules/home/desktop/noctalia/plugins/source.nix
```

The repository currently defines official, community, and local Git/path
sources. Use the exact upstream plugin ID everywhere:

```text
namespace/plugin-name
```

The same ID must be used in `plugins.enabled`, `plugin_settings`, component
references, and IPC commands.

## Plugin Components

Noctalia plugins may provide services, panels, widgets, launcher providers,
settings, and IPC actions. Reference component IDs with the complete plugin
namespace:

```nix
widget."namespace/plugin:widget-id" = {
  glyph = "icon";
};

shell.launcher.providers."namespace/plugin:provider-id" = {
  prefix = "prefix";
  global = true;
};
```

## Local Plugin Layout

A substantial local plugin normally uses:

```text
local-plugins/<namespace>/<plugin-name>/
├── plugin.toml
├── README.md
├── service.luau
├── panel.luau
├── widget.luau
├── translations/
│   └── en.json
└── thumbnail.webp
```

Only add components that the plugin needs.

## `plugin.toml`

Include stable metadata:

```toml
id = "namespace/plugin-name"
name = "Human-readable name"
version = "1.0.0"
author = "author"
dependencies = ["required-command"]
tags = ["bar", "panel", "utility"]
icon = "icon-name"
description = "Short plugin description."
```

Set `plugin_api` to the integer supported by the installed Noctalia version.
Verify the current plugin API from the Noctalia plugin documentation or runtime
before creating or updating a local plugin; do not copy a historical API
version blindly.

Declare settings with stable keys, supported types, translation keys, defaults,
and bounds where applicable:

```toml
[[setting]]
key = "columns"
type = "int"
label_key = "settings.columns.label"
description_key = "settings.columns.description"
default = 3
min = 1
max = 4
step = 1
```

Keep plugin IDs stable after publication.

## Local Plugin Luau Architecture

Prefer separating responsibilities:

```text
service.luau  → parsing, IPC, cache, refresh, external data
panel.luau    → rendering, search, editing, user interaction
widget.luau   → lightweight bar entry and toggle/refresh actions
```

The service should own shared data and publish snapshots through
`noctalia.state`. Use `noctalia.getConfig()` for plugin settings,
`noctalia.tr()` for user-facing text, and `noctalia.pluginDataDir()` for
persistent plugin data.

Avoid polling loops, unnecessary timers, filesystem watchers, persistent helper
processes, duplicate parsing, and building large UI trees in one callback.

Use stable plugin-prefixed state keys:

```lua
local SNAPSHOT_KEY = "plugin-name.snapshot"
```

## Complex Local Plugin Patterns

For plugins that process external data or render large interfaces, use an
event-driven architecture.

The service should:

- load configuration once during startup;
- refresh only on explicit requests or relevant settings changes;
- publish normalized data through `noctalia.state`;
- keep the last successful snapshot when a refresh fails;
- store durable cache data through `noctalia.pluginDataDir()`;
- use bounded parsing depth, file count, or input size where applicable.

The panel should:

- read the shared snapshot instead of parsing source data;
- keep search and editing state local to the panel;
- render large result sets progressively;
- avoid rebuilding the entire UI tree in one callback.

The widget should remain lightweight:

- render its icon and tooltip;
- toggle the panel;
- request refresh through a state key or IPC event;
- never duplicate service parsing or cache logic.

Use stable plugin-prefixed state keys and avoid timers, polling loops,
persistent subprocesses, and filesystem watchers unless they are required.

## Local Plugin Documentation

Every substantial local plugin should document its ID, components, requirements,
usage, settings, IPC commands, persistence behavior, architecture, and known
limitations. Use portable paths such as `~/.config/...`; do not hardcode a
machine-specific home directory.

## Translations

Keys referenced by `plugin.toml` and Luau must exist in:

```text
translations/en.json
```

Keep setting labels and descriptions grouped under `settings` and avoid
hardcoding user-facing strings when a translation key is appropriate.

## Built-in and Community Templates

Built-in template integration belongs in:

```text
templates/builtin.nix
```

Community template integration belongs in:

```text
templates/comunity.nix
```

Use `enable_builtin_templates` with `builtin_ids`, or
`enable_community_templates` with `community_ids`. Keep application-specific
theme integration in the template module rather than unrelated Noctalia files.

## User Templates

User template inputs belong under:

```text
templates/inputs/
```

Static inputs use `xdg.configFile`:

```nix
xdg.configFile."noctalia/inputs/example.css".source =
  ./inputs/example.css;
```

Dynamic JSON inputs use `pkgs.formats.json`:

```nix
jsonFormat = pkgs.formats.json { };
generated = jsonFormat.generate "template.json" settings;
```

Register user templates with explicit input and output paths:

```nix
programs.noctalia.settings.theme.templates.user = {
  example = {
    input_path = "${inputsDirectory}/example.css";
    output_path = "${homeDirectory}/.config/example/theme.css";
  };
};
```

Use `config.home.homeDirectory` instead of hardcoding `/home/<user>`.

## Validation Checklist

Before committing:

- verify the actual path of every referenced repository convention;
- verify plugin source registration;
- verify plugin IDs and component IDs;
- install required packages conditionally;
- validate `plugin.toml` metadata and entrypoints;
- validate translation keys;
- validate template input and output paths;
- run the relevant formatter;
- run `git diff --check`;
- evaluate affected configurations;
- run `nix flake check --all-systems` when Nix outputs are affected;
- review the complete diff.
