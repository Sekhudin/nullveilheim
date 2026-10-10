{ config, lib, ... }:

let
  cfg = config.homeDesktop.noctalia;
  wallpapers = config.homeDesktop.wallpapers;
in
{
  home = lib.mkIf cfg.enable {
    file = wallpapers.homeFile;
  };

  programs.noctalia.settings.wallpaper = {
    enabled = true;
    fill_mode = "fit";
    transition = [
      "disc"
      "zoom"
      "honeycomb"
    ];
    transition_duration = 1500;
    edge_smoothness = 0.3;
    directory = wallpapers.dir;
    transition_on_startup = false;
    per_monitor_directories = false;
    default.path = wallpapers.files."02";
    automation = {
      enabled = cfg.desktop.wallpaper.automation.enable;
      interval_seconds = 2000;
      order = "random";
      recursive = false;
    };
  };

  programs.noctalia.settings.backdrop = {
    enabled = cfg.desktop.backdrop.enable;
    blur_intensity = 0.5;
    tint_intensity = 0.3;
  };
}
