{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  ecosystemEnabled = cfg.ecosystem.use == "default";

  inherit (extraLib.hyprland) getVarRef;

  mkTimeout = s: {
    backlight = s;
    lock = s * 2;
    screen = s * 3;
    suspend = s * 6;
  };

  var = getVarRef config;
  actions = var "actions";

  timeout = mkTimeout 300;

  backlightoff = "brightnessctl -sd rgb:kbd_backlight set 0";
  backlighton = "brightnessctl -rd rgb:kbd_backlight";
in
{
  config = lib.mkIf (cfg.enable && ecosystemEnabled) {
    services = {
      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = actions.lock;
            before_sleep_cmd = actions.lock;
            ignore_dbus_inhibit = false;
            ignore_systemd_inhibit = false;
            ignore_wayland_inhibit = false;
          };

          listener = [
            {
              timeout = timeout.backlight;
              on-timeout = backlightoff;
              on-resume = backlighton;
            }
            {
              timeout = timeout.lock;
              on-timeout = actions.lock;
            }
            {
              timeout = timeout.screen;
              on-timeout = actions.screenoff;
              on-resume = actions.screenon;
            }
            {
              timeout = timeout.suspend;
              on-timeout = actions.suspend;
            }
          ];
        };
      };
    };
  };
}
