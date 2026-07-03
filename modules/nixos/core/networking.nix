{ config, lib, ... }:

let
  cfg = config.nixosCoreModules.networking;
  masterEnable = config.nixosCoreModules.enable;
in
{
  options.nixosCoreModules.networking = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable networking";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "networking settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    networking = lib.mkMerge [
      {
        hostName = lib.mkDefault "nixos";
        networkmanager.enable = lib.mkDefault true;
        firewall.allowedTCPPorts = lib.mkDefault [ ];
      }
      cfg.settings
    ];
  };
}
