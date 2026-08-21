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
            format-wifi = ''<span size="150%">{icon}</span>'';
            format-ethernet = ''<span size="150%">{icon}</span>'';
            format-linked = ''<span size="150%">{icon}</span>'';
            format-disconnected = ''<span size="150%">{icon}</span>'';
            format-disabled = ''<span size="150%">{icon}</span>'';
            format-alt = ''<span size="150%">{icon}</span> {essid} | <b>ip</b>: {ipaddr} | <b>down</b>: {bandwidthDownBytes}'';
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
              disconnected = "󰤯 ";
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
