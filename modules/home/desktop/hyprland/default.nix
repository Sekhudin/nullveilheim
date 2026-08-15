{
  config,
  lib,
  color,
  ...
}:

let
  themeNames = lib.attrNames color.themes;
in
{
  imports = [
    ./bar
    ./core
    ./launcher
    ./polkit
    ./wallpaper
  ];

  options.homeDesktopModules.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable hyprland modules";
      default = false;
    };

    theme = lib.mkOption {
      type = lib.types.enum themeNames;
      description = "theme settings";
      default = config.homeCoreModules.theme;
    };

    bar = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "ashell"
              "waybar"
            ];
            description = "choose status bar";
            default = "waybar";
          };
        };
      };
    };

    launcher = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "rofi"
            ];
            description = "choose launcher";
            default = "rofi";
          };
        };
      };
    };

    notification = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "mako"
            ];
            description = "choose notification";
            default = "mako";
          };
        };
      };
    };

    osd = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "swayosd"
            ];
            description = "choose on-screen display";
            default = "swayosd";
          };
        };
      };
    };

    polkit = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "hyprpolkitagent"
            ];
            description = "choose polkit agent";
            default = "hyprpolkitagent";
          };
        };
      };
    };

    wallpaper = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "hyprpaper"
            ];
            description = "choose wallpaper";
            default = "hyprpaper";
          };
        };
      };
    };
  };
}
