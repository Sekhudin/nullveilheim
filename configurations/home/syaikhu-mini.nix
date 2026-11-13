{
  pkgs,
  lib,
  ezModules,
  extraLib,
  ...
}:

let
  ctx = extraLib.mkHomeContext {
    inherit pkgs;
    username = "syaikhu";
  };
in
{
  imports = lib.attrValues ezModules ++ [ ];

  home = {
    stateVersion = "26.05";
    username = ctx.username;
    homeDirectory = ctx.homeDirectory;
    packages = with pkgs; [
      nixvim
    ];
    sessionVariables = rec {
      EDITOR = lib.getExe' pkgs.nixvim "nvim";
      SELF_FLAKE = "${ctx.homeDirectory}/.config/nullveilheim";
      NH_FLAKE = SELF_FLAKE;
    };
  };
}
