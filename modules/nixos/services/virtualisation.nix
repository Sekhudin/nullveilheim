{ config, lib, ... }:

let
  cfg = config.nixosServicesModules.virtualisation;
  masterEnable = config.nixosServicesModules.enable;
in
{
  options.nixosServicesModules.virtualisation = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable virtualisation";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "virtualisation settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    virtualisation = lib.mkMerge [
      {
        docker = {
          enable = lib.mkDefault false;
          rootless = {
            enable = lib.mkDefault true;
            setSocketVariable = lib.mkDefault true;
          };
        };
      }
      cfg.settings
    ];
  };
}
