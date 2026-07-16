{ lib, ... }:

{
  options.pluginsModules.completion = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable completion";
      default = false;
    };
  };
}
