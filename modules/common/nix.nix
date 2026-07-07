{ config, lib, ... }:

let
  cfg = config.commonModules.nix;
  masterEnable = config.commonModules.enable;
in
{
  options.commonModules.nix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable nix config";
      default = true;
    };

    gc = lib.mkOption {
      type = lib.types.attrs;
      description = "gc nix settings";
      default = { };
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "nix settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    nix = {
      gc = lib.mkMerge [
        {
          automatic = lib.mkDefault false;
          dates = lib.mkDefault "daily";
          options = lib.mkDefault "--delete-older-than 7d";
        }
        cfg.gc
      ];

      settings = lib.mkMerge [
        {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        }
        cfg.settings
      ];
    };
  };
}
