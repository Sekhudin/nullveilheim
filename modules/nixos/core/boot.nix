{ config, lib, ... }:

let
  cfg = config.nixosCoreModules.boot;
  masterEnable = config.nixosCoreModules.enable;
in
{
  options.nixosCoreModules.boot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "activate systemd-boot bootloader";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "extra boot custom settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    boot = lib.mkMerge [
      {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        tmp.cleanOnBoot = true;
      }
      cfg.settings
    ];
  };
}
