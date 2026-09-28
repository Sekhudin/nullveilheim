{
  config,
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib.hyprland)
    hypr
    variables
    ;

  core = config.homeCore;
  theme = core.themeConfig;
in
{
  wayland.windowManager.hyprland = {
    settings = lib.mkMerge [
      {
        monitors = hypr.mkVar {
          edp_1 = "eDP-1";
          hdmia_1 = "HDMI-A-1";
        };

        submaps = hypr.mkVar {
          monitor = "M";
          resize = "R";
          session = "S";
        };

        cursor = hypr.mkVar {
          inherit (config.homeCore.cursor)
            theme
            size
            ;
        };

        tokens = hypr.mkVar theme.tokens;

        styles = hypr.mkVar rec {
          gaps_in = 4;
          gaps_out = 4;
          rounding = 12;
          border_size = 2;
          min_width = 16;
          min_height = 16;
          opacity = theme.opacity;
          opacity_mid = 0.6;
          opacity_low = 0.4;
          padding_x = 12;
          padding_y = 8;
          margin_top = (gaps_out * 8) + (min_height + 2);
          animation_ms = 800;
        };

        apps = hypr.mkVar {
          terminal = config.homeCore.terminal;
          browser = "firefox";
        };

        menus = hypr.mkVar {
          binds = "nv-binds";
          control_center = "nv-control-center";
          launcher = "nv-launcher";
          power = "nv-power";
          settings = "settings";
          screenshot = "nv-screenshot";
        };

        actions = hypr.mkVar {
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
      }
      variables
    ];
  };
}
