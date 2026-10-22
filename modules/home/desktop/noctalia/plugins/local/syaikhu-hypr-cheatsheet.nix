{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
in
{
  home = lib.mkIf cfg.enable {
    packages = [ ];
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
