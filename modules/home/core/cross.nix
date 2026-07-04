{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.homeCoreModules.cross;
  masterEnable = config.homeCoreModules.enable;
in
{
  options.homeCoreModules.cross = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable cross";
      default = true;
    };
  };

  config = {
    programs = lib.mkIf (masterEnable && cfg.enable) {
      direnv = {
        enable = true;
        silent = true;
        nix-direnv = {
          enable = true;
        };
      };

      bat = {
        enable = true;
        config = {
          style = "plain";
          theme = "TwoDark";
        };
      };

      btop = {
        enable = true;
        settings = {
          vim_keys = true;
          show_battery = false;
        };
      };
    };

    home = lib.mkIf (masterEnable && cfg.enable) {
      packages = with pkgs; [
        home-manager
        coreutils
        gnused
        gawk
        curl
        wget
        tree
        ack
        fswatch
      ];
    };
  };
}
