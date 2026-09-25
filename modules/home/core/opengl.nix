{
  config,
  pkgs,
  lib,
  ...
}:

let
  core = config.homeCore;
in
{
  home = lib.mkIf (core.opengl != "") {
    packages = [
      pkgs.nixgl.${core.opengl}
    ];
  };
}
