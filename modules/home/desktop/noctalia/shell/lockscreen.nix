{ config, extraLib, ... }:

let
  inherit (extraLib.hyprland) hypr;

  monitors = hypr.getVarValues config "monitors";
in
{
  programs.noctalia.settings.lockscreen = {
    enabled = true;
    lock_before_suspend = true;
    fingerprint = true;
    allow_empty_password = false;
    blurred_desktop = false;
    transition_duration = 1500;
    edge_smoothness = 0.3;
    blur_intensity = 0.5;
    tint_intensity = 0.3;
    transition = [
      "disc"
      "zoom"
      "honeycomb"
    ];
  };

  programs.noctalia.settings.lockscreen_widgets = {
    enabled = true;
    schema_version = 2;
    widget_order = [
      "clock_main"
      "lockscreen-login-box@${monitors.primary}"
      "lockscreen-widget-0000000000000001"
      "lockscreen-widget-0000000000000003"
      "lockscreen-widget-0000000000000004"
    ];
    widget = {
      clock_main = {
        type = "clock";
        box_height = 112.0;
        box_width = 512.0;
        cx = 960.0;
        cy = 484.0;
        output = monitors.primary;
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        settings = {
          clock_style = "digital";
          format = "{:%H:%M}";
          background = false;
          center_text = true;
          shadow = false;
        };
      };

      "lockscreen-login-box@${monitors.primary}" = {
        type = "login_box";
        box_height = 70.0;
        box_width = 368.0;
        cx = 960.0;
        cy = 636.0;
        output = monitors.primary;
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        settings = {
          layout = "compact";
          background_color = "on_surface";
          background_opacity = 0.0;
          background_radius = 12.0;
          center_password_text = true;
          input_opacity = 0.5;
          input_radius = 12.0;
          show_media = true;
          show_caps_lock = false;
          show_keyboard_layout = false;
          show_login_button = false;
          show_session_buttons = false;
          show_unlock_hint = false;
          show_weather = false;
        };
      };

      lockscreen-widget-0000000000000001 = {
        type = "label";
        box_height = 128.0;
        box_width = 432.0;
        cx = 344.0;
        cy = 860.0;
        output = monitors.primary;
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        settings = {
          title = "Be present";
          description = "The world is right here";
          background = false;
          background_opacity = 0.0;
          background_padding = 0;
          background_radius = 0;
          opacity = 1.0;
          shadow = false;
        };
      };

      lockscreen-widget-0000000000000003 = {
        type = "audio_visualizer";
        box_height = 48.0;
        box_width = 384.0;
        cx = 320.0;
        cy = 964.0;
        output = monitors.primary;
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        settings = {
          background = false;
          background_color = "surface";
          bands = 28;
          centered = true;
          show_when_idle = true;
        };
      };

      lockscreen-widget-0000000000000004 = {
        type = "label";
        box_height = 32.0;
        box_width = 240.0;
        cx = 960.0;
        cy = 585.0;
        output = monitors.primary;
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        settings = {
          title = "Unlock your day";
          background = false;
          shadow = false;
        };
      };
    };
  };
}
