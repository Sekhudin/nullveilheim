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
          };

          apps = mkVar rec {
            terminal = config.homeTerminalModules.use;
            browser = "firefox";
            editor = "nvim";
            filemanager = "${terminal} -e yazi";
            windowboard = "wayscriber --active";
            windowboard_freeze = "${windowboard} --freeze";
          };

          menus = mkVar {
            apps = "nv-apps";
            binds = "nv-binds";
            power = "nv-power";
            screenshot = "nv-screenshot";
          };

          actions = mkVar {
            hibernate = "nv-hibernate";
            lock = "nv-lock";
            logout = "nv-logout";
            poweroff = "nv-poweroff";
            powerprofile = "nv-powerprofile";
            reboot = "nv-reboot";
            reload = "nv-reload";
            screenoff = "nv-screenoff";
            screenon = "nv-screenon";
            suspend = "nv-suspend";

            # osd
            brightness_up = "nv-brightness-up";
            brightness_down = "nv-brightness-down";

            media_playback = "nv-media-playback";
            media_next = "nv-media-next";
            media_prev = "nv-media-prev";

            mic_up = "nv-mic-up";
            mic_down = "nv-mic-down";
            mic_mute = "nv-mic-mute";

            volume_up = "nv-volume-up";
            volume_down = "nv-volume-down";
            volume_mute = "nv-volume-mute";

            capslock = "nv-capslock";
            numlock = "nv-numlock";
            scrolllock = "nv-scrolllock";

            # misc
            screenshot_fullscreen = "nv-screenshot-fullscreen";
            screenshot_region = "nv-screenshot-region";
            screenshot_window = "nv-screenshot-window";

            screenrec = "nv-screenrec";
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
