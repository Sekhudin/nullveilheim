{ lib, ... }:

{
  options.commonModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable common modules";
      default = false;
    };

    osConfig = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
      description = "optionsl osConfig";
    };
  };
}
