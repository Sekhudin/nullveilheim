{ config, lib, ... }:

let
  cfg = config.nixosDesktopModules.gnome;
  masterEnable = config.nixosDesktopModules.enable;
  isGnome = config.nixosDesktopModules.use == "gnome";
in
{
  options.nixosDesktopModules.gnome = {
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

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "gnome settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && isGnome) {
    services = {
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

      desktopManager = {
        gnome = lib.mkMerge [
          {
            enable = true;
            extraGSettingsOverrides = ''
              [org.gnome.desktop.wm.preferences]
              button-layout='appmenu:minimize,maximize,close'
            '';
          }
          cfg.settings
        ];
      };
    };
  };
}
