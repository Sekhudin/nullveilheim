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
            interval = 2;
            align = 0.5;
            justify = 0.5;
            max-length = 50;
            min-length = 1;
            rfkill = true;
            format-wifi = "<big>{icon}</big>";
            format-ethernet = "<big>{icon}</big>";
            format-linked = "<big>{icon}</big>";
            format-disconnected = "";
            format-disabled = "<big>{icon}</big>";
            format-alt = "<big>{icon}</big> {essid} | ip: {ipaddr} | down: {bandwidthDownBytes}";
            format-alt-click = "click-right";
            format-icons = {
              wifi = [
                "󰤯 "
                "󰤟 "
                "󰤢 "
                "󰤥 "
                "󰤨 "
              ];
              ethernet = "󰈀 ";
              disconnected = "";
              disabled = "󰤭 ";
            };

            tooltip = false;
          };
        };
        secondary = primary;
      };
    };
  };
}
