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

  inherit (extraLib) importModules;

  inherit (extraLib.hyprland) getVarRef dsp;

  var = getVarRef config;
  actions = var "actions";
in
{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpolkitagent.nix
    ./hyprtoolkit.nix
  ];

  config = lib.mkIf (cfg.enable && ecosystemEnabled) {
    home = {
      packages =
        with pkgs;
        [
          libnotify
        ]
        ++ (map (module: module.app) (importModules {
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
        }));
    };
  };
}
