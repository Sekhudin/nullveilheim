{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;

  jsonFormat = pkgs.formats.json { };
  tomlFormat = pkgs.formats.toml { };

  homeDirectory = config.home.homeDirectory;
  inputsDirectory = "${homeDirectory}/.config/noctalia/inputs";

  yakc = config.programs.yakc;
  yakcSource = jsonFormat.generate "template.json" (
    yakc.settings
    // {
      popupFontColor = "{{ colors.on_primary.default.hex }}";
      popupBackgroundColor = "{{ colors.primary.default.hex }}";
    }
  );

  herdr = config.programs.herdr;
  herdrSource = tomlFormat.generate "herdr-template.toml" (
    herdr.settings
    // {
      theme.custom = {
        accent = "{{ colors.primary.default.hex }}";
        panel_bg = "{{ colors.surface.default.hex }}";
        sidebar_bg = "{{ colors.surface_container.default.hex }}";
        active_row_bg = "{{ colors.primary_container.default.hex }}";
        selection_bg = "{{ colors.secondary_container.default.hex }}";

        surface0 = "{{ colors.surface.default.hex }}";
        surface1 = "{{ colors.surface_container.default.hex }}";
        surface_dim = "{{ colors.surface_dim.default.hex }}";

        overlay0 = "{{ colors.outline_variant.default.hex }}";
        overlay1 = "{{ colors.outline.default.hex }}";

        text = "{{ colors.on_surface.default.hex }}";
        subtext0 = "{{ colors.on_surface_variant.default.hex }}";

        mauve = "{{ colors.terminal_normal_magenta.default.hex }}";
        green = "{{ colors.terminal_normal_green.default.hex }}";
        yellow = "{{ colors.terminal_normal_yellow.default.hex }}";
        red = "{{ colors.terminal_normal_red.default.hex }}";
        blue = "{{ colors.terminal_normal_blue.default.hex }}";
        teal = "{{ colors.terminal_normal_cyan.default.hex }}";
        peach = "{{ colors.tertiary_container.default.hex }}";
      };
    }
  );
in
{
  programs.yakc.skipConfigFile = cfg.enable;
  programs.herdr.skipConfigFile = cfg.enable;

  xdg.configFile = lib.mkIf cfg.enable {
    "noctalia/inputs/obsidian.css".source = ./inputs/obsidian.css;
    "noctalia/inputs/telegram.tdesktop-theme".source = ./inputs/telegram.tdesktop-theme;
    "noctalia/inputs/yakc.json".source = yakcSource;
    "noctalia/inputs/herdr.toml".source = herdrSource;
  };

  programs.noctalia.settings.theme.templates.user = {
    obsidian = {
      input_path = "${inputsDirectory}/obsidian.css";
      output_path = "${homeDirectory}/.config/obsidian/noctalia.css";
    };
    telegram = {
      input_path = "${inputsDirectory}/telegram.tdesktop-theme";
      output_path = "${homeDirectory}/.local/share/TelegramDesktop/noctalia.tdesktop-theme";
    };
    yakc = {
      input_path = "${inputsDirectory}/yakc.json";
      output_path = "${homeDirectory}/.config/dev.iammodev.yakc/config.json";
    };
    herdr = {
      input_path = "${inputsDirectory}/herdr.toml";
      output_path = "${homeDirectory}/.config/herdr/config.toml";
    };
  };
}
