{ config, lib, ... }:

let
  cfg = config.nixosSecurityModules.polkit;
  masterEnable = config.nixosSecurityModules.enable;
in
{
  options.nixosSecurityModules.polkit = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable polkit";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "polkit settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    security = {
      polkit = lib.mkMerge [
        {
          enable = true;
        }
        cfg.settings
      ];
    };
  };
}
