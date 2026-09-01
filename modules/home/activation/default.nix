{
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkImports;
in
{
  imports = mkImports {
    recursive = false;
    excludeDefault = true;
    dirs = [
      ./.
    ];
  };

  options.activationModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable activation modules";
      default = false;
    };
  };
}
