{ config, lib, ... }:

let
  cfg = config.homeDesktopModules.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings.config = {
        general = {
          border_size = 1;
          gaps_in = 4;
          gaps_out = 4;
          layout = "dwindle";
          snap = {
            enabled = false;
          };
        };

        decoration = {
          rounding = 8;
          shadow = {
            enabled = true;
          };
          blur = {
            enabled = true;
          };
          glow = {
            enabled = false;
          };
        };

        animations = {
          enabled = true;
        };

        input = {
          kb_layout = "us";
          sensitivity = 0.0;
          follow_mouse = 1;
          touchpad = {
            natural_scroll = false;
            tap_to_click = true;
          };
          touchdevice = {
            enabled = true;
            transform = 0;
          };
          virtualkeyboard = {
            share_states = 2;
            release_pressed_on_close = false;
          };
          tablet = {
            relative_input = false;
            left_handed = false;
            absolute_region_position = false;
          };
        };

        gestures = {
          workspace_swipe_create_new = true;
          scrolling = {
            move_snap_to_grid = true;
            move_snap_cursor = true;
          };
        };

        group = {
          auto_group = true;
          groupbar = {
            enabled = true;
          };
        };

        misc = {
          disable_hyprland_logo = false;
          disable_splash_rendering = true;
        };

        layout = {
          single_window_aspect_ratio_tolerance = 0.1;
        };

        binds = {
          pass_mouse_when_bound = false;
        };

        xwayland = {
          enabled = true;
        };

        opengl = {
          nvidia_anti_flicker = true;
        };

        render = {
          expand_undersized_textures = true;
        };

        cursor = {
          invisible = false;
        };

        ecosystem = {
          no_update_news = true;
        };

        quirks = {
          prefer_hdr = 0;
          skip_non_kms_dmabuf_formats = false;
        };

        debug = {
          overlay = false;
        };

        experimental = {
          wp_cm_1_2 = false;
        };
      };
    };
  };
}
