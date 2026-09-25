{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeApps.mpv;
  core = config.homeCore;
in
{
  options.homeApps.mpv = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable mpv";
      default = true;
    };
  };

  config = {
    programs.mpv = {
      enable = cfg.enable;
      config = {
        audio-buffer = "0.5";
        autofit = "35%";
        border = "no";
        cache = "yes";
        demuxer-max-back-bytes = "100M";
        demuxer-max-bytes = "500M";
        geometry = "30%x30%+100%+100%";
        gpu-context = "auto";
        hwdec = "auto";
        keep-open = "yes";
        keepaspect-window = false;
        ontop = "yes";
        osc = "no";
        osd-bar = "no";
        profile = "fast";
        spirv-compiler = "auto";
        title = "mpv - \${filename}";
        video-sync = "display-resample";
        vo = "gpu-next";
        ytdl-format = "bestvideo[height<=1080][vcodec^=vp9]+bestaudio/best";
      };
      scripts = with pkgs.mpvScripts; [
        mpris
        thumbfast
        modernz
      ];
      bindings = {
        "q" = "quit";
        "WHEEL_UP" = "add volume 2";
        "WHEEL_DOWN" = "add volume -2";
        "MBTN_LEFT" = "cycle pause";
        "MBTN_RIGHT" = "script-binding modernz-settings";
        "ALT+j" = "add geometry -5";
        "ALT+k" = "add geometry +5";
      };
    };

    xdg.desktopEntries = lib.mkIf (cfg.enable && core.opengl != "") {
      mpv = {
        name = "MPV player";
        type = "Application";
        icon = "mpv";
        exec = "${core.opengl} mpv --player-operation-mode=pseudo-gui -- %U";
        comment = "Play movies and songs";
        terminal = false;
        settings.Keywords = "limiter;compressor;reverberation;equalizer;autovolume;";
        categories = [
          "AudioVideo"
          "Audio"
        ];
      };
    };
  };
}
