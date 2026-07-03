{ config, lib, ... }:

let
  cfg = config.nixosDesktopModules.desktop;
  isGnome = config.nixosDesktopModules.use == "gnome";
  masterEnable = config.nixosDesktopModules.enable;
in
{
  options.nixosDesktopModules.desktop = {
    desktopManager = lib.mkOption {
      type = lib.types.attrs;
      description = "gnome settings";
      default = { };
    };

    displayManager = lib.mkOption {
      type = lib.types.attrs;
      description = "display manager settings";
      default = { };
    };

    xserver = lib.mkOption {
      type = lib.types.attrs;
      description = "xserver settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && isGnome) {
    services.desktopManager = lib.mkMerge [
      {
        gnome.enable = true;
      }
      cfg.desktopManager
    ];

    services.displayManager = lib.mkMerge [
      {
        gdm.enable = true;
      }
      cfg.displayManager
    ];

    services.xserver = lib.mkMerge [
      {
        enable = true;
        xkb = {
          layout = "us";
          variant = "";
        };
      }
      cfg.xserver
    ];
  };
}
