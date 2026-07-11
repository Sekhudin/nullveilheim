{
  config,
  lib,
  ...
}:

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

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = "nix settings";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    nix = lib.mkMerge [
      {
        gc = {
          options = lib.mkDefault "--delete-older-than 7d";
        };

        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
      }
      cfg.settings
    ];
  };
}
