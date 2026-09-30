{ config, ... }:

let
  cfg = config.homeDesktop.noctalia.desktop;
  wallpapers = config.homeDesktop.wallpapers;
in
{
  programs.noctalia.settings.wallpaper = {
    enabled = true;
    fill_mode = "fit";
    transition = [
      "fade"
      "wipe"
      "disc"
      "stripes"
      "zoom"
      "honeycomb"
    ];
    transition_duration = 1500;
    edge_smoothness = 0.3;
    directory = wallpapers.dir;
    transition_on_startup = false;
    per_monitor_directories = false;
    default.path = wallpapers."02";
    automation = {
      enabled = cfg.wallpaper.automation.enable;
      interval_seconds = 2000;
      order = "random";
      recursive = false;
    };
  };

  programs.noctalia.settings.backdrop = {
    enabled = cfg.backdrop.enable;
    blur_intensity = 0.5;
    tint_intensity = 0.3;
  };
}
