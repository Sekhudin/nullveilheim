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
      openssh
    ];
  };

  programs.noctalia.settings = {
    plugins.enabled = [ "cleboost/ssh-launcher" ];

    plugin_settings."cleboost/ssh-launcher" = {
      config_path = "~/.ssh/config";
      max_results = 10;
    };
  };
}
