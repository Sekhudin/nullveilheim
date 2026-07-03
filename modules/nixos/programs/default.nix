{ lib, ... }:

{
  imports = [ ];

  options.nixosProgramsModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable programs modules";
      default = true;
    };
  };
}
