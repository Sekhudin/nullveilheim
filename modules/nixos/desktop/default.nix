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
    recursive = true;
    excludeDefault = true;
    dirs = [
      ./.
    ];
  };

  options.nixosDesktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      description = "enable desktop";
      default = true;
    };
  };
}
