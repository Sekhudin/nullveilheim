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
          "custom/nixosicon" = {
            format = ''<span size="150%"> </span>'';
            align = 0.5;
            justify = "center";
            tooltip = false;
            on-click = menus.apps;
            expand = false;
          };
        };
        secondary = primary;
      };
    };
  };
}
