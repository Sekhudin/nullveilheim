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

  brightness = hypr.getVarValues config "brightness";
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
        name = brightness.up;
        text = ipc "brightness-up";
      })

      (pkgs.writeShellApplication {
        inherit runtimeInputs;
        name = brightness.down;
        text = ipc "brightness-down";
      })
    ];
  };
}
