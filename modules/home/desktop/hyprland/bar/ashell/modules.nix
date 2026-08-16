{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableAshell = (cfg.bar.use == "ashell");
  inherit (extraLib.hyprland) getVarRef dsp;

  var = getVarRef config;
  actions = var "actions";
in
{
  config = lib.mkIf (cfg.enable && enableAshell) {
    programs = {
      ashell.settings = {
        keyboard_layout = {
          labels = {
            "English (US)" = "EN";
            "Italian" = "IT";
          };
        };

        media_player = {
          max_title_length = 50;
          indicator_format = "Icon";
        };

        notifications = {
          format = "%m/%d %H:%M";
          show_timestamps = true;
          show_bodies = false;
          grouped = true;
          toast = true;
          toast_position = "top_right";
          toast_timeout = 4000;
          toast_limit = 5;
          toast_max_height = 150;
          blocklist = [ ];
        };

        settings = {
          logout_cmd = actions.logout;
          reboot_cmd = actions.reboot;
          lock_cmd = actions.lock;
          shutdown_cmd = actions.poweroff;
          suspend_cmd = actions.suspend;

          battery_format = "Icon";
          battery_hide_when_full = false;
          peripheral_battery_format = "IconAndPercentage";
          peripheral_indicators = "All";
          indicators = [
            "IdleInhibitor"
            "PowerProfile"
            "Audio"
            "Microphone"
            "Bluetooth"
            "Network"
            "Vpn"
            "Battery"
          ];
        };

        system_info = {
          indicators = [
            "Cpu"
            "Memory"
            "Temperature"
          ];
          interval = 5;

          cpu = {
            warn_threshold = 60;
            alert_threshold = 80;
            format = "Percentage";
          };

          memory = {
            warn_threshold = 70;
            alert_threshold = 85;
            format = "Percentage";
          };

          disk = {
            warn_threshold = 80;
            alert_threshold = 90;
            format = "Percentage";
          };

          temperature = {
            warn_threshold = 60;
            alert_threshold = 80;
            sensor = "Cpu";
          };
        };

        tempo = {
          clock_format = "%a %d %b %R";
        };

        tray = {
          right_click = "menu";
          blocklist = [ ];
        };

        window_title = {
          mode = "Title";
          truncate_title_after_length = 50;
        };

        workspaces = {
          visibility_mode = "MonitorSpecific";
          max_workspaces = 9;
        };
      };
    };
  };
}
