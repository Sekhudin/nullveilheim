{ config, lib, ... }:

let
  cfg = config.nixosCoreModules.time;
  masterEnable = config.nixosCoreModules.enable;
in
{
  options.nixosCoreModules.time = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "activate time";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "extra time settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    time = lib.mkMerge [
      {
        timeZone = lib.mkDefault "Asia/Jakarta";
      }
      cfg.settings
    ];
  };
}
