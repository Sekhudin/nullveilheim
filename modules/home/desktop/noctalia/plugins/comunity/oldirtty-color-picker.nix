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
      hyprpicker
    ];
  };

  programs.noctalia.settings = {
    plugins.enabled = [ "oldirtty/color_picker" ];

    plugin_settings."oldirtty/color_picker" = {
      hyprpicker-format = "hex";
      hyprpicker-lowercase = false;
    };
  };
}
