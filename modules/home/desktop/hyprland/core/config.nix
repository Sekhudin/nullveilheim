{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland) mkLuaInline;
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings.config = {
        general = rec {
          border_size = 1;
          gaps_in = 4;
          gaps_out = gaps_in;
          layout = "dwindle";
          resize_on_border = true;
          col = {
            active_border = mkLuaInline "active_border";
            inactive_border = mkLuaInline "inactive_border";
          };
          snap = {
            enabled = false;
          };
        };

        decoration = {
          rounding = 8;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          dim_modal = true;
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
          natural_scroll = true;
          repeat_rate = 45;
          repeat_delay = 300;
          touchpad = {
            natural_scroll = true;
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
