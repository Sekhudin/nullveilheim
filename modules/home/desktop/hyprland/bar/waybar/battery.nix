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
            interval = 2;
            align = 0.5;
            justify = "center";
            format = "<big>{icon}</big> {capacity}%";
            format-charging = "<big>{icon}</big> {capacity}%";
            format-discharging = "<big>{icon}</big> {capacity}%";
            tooltip = false;
            states = {
              warning = 30;
              critical = 15;
            };
            events = {
              on-discharging-warning = ''notify-send -u normal "Battery" "Battery level is low"'';
              on-discharging-critical = ''notify-send -u critical "Battery" "Battery level is critically low"'';
              on-charging-100 = ''notify-send -u normal "Battery" "Battery is fully charged"'';
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
