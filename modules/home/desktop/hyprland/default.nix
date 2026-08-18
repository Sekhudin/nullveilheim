{
  lib,
  ...
}:

{
  imports = [
    ./bar
    ./core
    ./launcher
    ./notification
    ./wallpaper
  ];

  options.homeDesktopModules.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable hyprland modules";
      default = false;
    };

    ecosystem = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "default"
              "noctalia"
            ];
            description = "choose status bar";
            default = "default";
          };
        };
      };
    };

    bar = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
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
              "dunst"
            ];
            description = "choose notification";
            default = "dunst";
          };
        };
      };
    };

    osd = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "swayosd"
            ];
            description = "choose on-screen display";
            default = "swayosd";
          };
        };
      };
    };

    wallpaper = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
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
