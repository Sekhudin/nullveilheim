{ config, extraLib, ... }:

let
  cfg = config.homeDesktop;
  inherit (extraLib.hyprland) hypr;

  styles = hypr.getVarValues config "styles";
in
{
  programs.noctalia.settings.shell = {
    corner_radius_scale = 1.0;
    button_borders = true;
    input_borders = true;
    popup_borders = true;
    card_borders = true;
    popup_shadows = true;
    font_family = cfg.font.family.sans_serif;
    time_format = "{:%H:%M}";
    date_format = "%A, %x";
    setup_wizard_enabled = false;
    polkit_agent = true;
    show_location = true;
    panel = {
      transparency_mode = "soft";
      floating_layer = "overlay";
      floating_offset = styles.margin_out;
      control_center_placement = "attached";
      wallpaper_placement = "attached";
      session_placement = "attached";
      launcher_placement = "attached";
      clipboard_placement = "attached";
      polkit_placement = "attached";
      open_near_click_control_center = true;
      open_near_click_launcher = true;
      open_near_click_clipboard = true;
      open_near_click_wallpaper = true;
      open_near_click_session = true;
    };
    launcher = {
      app_grid = false;
      compact = false;
      categories = false;
      show_icons = true;
      show_app_origin_indicator = true;
      show_app_actions = false;
      fetch_exchange_rates = true;
      provider_prefix = "/";
      auto_paste = "auto";
    };
    window_switcher = {
      style = "carousel";
      mru = false;
      show_caption = true;
      show_count = true;
      show_app_icon = true;
    };
    screenshot = {
      save_to_file = true;
      copy_to_clipboard = true;
      freeze_screen = true;
      confirm_region = true;
      remember_last_region = false;
      show_cursor = false;
      annotate = false;
      skip_annotate_on_copy_save = false;
      close_on_copy = true;
      close_on_save = true;
      pipe_to_command = false;
    };
    screen_corners = {
      enabled = true;
      size = styles.border_radius + styles.margin_out + styles.border_size;
    };
  };
}
