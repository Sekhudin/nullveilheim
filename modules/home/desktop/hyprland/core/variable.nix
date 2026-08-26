{
  pkgs,
  config,
  lib,
  extraLib,
  color,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (color) mkTokens;
  inherit (extraLib.hyprland) variables mkVar;

  tokens = mkTokens config.homeCoreModules.theme;
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        bibata-cursors
      ];
    };

    wayland.windowManager.hyprland = {
      settings = lib.mkMerge [
        {
          monitors = mkVar {
            edp_1 = "eDP-1";
            hdmia_1 = "HDMI-A-1";
          };

          submaps = mkVar {
            monitor = "M";
            resize = "R";
            session = "S";
            whiteboard = "W";
          };

          apps = mkVar {
            terminal = config.homeTerminalModules.use;
            browser = "firefox";
            editor = "nvim";
          };

          menus = mkVar {
            apps = "hypr-apps";
            binds = "hypr-binds";
            power = "hypr-power";
            screenshot = "hypr-screenshot";
          };

          actions = mkVar {
            hibernate = "hypr-hibernate";
            lock = "hypr-lock";
            logout = "hypr-logout";
            poweroff = "hypr-poweroff";
            powerprofile = "hypr-powerprofile";
            reboot = "hypr-reboot";
            reload = "hypr-reload";
            screenoff = "hypr-screenoff";
            screenon = "hypr-screenon";
            suspend = "hypr-suspend";

            # osd
            brightness_up = "hypr-brightness-up";
            brightness_down = "hypr-brightness-down";

            media_playback = "hypr-media-playback";
            media_next = "hypr-media-next";
            media_prev = "hypr-media-prev";

            mic_up = "hypr-mic-up";
            mic_down = "hypr-mic-down";
            mic_mute = "hypr-mic-mute";

            volume_up = "hypr-volume-up";
            volume_down = "hypr-volume-down";
            volume_mute = "hypr-volume-mute";

            capslock = "hypr-capslock";
            numlock = "hypr-numlock";
            scrolllock = "hypr-scrolllock";

            # misc
            screenshot_fullscreen = "hypr-screenshot-fullscreen";
            screenshot_region = "hypr-screenshot-region";
            screenshot_window = "hypr-screenshot-window";
          };

          cursor = mkVar {
            theme = "Bibata-Modern-Ice";
            size = 24;
          };

          tokens = mkVar tokens;

          styles = mkVar rec {
            gaps_in = 4;
            gaps_out = 4;
            rounding = 12;
            border_size = 2;
            min_width = 16;
            min_height = 16;
            opacity = color.opacity;
            opacity_mid = 0.6;
            opacity_low = 0.4;
            padding_x = 12;
            padding_y = 8;
            margin_top = (gaps_out * 8) + (min_height + 2);
            animation_ms = 300;
          };
        }
        variables
      ];
    };
  };
}
