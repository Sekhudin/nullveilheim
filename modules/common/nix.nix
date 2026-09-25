{
  config,
  lib,
  ...
}:

let
  cfg = config.common.nix;
in
{
  options.common.nix = {
    trusted-users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "trusted users";
      default = [ ];
    };
  };

  config = {
    nix = {
      gc = {
        options = "--delete-older-than 7d";
      };

      settings = {
        inherit (cfg) trusted-users;

        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://hyprland.cachix.org"
          "https://noctalia.cachix.org"
        ];
        trusted-substituters = [
          "https://hyprland.cachix.org"
          "https://noctalia.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };
  };
}
