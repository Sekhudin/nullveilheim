{ lib, ... }:

{
  imports = [
  ];

  options.darwinCoreModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable core modules";
      default = false;
    };
  };
}
