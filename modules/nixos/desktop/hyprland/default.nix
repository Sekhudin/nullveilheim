{ config, lib, ... }:

let
  cfg = config.nixosDesktopModules.hyprland;
  master = config.nixosDesktopModules;
  isHyprland = (master.enable && master.use == "hyprland");
in
{
  options.nixosDesktopModules.hyprland = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "gdm settings";
      default = { };
    };
  };

  config = lib.mkIf isHyprland {
    programs = {
      hyprland = lib.mkMerge [
        {
          enable = true;
          withUWSM = lib.mkDefault true;
          xwayland = {
            enable = lib.mkDefault true;
          };
          systemd = {
            setPath = {
              enable = lib.mkDefault true;
            };
          };
        }
        cfg.settings
      ];
    };
  };
}
