{ lib, extraLib, ... }:

let
  inherit (extraLib) mkImports;
in
{
  imports = mkImports {
    recursive = false;
    excludeDefault = true;
    dirs = [
      ./.
    ];
  };

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
