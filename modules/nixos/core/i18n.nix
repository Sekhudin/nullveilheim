{ config, lib, ... }:

let
  cfg = config.nixosCoreModules.i18n;
  masterEnable = config.nixosCoreModules.enable;
in
{
  options.nixosCoreModules.i18n = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable i18n";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "i18n settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    i18n = lib.mkMerge [
      {
        defaultLocale = lib.mkDefault "en_US.UTF-8";
      }
      cfg.settings
    ];

    console = {
      keyMap = "us";
    };
  };
}
