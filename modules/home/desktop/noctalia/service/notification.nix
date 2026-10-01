{ config, extraLib, ... }:

let
  inherit (extraLib.hyprland) hypr;

  styles = hypr.getVarValues config "styles";
in
{
  programs.noctalia.settings.notification = {
    enable_daemon = true;
    show_app_name = true;
    show_actions = true;
    layer = "top";
    position = "top_right";
    background_opacity = styles.opacity;
    offset_x = styles.margin_out;
    offset_y = styles.margin_out;
  };
}
