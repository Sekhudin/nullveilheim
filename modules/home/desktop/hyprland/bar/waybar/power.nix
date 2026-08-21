{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
  inherit (extraLib.hyprland) getVarRef;

  var = getVarRef config;
  menus = var "menus";
in
{
  config = lib.mkIf (cfg.enable && enableWaybar) {
    programs = {
      waybar.settings = rec {
        primary = {
          "custom/power" = {
            format = ''<span size="150%"> </span>'';
            align = 0.5;
            justify = 0.5;
            tooltip = false;
            on-click = menus.power;
            expand = false;
          };
        };
        secondary = primary;
      };
    };
  };
}
