{ lib, ... }:

{
  imports = [ ];

  options.nixosHardwareModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable hardware modules";
      default = false;
    };
  };

  config = {
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };
  };
}
