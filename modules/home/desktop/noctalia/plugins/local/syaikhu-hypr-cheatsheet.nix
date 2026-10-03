{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
  packages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home = lib.mkIf cfg.enable {
    packages = [
      packages.hyprland
    ];
  };

  programs.noctalia.settings = {
    plugins.enabled = [
      "syaikhu/hypr-cheatsheet"
    ];

    plugin_settings."syaikhu/hypr-cheatsheet" = {
      config_type = "lua";
      config = "~/.config/hypr/hyprland.lua";
      columns = 3;
      show_undescribed = false;
    };

    widget."syaikhu/hypr-cheatsheet:keybinds" = {
      glyph = "command";
    };
  };
}
