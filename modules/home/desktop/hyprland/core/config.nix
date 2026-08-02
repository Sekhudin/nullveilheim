{
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  inherit (extraLib.hyprland) getVar;

  rounding = getVar "styles.rounding";
  font_family = getVar "styles.font_family";
  gaps_in = getVar "styles.gaps_in";
  gaps_out = getVar "styles.gaps_out";

  border = getVar "tokens.border";
  active_border = getVar "tokens.active_border";
in
{
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      settings.config = {
        general = {
          border_size = 1;
          gaps_in = gaps_in;
          gaps_out = gaps_out;
          layout = "dwindle";
          resize_on_border = true;
          col = {
            active_border = border;
            inactive_border = active_border;
          };
          snap = {
            enabled = false;
          };
        };

        decoration = {
          rounding = rounding;
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
            disable_while_typing = true;
            clickfinger_behavior = false;
            natural_scroll = true;
            tap_to_click = true;
            tap_and_drag = true;
            drag_lock = 1;
            middle_button_emulation = false;
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
          font_family = font_family;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        layout = {
          single_window_aspect_ratio_tolerance = 0.1;
        };

        binds = {
          pass_mouse_when_bound = false;
          drag_threshold = 10;
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
