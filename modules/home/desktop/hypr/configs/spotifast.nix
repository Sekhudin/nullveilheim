{ config, ... }:

let
  cfg = config.homeDesktop;
in
{
  programs.spotifast = {
    enable = cfg.enable;
  };
}
