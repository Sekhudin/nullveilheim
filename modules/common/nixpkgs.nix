{
  inputs,
  config,
  lib,
  ...
}:

let
  cfg = config.commonModules.nixpkgs;
  master = config.commonModules;
  masterEnable = master.enable;

  inherit (inputs.self.nullveilheimConfigurations) nixpkgs;
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
        nixpkgs.config
        cfg.config
      ];

      overlays = lib.optionals cfg.enableOverlays nixpkgs.overlays;
    };
  };
}
