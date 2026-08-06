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
          "pulseaudio" = {
            format = "{icon}  {volume}%";
            format-bluetooth = "{icon}  {volume}%";
            format-muted = "{icon}";

            format-icons = {
              default = [
                ""
                ""
              ];
              default-muted = "";
              headphone = "";
              headset = "󰋎";
              hands-free = "󰂑";
              hdmi = "󰡁";
              car = "";
              phone = "";
            };

            on-click = "pavucontrol";
            tooltip = false;
          };
        };
        secondary = primary;
      };
    };
  };
}
