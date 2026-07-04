{ config, lib, ... }:

let
  cfg = config.darwinCoreModules.nix;
  masterEnable = config.darwinCoreModules.enable;
in
{
  options.darwinCoreModules.nix = {
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
