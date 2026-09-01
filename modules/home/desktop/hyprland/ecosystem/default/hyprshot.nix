{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  ecosystemEnabled = cfg.ecosystem.use == "default";
in
{
  config = lib.mkIf (cfg.enable && ecosystemEnabled) {
    programs = {
      hyprshot = {
        enable = true;
        saveLocation = "${config.home.homeDirectory}/Pictures/Screenshots";
      };
    };
  };
}
