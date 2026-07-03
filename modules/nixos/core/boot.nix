{ config, lib, ... }:

let
  cfg = config.nixosCoreModules.boot;
  masterEnable = config.nixosCoreModules.enable;
in
{
  options.nixosCoreModules.boot = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable boot";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "boot settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    boot = lib.mkMerge [
      {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        tmp.cleanOnBoot = lib.mkDefault true;
      }
      cfg.settings
    ];
  };
}
