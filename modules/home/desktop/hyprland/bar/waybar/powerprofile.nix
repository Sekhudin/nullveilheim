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
  actions = var "actions";
in
{
  config = lib.mkIf (cfg.enable && enableWaybar) {
    programs = {
      waybar.settings = rec {
        primary = {
          "power-profiles-daemon" = {
            format = "<big>{icon}</big>";
            tooltip = false;
            expand = false;
            on-click = actions.powerprofile;
            format-icons = {
              default = "󰏒 ";
              performance = "󰏒 ";
              balanced = "󱅻 ";
              power-saver = " ";
            };
          };
        };
        secondary = primary;
      };
    };
  };
}
