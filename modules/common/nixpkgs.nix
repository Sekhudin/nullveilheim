{
  inputs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.commonModules.nixpkgs;
  master = config.commonModules;
  masterEnable = master.enable;
  isStandalone = (extraLib.isStandalone master.osConfig);
in
{
  options.commonModules.nixpkgs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable nixpkgs config";
      default = true;
    };

    enableOverlays = lib.mkOption {
      type = lib.types.bool;
      description = "enable nixpkgs overlays";
      default = false;
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

      overlays = lib.optionals cfg.enableOverlays (
        (lib.attrValues inputs.self.overlays)
        ++ [
        ]
        ++ lib.optionals isStandalone [
          inputs.nixgl.overlay
        ]
      );

    };
  };
}
