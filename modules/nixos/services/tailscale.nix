{ config, lib, ... }:

let
  cfg = config.nixosServicesModules.tailscale;
  masterEnable = config.nixosServicesModules.enable;
in
{
  options.nixosServicesModules.tailscale = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable tailscale";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "tailscale settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    services = {
      tailscale = lib.mkMerge [
        {
          enable = true;
        }
        cfg.settings
      ];
    };
  };
}
