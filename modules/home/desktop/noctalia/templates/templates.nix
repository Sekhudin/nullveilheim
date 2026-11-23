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
        sidebar_bg = "{{ colors.surface.default.hex }}";
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

  starship = config.programs.starship;
  starshipSource = tomlFormat.generate "starship-template.toml" (
    starship.settings
    // {
      palette = "noctalia";

      palettes.noctalia = {
        blue = "{{colors.terminal_normal_blue.default.hex}}";
        red = "{{colors.terminal_normal_red.default.hex}}";
        green = "{{colors.terminal_normal_green.default.hex}}";
        yellow = "{{colors.terminal_normal_yellow.default.hex}}";
        cyan = "{{colors.terminal_normal_cyan.default.hex}}";
        magenta = "{{colors.terminal_normal_magenta.default.hex}}";
        white = "{{colors.terminal_normal_white.default.hex}}";
        black = "{{colors.terminal_normal_black.default.hex}}";

        rosewater = "{{colors.terminal_bright_yellow.default.hex}}";
        flamingo = "{{colors.terminal_bright_red.default.hex}}";
        pink = "{{colors.terminal_bright_magenta.default.hex}}";
        mauve = "{{colors.terminal_normal_magenta.default.hex}}";
        maroon = "{{colors.terminal_bright_red.default.hex}}";
        peach = "{{colors.terminal_bright_yellow.default.hex}}";
        teal = "{{colors.terminal_normal_cyan.default.hex}}";
        sky = "{{colors.terminal_bright_cyan.default.hex}}";
        sapphire = "{{colors.terminal_bright_blue.default.hex}}";
        lavender = "{{colors.terminal_bright_magenta.default.hex}}";

        text = "{{colors.terminal_foreground.default.hex}}";
        subtext1 = "{{colors.terminal_normal_white.default.hex}}";
        subtext0 = "{{colors.terminal_bright_black.default.hex}}";

        overlay2 = "{{colors.terminal_bright_black.default.hex}}";
        overlay1 = "{{colors.terminal_bright_black.default.hex}}";
        overlay0 = "{{colors.terminal_normal_black.default.hex}}";
        surface2 = "{{colors.terminal_normal_black.default.hex}}";
        surface1 = "{{colors.terminal_normal_black.default.hex}}";
        surface0 = "{{colors.terminal_background.default.hex}}";
        base = "{{colors.terminal_background.default.hex}}";
        mantle = "{{colors.terminal_background.default.hex}}";
        crust = "{{colors.terminal_background.default.hex}}";
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
    "noctalia/inputs/starship.toml".source = starshipSource;
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
    starship = {
      input_path = "${inputsDirectory}/starship.toml";
      output_path = "${homeDirectory}/.config/starship.toml";
    };
  };
}
