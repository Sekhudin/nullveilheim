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
      qrencode
    ];
  };

  programs.noctalia.settings = {
    plugins.enabled = [ "yocraft/qrcode" ];

    plugin_settings."yocraft/qrcode" = {
      titlebar = true;
      generate_button = true;
      close_on_copy = false;
      keep_on_close = false;
    };
  };
}
