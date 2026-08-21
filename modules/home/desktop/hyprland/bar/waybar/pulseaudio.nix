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
            format = "<big>{icon}</big> {volume}%";
            format-bluetooth = "<big>{icon}</big>";
            format-muted = "<big>{icon}</big> off";
            format-icons = {
              default = [
                " "
                " "
              ];
              default-muted = " ";
              headphone = " ";
              headset = "󰋎 ";
              hands-free = "󰂑";
              hdmi = "󰡁";
              car = " ";
              phone = " ";
            };
            tooltip = false;
            on-click = "pavucontrol";
          };
        };
        secondary = primary;
      };
    };
  };
}
