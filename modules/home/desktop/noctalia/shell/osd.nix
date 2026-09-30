{ config, extraLib, ... }:

let
  inherit (extraLib.hyprland) hypr;

  styles = hypr.getVarValues config "styles";
in
{
  programs.noctalia.settings.osd = {
    position = "top_center";
    position_vertical = "top_center";
    scale = 1.0;
    background_opacity = styles.opacity;
    border = true;
    offset_x = styles.margin_out;
    offset_y = styles.margin_out;
    kinds = {
      volume = true;
      volume_output = true;
      volume_input = true;
      brightness = true;
      wifi = true;
      bluetooth = true;
      power_profile = true;
      caffeine = true;
      nightlight = true;
      dnd = true;
      lock_keys = true;
      keyboard_layout = true;
      media = true;
      privacy = true;
      keyboard_backlight = true;
    };
  };
}
