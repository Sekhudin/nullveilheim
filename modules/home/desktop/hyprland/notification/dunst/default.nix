{
  config,
  lib,
  extraLib,
  color,
  font,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  enableDunst = (cfg.notification.use == "dunst");
  inherit (extraLib.hyprland) getVarRef;
  inherit (color) mkOpacity;

  var = getVarRef config;
  styles = var "styles";
  tokens = var "tokens";

in
{
  config = lib.mkIf (cfg.enable && enableDunst) {
    services = {
      dunst = {
        enable = true;
        iconTheme = {
          size = "32x32";
          inherit (config.homeCoreModules.iconTheme)
            name
            package
            ;
        };
        settings = {
          global = {
            width = 300;
            origin = "top-right";
            layer = "overlay";
            timeout = 5;
            icon_position = "left";
            markup = "all";
            alignment = "left";
            notification_limit = 5;
            padding = styles.padding_y;
            horizontal_padding = styles.padding_x;
            offset = styles.gaps_out;
            gap_size = styles.gaps_in;
            frame_color = tokens.border;
            frame_width = 1;
            font = "${font.family.sans_serif} ${toString font.sizes.desktop}";
            background = mkOpacity tokens.bg 0.8;
            foreground = tokens.fg;
            corners = "all";
            corner_radius = styles.rounding;
            ignore_dbusclose = false;
            sticky_history = false;
            override_pause_level = 0;
            progress_bar = true;
            progress_bar_horizontal_alignment = "center";
            progress_bar_height = 10;
            progress_bar_min_width = 150;
            progress_bar_max_width = 300;
            progress_bar_frame_width = 1;
            progress_bar_corner_radius = 10;
            progress_bar_corners = "all";
            mouse_left_click = "close_current";
            mouse_right_click = "close_all";
            format = ''<span size="small" weight="bold" text_transform="capitalize">%a</span>\n<span weight="light">%b</span>'';
          };
          urgency_low = {
            timeout = 3;
          };
          urgency_normal = {
            timeout = 5;
            frame_color = tokens.info;
          };
          urgency_critical = {
            timeout = 0;
            frame_color = tokens.destructive;
            mouse_left_click = "do_action";
            mouse_right_click = "close_current";
          };
        };
      };
    };
  };
}
