{
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  ecosystemEnabled = cfg.ecosystem.use == "default";
in
{
  config = lib.mkIf (cfg.enable && ecosystemEnabled) {
    services = {
      hyprpolkitagent = {
        enable = true;
      };
    };

    xdg.configFile = {
      "hyprpolkitagent/hyprpolkitagent.conf" = {
        text = ''
          general {
            password_field_width = 500
            window_width         = 900
            window_height        = 900
            show_details         = true
          }
        '';
      };
    };
  };
}
