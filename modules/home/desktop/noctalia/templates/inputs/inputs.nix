{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;

  jsonFormat = pkgs.formats.json { };

  yakc = config.programs.yakc;
  yakcTemplate = yakc.settings // {
    popupFontColor = "{{ colors.on_primary.default.hex }}";
    popupBackgroundColor = "{{ colors.primary.default.hex }}";
  };
in
{
  xdg.configFile = lib.mkIf cfg.enable {
    "noctalia/inputs/obsidian.css".source = ./obsidian.css;
    "noctalia/inputs/telegram.tdesktop-theme".source = ./telegram.tdesktop-theme;
    "noctalia/inputs/yakc.json".source = jsonFormat.generate "template.json" yakcTemplate;
  };
}
