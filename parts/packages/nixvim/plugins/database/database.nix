{ lib, ... }:

{
  options.pluginsModules.database = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable database client";
      default = false;
    };
  };
}
