{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib)
    importModules
    mkJq
    joinPipe
    ;

  inherit (extraLib.hyprland) getVarRef;

  var = getVarRef config;
  actions = var "actions";

  actionModules = importModules {
    dir = ./actions;
    recursive = false;
    excludeDefault = true;
    args = {
      inherit
        mkJq
        joinPipe
        pkgs
        lib
        actions
        ;
    };
  };

  action = {
    apps = map (module: module.app) actionModules;
  };
in
{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpolkitagent.nix
  ];

  home = {
    packages = action.apps ++ [ ];
  };
}
