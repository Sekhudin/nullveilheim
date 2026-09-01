{
  pkgs,
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
    home = {
      packages = with pkgs; [
        hyprland-qt-support
      ];
    };

    xdg.configFile = {
      "hypr/application-style.conf" = {
        text = ''
          roundness = 2
          border_width = 1
          reduce_motion = false
        '';
      };
    };
  };
}
