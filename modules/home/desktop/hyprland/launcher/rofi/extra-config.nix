{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableRofi = (cfg.launcher.use == "rofi");
in
{
  config = lib.mkIf (cfg.enable && enableRofi) {
    programs = {
      rofi.extraConfig = {
        show-icons = true;
        drun-display-format = "{name}";
        combi-modes = [
          "window"
          "drun"
          "run"
        ];
      };
    };
  };
}
