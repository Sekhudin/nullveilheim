{ config, lib, ... }:

let
  cfg = config.nixosDesktop.apps.steam;
in
{
  options.nixosDesktop.apps.steam = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable steam";
      default = true;
    };
  };

  config = {
    programs.steam = {
      enable = cfg.enable;
      remotePlay = {
        openFirewall = true;
      };
      dedicatedServer = {
        openFirewall = true;
      };
    };
  };
}
