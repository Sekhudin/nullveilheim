{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeApps.obs-studio;
  core = config.homeCore;
in
{
  options.homeApps.obs-studio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable obs-studio";
      default = true;
    };
  };

  config = {
    programs.obs-studio = {
      enable = cfg.enable;
      plugins = with pkgs.obs-studio-plugins; [
        obs-gstreamer
        obs-backgroundremoval
      ];
    };

    xdg.desktopEntries = lib.mkIf (cfg.enable && core.opengl != "") {
      "com.obsproject.Studio" = {
        name = "OBS Studio";
        type = "Application";
        icon = "com.obsproject.Studio";
        exec = "${core.opengl} obs";
        comment = "Free and Open Source Streaming/Recording Software";
        terminal = false;
        settings.StartupNotify = "true";
        settings.StartupWMClass = "obs";
        settings.Keywords = "limiter;compressor;reverberation;equalizer;autovolume;";
        categories = [
          "AudioVideo"
          "Recorder"
        ];
      };
    };
  };
}
