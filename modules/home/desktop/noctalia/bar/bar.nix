{
  config,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktop;
  inherit (extraLib.hyprland) hypr;

  styles = hypr.getVarValues config "styles";
  barStyle =
    let
      thickness = 36;
      padding = styles.margin_in;
      radius = styles.border_radius;
      scale = if cfg.noctalia.bar.label.enable then 1.0 else 1.2;
      capsule_thickness = 1.0 - ((padding * 2.0) / thickness);
      capsule_radius = radius - padding;
    in
    {
      font_family = cfg.font.family.sans_serif;
      widget_spacing = 0;
      background_opacity = styles.opacity;
      capsule_opacity = styles.opacity;
      inherit
        thickness
        padding
        radius
        scale
        capsule_thickness
        capsule_radius
        ;
    };
in
{
  programs.noctalia.settings.bar = {
    order = [ "main" ];
    default = {
      enabled = true;
      position = "top";
      layer = "top";
      auto_hide = false;
      smart_auto_hide = false;
      show_on_workspace_switch = true;
      reserve_space = true;
      thickness = barStyle.thickness;
      background_opacity = barStyle.background_opacity;
      border = "outline";
      border_width = 0.0;
      shadow = true;
      contact_shadow = false;
      panel_overlap = 1;
      radius = barStyle.radius;
      radius_top_left = barStyle.radius;
      radius_top_right = barStyle.radius;
      radius_bottom_left = barStyle.radius;
      radius_bottom_right = barStyle.radius;
      margin_edge = 0;
      margin_ends = 400;
      margin_opposite_edge = true;
      padding = barStyle.padding;
      widget_spacing = barStyle.widget_spacing;
      hover_highlight = true;
      scale = barStyle.scale;
      font_family = barStyle.font_family;
      font_weight = 500;
      capsule = true;
      capsule_fill = "surface_variant";
      capsule_thickness = barStyle.capsule_thickness;
      capsule_radius = barStyle.capsule_radius;
      capsule_opacity = barStyle.capsule_opacity;
      dead_zone.actions = {
        left = "panel-toggle control-center";
        right = "settings-toggle";
      };
      start = [
        "launcher"
        "workspaces"
        "k4n4t4/hypr-submap:hypr-submap"
        "wallpaper"
        "noctalia/screen_recorder:recorder"
        "clock"
      ];
      center = [
        "media"
      ];
      end = [
        "tray"
        "notifications"
        "network"
        "bluetooth"
        "volume"
        "brightness"
        "battery"
        "session"
      ];
    };
  };
}
