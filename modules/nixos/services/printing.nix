{ config, lib, ... }:

let
  cfg = config.nixosServicesModules.printing;
  masterEnable = config.nixosServicesModules.enable;
in
{
  options.nixosServicesModules.printing = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable printing service";
      default = false;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "printing settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    services.printing = lib.mkMerge [
      {
        enable = true;
      }
      cfg.settings
    ];
  };
}
