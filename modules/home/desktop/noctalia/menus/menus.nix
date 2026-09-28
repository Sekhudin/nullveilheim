{
  inputs,
  pkgs,
  config,
  lib,
  extraLib,
  ...
}:

let
  cfg = config.homeDesktop.noctalia;
  inherit (extraLib.hyprland) hypr;

  menus = hypr.getVarValues config "menus";
  ipc = cmd: "noctalia msg ${cmd}";

  runtimeInputs = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
in
{
  home = lib.mkIf cfg.enable {
    packages = [
      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = menus.launcher;
        text = ipc "panel-toggle launcher";
      })
    ];
  };
}
