{
  config,
  lib,
  extraLib,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
  inherit (extraLib.hyprland) getVarRef;

  var = getVarRef config;
  styles = var "styles";
in
{
  config = lib.mkIf (cfg.enable && enableWaybar) {
    programs = {
      waybar.settings = rec {
        primary = {
          "tray" = {
            icon-size = toString (font.sizes.bar * 1.0);
            spacing = styles.gaps_in;
            show-passive-items = false;
            reverse-direction = false;
            expand = false;
            tooltip = false;
            gnore-list = [ ];
            on-update = "";
            icons = { };
            orders = { };
          };
        };
        secondary = primary;
      };
    };
  };
}
