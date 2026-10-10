{ config, lib, ... }:

let
  cfg = config.homeDesktop.noctalia;
in
{
  xdg.configFile = lib.mkIf cfg.enable {
    "noctalia/inputs/obsidian.css".source = ./obsidian.css;
    "noctalia/inputs/telegram.tdesktop-theme".source = ./telegram.tdesktop-theme;
  };
}
