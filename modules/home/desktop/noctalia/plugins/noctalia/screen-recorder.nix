{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
in
{
  home = lib.mkIf cfg.enable {
    packages = with pkgs; [
      gpu-screen-recorder
    ];
  };

  programs.noctalia.settings = {
    plugins.enabled = [ "noctalia/screen_recorder" ];

    plugin_settings."noctalia/screen_recorder" = {
      video_source = "portal";
      directory = "~/Videos/Recordings";
      video_qp = 22;
      color_range = "full";
      copy_to_clipboard = true;
      audio_source = "default_output";
    };
  };
}
