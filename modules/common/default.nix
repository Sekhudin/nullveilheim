{ lib, ... }:

{
  options.commonModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable common modules";
      default = false;
    };
  };
}
