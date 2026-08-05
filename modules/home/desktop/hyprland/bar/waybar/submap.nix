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
            format = "<b>{}</b>";
            justify = "center";
            default-submap = "N";
            align = 0.5;
            max-length = 10;
            tooltip = false;
            always-on = true;
            expand = false;
            on-click = ''
              case "$(hyprctl submap)" in
                default|N"")
                  hyprctl dispatch '${
                    dsp.submap {
                      name = "M";
                    }
                  }'
                  ;;
                M)
                  hyprctl dispatch '${
                    dsp.submap {
                      name = "R";
                    }
                  }'
                  ;;
                R)
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
