{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.lz-n;
in
{
  options.pluginsModules.lz-n = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable lz-n";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      lz-n = {
        enable = true;
        plugins = [ ];
      };
    };
  };
}
