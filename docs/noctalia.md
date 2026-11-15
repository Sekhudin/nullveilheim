# Noctalia

Noctalia is the Linux desktop shell used by this repository. It provides the
bar, dock, notifications, wallpaper, OSD, lockscreen, desktop widgets, and
plugin system.

The Noctalia configuration is located under:

```text
modules/home/desktop/noctalia/
```

## Enabling Noctalia

Enable the desktop shell from a Home Manager profile with:

```nix
homeDesktop = {
  enable = true;
  use = "noctalia";
};
```

`homeDesktop.enable` enables the desktop configuration. The only currently
available value for `homeDesktop.use` is:

```text
noctalia
```

Linux profiles can also enable the desktop based on the current platform:

```nix
homeDesktop.enable = isLinux;
```

The main Noctalia integration then enables:

```nix
programs.noctalia.enable = true;
```

## Available Options

The Noctalia-specific options are defined in:

```text
modules/home/desktop/options.nix
```

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `homeDesktop.enable` | boolean | `false` | Enable the desktop configuration. |
| `homeDesktop.use` | enum | `"noctalia"` | Select the desktop shell. |
| `homeDesktop.noctalia.bar.label.enable` | boolean | `false` | Show labels in the bar. |
| `homeDesktop.noctalia.dock.enable` | boolean | `true` | Enable the dock. |
| `homeDesktop.noctalia.desktop.widgets.enable` | boolean | `false` | Enable desktop widgets. |
| `homeDesktop.noctalia.desktop.wallpaper.automation.enable` | boolean | `false` | Enable wallpaper automation. |
| `homeDesktop.noctalia.desktop.backdrop.enable` | boolean | `false` | Enable the desktop backdrop. |

Example:

```nix
homeDesktop.noctalia = {
  bar.label.enable = true;
  dock.enable = true;

  desktop = {
    widgets.enable = true;
    wallpaper.automation.enable = true;
    backdrop.enable = true;
  };
};
```

`homeDesktop.noctalia.enable` is an internal read-only value. It is derived
from `homeDesktop.enable` and `homeDesktop.use`, so it should not be set
directly.

## Configuration Structure

```text
modules/home/desktop/noctalia/
├── noctalia.nix       # main integration
├── bar/               # bar and bar widgets
├── desktop/           # wallpaper and desktop widgets
├── dock/               # dock configuration
├── ipc/                # IPC command wrappers
├── plugins/            # plugin integrations
├── service/            # audio, battery, calendar, and other services
├── shell/              # shell, theme, lockscreen, and OSD settings
└── templates/          # built-in, community, and user templates
```

Noctalia modules are discovered automatically through the recursive desktop
module loader. Ordinary modules below `modules/home/desktop/` do not need
manual imports.

Common Noctalia settings are configured through modules under:

```text
modules/home/desktop/noctalia/shell/
modules/home/desktop/noctalia/service/
modules/home/desktop/noctalia/desktop/
modules/home/desktop/noctalia/bar/
modules/home/desktop/noctalia/dock/
```

## Plugins

Plugin source definitions are located in:

```text
modules/home/desktop/noctalia/plugins/source.nix
```

The repository uses three plugin sources:

| Source | Type | Purpose |
| --- | --- | --- |
| Official | Git | Official Noctalia plugins. |
| Community | Git | Community-maintained plugins. |
| Local | Path | Plugins maintained in this repository. |

Enable a plugin and configure its settings with:

```nix
programs.noctalia.settings = {
  plugins.enabled = [
    "namespace/plugin-name"
  ];

  plugin_settings."namespace/plugin-name" = {
    # Plugin-specific settings.
  };
};
```

Plugin integrations are organized under:

```text
modules/home/desktop/noctalia/plugins/
```

Use the exact plugin ID consistently in `plugins.enabled`,
`plugin_settings`, widget or panel references, and IPC commands.

The repository intentionally preserves the existing `comunity` spelling for
community integrations:

```text
modules/home/desktop/noctalia/plugins/comunity/
```

## Local Plugins

Local plugin source code belongs under:

```text
modules/home/desktop/noctalia/local-plugins/
```

A substantial local plugin may contain:

```text
plugin.toml
README.md
service.luau
panel.luau
widget.luau
translations/en.json
thumbnail.webp
```

The Nix integration for a local plugin is kept separately under:

```text
modules/home/desktop/noctalia/plugins/local/
```

Keep plugin metadata, component IDs, translation keys, and entrypoints
consistent with the plugin's `plugin.toml` file.

## Theme Templates

Built-in template integration is defined in:

```text
modules/home/desktop/noctalia/templates/builtin.nix
```

Community template integration is defined in:

```text
modules/home/desktop/noctalia/templates/comunity.nix
```

The repository uses templates to apply the Noctalia theme to applications such
as Ghostty, Alacritty, GTK, Qt, Obsidian, Telegram, YAKC, and Yazi.

User template inputs belong under:

```text
modules/home/desktop/noctalia/templates/inputs/
```

Static inputs use `xdg.configFile`:

```nix
xdg.configFile."noctalia/inputs/example.css".source =
  ./inputs/example.css;
```

Generated JSON inputs use `pkgs.formats.json`:

```nix
jsonFormat = pkgs.formats.json { };
generated = jsonFormat.generate "template.json" settings;
```

Use `config.home.homeDirectory` when constructing template paths instead of
hardcoding a machine-specific home directory.

## Related Files

| Purpose | Path |
| --- | --- |
| Main Noctalia integration | `modules/home/desktop/noctalia/noctalia.nix` |
| Desktop options | `modules/home/desktop/options.nix` |
| Plugin sources | `modules/home/desktop/noctalia/plugins/source.nix` |
| Plugin integrations | `modules/home/desktop/noctalia/plugins/` |
| Local plugin source | `modules/home/desktop/noctalia/local-plugins/` |
| Built-in templates | `modules/home/desktop/noctalia/templates/builtin.nix` |
| Community templates | `modules/home/desktop/noctalia/templates/comunity.nix` |
| User template inputs | `modules/home/desktop/noctalia/templates/inputs/` |

[← Back to README](../README.md)
