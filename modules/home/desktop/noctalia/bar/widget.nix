{ config, ... }:

let
  cfg = config.homeDesktop.noctalia.bar;
  svgs = config.homeDesktop.svgs;
  def = config.programs.noctalia.settings.bar.default;
in
{
  programs.noctalia.settings.widget = {
    launcher.custom_image = svgs.nix-white;
    workspaces = {
      style = "regular";
      capsule_radius = def.capsule_radius - def.padding;
      pill_scale = 1.0;
      active_pill_size = 1.8;
      inactive_pill_size = 1.0;
    };
    wallpaper.glyph = "library-photo";
    clock.format = "{:%H:%M}";
    media = {
      rotate_album_art = true;
      album_art_only = false;
      hide_when_no_media = true;
    };
    tray = {
      drawer = true;
      drawer_columns = 3;
      detached_panel = true;
      hide_passive = true;
      pinned = [ ];
      hidden = [ ];
    };
    notifications.hide_when_no_unread = false;
    network = {
      show_label = cfg.label.enable;
      show_vpn_label = cfg.label.enable;
    };
    bluetooth = {
      show_label = cfg.label.enable;
    };
    volume = {
      show_label = cfg.label.enable;
    };
    brightness = {
      show_label = cfg.label.enable;
    };
    battery = {
      display_mode = "glyph";
      show_label = cfg.label.enable;
      label_content = "percent";
    };
  };
}
