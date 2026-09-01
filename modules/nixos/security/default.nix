{ lib, extraLib, ... }:

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

  options.nixosSecurityModules = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable security module";
      default = false;
    };
  };
}
