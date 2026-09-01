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
    mkImports
    importModules
    ;

  inherit (extraLib.hyprland)
    getVarRef
    dsp
    ;

  var = getVarRef config;
  actions = var "actions";
in
{
  imports = mkImports {
    recursive = false;
    excludeDefault = true;
    dirs = [
      ./.
    ];
  };

  config = lib.mkIf (cfg.enable && ecosystemEnabled) {
    home = {
      packages = map (module: module.app) (importModules {
        dir = ./actions;
        recursive = false;
        excludeDefault = true;
        args = {
          inherit
            pkgs
            dsp
            actions
            ;
        };
      });
    };
  };
}
