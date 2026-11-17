{ config, ... }:

let
  cfg = config.homeDesktop;
in
{
  programs.openscreen = {
    enable = cfg.enable;
  };
}
