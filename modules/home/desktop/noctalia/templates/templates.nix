{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;

  jsonFormat = pkgs.formats.json { };

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
in
{
  xdg.configFile = lib.mkIf cfg.enable {
    "noctalia/inputs/obsidian.css".source = ./inputs/obsidian.css;
    "noctalia/inputs/telegram.tdesktop-theme".source = ./inputs/telegram.tdesktop-theme;
    "noctalia/inputs/yakc.json".source = yakcSource;
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
  };
}
