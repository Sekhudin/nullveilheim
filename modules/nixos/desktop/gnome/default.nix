{ config, lib, ... }:

let
  cfg = config.nixosDesktopModules.gnome;
  isGnome = config.nixosDesktopModules.use == "gnome";
  masterEnable = config.nixosDesktopModules.enable;
in
{
  options.nixosDesktopModules.gnome = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "extra gnome settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && isGnome) {
    services.desktopManager = {
      gnome.enable = true;
    };

    services.displayManager = {
      gdm.enable = true;
    };

    services.xserver = lib.mkMerge [
      {
        enable = true;
        xkb = {
          layout = "us";
          variant = "";
        };
      }
      cfg.settings
    ];
  };
}
