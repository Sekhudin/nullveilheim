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
            format = " ";
            align = 0.5;
            justify = 0.5;
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
