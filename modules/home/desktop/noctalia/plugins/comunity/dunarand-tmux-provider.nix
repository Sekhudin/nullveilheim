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
      tmux
      tmuxp
    ];
  };

  programs.noctalia.settings = {
    plugins.enabled = [ "dunarand/tmux-provider" ];

    plugin_settings."dunarand/tmux-provider" = {
      use_tmuxp = true;
    };
  };
}
