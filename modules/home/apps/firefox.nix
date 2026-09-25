{
  config,
  lib,
  ...
}:

let
  cfg = config.homeApps.firefox;
in
{
  options.homeApps.firefox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable firefox";
      default = true;
    };
  };

  config = {
    programs.firefox = {
      enable = cfg.enable;
    };
  };
}
