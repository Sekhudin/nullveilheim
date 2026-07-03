{ lib, ... }:

{
  imports = [ ];

  options.nixosHardwareModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable hardware modules";
      default = true;
    };
  };
}
