{ config, lib, ... }:

let
  cfg = config.nixosDesktopModules.gnome;
  master = config.nixosDesktopModules;
  enableGnome = (master.enable && master.use == "gnome");
in
{
  options.nixosDesktopModules.gnome = {
    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "gnome settings";
      default = { };
    };
  };

  config = lib.mkIf enableGnome {
    services = {
      displayManager = {
        gdm = {
          enable = true;
        };
      };

      xserver = {
        enable = true;
        xkb = {
          layout = "us";
          variant = "";
        };
      };

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
