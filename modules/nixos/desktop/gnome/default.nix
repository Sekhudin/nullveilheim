{ config, lib, ... }:

let
  cfg = config.nixosDesktopModules.desktop;
  isGnome = config.nixosDesktopModules.use == "gnome";
  masterEnable = config.nixosDesktopModules.enable;
in
{
  options.nixosDesktopModules.desktop = {
    gnome = lib.mkOption {
      type = lib.types.attrs;
      description = "gnome settings";
      default = { };
    };

    gdm = lib.mkOption {
      type = lib.types.attrs;
      description = "gdm settings";
      default = { };
    };

    xserver = lib.mkOption {
      type = lib.types.attrs;
      description = "xserver settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && isGnome) {
    services = {
      desktopManager = {
        gnome = lib.mkMerge [
          {
            enable = true;
            extraGSettingsOverrides = ''
              [org.gnome.desktop.wm.preferences]
              button-layout='appmenu:minimize,maximize,close'
            '';
          }
          cfg.gnome
        ];
      };

      displayManager = {
        gdm = lib.mkMerge [
          {
            enable = true;
          }
          cfg.gdm
        ];
      };

      xserver = lib.mkMerge [
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
  };
}
