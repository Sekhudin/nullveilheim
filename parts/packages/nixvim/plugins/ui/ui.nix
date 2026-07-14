{ lib, ... }:

{
  options.pluginsModules.ui = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable sidebar";
      default = true;
    };
  };
}
