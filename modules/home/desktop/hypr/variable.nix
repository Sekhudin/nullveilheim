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
          primary = "eDP-1";
          secondary = "HDMI-A-1";
        };

        submaps = hypr.mkVar {
          monitor = "M";
          resize = "R";
          session = "S";
        };

        cursor = hypr.mkVar {
          theme = core.cursor.theme;
          size = core.cursor.size;
        };

        tokens = hypr.mkVar theme.tokens;

        styles = hypr.mkVar {
          min_width = 16;
          min_height = 16;
          padding_x = 12;
          padding_y = 8;
          margin_in = 4;
          margin_out = 4;
          border_size = 2;
          border_radius = 12;
          opacity = theme.opacity;
          animation_ms = 800;
        };

        apps = hypr.mkVar {
          terminal = core.terminal;
          browser = core.browser;
        };

        menus = hypr.mkVar {
          help = "nv-menu-help";
          launcher = "nv-menu-launcher";
          control = "nv-menu-control";
          settings = "nv-menu-settings";
          window = "nv-menu-window";
          session = "nv-menu-session";
          screenshot = "nv-menu-screenshot";
        };

        sessions = hypr.mkVar {
          lock = "nv-session-lock";
          lock_suspend = "nv-session-lock-suspend";
          logout = "nv-session-logout";
          reboot = "nv-session-reboot";
          shutdown = "nv-session-shutdown";
        };

        screenshots = hypr.mkVar {
          region = "nv-screenshot-region";
          fullscreen = "nv-screenshot-fullscreen";
        };

        brightness = hypr.mkVar {
          up = "nv-brightness-up";
          down = "nv-brightness-down";
        };

        media = hypr.mkVar {
          next = "nv-media-next";
          prev = "nv-media-prev";
          toggle = "nv-media-toggle";
        };

        volume = hypr.mkVar {
          up = "nv-volume-up";
          down = "nv-volume-down";
          toggle = "nv-volume-toggle";
        };

        mic = hypr.mkVar {
          up = "nv-mic-up";
          down = "nv-mic-down";
          toggle = "nv-mic-toggle";
        };
      }
      variables
    ];
  };
}
