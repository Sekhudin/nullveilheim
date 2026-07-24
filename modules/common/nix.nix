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
    nix = {
      gc = {
        options = lib.mkDefault "--delete-older-than 7d";
      };

      settings = lib.mkMerge [
        {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          substituters = [
            "https://hyprland.cachix.org"
          ];
          trusted-substituters = [
            "https://hyprland.cachix.org"
          ];
          trusted-public-keys = [
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          ];
        }
        cfg.settings
      ];
    };
  };
}
