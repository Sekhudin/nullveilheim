{
  config,
  lib,
  ...
}:

let
  cfg = config.darwinCoreModules.nixpkgs;
  masterEnable = config.darwinCoreModules.enable;
in
{
  options.darwinCoreModules.nixpkgs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable nixpkgs config";
      default = true;
    };

    config = lib.mkOption {
      type = lib.types.attrs;
      description = "nixpkgs config";
      default = { };
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    nixpkgs = {
      config = lib.mkMerge [
        {
          allowUnfree = lib.mkDefault true;
          allowBroken = lib.mkDefault false;
          contentAddressedByDefault = lib.mkDefault false;
          tarball-ttl = lib.mkDefault 0;
        }
        cfg.config
      ];
    };
  };
}
