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
    ./core
    ./polkit
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
              "waybar"
            ];
            description = "choose status bar";
            default = "waybar";
          };
        };
      };
    };

    brightness = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "brightnessctl"
            ];
            description = "choose brightness";
            default = "brightnessctl";
          };
        };
      };
    };

    clipboard = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "cliphist"
            ];
            description = "choose clipboard";
            default = "cliphist";
          };
        };
      };
    };

    cursor = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "hyprcursor"
            ];
            description = "choose cursor";
            default = "hyprcursor";
          };
        };
      };
    };

    idle = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "hypridle"
            ];
            description = "choose idle manager";
            default = "hypridle";
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

    lockscreen = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "hyprlock"
            ];
            description = "choose lock screen";
            default = "hyprlock";
          };
        };
      };
    };

    logout = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "wlogout"
            ];
            description = "choose logout menu";
            default = "wlogout";
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
              "hyprpolkitagent"
            ];
            description = "choose polkit agent";
            default = "hyprpolkitagent";
          };
        };
      };
    };

    portal = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "hyprland"
            ];
            description = "choose desktop portal";
            default = "hyprland";
          };
        };
      };
    };

    screenshot = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "grim"
            ];
            description = "choose screenshot";
            default = "grim";
          };
        };
      };
    };

    session = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "uwsm"
            ];
            description = "choose session manager";
            default = "uwsm";
          };
        };
      };
    };

    volume = lib.mkOption {
      type = lib.types.submodule {
        options = {
          use = lib.mkOption {
            type = lib.types.enum [
              "none"
              "wpctl"
            ];
            description = "choose volume";
            default = "wpctl";
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
