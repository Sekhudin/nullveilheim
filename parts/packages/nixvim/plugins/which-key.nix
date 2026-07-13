{ config, lib, ... }:

let
  cfg = config.pluginsModules.which-key;
in
{
  options.pluginsModules.which-key = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable which-key";
      default = true;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "extra settings";
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      which-key = lib.mkMerge [
        {
          enable = true;
        }
        cfg.settings
      ];
    };
  };
}
