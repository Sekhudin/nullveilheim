{ config, lib, ... }:

let
  cfg = config.pluginsModules.ui;
in
{
  plugins = lib.mkIf cfg.enable {
    which-key = {
      settings = {
        spec = [ ];
      };
    };
  };
}
