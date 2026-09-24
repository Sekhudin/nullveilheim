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

  inherit (inputs.self.nullveilheim) nixpkgs;
in
{
  options.commonModules.nixpkgs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable nixpkgs config";
      default = true;
    };
  };

  config = lib.mkIf (masterEnable && cfg.enable) {
    nixpkgs = {
      inherit (nixpkgs)
        config
        overlays
        ;
    };
  };
}
