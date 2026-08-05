{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableWaybar = (cfg.bar.use == "waybar");
in
{
  config = lib.mkIf (cfg.enable && enableWaybar) {
    programs = {
      waybar.settings = rec {
        primary = {
          "battery" = {
            bat = "BAT0";
            interval = 1;
            align = 0.5;
            justify = "center";
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% {icon}";
            format-discharging = "{capacity}% {icon}";
            tooltip = false;
            states = {
              warning = 30;
              critical = 15;
            };
            events = {
              on-charging = "";
              on-discharging = "";
              on-charging-100 = "";
              on-discharging-warning = "";
              on-discharging-critical = "";
            };
            format-icons = rec {
              default = [
                "󰂎"
                "󰁺"
                "󰁻"
                "󰁼"
                "󰁽"
                "󰁾"
                "󰁿"
                "󰂀"
                "󰂁"
                "󰂂"
                "󰁹"
              ];
              discharging = default;
              charging = [
                "󰢟"
                "󰢜"
                "󰂆"
                "󰂇"
                "󰂈"
                "󰢝"
                "󰂉"
                "󰢞"
                "󰂊"
                "󰂋"
                "󰂅"
              ];
            };
          };
        };
        secondary = primary;
      };
    };
  };
}
