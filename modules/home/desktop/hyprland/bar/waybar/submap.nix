{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
  inherit (extraLib.hyprland) dsp;
in
{
  config = lib.mkIf (cfg.enable && enableWaybar) {
    programs = {
      waybar.settings = rec {
        primary = {
          "hyprland/submap" = {
            format = "{}";
            justify = "center";
            default-submap = "normal";
            align = 0.5;
            max-length = 10;
            tooltip = false;
            always-on = true;
            expand = false;
            on-click = ''
              case "$(hyprctl submap)" in
                default|normal"")
                  hyprctl dispatch '${
                    dsp.submap {
                      name = "monitor";
                    }
                  }'
                  ;;
                monitor)
                  hyprctl dispatch '${
                    dsp.submap {
                      name = "resize";
                    }
                  }'
                  ;;
                resize)
                  hyprctl dispatch '${
                    dsp.submap {
                      name = "reset";
                    }
                  }'
                  ;;
              esac
            '';
          };
        };
        secondary = primary;
      };
    };
  };
}
