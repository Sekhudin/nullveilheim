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
      socat
    ];
  };

  programs.noctalia.settings = {
    plugins.enabled = [ "profidev/hypr-screen-mirror" ];

    plugin_settings."profidev/hypr-screen-mirror" = {
    };
  };
}
