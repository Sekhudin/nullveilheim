{ config, ... }:

let
  cfg = config.homeDesktop;
in
{
  programs.recordly = {
    enable = cfg.enable;
  };
}
