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
    services.xserver = lib.mkMerge [
      {
        enable = true;
        displayManager = {
          gdm.enable = true;
          gnome.enable = true;
        };

        xkb = {
          layout = "us";
          variant = "";
        };
      }
      cfg.settings
    ];
  };
}
