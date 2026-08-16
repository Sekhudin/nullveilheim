{
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktopModules.hyprland;
  ecosystemEnabled = cfg.ecosystem.use == "default";

  inherit (extraLib)
    importModules
    mkJq
    joinPipe
    ;

  inherit (extraLib.hyprland) getVarRef;

  var = getVarRef config;
  actions = var "actions";
in
{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpolkitagent.nix
  ];

  config = lib.mkIf (cfg.enable && ecosystemEnabled) {
    home = {
      packages = map (module: module.app) (importModules {
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
      });
    };
  };
}
