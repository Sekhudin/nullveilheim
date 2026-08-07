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
  imports = [
    ./extra-config.nix
    ./theme.nix
  ];

  config = lib.mkIf (cfg.enable && enableRofi) {
    programs = {
      rofi.pass = {
        enable = false;
        extraConfig = { };
        stores = [ ];
      };
    };
  };
}
