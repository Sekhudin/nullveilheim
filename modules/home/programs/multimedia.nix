{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeProgramsModules.multimedia;
  master = config.homeProgramsModules;
  openGL = config.homeCoreModules.openGL;
  masterEnable = master.enable;
  openGLEnable = (openGL.use != "default");
in
{
  options.homeProgramsModules.multimedia = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable multimedia";
      default = true;
    };

    obs = lib.mkOption {
      type = lib.types.attrs;
      description = "obs settings";
      default = { };
    };

    mpv = lib.mkOption {
      type = lib.types.attrs;
      description = "mpv settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    programs = {
      obs-studio = lib.mkMerge [
        {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            obs-gstreamer
            obs-backgroundremoval
          ];
        }
        cfg.obs
      ];

      mpv = lib.mkMerge [
        {
          enable = true;
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
        }
        cfg.mpv
      ];
    };

    xdg.desktopEntries = lib.mkIf openGLEnable {
      "com.obsproject.Studio" = {
        name = "OBS Studio";
        type = "Application";
        icon = "com.obsproject.Studio";
        exec = "${openGL.use} obs";
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

      mpv = {
        name = "MPV player";
        type = "Application";
        icon = "mpv";
        exec = "${openGL.use} mpv --player-operation-mode=pseudo-gui -- %U";
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
