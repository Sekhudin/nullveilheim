{
  config,
  lib,
  ...
}:

let
  cfg = config.pluginsModules.which-key;
in
{
  options.pluginsModules.which-key = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable which-key";
      default = false;
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
          settings = {
            delay = lib.mkDefault 0;
            expand = lib.mkDefault 1;
            notify = lib.mkDefault false;
            preset = lib.mkDefault true;
            win = {
              border = lib.mkDefault "single";
            };
            triggers = [
              {
                __unkeyed-1 = "<leader>";
                mode = "n";
              }
              {
                __unkeyed-1 = "g";
                mode = "n";
              }
            ];
            spec = [
            ];
          };
        }
        cfg.settings
      ];
    };
  };
}
