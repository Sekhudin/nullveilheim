{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    services = {
      udiskie = {
        enable = true;
        automount = true;
        notify = true;
        tray = "auto";
        settings = { };
      };
    };

    programs = {
      yazi = {
        enable = true;
      };
    };
  };
}
