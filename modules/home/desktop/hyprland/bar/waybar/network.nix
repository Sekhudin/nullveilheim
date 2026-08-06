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
          "network" = {
            interface = "wlp0s20f3";
            family = "ipv4_6";
            interval = 1;
            align = 0.5;
            justify = "center";
            max-length = 30;
            min-length = 1;
            rfkill = true;
            format-wifi = "{icon} ";
            format-ethernet = "{icon}";
            format-linked = "{icon}";
            format-disconnected = "󰤭";
            format-disabled = "󰤭";
            format-alt = "{ipaddr}";
            format-alt-click = "left";
            format-icons = {
              wifi = [
                "󰤯"
                "󰤟"
                "󰤢"
                "󰤥"
                "󰤨"
              ];
              ethernet = "󰈀";
              disconnected = "󰤭";
              disabled = "󰤭";
            };

            tooltip = false;
          };
        };
        secondary = primary;
      };
    };
  };
}
